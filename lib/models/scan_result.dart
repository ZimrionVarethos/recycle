import 'dart:convert';
import 'dart:typed_data';
import 'plastic_class.dart';

class ScanResult {
  final String id;
  final PlasticClass predictedClass;
  final double confidence;
  final Map<PlasticClass, double> probabilities;
  final String backbone;
  final int inferenceTimeMs;
  final bool isDemo;
  final String sourceBackend; // 'lightweight_ml' | 'python_api'
  final String itemTitle;
  final DateTime timestamp;
  final String? imageBase64;
  final String? gradcamUrl;
  final double focusX;
  final double focusY;
  final bool syncedToSupabase;

  const ScanResult({
    required this.id,
    required this.predictedClass,
    required this.confidence,
    required this.probabilities,
    required this.backbone,
    required this.inferenceTimeMs,
    required this.isDemo,
    required this.sourceBackend,
    required this.itemTitle,
    required this.timestamp,
    this.imageBase64,
    this.gradcamUrl,
    this.focusX = 0.50,
    this.focusY = 0.48,
    this.syncedToSupabase = false,
  });

  Uint8List? get imageBytes =>
      imageBase64 != null && imageBase64!.isNotEmpty ? base64Decode(imageBase64!) : null;

  ScanResult copyWith({bool? syncedToSupabase}) {
    return ScanResult(
      id: id,
      predictedClass: predictedClass,
      confidence: confidence,
      probabilities: probabilities,
      backbone: backbone,
      inferenceTimeMs: inferenceTimeMs,
      isDemo: isDemo,
      sourceBackend: sourceBackend,
      itemTitle: itemTitle,
      timestamp: timestamp,
      imageBase64: imageBase64,
      gradcamUrl: gradcamUrl,
      focusX: focusX,
      focusY: focusY,
      syncedToSupabase: syncedToSupabase ?? this.syncedToSupabase,
    );
  }

  Map<String, dynamic> toJson() {
    final probJson = <String, double>{};
    probabilities.forEach((key, value) {
      probJson[key.shortLabel] = value;
    });
    return {
      'id': id,
      'predictedClass': predictedClass.shortLabel,
      'confidence': confidence,
      'probabilities': probJson,
      'backbone': backbone,
      'inferenceTimeMs': inferenceTimeMs,
      'isDemo': isDemo,
      'sourceBackend': sourceBackend,
      'itemTitle': itemTitle,
      'timestamp': timestamp.toIso8601String(),
      'imageBase64': imageBase64,
      'gradcamUrl': gradcamUrl,
      'focusX': focusX,
      'focusY': focusY,
      'syncedToSupabase': syncedToSupabase,
    };
  }

  Map<String, dynamic> toApiPayloadPreview() {
    final probJson = <String, double>{};
    probabilities.forEach((key, value) {
      probJson[key.codeBadge] = double.parse(value.toStringAsFixed(4));
    });
    return {
      'status': 'success',
      'source_backend': sourceBackend,
      'is_demo': isDemo,
      'model_architecture': {
        'backbone': backbone,
        'input_tensor_shape': [1, 224, 224, 3],
        'inference_latency_ms': inferenceTimeMs,
      },
      'prediction': {
        'resin_code': predictedClass.codeBadge,
        'label': predictedClass.shortLabel,
        'confidence': double.parse(confidence.toStringAsFixed(4)),
      },
      'softmax_distribution': probJson,
    };
  }

  Map<String, dynamic> toSupabaseRow(String deviceId) {
    final probJson = <String, double>{};
    probabilities.forEach((key, value) {
      probJson[key.shortLabel] = double.parse(value.toStringAsFixed(4));
    });
    return {
      'predicted_label': predictedClass.shortLabel,
      'confidence': double.parse(confidence.toStringAsFixed(4)),
      'model_name': backbone,
      'is_demo': isDemo,
      'inference_time_ms': inferenceTimeMs,
      'user_consent_logged': true,
      'device_id': deviceId,
      'item_title': itemTitle,
      'probabilities': probJson,
      'source_backend': sourceBackend,
    };
  }

  factory ScanResult.fromJson(Map<String, dynamic> json) {
    final rawProbs = (json['probabilities'] as Map<String, dynamic>?) ?? {};
    final parsedProbs = <PlasticClass, double>{};
    for (final cls in PlasticClass.values) {
      final val = rawProbs[cls.shortLabel] ?? rawProbs[cls.shortLabel.toUpperCase()];
      parsedProbs[cls] = (val is num) ? val.toDouble() : 0.0;
    }

    return ScanResult(
      id: (json['id'] as String?) ?? 'scan_${DateTime.now().millisecondsSinceEpoch}',
      predictedClass: PlasticClass.fromString((json['predictedClass'] as String?) ?? 'PET'),
      confidence: (json['confidence'] as num?)?.toDouble() ?? 0.70,
      probabilities: parsedProbs,
      backbone: (json['backbone'] as String?) ?? 'MobileNetV2',
      inferenceTimeMs: (json['inferenceTimeMs'] as num?)?.toInt() ?? 42,
      isDemo: (json['isDemo'] as bool?) ?? true,
      sourceBackend: (json['sourceBackend'] as String?) ?? 'lightweight_ml',
      itemTitle: (json['itemTitle'] as String?) ?? 'Sampah Plastik',
      timestamp: DateTime.tryParse((json['timestamp'] as String?) ?? '') ?? DateTime.now(),
      imageBase64: json['imageBase64'] as String?,
      gradcamUrl: json['gradcamUrl'] as String?,
      focusX: (json['focusX'] as num?)?.toDouble() ?? 0.50,
      focusY: (json['focusY'] as num?)?.toDouble() ?? 0.48,
      syncedToSupabase: (json['syncedToSupabase'] as bool?) ?? false,
    );
  }
}
