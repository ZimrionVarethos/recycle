import 'package:flutter/material.dart';
import '../../config/app_constants.dart';
import '../../config/app_theme.dart';
import '../../config/plastics_data.dart';
import '../../models/plastic_class.dart';
import '../../widgets/common/brutal_button.dart';
import '../../widgets/common/brutal_card.dart';

class ScanBackboneCard extends StatelessWidget {
  final String activeBackbone;
  final ValueChanged<String> onSelectBackbone;

  const ScanBackboneCard({
    super.key,
    required this.activeBackbone,
    required this.onSelectBackbone,
  });

  @override
  Widget build(BuildContext context) {
    return BrutalCard(
      backgroundColor: AppColors.whitePure,
      padding: const EdgeInsets.all(14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'ARSITEKTUR MODEL CNN',
            style: AppTheme.mono(
              fontSize: 11,
              fontWeight: FontWeight.w700,
              color: AppColors.greenMid,
            ),
          ),
          const SizedBox(height: 10),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              for (final model in AppConstants.backbones)
                ChoiceChip(
                  label: Text(
                    model,
                    style: AppTheme.ubuntu(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: AppColors.blackInk,
                    ),
                  ),
                  selected: activeBackbone == model,
                  selectedColor: AppColors.mintPistachio,
                  backgroundColor: AppColors.bgLabWhite,
                  side: const BorderSide(color: AppColors.blackInk, width: 1.5),
                  onSelected: (_) => onSelectBackbone(model),
                ),
            ],
          ),
        ],
      ),
    );
  }
}

class QuickSampleCard extends StatelessWidget {
  final PlasticClass selectedSample;
  final bool isScanning;
  final ValueChanged<PlasticClass> onSelectSample;
  final VoidCallback onRunSample;

  const QuickSampleCard({
    super.key,
    required this.selectedSample,
    required this.isScanning,
    required this.onSelectSample,
    required this.onRunSample,
  });

  @override
  Widget build(BuildContext context) {
    final sampleInfo = PlasticsCatalog.byClass(selectedSample);
    return BrutalCard(
      isDark: true,
      padding: const EdgeInsets.all(14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'UJI CEPAT SAMPEL DATASET (7 KELAS)',
            style: AppTheme.mono(
              fontSize: 11,
              fontWeight: FontWeight.w700,
              color: AppColors.mintPistachio,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'Terpilih: ${sampleInfo.sampleName} (${sampleInfo.plasticClass.codeBadge})',
            style: AppTheme.ubuntu(fontSize: 13, color: AppColors.whitePure),
          ),
          const SizedBox(height: 10),
          Wrap(
            spacing: 6,
            runSpacing: 6,
            children: [
              for (final cls in PlasticClass.values)
                GestureDetector(
                  onTap: () => onSelectSample(cls),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: selectedSample == cls
                          ? AppColors.mintPistachio
                          : const Color(0xFF031818),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: selectedSample == cls
                            ? AppColors.blackInk
                            : AppColors.mintPistachio,
                        width: 1.5,
                      ),
                    ),
                    child: Text(
                      cls.codeBadge,
                      style: AppTheme.mono(
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        color: selectedSample == cls
                            ? AppColors.blackInk
                            : AppColors.mintPistachio,
                      ),
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            child: BrutalButton(
              label: 'Jalankan Simulasi Sampel',
              icon: Icons.science_rounded,
              variant: BrutalButtonVariant.white,
              onPressed: isScanning ? null : onRunSample,
            ),
          ),
        ],
      ),
    );
  }
}
