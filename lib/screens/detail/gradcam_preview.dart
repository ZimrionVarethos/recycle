import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import '../../config/app_theme.dart';
import '../../models/plastic_class.dart';
import '../../widgets/common/brutal_card.dart';
import '../../widgets/common/plastic_vector_icon.dart';

class GradCamPreview extends StatefulWidget {
  final Uint8List? imageBytes;
  final String? gradcamUrl;
  final PlasticClass plasticClass;
  final double focusX;
  final double focusY;

  const GradCamPreview({
    super.key,
    required this.imageBytes,
    required this.gradcamUrl,
    required this.plasticClass,
    required this.focusX,
    required this.focusY,
  });

  @override
  State<GradCamPreview> createState() => _GradCamPreviewState();
}

class _GradCamPreviewState extends State<GradCamPreview> {
  bool _showHeatmap = false;
  double _opacity = 0.65;

  @override
  Widget build(BuildContext context) {
    final hasRemoteGradcam = widget.gradcamUrl != null &&
        widget.gradcamUrl!.startsWith('data:image');
    Uint8List? remoteGradcamBytes;
    if (hasRemoteGradcam) {
      try {
        final b64Part = widget.gradcamUrl!.split(',').last;
        remoteGradcamBytes = base64Decode(b64Part);
      } catch (_) {}
    }

    return BrutalCard(
      padding: const EdgeInsets.all(14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'PRATINJAU CITRA & GRAD-CAM',
                style: AppTheme.mono(
                  fontSize: 10,
                  fontWeight: FontWeight.w700,
                  color: AppColors.greenMid,
                ),
              ),
              GestureDetector(
                onTap: () => setState(() => _showHeatmap = !_showHeatmap),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    gradient: _showHeatmap ? AppColors.mintGradient : null,
                    color: _showHeatmap ? null : AppColors.bgLabWhite,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: AppColors.blackInk, width: 2),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.layers_rounded, size: 14, color: AppColors.blackInk),
                      const SizedBox(width: 4),
                      Text(
                        _showHeatmap ? 'Grad-CAM ON' : 'Grad-CAM OFF',
                        style: AppTheme.mono(
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
                          color: AppColors.blackInk,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Container(
            height: 220,
            width: double.infinity,
            decoration: BoxDecoration(
              color: AppColors.bgCanvasDark,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.blackInk, width: 2),
            ),
            clipBehavior: Clip.antiAlias,
            child: Stack(
              fit: StackFit.expand,
              children: [
                if (_showHeatmap && remoteGradcamBytes != null)
                  Image.memory(remoteGradcamBytes, fit: BoxFit.contain)
                else if (widget.imageBytes != null)
                  Image.memory(widget.imageBytes!, fit: BoxFit.contain)
                else
                  Center(
                    child: Container(
                      width: 110,
                      height: 110,
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: AppColors.whitePure,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: AppColors.blackInk, width: 2.5),
                      ),
                      child: PlasticVectorIcon(
                        plasticClass: widget.plasticClass,
                        size: 80,
                      ),
                    ),
                  ),
                if (_showHeatmap && remoteGradcamBytes == null)
                  Positioned.fill(
                    child: IgnorePointer(
                      child: CustomPaint(
                        painter: _GradCamPainter(
                          focusX: widget.focusX,
                          focusY: widget.focusY,
                          opacity: _opacity,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
          if (_showHeatmap && remoteGradcamBytes == null) ...[
            const SizedBox(height: 8),
            Row(
              children: [
                Text(
                  'Opasitas Heatmap:',
                  style: AppTheme.ubuntu(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textSecondaryLight,
                  ),
                ),
                Expanded(
                  child: Slider(
                    value: _opacity,
                    min: 0.2,
                    max: 0.95,
                    activeColor: AppColors.greenMid,
                    onChanged: (v) => setState(() => _opacity = v),
                  ),
                ),
                Text(
                  '${(_opacity * 100).round()}%',
                  style: AppTheme.mono(fontSize: 11, color: AppColors.blackInk),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}

class _GradCamPainter extends CustomPainter {
  final double focusX;
  final double focusY;
  final double opacity;

  _GradCamPainter({
    required this.focusX,
    required this.focusY,
    required this.opacity,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width * focusX, size.height * focusY);
    final radius = size.shortestSide * 0.45;
    final gradient = RadialGradient(
      colors: [
        Colors.red.withValues(alpha: opacity * 0.9),
        Colors.amber.withValues(alpha: opacity * 0.65),
        Colors.greenAccent.withValues(alpha: opacity * 0.35),
        Colors.transparent,
      ],
      stops: const [0.0, 0.38, 0.72, 1.0],
    );

    final rect = Rect.fromCircle(center: center, radius: radius);
    canvas.drawRect(
      Offset.zero & size,
      Paint()..shader = gradient.createShader(rect),
    );
  }

  @override
  bool shouldRepaint(covariant _GradCamPainter oldDelegate) =>
      oldDelegate.opacity != opacity ||
      oldDelegate.focusX != focusX ||
      oldDelegate.focusY != focusY;
}
