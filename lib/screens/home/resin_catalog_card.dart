import 'package:flutter/material.dart';
import '../../config/app_theme.dart';
import '../../models/plastic_class.dart';
import '../../widgets/common/brutal_button.dart';
import '../../widgets/common/brutal_card.dart';
import '../../widgets/common/plastic_vector_icon.dart';

class ResinCatalogCard extends StatelessWidget {
  final PlasticInfo info;
  final VoidCallback onTestScan;

  const ResinCatalogCard({
    super.key,
    required this.info,
    required this.onTestScan,
  });

  @override
  Widget build(BuildContext context) {
    return BrutalCard(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  gradient: AppColors.mintGradient,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: AppColors.blackInk, width: 2),
                ),
                child: Text(
                  info.plasticClass.codeBadge,
                  style: AppTheme.mono(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: AppColors.blackInk,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.blackInk,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  'DAUR ULANG: ${info.tier}',
                  style: AppTheme.mono(
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                    color: AppColors.mintPistachio,
                  ),
                ),
              ),
            ],
          ),
          const Divider(color: AppColors.blackInk, thickness: 2, height: 22),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 58,
                height: 58,
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: AppColors.bgLabWhite,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.blackInk, width: 2),
                ),
                child: PlasticVectorIcon(plasticClass: info.plasticClass),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      info.polymerName,
                      style: AppTheme.ubuntu(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: AppColors.blackInk,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Contoh: ${info.examples}',
                      style: AppTheme.ubuntu(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: AppColors.greenMid,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: AppColors.bgLabWhite,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: AppColors.blackInk, width: 1.5),
            ),
            child: Text(
              'Panduan Sortir: ${info.handlingGuide}',
              style: AppTheme.ubuntu(
                fontSize: 12,
                color: AppColors.textSecondaryLight,
                height: 1.4,
              ),
            ),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  info.isMinorityClass
                      ? '${info.datasetCount} citra latih (Kelas Minoritas)'
                      : '${info.datasetCount} citra latih',
                  style: AppTheme.mono(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: AppColors.greenMid,
                  ),
                ),
              ),
              BrutalButton(
                label: 'Uji Scan',
                icon: Icons.qr_code_scanner,
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                fontSize: 12,
                onPressed: onTestScan,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
