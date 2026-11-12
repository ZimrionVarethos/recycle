import 'package:flutter/material.dart';
import '../../config/app_constants.dart';
import '../../config/app_theme.dart';
import '../../widgets/common/brutal_card.dart';

void showResearchInfoSheet(BuildContext context) {
  showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    backgroundColor: AppColors.bgLabWhite,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      side: BorderSide(color: AppColors.blackInk, width: 3),
    ),
    builder: (ctx) => DraggableScrollableSheet(
      expand: false,
      initialChildSize: 0.78,
      maxChildSize: 0.92,
      minChildSize: 0.5,
      builder: (_, scrollCtrl) => ListView(
        controller: scrollCtrl,
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 32),
        children: [
          Center(
            child: Container(
              width: 44,
              height: 5,
              decoration: BoxDecoration(
                color: AppColors.blackInk,
                borderRadius: BorderRadius.circular(99),
              ),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'Metodologi, Dataset & Target Riset',
            style: AppTheme.ubuntu(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: AppColors.blackInk,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            '${AppConstants.institution} • ${AppConstants.teamName}',
            style: AppTheme.mono(
              fontSize: 11,
              fontWeight: FontWeight.w700,
              color: AppColors.greenMid,
            ),
          ),
          const SizedBox(height: 16),
          BrutalCard(
            isDark: true,
            padding: const EdgeInsets.all(14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'PERBANDINGAN MODEL CNN',
                  style: AppTheme.mono(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: AppColors.mintPistachio,
                  ),
                ),
                const SizedBox(height: 10),
                for (final b in AppConstants.baselineBenchmarks) ...[
                  Text(
                    '${b['name']} • ${b['baselineAcc']}',
                    style: AppTheme.ubuntu(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: AppColors.whitePure,
                    ),
                  ),
                  Text(
                    '${b['params']} — ${b['note']}',
                    style: AppTheme.ubuntu(
                      fontSize: 12,
                      color: AppColors.textMutedDark,
                    ),
                  ),
                  const SizedBox(height: 10),
                ],
              ],
            ),
          ),
          const SizedBox(height: 14),
          BrutalCard(
            backgroundColor: AppColors.bgSurfaceMuted,
            padding: const EdgeInsets.all(14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Keterbatasan Jujur & Privasi',
                  style: AppTheme.ubuntu(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: AppColors.blackInk,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  '• Dataset total ${AppConstants.totalDatasetImages} citra (7 kelas ASTM D7611). Kelas minoritas PS (96 citra) & Other (186 citra) rentan salah prediksi sebelum focal loss/oversampling penuh.\n'
                  '• Progres Colab training saat ini ~70%; target rilis akhir adalah akurasi ≥92% & macro F1 ≥0.85 pada held-out test set.\n'
                  '• Kelas #7 "Other" merepresentasikan resin plastik ke-7 dalam dataset, bukan detektor objek non-plastik.\n'
                  '• Mode Dummy ML Ringan di perangkat menampilkan label "MODE DEMO" sebagai simulasi sambil menunggu hosting FastAPI Python.\n'
                  '• Privasi: foto pengguna tidak pernah diunggah ke Supabase — hanya metadata log anonim & koreksi label.',
                  style: AppTheme.ubuntu(
                    fontSize: 12,
                    color: AppColors.textSecondaryLight,
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}
