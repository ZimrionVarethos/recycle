import 'package:flutter/material.dart';
import '../../config/app_constants.dart';
import '../../config/app_theme.dart';
import '../../models/plastic_class.dart';
import '../../state/app_controller.dart';
import '../../widgets/common/app_logo_badge.dart';
import '../../widgets/common/brutal_button.dart';
import 'hero_scanner_preview.dart';

class HeroHeaderSection extends StatelessWidget {
  final AppController controller;
  final PlasticClass selectedClass;
  final ValueChanged<PlasticClass> onClassChanged;

  const HeroHeaderSection({
    super.key,
    required this.controller,
    required this.selectedClass,
    required this.onClassChanged,
  });

  @override
  Widget build(BuildContext context) {
    final settings = controller.settings;

    return Container(
      decoration: const BoxDecoration(
        gradient: AppColors.heroGradient,
        border: Border(
          bottom: BorderSide(color: AppColors.blackInk, width: 4),
        ),
      ),
      child: SafeArea(
        bottom: false,
        child: Stack(
          children: [
            Positioned(
              right: 0,
              bottom: 0,
              child: CustomPaint(
                size: const Size(240, 84),
                painter: _HeroRibbonPainter(),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 14, 16, 28),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildTopFramedHeader(settings.isLightLabTheme),
                  const SizedBox(height: 22),
                  _buildHeroTypography(settings.backendMode.shortTag),
                  const SizedBox(height: 16),
                  _buildHeroActionButtons(),
                  const SizedBox(height: 20),
                  HeroScannerPreview(
                    animateLaser: settings.enableScanAnimation,
                    selectedClass: selectedClass,
                    onPinTapped: onClassChanged,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTopFramedHeader(bool isLight) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: const Color(0xFF072B2A).withValues(alpha: 0.92),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.whitePure, width: 3),
        boxShadow: const [
          BoxShadow(color: AppColors.blackInk, offset: Offset(0, 6)),
        ],
      ),
      child: Row(
        children: [
          const AppLogoBadge(width: 54, height: 40, borderWidth: 3),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  AppConstants.appName,
                  style: AppTheme.ubuntu(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: AppColors.whitePure,
                  ),
                ),
                Text(
                  'Kelompok 7 • IPB',
                  style: AppTheme.mono(
                    fontSize: 10,
                    color: AppColors.mintPistachio,
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: controller.toggleThemeMode,
            tooltip: isLight ? 'Mode Hutan Gelap' : 'Mode Lab Putih',
            icon: Icon(
              isLight ? Icons.dark_mode_rounded : Icons.light_mode_rounded,
              color: AppColors.mintPistachio,
            ),
          ),
          BrutalButton(
            label: 'Scan',
            icon: Icons.camera_alt_rounded,
            fontSize: 12,
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            onPressed: () => controller.setTab(1),
          ),
        ],
      ),
    );
  }

  Widget _buildHeroTypography(String backendTag) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          decoration: BoxDecoration(
            color: const Color(0xFF041D1D),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: AppColors.mintPistachio, width: 1.5),
          ),
          child: Text(
            '$backendTag • ${AppConstants.currentTrainingNote}',
            style: AppTheme.mono(
              fontSize: 10,
              fontWeight: FontWeight.w700,
              color: AppColors.mintPistachio,
            ),
          ),
        ),
        const SizedBox(height: 12),
        Text(
          AppConstants.appName,
          style: AppTheme.ubuntu(
            fontSize: 38,
            fontWeight: FontWeight.w700,
            color: AppColors.whitePure,
            height: 1.05,
          ),
        ),
        const SizedBox(height: 12),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 30,
              height: 36,
              margin: const EdgeInsets.only(top: 2),
              decoration: const BoxDecoration(
                border: Border(
                  left: BorderSide(color: AppColors.whitePure, width: 7),
                  bottom: BorderSide(color: AppColors.whitePure, width: 7),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                AppConstants.appSubtitle,
                style: AppTheme.ubuntu(
                  fontSize: 17,
                  fontWeight: FontWeight.w700,
                  color: AppColors.whitePure,
                  height: 1.3,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildHeroActionButtons() {
    return Row(
      children: [
        Expanded(
          child: BrutalButton(
            label: 'Mulai Scan Plastik',
            icon: Icons.qr_code_scanner_rounded,
            variant: BrutalButtonVariant.mint,
            onPressed: () => controller.setTab(1),
          ),
        ),
        const SizedBox(width: 10),
        BrutalButton(
          label: 'Ganti Pin',
          icon: Icons.radar_rounded,
          variant: BrutalButtonVariant.white,
          onPressed: () {
            final idx = (PlasticClass.values.indexOf(selectedClass) + 1) % 6;
            onClassChanged(PlasticClass.values[idx]);
          },
        ),
      ],
    );
  }
}

class _HeroRibbonPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;

    void drawWave(double startX, double endY, Color color) {
      final path = Path()
        ..moveTo(w * startX, h)
        ..cubicTo(w * (startX + 0.25), h * 0.85, w * 0.72, h * 0.55, w, h * endY)
        ..lineTo(w, h)
        ..close();
      canvas.drawPath(path, Paint()..color = color);
    }

    drawWave(0.15, 0.08, const Color(0xFF18634F));
    drawWave(0.32, 0.26, AppColors.whitePure);
    drawWave(0.42, 0.36, AppColors.mintPistachio);
    drawWave(0.60, 0.58, AppColors.blackInk);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
