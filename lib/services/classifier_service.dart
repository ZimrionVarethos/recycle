import 'dart:typed_data';
import '../models/plastic_class.dart';
import '../models/scan_result.dart';

class BackendHealthStatus {
  final bool isHealthy;
  final String message;
  final bool modelLoaded;

  const BackendHealthStatus({
    required this.isHealthy,
    required this.message,
    this.modelLoaded = false,
  });
}

abstract class ClassifierService {
  Future<ScanResult> classifyImage({
    required Uint8List imageBytes,
    required String fileName,
    required String backbone,
  });

  Future<ScanResult> classifySample({
    required PlasticClass sampleClass,
    required String backbone,
  });

  Future<BackendHealthStatus> checkHealth();
}
