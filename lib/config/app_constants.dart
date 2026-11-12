class AppConstants {
  static const String appName = 'DEEP SORTING';
  static const String appSubtitle =
      'Klasifikasi Jenis Sampah Plastik dengan CNN dan Transfer Learning';
  static const String institution = 'IPB University • Visual Komputer Cerdas';
  static const String teamName = 'Kelompok 7';

  static const int totalDatasetImages = 1331;
  static const String inputResolution = '224 × 224 × 3 RGB';
  static const String currentTrainingNote = 'Colab Training ~70%';
  static const String releaseTargetNote = 'Target Acceptance ≥92%';

  static const List<String> backbones = [
    'MobileNetV2',
    'VGG16',
    'CNN Custom',
  ];

  // Dapat diisi saat build via --dart-define atau dikonfigurasi langsung di menu Pengaturan aplikasi
  static const String defaultSupabaseUrl = String.fromEnvironment(
    'SUPABASE_URL',
    defaultValue: '',
  );
  static const String defaultSupabaseAnonKey = String.fromEnvironment(
    'SUPABASE_ANON_KEY',
    defaultValue: '',
  );
  static const String defaultPythonApiUrl = String.fromEnvironment(
    'PYTHON_ML_URL',
    defaultValue: 'http://10.0.2.2:8000',
  );

  static const List<Map<String, String>> heroPins = [
    {'id': '0', 'label': '[PET #1] Botol Air', 'top': '0.16', 'left': '0.50'},
    {'id': '1', 'label': '[HDPE #2] Jerigen Putih', 'top': '0.52', 'left': '0.26'},
    {'id': '4', 'label': '[PP #5] Gelas Cup', 'top': '0.72', 'left': '0.18'},
    {'id': '3', 'label': '[LDPE #4] Kantong Hijau', 'top': '0.78', 'left': '0.50'},
    {'id': '5', 'label': '[PS #6] Wadah Makanan', 'top': '0.88', 'left': '0.32'},
  ];

  static const List<Map<String, String>> baselineBenchmarks = [
    {
      'name': 'MobileNetV2 (Transfer Learning)',
      'params': '3.5M parameter',
      'baselineAcc': '64.3% (Run Awal)',
      'note': 'Ringan dan cepat, kandidat utama deployment mobile & FastAPI.',
    },
    {
      'name': 'VGG16 (Transfer Learning)',
      'params': '138M parameter',
      'baselineAcc': '62.2% (Run Awal)',
      'note': 'Ekstraksi tepi tajam namun bobot model besar (~500 MB).',
    },
    {
      'name': 'CNN Custom (4-Layer Baseline)',
      'params': '1.8M parameter',
      'baselineAcc': '40.3% (Run Awal)',
      'note': 'Dilatih dari scratch pada 1.331 citra; butuh augmentasi intensif.',
    },
  ];
}
