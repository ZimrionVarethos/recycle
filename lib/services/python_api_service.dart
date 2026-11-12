import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import '../config/plastics_data.dart';
import '../models/plastic_class.dart';
import '../models/scan_result.dart';
import 'classifier_service.dart';

class PythonApiException implements Exception {
  final String message;
  PythonApiException(this.message);

  @override
  String toString() => message;
}

class PythonApiService implements ClassifierService {
  final String baseUrl;
  final Duration timeout;

  PythonApiService({
    required this.baseUrl,
    this.timeout = const Duration(seconds: 15),
  });

  String get _cleanBaseUrl => baseUrl.trim().replaceAll(RegExp(r'/$'), '');

  @override
  Future<BackendHealthStatus> checkHealth() async {
    if (_cleanBaseUrl.isEmpty) {
      return const BackendHealthStatus(
        isHealthy: false,
        message: 'URL Backend Python belum diisi di Pengaturan.',
      );
    }

    try {
      final uri = Uri.parse('$_cleanBaseUrl/health');
      final res = await http.get(uri).timeout(const Duration(seconds: 5));
      if (res.statusCode == 200) {
        final data = jsonDecode(res.body) as Map<String, dynamic>;
        final loaded = (data['model_loaded'] as bool?) ?? false;
        return BackendHealthStatus(
          isHealthy: true,
          modelLoaded: loaded,
          message: loaded
              ? 'FastAPI Terhubung • Model Keras Aktif'
              : 'FastAPI Terhubung • Model Mode Fallback',
        );
      }
      return BackendHealthStatus(
        isHealthy: false,
        message: 'Server merespons status HTTP ${res.statusCode}',
      );
    } on TimeoutException {
      return const BackendHealthStatus(
        isHealthy: false,
        message: 'Timeout saat menghubungi server Python (/health).',
      );
    } catch (e) {
      return BackendHealthStatus(
        isHealthy: false,
        message: 'Tidak dapat terhubung ke $_cleanBaseUrl ($e)',
      );
    }
  }

  @override
  Future<ScanResult> classifyImage({
    required Uint8List imageBytes,
    required String fileName,
    required String backbone,
  }) async {
    if (_cleanBaseUrl.isEmpty) {
      throw PythonApiException('URL Backend Python masih kosong.');
    }

    try {
      final uri = Uri.parse('$_cleanBaseUrl/predict');
      final request = http.MultipartRequest('POST', uri);
      request.fields['backbone'] = backbone;

      final lowerName = fileName.toLowerCase();
      final subType = lowerName.endsWith('.png')
          ? 'png'
          : (lowerName.endsWith('.webp') ? 'webp' : 'jpeg');

      request.files.add(
        http.MultipartFile.fromBytes(
          'file',
          imageBytes,
          filename: fileName.isEmpty ? 'upload.jpg' : fileName,
          contentType: MediaType('image', subType),
        ),
      );

      final streamed = await request.send().timeout(timeout);
      final response = await http.Response.fromStream(streamed);

      if (response.statusCode != 200) {
        throw PythonApiException(
          'Server Python mengembalikan error HTTP ${response.statusCode}.',
        );
      }

      final decoded = jsonDecode(response.body);
      if (decoded is! Map<String, dynamic>) {
        throw PythonApiException('Format JSON respons Python tidak valid.');
      }

      final labelStr = (decoded['label'] as String?) ?? 'Other';
      final predicted = PlasticClass.fromString(labelStr);
      final confidence = (decoded['confidence'] as num?)?.toDouble() ?? 0.0;
      final latency = (decoded['inference_time_ms'] as num?)?.toInt() ?? 45;
      final gradcamUrl = decoded['gradcam_url'] as String?;

      final probsMap = <PlasticClass, double>{};
      final rawProbs = decoded['probabilities'] as Map<String, dynamic>?;
      for (final cls in PlasticClass.values) {
        final rawVal = rawProbs?[cls.shortLabel] ?? rawProbs?[cls.shortLabel.toUpperCase()];
        probsMap[cls] = (rawVal is num) ? rawVal.toDouble() : 0.0;
      }

      return ScanResult(
        id: 'py_${DateTime.now().millisecondsSinceEpoch}',
        predictedClass: predicted,
        confidence: confidence.clamp(0.0, 1.0),
        probabilities: probsMap,
        backbone: backbone,
        inferenceTimeMs: latency,
        isDemo: false,
        sourceBackend: 'python_api',
        itemTitle: 'Python API (${predicted.shortLabel})',
        timestamp: DateTime.now(),
        imageBase64: base64Encode(imageBytes),
        gradcamUrl: gradcamUrl,
      );
    } on TimeoutException {
      throw PythonApiException(
        'Koneksi ke server Python timeout (>15 detik). Periksa server Uvicorn/FastAPI.',
      );
    } on FormatException {
      throw PythonApiException('Respons dari server Python bukan JSON yang valid.');
    } catch (e) {
      if (e is PythonApiException) rethrow;
      throw PythonApiException('Gagal terhubung ke Python API: $e');
    }
  }

  @override
  Future<ScanResult> classifySample({
    required PlasticClass sampleClass,
    required String backbone,
  }) async {
    final health = await checkHealth();
    if (!health.isHealthy) {
      throw PythonApiException(
        'Server Python offline (${health.message}). Aktifkan Mode Dummy atau nyalakan FastAPI.',
      );
    }
    final info = PlasticsCatalog.byClass(sampleClass);
    throw PythonApiException(
      'Mode Python Live membutuhkan foto asli (${info.sampleName}). Silakan pilih dari Kamera atau Galeri.',
    );
  }
}
