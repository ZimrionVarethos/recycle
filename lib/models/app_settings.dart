import '../config/app_constants.dart';

enum BackendMode {
  dummyLightweightSupabase,
  pythonFastApi;

  String get label {
    switch (this) {
      case BackendMode.dummyLightweightSupabase:
        return 'Dummy: ML Ringan + Supabase';
      case BackendMode.pythonFastApi:
        return 'Python FastAPI Backend';
    }
  }

  String get shortTag {
    switch (this) {
      case BackendMode.dummyLightweightSupabase:
        return 'DUMMY • ML RINGAN + SUPABASE';
      case BackendMode.pythonFastApi:
        return 'LIVE • PYTHON FASTAPI';
    }
  }
}

class AppSettings {
  final BackendMode backendMode;
  final String pythonApiUrl;
  final String supabaseUrl;
  final String supabaseAnonKey;
  final bool saveLogsToSupabase;
  final String defaultBackbone;
  final bool isLightLabTheme;
  final bool enableScanAnimation;

  const AppSettings({
    this.backendMode = BackendMode.dummyLightweightSupabase,
    this.pythonApiUrl = AppConstants.defaultPythonApiUrl,
    this.supabaseUrl = AppConstants.defaultSupabaseUrl,
    this.supabaseAnonKey = AppConstants.defaultSupabaseAnonKey,
    this.saveLogsToSupabase = true,
    this.defaultBackbone = 'MobileNetV2',
    this.isLightLabTheme = false,
    this.enableScanAnimation = true,
  });

  bool get hasSupabaseConfig =>
      supabaseUrl.trim().isNotEmpty && supabaseAnonKey.trim().isNotEmpty;

  AppSettings copyWith({
    BackendMode? backendMode,
    String? pythonApiUrl,
    String? supabaseUrl,
    String? supabaseAnonKey,
    bool? saveLogsToSupabase,
    String? defaultBackbone,
    bool? isLightLabTheme,
    bool? enableScanAnimation,
  }) {
    return AppSettings(
      backendMode: backendMode ?? this.backendMode,
      pythonApiUrl: pythonApiUrl ?? this.pythonApiUrl,
      supabaseUrl: supabaseUrl ?? this.supabaseUrl,
      supabaseAnonKey: supabaseAnonKey ?? this.supabaseAnonKey,
      saveLogsToSupabase: saveLogsToSupabase ?? this.saveLogsToSupabase,
      defaultBackbone: defaultBackbone ?? this.defaultBackbone,
      isLightLabTheme: isLightLabTheme ?? this.isLightLabTheme,
      enableScanAnimation: enableScanAnimation ?? this.enableScanAnimation,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'backendMode': backendMode.name,
      'pythonApiUrl': pythonApiUrl,
      'supabaseUrl': supabaseUrl,
      'supabaseAnonKey': supabaseAnonKey,
      'saveLogsToSupabase': saveLogsToSupabase,
      'defaultBackbone': defaultBackbone,
      'isLightLabTheme': isLightLabTheme,
      'enableScanAnimation': enableScanAnimation,
    };
  }

  factory AppSettings.fromJson(Map<String, dynamic> json) {
    final modeStr = json['backendMode'] as String?;
    final mode = modeStr == BackendMode.pythonFastApi.name
        ? BackendMode.pythonFastApi
        : BackendMode.dummyLightweightSupabase;

    return AppSettings(
      backendMode: mode,
      pythonApiUrl:
          (json['pythonApiUrl'] as String?) ?? AppConstants.defaultPythonApiUrl,
      supabaseUrl:
          (json['supabaseUrl'] as String?) ?? AppConstants.defaultSupabaseUrl,
      supabaseAnonKey: (json['supabaseAnonKey'] as String?) ??
          AppConstants.defaultSupabaseAnonKey,
      saveLogsToSupabase: (json['saveLogsToSupabase'] as bool?) ?? true,
      defaultBackbone: (json['defaultBackbone'] as String?) ?? 'MobileNetV2',
      isLightLabTheme: (json['isLightLabTheme'] as bool?) ?? false,
      enableScanAnimation: (json['enableScanAnimation'] as bool?) ?? true,
    );
  }
}
