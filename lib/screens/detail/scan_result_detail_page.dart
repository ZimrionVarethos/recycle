import 'package:flutter/material.dart';
import '../../config/app_constants.dart';
import '../../config/app_theme.dart';
import '../../config/plastics_data.dart';
import '../../models/scan_result.dart';
import '../../state/app_controller.dart';
import '../../widgets/common/brutal_button.dart';
import '../../widgets/common/brutal_card.dart';
import 'detail_extra_cards.dart';
import 'feedback_sheet.dart';
import 'gradcam_preview.dart';
import 'softmax_chart.dart';

class ScanResultDetailPage extends StatelessWidget {
  final ScanResult result;
  final AppController controller;
  final bool openedFromHistory;

  const ScanResultDetailPage({
    super.key,
    required this.result,
    required this.controller,
    this.openedFromHistory = false,
  });

  @override
  Widget build(BuildContext context) {
    final info = PlasticsCatalog.byClass(result.predictedClass);
    final isLight = controller.settings.isLightLabTheme;
    final confPct = (result.confidence * 100).toStringAsFixed(1);

    return Scaffold(
      backgroundColor: isLight ? AppColors.bgSurfaceMuted : AppColors.bgCanvasDark,
      appBar: AppBar(
        backgroundColor: AppColors.bgHeroTop,
        foregroundColor: AppColors.whitePure,
        elevation: 0,
        title: Text(
          openedFromHistory ? 'Detail Riwayat Scan' : 'Hasil Klasifikasi CNN',
          style: AppTheme.ubuntu(fontSize: 17, fontWeight: FontWeight.w700),
        ),
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 12),
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: result.isDemo
                  ? AppColors.mintPistachio
                  : AppColors.greenBright,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: AppColors.blackInk, width: 2),
            ),
            child: Text(
              result.isDemo ? 'MODE DEMO' : 'PYTHON API',
              style: AppTheme.mono(
                fontSize: 10,
                fontWeight: FontWeight.w700,
                color: result.isDemo ? AppColors.blackInk : AppColors.whitePure,
              ),
            ),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
        children: [
          GradCamPreview(
            imageBytes: result.imageBytes,
            gradcamUrl: result.gradcamUrl,
            plasticClass: result.predictedClass,
            focusX: result.focusX,
            focusY: result.focusY,
          ),
          const SizedBox(height: 16),
          _buildPredictionSummaryCard(info.polymerName, confPct),
          const SizedBox(height: 16),
          RecyclingGuideCard(
            recyclability: info.recyclability,
            handling: info.handlingGuide,
            safety: info.safetyNote,
          ),
          const SizedBox(height: 16),
          SoftmaxChart(
            probabilities: result.probabilities,
            winner: result.predictedClass,
            backbone: result.backbone,
          ),
          const SizedBox(height: 16),
          JsonInspectorCard(result: result),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: BrutalButton(
                  label: 'Koreksi Label',
                  icon: Icons.edit_note_rounded,
                  variant: BrutalButtonVariant.white,
                  onPressed: () => showFeedbackSheet(
                    context: context,
                    controller: controller,
                    scanResult: result,
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: BrutalButton(
                  label: openedFromHistory ? 'Tutup' : 'Scan Lagi',
                  icon: openedFromHistory
                      ? Icons.arrow_back_rounded
                      : Icons.qr_code_scanner_rounded,
                  variant: BrutalButtonVariant.mint,
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPredictionSummaryCard(String polymerName, String confPct) {
    return BrutalCard(
      isDark: true,
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                  color: AppColors.mintPistachio,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  result.predictedClass.codeBadge,
                  style: AppTheme.mono(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: AppColors.blackInk,
                  ),
                ),
              ),
              Text(
                '${result.inferenceTimeMs} ms • ${result.backbone}',
                style: AppTheme.mono(
                  fontSize: 11,
                  color: AppColors.mintPistachio,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            result.itemTitle,
            style: AppTheme.ubuntu(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: AppColors.whitePure,
            ),
          ),
          Text(
            polymerName,
            style: AppTheme.ubuntu(
              fontSize: 13,
              color: AppColors.textMutedDark,
            ),
          ),
          const SizedBox(height: 14),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Confidence Score',
                style: AppTheme.mono(fontSize: 11, color: AppColors.textMutedDark),
              ),
              Text(
                '$confPct%',
                style: AppTheme.mono(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: AppColors.mintPistachio,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Container(
            height: 12,
            width: double.infinity,
            padding: const EdgeInsets.all(2),
            decoration: BoxDecoration(
              color: AppColors.blackInk,
              borderRadius: BorderRadius.circular(99),
            ),
            child: FractionallySizedBox(
              alignment: Alignment.centerLeft,
              widthFactor: result.confidence.clamp(0.05, 1.0),
              child: Container(
                decoration: BoxDecoration(
                  gradient: AppColors.mintGradient,
                  borderRadius: BorderRadius.circular(99),
                ),
              ),
            ),
          ),
          const SizedBox(height: 10),
          Text(
            result.syncedToSupabase
                ? '✓ Tersinkronisasi ke riwayat lokal & Supabase'
                : '• Tersimpan di blok riwayat lokal (${AppConstants.currentTrainingNote})',
            style: AppTheme.mono(fontSize: 10, color: AppColors.textMutedDark),
          ),
        ],
      ),
    );
  }
}
