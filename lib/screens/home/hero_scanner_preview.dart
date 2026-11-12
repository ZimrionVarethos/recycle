import 'package:flutter/material.dart';
import '../../config/app_theme.dart';
import '../../config/plastics_data.dart';
import '../../models/plastic_class.dart';

class HeroScannerPreview extends StatefulWidget {
  final bool animateLaser;
  final PlasticClass selectedClass;
  final ValueChanged<PlasticClass> onPinTapped;

  const HeroScannerPreview({
    super.key,
    required this.animateLaser,
    required this.selectedClass,
    required this.onPinTapped,
  });

  @override
  State<HeroScannerPreview> createState() => _HeroScannerPreviewState();
}

class _HeroScannerPreviewState extends State<HeroScannerPreview>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  static const _pins = [
    (cls: PlasticClass.pet, label: '[PET #1] Botol', top: 0.14, left: 0.46),
    (cls: PlasticClass.hdpe, label: '[HDPE #2] Jerigen', top: 0.50, left: 0.20),
    (cls: PlasticClass.pp, label: '[PP #5] Cup', top: 0.70, left: 0.12),
    (cls: PlasticClass.ldpe, label: '[LDPE #4] Kresek', top: 0.74, left: 0.50),
    (cls: PlasticClass.ps, label: '[PS #6] Wadah', top: 0.85, left: 0.28),
  ];

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 3600),
    );
    if (widget.animateLaser) _controller.repeat(reverse: true);
  }

  @override
  void didUpdateWidget(covariant HeroScannerPreview oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.animateLaser && !_controller.isAnimating) {
      _controller.repeat(reverse: true);
    } else if (!widget.animateLaser && _controller.isAnimating) {
      _controller.stop();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final activeInfo = PlasticsCatalog.byClass(widget.selectedClass);

    return Column(
      children: [
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: AppColors.whitePure, width: 2.5),
            boxShadow: const [
              BoxShadow(
                color: AppColors.blackInk,
                offset: Offset(4, 4),
                blurRadius: 0,
              ),
            ],
          ),
          clipBehavior: Clip.antiAlias,
          child: AspectRatio(
            aspectRatio: 1160 / 884,
            child: LayoutBuilder(
              builder: (context, constraints) {
                final w = constraints.maxWidth;
                final h = constraints.maxHeight;
                return Stack(
                  children: [
                    Positioned.fill(
                      child: Image.asset(
                        'assets/images/hero_bin.webp',
                        fit: BoxFit.cover,
                      ),
                    ),
                    // Laser CNN Sweep Bar
                    AnimatedBuilder(
                      animation: _controller,
                      builder: (context, _) {
                        final topPos = h * (0.08 + 0.78 * _controller.value);
                        return Positioned(
                          top: topPos,
                          left: w * 0.05,
                          right: w * 0.05,
                          child: Container(
                            height: 3,
                            decoration: BoxDecoration(
                              gradient: const LinearGradient(
                                colors: [
                                  Colors.transparent,
                                  AppColors.mintPistachio,
                                  Colors.transparent,
                                ],
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: AppColors.mintPistachio.withValues(alpha: 0.9),
                                  blurRadius: 12,
                                  spreadRadius: 1,
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                    // Interactive Bounding Pins
                    for (final pin in _pins)
                      Positioned(
                        top: h * pin.top,
                        left: w * pin.left,
                        child: _BboxPin(
                          label: pin.label,
                          isActive: pin.cls == widget.selectedClass,
                          onTap: () => widget.onPinTapped(pin.cls),
                        ),
                      ),
                  ],
                );
              },
            ),
          ),
        ),
        const SizedBox(height: 12),
        // Readout Bar
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          decoration: BoxDecoration(
            color: const Color(0xFF031B1B),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.mintPistachio, width: 2),
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.mintPistachio,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  activeInfo.plasticClass.codeBadge,
                  style: AppTheme.mono(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: AppColors.blackInk,
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Objek Terpilih pada Tong Sampah:',
                      style: AppTheme.ubuntu(
                        fontSize: 11,
                        color: AppColors.textMutedDark,
                      ),
                    ),
                    Text(
                      activeInfo.sampleName,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTheme.ubuntu(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: AppColors.whitePure,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _BboxPin extends StatelessWidget {
  final String label;
  final bool isActive;
  final VoidCallback onTap;

  const _BboxPin({
    required this.label,
    required this.isActive,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 160),
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: isActive
              ? AppColors.mintPistachio
              : AppColors.bgCanvasDark.withValues(alpha: 0.85),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isActive ? AppColors.blackInk : AppColors.mintPistachio,
            width: 2,
          ),
          boxShadow: const [
            BoxShadow(
              color: AppColors.blackInk,
              offset: Offset(2, 2),
              blurRadius: 0,
            ),
          ],
        ),
        child: Text(
          label,
          style: AppTheme.mono(
            fontSize: 10,
            fontWeight: FontWeight.w700,
            color: isActive ? AppColors.blackInk : AppColors.whitePure,
          ),
        ),
      ),
    );
  }
}
