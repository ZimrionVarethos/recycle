import 'dart:typed_data';
import 'package:flutter/material.dart';
import '../models/app_settings.dart';
import '../models/plastic_class.dart';
import '../models/scan_result.dart';
import '../services/classifier_service.dart';
import '../services/lightweight_ml_service.dart';
import '../services/python_api_service.dart';
import '../services/storage_service.dart';
import '../services/supabase_service.dart';

class AppController extends ChangeNotifier {
  final StorageService _storage = StorageService();
  final SupabaseService _supabase = SupabaseService();
  final LightweightMlService _lightweightMl = LightweightMlService();

  AppSettings _settings = const AppSettings();
  List<ScanResult> _history = [];
  String _deviceId = 'ds_local_device';
  int _currentTabIndex = 0;
  bool _isInitialized = false;
  bool _isScanning = false;
  String? _scanError;
  PlasticClass _preselectedSample = PlasticClass.pet;

  AppSettings get settings => _settings;
  List<ScanResult> get history => List.unmodifiable(_history);
  String get deviceId => _deviceId;
  int get currentTabIndex => _currentTabIndex;
  bool get isInitialized => _isInitialized;
  bool get isScanning => _isScanning;
  String? get scanError => _scanError;
  PlasticClass get preselectedSample => _preselectedSample;

  ClassifierService get activeClassifier {
    if (_settings.backendMode == BackendMode.pythonFastApi) {
      return PythonApiService(baseUrl: _settings.pythonApiUrl);
    }
    return _lightweightMl;
  }

  Future<void> initialize() async {
    _deviceId = await _storage.getOrCreateDeviceId();
    _settings = await _storage.loadSettings();
    _history = await _storage.loadHistory();
    _isInitialized = true;
    notifyListeners();
  }

  void setTab(int index) {
    if (_currentTabIndex == index) return;
    _currentTabIndex = index;
    notifyListeners();
  }

  void jumpToScanWithSample(PlasticClass cls) {
    _preselectedSample = cls;
    _currentTabIndex = 1;
    notifyListeners();
  }

  void setPreselectedSample(PlasticClass cls) {
    if (_preselectedSample == cls) return;
    _preselectedSample = cls;
    notifyListeners();
  }

  Future<void> updateSettings(AppSettings updated) async {
    _settings = updated;
    await _storage.saveSettings(updated);
    notifyListeners();
  }

  void toggleThemeMode() {
    updateSettings(
      _settings.copyWith(isLightLabTheme: !_settings.isLightLabTheme),
    );
  }

  void toggleScanAnimation() {
    updateSettings(
      _settings.copyWith(enableScanAnimation: !_settings.enableScanAnimation),
    );
  }

  Future<ScanResult?> scanImageBytes({
    required Uint8List bytes,
    required String fileName,
    String? backboneOverride,
  }) async {
    _isScanning = true;
    _scanError = null;
    notifyListeners();

    try {
      final backbone = backboneOverride ?? _settings.defaultBackbone;
      var result = await activeClassifier.classifyImage(
        imageBytes: bytes,
        fileName: fileName,
        backbone: backbone,
      );

      result = await _persistAndSyncResult(result);
      _isScanning = false;
      notifyListeners();
      return result;
    } catch (e) {
      _isScanning = false;
      _scanError = e.toString();
      notifyListeners();
      return null;
    }
  }

  Future<ScanResult?> scanSample({
    required PlasticClass sampleClass,
    String? backboneOverride,
  }) async {
    _isScanning = true;
    _scanError = null;
    notifyListeners();

    try {
      final backbone = backboneOverride ?? _settings.defaultBackbone;
      var result = await activeClassifier.classifySample(
        sampleClass: sampleClass,
        backbone: backbone,
      );

      result = await _persistAndSyncResult(result);
      _isScanning = false;
      notifyListeners();
      return result;
    } catch (e) {
      _isScanning = false;
      _scanError = e.toString();
      notifyListeners();
      return null;
    }
  }

  void clearScanError() {
    _scanError = null;
    notifyListeners();
  }

  Future<ScanResult> _persistAndSyncResult(ScanResult result) async {
    var finalResult = result;
    if (_settings.saveLogsToSupabase && _settings.hasSupabaseConfig) {
      final synced = await _supabase.logClassification(
        url: _settings.supabaseUrl,
        anonKey: _settings.supabaseAnonKey,
        deviceId: _deviceId,
        result: result,
      );
      finalResult = result.copyWith(syncedToSupabase: synced);
    }

    _history = [finalResult, ..._history];
    await _storage.saveHistory(_history);
    return finalResult;
  }

  Future<void> deleteHistoryItem(String id) async {
    _history = _history.where((item) => item.id != id).toList();
    await _storage.saveHistory(_history);
    notifyListeners();
  }

  Future<void> clearHistory() async {
    _history = [];
    await _storage.saveHistory(_history);
    notifyListeners();
  }

  Future<int> syncHistoryFromSupabase() async {
    if (!_settings.hasSupabaseConfig) return 0;
    final remote = await _supabase.fetchDeviceHistory(
      url: _settings.supabaseUrl,
      anonKey: _settings.supabaseAnonKey,
      deviceId: _deviceId,
    );
    if (remote.isEmpty) return 0;

    final existingIds = _history.map((e) => e.id).toSet();
    final newItems = remote.where((r) => !existingIds.contains(r.id)).toList();
    if (newItems.isNotEmpty) {
      _history = [..._history, ...newItems]
        ..sort((a, b) => b.timestamp.compareTo(a.timestamp));
      await _storage.saveHistory(_history);
      notifyListeners();
    }
    return newItems.length;
  }

  Future<BackendHealthStatus> testMlBackendHealth() {
    return activeClassifier.checkHealth();
  }

  Future<SupabaseResult> testSupabaseConnection() {
    return _supabase.testConnection(
      url: _settings.supabaseUrl,
      anonKey: _settings.supabaseAnonKey,
      deviceId: _deviceId,
    );
  }

  Future<SupabaseResult> submitFeedback({
    required ScanResult scanResult,
    required PlasticClass correctedClass,
    String? notes,
  }) {
    return _supabase.submitFeedback(
      url: _settings.supabaseUrl,
      anonKey: _settings.supabaseAnonKey,
      scanResult: scanResult,
      correctedClass: correctedClass,
      notes: notes,
    );
  }
}
