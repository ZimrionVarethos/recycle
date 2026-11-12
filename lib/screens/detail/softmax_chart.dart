import 'package:flutter/material.dart';
import '../../config/app_theme.dart';
import '../../models/plastic_class.dart';
import '../../widgets/common/brutal_card.dart';

class SoftmaxChart extends StatelessWidget {
  final Map<PlasticClass, double> probabilities;
  final PlasticClass winner;
  final String backbone;

  const SoftmaxChart({
    super.key,
    required this.probabilities,
    required this.winner,
    required this.backbone,
  });

  @override
  Widget build(BuildContext context) {
    final sorted = List<PlasticClass>.from(PlasticClass.values)
      ..sort(
        (a, b) => (probabilities[b] ?? 0).compareTo(probabilities[a] ?? 0),
      );

    return BrutalCard(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'OUTPUT SOFTMAX (7 KELAS RESIN)',
                      style: AppTheme.mono(
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                        color: AppColors.greenMid,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'Distribusi Probabilitas Prediksi',
                      style: AppTheme.ubuntu(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: AppColors.blackInk,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  gradient: AppColors.mintGradient,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: AppColors.blackInk, width: 1.5),
                ),
                child: Text(
                  backbone,
                  style: AppTheme.mono(
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                    color: AppColors.blackInk,
                  ),
                ),
              ),
            ],
          ),
          const Divider(color: AppColors.blackInk, thickness: 2, height: 22),
          for (final cls in sorted) ...[
            _buildBarRow(cls, probabilities[cls] ?? 0, cls == winner),
            const SizedBox(height: 10),
          ],
          Text(
            '*Estimasi komparasi fitur citra (bukan calibrated statistical probability).',
            style: AppTheme.ubuntu(
              fontSize: 11,
              color: AppColors.textSecondaryLight,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBarRow(PlasticClass cls, double prob, bool isWinner) {
    final pct = (prob * 100).clamp(0.0, 100.0);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              cls.codeBadge,
              style: AppTheme.mono(
                fontSize: 12,
                fontWeight: isWinner ? FontWeight.w700 : FontWeight.w600,
                color: isWinner ? AppColors.greenMid : AppColors.blackInk,
              ),
            ),
            Text(
              '${pct.toStringAsFixed(1)}%',
              style: AppTheme.mono(
                fontSize: 12,
                fontWeight: FontWeight.w700,
                color: isWinner ? AppColors.greenMid : AppColors.textSecondaryLight,
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Container(
          height: 14,
          width: double.infinity,
          decoration: BoxDecoration(
            color: AppColors.bgLabWhite,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: AppColors.blackInk, width: 1.5),
          ),
          clipBehavior: Clip.antiAlias,
          child: FractionallySizedBox(
            alignment: Alignment.centerLeft,
            widthFactor: (pct / 100).clamp(0.02, 1.0),
            child: Container(
              color: isWinner ? AppColors.greenMid : AppColors.mintPistachio,
            ),
          ),
        ),
      ],
    );
  }
}
