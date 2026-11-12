import 'dart:convert';
import 'dart:math';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/app_settings.dart';
import '../models/plastic_class.dart';
import '../models/scan_result.dart';

class StorageService {
  static const String _settingsKey = 'ds_app_settings_v1';
  static const String _historyKey = 'ds_scan_history_v1';
  static const String _deviceIdKey = 'ds_device_id_v1';
  static const String _seededKey = 'ds_seeded_initial_v1';

  Future<String> getOrCreateDeviceId() async {
    final prefs = await SharedPreferences.getInstance();
    final existing = prefs.getString(_deviceIdKey);
    if (existing != null && existing.length >= 8) return existing;

    final rng = Random();
    final id = 'ds_${DateTime.now().millisecondsSinceEpoch}_${rng.nextInt(99999)}';
    await prefs.setString(_deviceIdKey, id);
    return id;
  }

  Future<AppSettings> loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_settingsKey);
    if (raw == null || raw.isEmpty) return const AppSettings();

    try {
      final decoded = jsonDecode(raw) as Map<String, dynamic>;
      return AppSettings.fromJson(decoded);
    } catch (_) {
      return const AppSettings();
    }
  }

  Future<void> saveSettings(AppSettings settings) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_settingsKey, jsonEncode(settings.toJson()));
  }

  Future<List<ScanResult>> loadHistory() async {
    final prefs = await SharedPreferences.getInstance();
    final hasSeeded = prefs.getBool(_seededKey) ?? false;
    final raw = prefs.getString(_historyKey);

    if (!hasSeeded && (raw == null || raw.isEmpty)) {
      final initial = _buildInitialDemoHistory();
      await saveHistory(initial);
      await prefs.setBool(_seededKey, true);
      return initial;
    }

    if (raw == null || raw.isEmpty) return [];

    try {
      final list = jsonDecode(raw) as List<dynamic>;
      return list
          .map((e) => ScanResult.fromJson(e as Map<String, dynamic>))
          .toList();
    } catch (_) {
      return [];
    }
  }

  Future<void> saveHistory(List<ScanResult> history) async {
    final prefs = await SharedPreferences.getInstance();
    // Batasi maksimum 40 riwayat lokal agar penyimpanan tetap ringan
    final trimmed = history.take(40).toList();
    final encoded = jsonEncode(trimmed.map((e) => e.toJson()).toList());
    await prefs.setString(_historyKey, encoded);
  }

  List<ScanResult> _buildInitialDemoHistory() {
    final now = DateTime.now();
    return [
      ScanResult(
        id: 'seed_pet_1',
        predictedClass: PlasticClass.pet,
        confidence: 0.784,
        probabilities: const {
          PlasticClass.pet: 0.784,
          PlasticClass.hdpe: 0.052,
          PlasticClass.pvc: 0.021,
          PlasticClass.ldpe: 0.068,
          PlasticClass.pp: 0.044,
          PlasticClass.ps: 0.015,
          PlasticClass.other: 0.016,
        },
        backbone: 'MobileNetV2',
        inferenceTimeMs: 42,
        isDemo: true,
        sourceBackend: 'lightweight_ml',
        itemTitle: 'Botol Air Mineral Transparan',
        timestamp: now.subtract(const Duration(minutes: 18)),
      ),
      ScanResult(
        id: 'seed_hdpe_2',
        predictedClass: PlasticClass.hdpe,
        confidence: 0.742,
        probabilities: const {
          PlasticClass.pet: 0.054,
          PlasticClass.hdpe: 0.742,
          PlasticClass.pvc: 0.032,
          PlasticClass.ldpe: 0.048,
          PlasticClass.pp: 0.081,
          PlasticClass.ps: 0.021,
          PlasticClass.other: 0.022,
        },
        backbone: 'MobileNetV2',
        inferenceTimeMs: 46,
        isDemo: true,
        sourceBackend: 'lightweight_ml',
        itemTitle: 'Jerigen Deterjen Putih',
        timestamp: now.subtract(const Duration(minutes: 45)),
      ),
    ];
  }
}
