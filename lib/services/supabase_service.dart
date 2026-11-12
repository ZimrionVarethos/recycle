import 'package:supabase/supabase.dart';
import '../models/plastic_class.dart';
import '../models/scan_result.dart';

class SupabaseResult {
  final bool success;
  final String message;

  const SupabaseResult({required this.success, required this.message});
}

class SupabaseService {
  SupabaseClient? _createClient(String url, String anonKey) {
    final cleanUrl = url.trim();
    final cleanKey = anonKey.trim();
    if (cleanUrl.isEmpty || cleanKey.isEmpty) return null;
    if (!cleanUrl.startsWith('http')) return null;

    return SupabaseClient(cleanUrl, cleanKey);
  }

  Future<SupabaseResult> testConnection({
    required String url,
    required String anonKey,
    required String deviceId,
  }) async {
    final client = _createClient(url, anonKey);
    if (client == null) {
      return const SupabaseResult(
        success: false,
        message: 'URL atau Anon Key Supabase belum lengkap/valid.',
      );
    }

    try {
      await client
          .from('classification_logs')
          .select('id')
          .eq('device_id', deviceId)
          .limit(1);

      return const SupabaseResult(
        success: true,
        message: 'Terhubung ke Supabase PostgreSQL (RLS Aktif).',
      );
    } on PostgrestException catch (e) {
      return SupabaseResult(
        success: false,
        message: 'Error Skema/RLS Supabase: ${e.message}',
      );
    } catch (e) {
      return SupabaseResult(
        success: false,
        message: 'Gagal menghubungi Supabase: $e',
      );
    }
  }

  Future<bool> logClassification({
    required String url,
    required String anonKey,
    required String deviceId,
    required ScanResult result,
  }) async {
    final client = _createClient(url, anonKey);
    if (client == null) return false;

    try {
      await client
          .from('classification_logs')
          .insert(result.toSupabaseRow(deviceId));
      return true;
    } catch (_) {
      return false;
    }
  }

  Future<List<ScanResult>> fetchDeviceHistory({
    required String url,
    required String anonKey,
    required String deviceId,
  }) async {
    final client = _createClient(url, anonKey);
    if (client == null) return [];

    try {
      final rows = await client
          .from('classification_logs')
          .select()
          .eq('device_id', deviceId)
          .order('created_at', ascending: false)
          .limit(30);

      return (rows as List<dynamic>).map((raw) {
        final row = raw as Map<String, dynamic>;
        final rawProbs = (row['probabilities'] as Map<String, dynamic>?) ?? {};
        final parsedProbs = <PlasticClass, double>{};
        for (final cls in PlasticClass.values) {
          final v = rawProbs[cls.shortLabel];
          parsedProbs[cls] = (v is num) ? v.toDouble() : 0.0;
        }
        final predicted = PlasticClass.fromString(
          (row['predicted_label'] as String?) ?? 'Other',
        );

        return ScanResult(
          id: row['id'].toString(),
          predictedClass: predicted,
          confidence: (row['confidence'] as num?)?.toDouble() ?? 0.70,
          probabilities: parsedProbs,
          backbone: (row['model_name'] as String?) ?? 'MobileNetV2',
          inferenceTimeMs: (row['inference_time_ms'] as num?)?.toInt() ?? 42,
          isDemo: (row['is_demo'] as bool?) ?? true,
          sourceBackend:
              (row['source_backend'] as String?) ?? 'lightweight_ml',
          itemTitle: (row['item_title'] as String?) ??
              'Riwayat Cloud (${predicted.shortLabel})',
          timestamp: DateTime.tryParse((row['created_at'] as String?) ?? '') ??
              DateTime.now(),
          syncedToSupabase: true,
        );
      }).toList();
    } catch (_) {
      return [];
    }
  }

  Future<SupabaseResult> submitFeedback({
    required String url,
    required String anonKey,
    required ScanResult scanResult,
    required PlasticClass correctedClass,
    String? notes,
  }) async {
    final client = _createClient(url, anonKey);
    if (client == null) {
      return const SupabaseResult(
        success: true,
        message: 'Koreksi disimpan lokal (Supabase belum dikonfigurasi).',
      );
    }

    try {
      await client.from('classification_feedback').insert({
        'prediction_id': scanResult.id,
        'predicted_label': scanResult.predictedClass.shortLabel,
        'corrected_label': correctedClass.shortLabel,
        'confidence': scanResult.confidence,
        'notes': (notes != null && notes.trim().isNotEmpty) ? notes.trim() : null,
      });

      return const SupabaseResult(
        success: true,
        message: 'Terima kasih! Koreksi label berhasil dikirim ke Supabase.',
      );
    } catch (e) {
      return SupabaseResult(
        success: false,
        message: 'Gagal mengirim ke Supabase: $e',
      );
    }
  }
}
