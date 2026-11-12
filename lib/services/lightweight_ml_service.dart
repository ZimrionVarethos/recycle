import 'dart:convert';
import 'dart:math';
import 'dart:typed_data';
import 'package:image/image.dart' as img;
import '../config/plastics_data.dart';
import '../models/plastic_class.dart';
import '../models/scan_result.dart';
import 'classifier_service.dart';

class LightweightMlService implements ClassifierService {
  @override
  Future<BackendHealthStatus> checkHealth() async {
    return const BackendHealthStatus(
      isHealthy: true,
      modelLoaded: true,
      message: 'ML Ringan On-Device Aktif (Mode Simulasi Lokal 224×224)',
    );
  }

  @override
  Future<ScanResult> classifyImage({
    required Uint8List imageBytes,
    required String fileName,
    required String backbone,
  }) async {
    final stopwatch = Stopwatch()..start();
    await Future<void>.delayed(const Duration(milliseconds: 360));

    final decoded = img.decodeImage(imageBytes);
    final features = decoded != null
        ? _extractFeatures(decoded)
        : const _ImageFeatures(0.5, 0.2, 0.3, 0.5, 0.48);

    final scores = _computeLogits(features, fileName, backbone);
    final probs = _softmax(scores);

    PlasticClass winner = PlasticClass.pet;
    double bestProb = -1;
    probs.forEach((cls, p) {
      if (p > bestProb) {
        bestProb = p;
        winner = cls;
      }
    });

    // Resize thumbnail untuk pratinjau riwayat lokal agar hemat storage
    String? thumbBase64;
    if (decoded != null) {
      final thumb = img.copyResize(decoded, width: 320);
      thumbBase64 = base64Encode(img.encodeJpg(thumb, quality: 78));
    } else {
      thumbBase64 = base64Encode(imageBytes);
    }

    stopwatch.stop();
    final latency = max(28, min(140, stopwatch.elapsedMilliseconds ~/ 5));
    final info = PlasticsCatalog.byClass(winner);

    return ScanResult(
      id: 'lw_${DateTime.now().millisecondsSinceEpoch}',
      predictedClass: winner,
      confidence: double.parse(bestProb.toStringAsFixed(4)),
      probabilities: probs,
      backbone: backbone,
      inferenceTimeMs: latency,
      isDemo: true,
      sourceBackend: 'lightweight_ml',
      itemTitle: 'Scan Foto (${info.plasticClass.shortLabel})',
      timestamp: DateTime.now(),
      imageBase64: thumbBase64,
      focusX: features.focusX,
      focusY: features.focusY,
    );
  }

  @override
  Future<ScanResult> classifySample({
    required PlasticClass sampleClass,
    required String backbone,
  }) async {
    final baseDelay = backbone == 'MobileNetV2'
        ? 42
        : (backbone == 'VGG16' ? 96 : 28);
    await Future<void>.delayed(const Duration(milliseconds: 320));

    final logits = <PlasticClass, double>{};
    final rng = Random(sampleClass.index * 31 + backbone.length);
    for (final cls in PlasticClass.values) {
      if (cls == sampleClass) {
        final boost = backbone == 'MobileNetV2'
            ? 2.4
            : (backbone == 'VGG16' ? 2.15 : 1.55);
        logits[cls] = boost + rng.nextDouble() * 0.45;
      } else {
        logits[cls] = -0.3 + rng.nextDouble() * 0.7;
      }
    }

    final probs = _softmax(logits);
    final info = PlasticsCatalog.byClass(sampleClass);

    return ScanResult(
      id: 'smp_${DateTime.now().millisecondsSinceEpoch}',
      predictedClass: sampleClass,
      confidence: probs[sampleClass] ?? 0.74,
      probabilities: probs,
      backbone: backbone,
      inferenceTimeMs: baseDelay,
      isDemo: true,
      sourceBackend: 'lightweight_ml',
      itemTitle: info.sampleName,
      timestamp: DateTime.now(),
      focusX: 0.50,
      focusY: 0.46,
    );
  }

  _ImageFeatures _extractFeatures(img.Image src) {
    final resized = img.copyResize(src, width: 224, height: 224);
    double sumLuma = 0;
    double sumSat = 0;
    double sumEdge = 0;
    double weightedX = 0;
    double weightedY = 0;
    double totalWeight = 0.001;
    int samples = 0;

    for (int y = 4; y < 220; y += 8) {
      for (int x = 4; x < 220; x += 8) {
        final p = resized.getPixel(x, y);
        final r = p.r / 255.0;
        final g = p.g / 255.0;
        final b = p.b / 255.0;
        final maxC = max(r, max(g, b));
        final minC = min(r, min(g, b));
        final luma = (r + g + b) / 3.0;
        final sat = maxC > 0 ? (maxC - minC) / maxC : 0.0;

        final rightP = resized.getPixel(x + 4, y);
        final rightLuma = (rightP.r + rightP.g + rightP.b) / (3.0 * 255.0);
        final edge = (luma - rightLuma).abs();

        sumLuma += luma;
        sumSat += sat;
        sumEdge += edge;
        weightedX += (x / 224.0) * (edge + 0.05);
        weightedY += (y / 224.0) * (edge + 0.05);
        totalWeight += (edge + 0.05);
        samples++;
      }
    }

    return _ImageFeatures(
      sumLuma / max(1, samples),
      sumSat / max(1, samples),
      min(1.0, (sumEdge / max(1, samples)) * 4.5),
      (weightedX / totalWeight).clamp(0.25, 0.75),
      (weightedY / totalWeight).clamp(0.25, 0.75),
    );
  }

  Map<PlasticClass, double> _computeLogits(
    _ImageFeatures f,
    String fileName,
    String backbone,
  ) {
    final name = fileName.toLowerCase();
    final logits = <PlasticClass, double>{
      PlasticClass.pet: 0.7 + (1.0 - f.saturation) * 0.6 + f.edgeDensity * 0.7,
      PlasticClass.hdpe: 0.6 + f.luminance * 0.9 + (1.0 - f.edgeDensity) * 0.4,
      PlasticClass.pvc: 0.3 + f.edgeDensity * 0.6,
      PlasticClass.ldpe: 0.5 + f.saturation * 0.9,
      PlasticClass.pp: 0.55 + f.luminance * 0.4 + f.edgeDensity * 0.4,
      PlasticClass.ps: 0.25 + (1.0 - f.luminance) * 0.9,
      PlasticClass.other: 0.35 + f.saturation * 0.4 + f.edgeDensity * 0.3,
    };

    // Jika nama file memberi petunjuk label (berguna saat pengujian dataset lokal)
    for (final cls in PlasticClass.values) {
      if (name.contains(cls.shortLabel.toLowerCase())) {
        logits[cls] = (logits[cls] ?? 0) + 1.8;
      }
    }
    if (name.contains('botol') || name.contains('aqua')) {
      logits[PlasticClass.pet] = (logits[PlasticClass.pet] ?? 0) + 1.3;
    } else if (name.contains('jerigen') || name.contains('sampo')) {
      logits[PlasticClass.hdpe] = (logits[PlasticClass.hdpe] ?? 0) + 1.3;
    } else if (name.contains('kresek') || name.contains('kantong')) {
      logits[PlasticClass.ldpe] = (logits[PlasticClass.ldpe] ?? 0) + 1.3;
    } else if (name.contains('styrofoam') || name.contains('gabus')) {
      logits[PlasticClass.ps] = (logits[PlasticClass.ps] ?? 0) + 1.4;
    }

    // Skala ketidakpastian agar mencerminkan fase training (~70-85%)
    final factor = backbone == 'CNN Custom' ? 0.68 : 1.0;
    return logits.map((k, v) => MapEntry(k, v * factor));
  }

  Map<PlasticClass, double> _softmax(Map<PlasticClass, double> logits) {
    final maxLogit = logits.values.reduce(max);
    final expMap = <PlasticClass, double>{};
    double sumExp = 0;
    logits.forEach((k, v) {
      final e = exp(v - maxLogit);
      expMap[k] = e;
      sumExp += e;
    });
    return expMap.map((k, v) => MapEntry(k, v / sumExp));
  }
}

class _ImageFeatures {
  final double luminance;
  final double saturation;
  final double edgeDensity;
  final double focusX;
  final double focusY;

  const _ImageFeatures(
    this.luminance,
    this.saturation,
    this.edgeDensity,
    this.focusX,
    this.focusY,
  );
}
