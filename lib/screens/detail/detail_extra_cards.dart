import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../config/app_theme.dart';
import '../../models/scan_result.dart';
import '../../widgets/common/brutal_card.dart';

class RecyclingGuideCard extends StatelessWidget {
  final String recyclability;
  final String handling;
  final String safety;

  const RecyclingGuideCard({
    super.key,
    required this.recyclability,
    required this.handling,
    required this.safety,
  });

  @override
  Widget build(BuildContext context) {
    return BrutalCard(
      backgroundColor: AppColors.bgSurfaceMuted,
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Panduan Daur Ulang',
                style: AppTheme.ubuntu(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  color: AppColors.blackInk,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.greenMid,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  recyclability,
                  style: AppTheme.ubuntu(
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                    color: AppColors.whitePure,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            handling,
            style: AppTheme.ubuntu(
              fontSize: 13,
              color: AppColors.textSecondaryLight,
              height: 1.45,
            ),
          ),
          const Divider(color: AppColors.blackInk, thickness: 1.5, height: 20),
          Text(
            'Keamanan: $safety',
            style: AppTheme.ubuntu(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: AppColors.blackInk,
            ),
          ),
        ],
      ),
    );
  }
}

class JsonInspectorCard extends StatefulWidget {
  final ScanResult result;

  const JsonInspectorCard({super.key, required this.result});

  @override
  State<JsonInspectorCard> createState() => _JsonInspectorCardState();
}

class _JsonInspectorCardState extends State<JsonInspectorCard> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    final jsonStr = const JsonEncoder.withIndent('  ')
        .convert(widget.result.toApiPayloadPreview());

    return BrutalCard(
      isDark: true,
      padding: const EdgeInsets.all(14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'INSPEKTOR JSON API',
                style: AppTheme.mono(
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  color: AppColors.mintPistachio,
                ),
              ),
              Row(
                children: [
                  IconButton(
                    icon: const Icon(
                      Icons.copy_rounded,
                      size: 18,
                      color: AppColors.mintPistachio,
                    ),
                    onPressed: () {
                      Clipboard.setData(ClipboardData(text: jsonStr));
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('JSON disalin ke clipboard')),
                      );
                    },
                  ),
                  TextButton(
                    onPressed: () => setState(() => _expanded = !_expanded),
                    child: Text(
                      _expanded ? 'Tutup' : 'Buka JSON',
                      style: AppTheme.mono(
                        fontSize: 11,
                        color: AppColors.whitePure,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
          if (_expanded)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFF031818),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.white24),
              ),
              child: SelectableText(
                jsonStr,
                style: AppTheme.mono(
                  fontSize: 11,
                  color: AppColors.mintPistachio,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
