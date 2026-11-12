import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image/image.dart' as img;
import 'package:shared_preferences/shared_preferences.dart';

import 'package:deep_sorting/config/plastics_data.dart';
import 'package:deep_sorting/main.dart';
import 'package:deep_sorting/models/app_settings.dart';
import 'package:deep_sorting/models/plastic_class.dart';
import 'package:deep_sorting/screens/detail/scan_result_detail_page.dart';
import 'package:deep_sorting/screens/scan/scan_page.dart';
import 'package:deep_sorting/services/lightweight_ml_service.dart';
import 'package:deep_sorting/state/app_controller.dart';

void main() {
  setUp(() {
    GoogleFonts.config.allowRuntimeFetching = false;
    SharedPreferences.setMockInitialValues({
      'ds_app_settings_v1': '{"enableScanAnimation":false}',
    });
  });

  test('PlasticsCatalog memuat 7 kelas ASTM D7611 lengkap', () {
    expect(PlasticsCatalog.all.length, 7);
    expect(PlasticClass.values.length, 7);
    expect(PlasticsCatalog.byClass(PlasticClass.pet).plasticClass.resinNumber, 1);
    expect(PlasticsCatalog.byClass(PlasticClass.ps).datasetCount, 96);
    expect(PlasticsCatalog.byClass(PlasticClass.other).datasetCount, 186);
  });

  test('LightweightMlService mengklasifikasikan sampel & gambar dengan Softmax = 1', () async {
    final ml = LightweightMlService();

    final sampleRes = await ml.classifySample(
      sampleClass: PlasticClass.hdpe,
      backbone: 'MobileNetV2',
    );
    expect(sampleRes.isDemo, isTrue);
    expect(sampleRes.sourceBackend, 'lightweight_ml');
    expect(sampleRes.predictedClass, PlasticClass.hdpe);
    final sumSample = sampleRes.probabilities.values.reduce((a, b) => a + b);
    expect(sumSample, closeTo(1.0, 0.001));

    // Buat citra uji RGB sintetis 64x64
    final synthetic = img.Image(width: 64, height: 64);
    img.fill(synthetic, color: img.ColorRgb8(210, 235, 225));
    final pngBytes = Uint8List.fromList(img.encodePng(synthetic));

    final imgRes = await ml.classifyImage(
      imageBytes: pngBytes,
      fileName: 'botol_pet_uji.png',
      backbone: 'MobileNetV2',
    );
    expect(imgRes.isDemo, isTrue);
    expect(imgRes.probabilities.length, 7);
    final sumImg = imgRes.probabilities.values.reduce((a, b) => a + b);
    expect(sumImg, closeTo(1.0, 0.001));
    expect(imgRes.imageBase64, isNotNull);
  });

  test('AppSettings serialisasi mode dummy vs Python FastAPI', () {
    const initial = AppSettings();
    expect(initial.backendMode, BackendMode.dummyLightweightSupabase);

    final updated = initial.copyWith(
      backendMode: BackendMode.pythonFastApi,
      pythonApiUrl: 'https://api.example.com',
      isLightLabTheme: true,
    );
    final restored = AppSettings.fromJson(updated.toJson());
    expect(restored.backendMode, BackendMode.pythonFastApi);
    expect(restored.pythonApiUrl, 'https://api.example.com');
    expect(restored.isLightLabTheme, isTrue);
  });

  testWidgets(
    'Navigasi 4 tab, scan sampel -> halaman detail baru -> blok riwayat',
    (WidgetTester tester) async {
      final controller = AppController();
      await controller.initialize();

      await tester.pumpWidget(DeepSortingApp(controller: controller));
      await tester.pump(const Duration(milliseconds: 200));

      // 4 tab utama tampil
      expect(find.text('Beranda'), findsOneWidget);
      expect(find.text('Scan'), findsWidgets);
      expect(find.text('Riwayat'), findsOneWidget);
      expect(find.text('Pengaturan'), findsOneWidget);

      final initialHistoryCount = controller.history.length;

      // Pindah ke tab Scan
      await tester.tap(find.byKey(const Key('nav_tab_1')));
      await tester.pump(const Duration(milliseconds: 200));
      expect(find.text('Scanner Klasifikasi Plastik'), findsOneWidget);

      // Jalankan simulasi sampel langsung (membuka halaman detail hasil baru)
      final scanScrollable = find.descendant(
        of: find.byType(ScanPage),
        matching: find.byType(Scrollable),
      ).first;
      await tester.scrollUntilVisible(
        find.text('Jalankan Simulasi Sampel'),
        200,
        scrollable: scanScrollable,
      );
      await tester.tap(find.text('Jalankan Simulasi Sampel'));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 450));
      await tester.pump(const Duration(milliseconds: 400));

      expect(find.text('Hasil Klasifikasi CNN'), findsOneWidget);
      expect(find.text('MODE DEMO'), findsOneWidget);
      expect(controller.history.length, initialHistoryCount + 1);

      // Tutup halaman detail -> pindah ke Riwayat dan cek blok muncul
      final detailScrollable = find.descendant(
        of: find.byType(ScanResultDetailPage),
        matching: find.byType(Scrollable),
      ).first;
      await tester.scrollUntilVisible(
        find.text('Scan Lagi'),
        250,
        scrollable: detailScrollable,
      );
      await tester.tap(find.text('Scan Lagi'));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 400));

      await tester.tap(find.byKey(const Key('nav_tab_2')));
      await tester.pump(const Duration(milliseconds: 200));
      expect(find.text('Blok Riwayat Scan'), findsOneWidget);

      // Cek tab Pengaturan juga merender switch mode backend tanpa error
      await tester.tap(find.byKey(const Key('nav_tab_3')));
      await tester.pump(const Duration(milliseconds: 200));
      expect(find.text('Pengaturan Sistem'), findsOneWidget);
      expect(find.text('Dummy: ML Ringan + Supabase'), findsOneWidget);
      expect(find.text('Python FastAPI Backend'), findsOneWidget);
    },
  );
}
