import 'package:flutter/material.dart';
import '../../config/app_theme.dart';
import '../../config/plastics_data.dart';
import '../../models/plastic_class.dart';
import '../../state/app_controller.dart';
import 'hero_header_section.dart';
import 'resin_catalog_card.dart';

class HomePage extends StatefulWidget {
  final AppController controller;

  const HomePage({super.key, required this.controller});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  PlasticClass _heroSelectedClass = PlasticClass.pet;
  String _tierFilter = 'ALL';

  @override
  Widget build(BuildContext context) {
    final settings = widget.controller.settings;
    final filteredPlastics = _tierFilter == 'ALL'
        ? PlasticsCatalog.all
        : PlasticsCatalog.all.where((p) => p.tier == _tierFilter).toList();

    return ListView(
      padding: EdgeInsets.zero,
      children: [
        HeroHeaderSection(
          controller: widget.controller,
          selectedClass: _heroSelectedClass,
          onClassChanged: (cls) => setState(() => _heroSelectedClass = cls),
        ),
        Container(
          color: settings.isLightLabTheme
              ? AppColors.bgSurfaceMuted
              : AppColors.bgCanvasDark,
          padding: const EdgeInsets.fromLTRB(16, 24, 16, 36),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: settings.isLightLabTheme
                      ? AppColors.blackInk
                      : AppColors.mintPistachio,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  'KATALOG ASTM D7611 • 1.331 CITRA LATIH',
                  style: AppTheme.mono(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: settings.isLightLabTheme
                        ? AppColors.mintPistachio
                        : AppColors.blackInk,
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Text(
                '7 Kelas Jenis Sampah Plastik',
                style: AppTheme.ubuntu(
                  fontSize: 24,
                  fontWeight: FontWeight.w700,
                  color: settings.isLightLabTheme
                      ? AppColors.blackInk
                      : AppColors.whitePure,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Ketuk "Uji Scan" pada salah satu kelas polimer untuk langsung mengujinya di layar Scanner.',
                style: AppTheme.ubuntu(
                  fontSize: 13,
                  color: settings.isLightLabTheme
                      ? AppColors.textSecondaryLight
                      : AppColors.textMutedDark,
                ),
              ),
              const SizedBox(height: 14),
              _buildFilterRow(),
              const SizedBox(height: 16),
              for (final item in filteredPlastics) ...[
                ResinCatalogCard(
                  info: item,
                  onTestScan: () =>
                      widget.controller.jumpToScanWithSample(item.plasticClass),
                ),
                const SizedBox(height: 14),
              ],
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildFilterRow() {
    const filters = [
      ('ALL', 'Semua (7)'),
      ('TINGGI', 'Tinggi'),
      ('MENENGAH', 'Menengah'),
      ('KHUSUS', 'Khusus'),
    ];
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          for (final f in filters) ...[
            GestureDetector(
              onTap: () => setState(() => _tierFilter = f.$1),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                decoration: BoxDecoration(
                  gradient: _tierFilter == f.$1 ? AppColors.mintGradient : null,
                  color: _tierFilter == f.$1 ? null : AppColors.whitePure,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: AppColors.blackInk, width: 2),
                ),
                child: Text(
                  f.$2,
                  style: AppTheme.ubuntu(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: AppColors.blackInk,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 8),
          ],
        ],
      ),
    );
  }
}
