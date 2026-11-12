import 'package:flutter/material.dart';
import '../../config/app_theme.dart';
import '../../models/plastic_class.dart';
import '../../models/scan_result.dart';
import '../../state/app_controller.dart';
import '../../widgets/common/brutal_button.dart';

Future<void> showFeedbackSheet({
  required BuildContext context,
  required AppController controller,
  required ScanResult scanResult,
}) {
  return showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (ctx) => _FeedbackSheetContent(
      controller: controller,
      scanResult: scanResult,
    ),
  );
}

class _FeedbackSheetContent extends StatefulWidget {
  final AppController controller;
  final ScanResult scanResult;

  const _FeedbackSheetContent({
    required this.controller,
    required this.scanResult,
  });

  @override
  State<_FeedbackSheetContent> createState() => _FeedbackSheetContentState();
}

class _FeedbackSheetContentState extends State<_FeedbackSheetContent> {
  late PlasticClass _selectedClass;
  final _notesController = TextEditingController();
  bool _submitting = false;

  @override
  void initState() {
    super.initState();
    _selectedClass = widget.scanResult.predictedClass;
  }

  @override
  void dispose() {
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    setState(() => _submitting = true);
    final res = await widget.controller.submitFeedback(
      scanResult: widget.scanResult,
      correctedClass: _selectedClass,
      notes: _notesController.text,
    );
    if (!mounted) return;
    setState(() => _submitting = false);
    Navigator.of(context).pop();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(res.message),
        backgroundColor: res.success ? AppColors.greenMid : AppColors.errorRed,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;
    return Container(
      padding: EdgeInsets.fromLTRB(20, 20, 20, 20 + bottomInset),
      decoration: const BoxDecoration(
        color: AppColors.whitePure,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        border: Border(
          top: BorderSide(color: AppColors.blackInk, width: 3),
          left: BorderSide(color: AppColors.blackInk, width: 3),
          right: BorderSide(color: AppColors.blackInk, width: 3),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Koreksi Label (Ground Truth)',
                style: AppTheme.ubuntu(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: AppColors.blackInk,
                ),
              ),
              IconButton(
                onPressed: () => Navigator.of(context).pop(),
                icon: const Icon(Icons.close_rounded, color: AppColors.blackInk),
              ),
            ],
          ),
          Text(
            'Koreksi Anda membantu tim peneliti IPB mengevaluasi akurasi model untuk retraining dataset.',
            style: AppTheme.ubuntu(
              fontSize: 12,
              color: AppColors.textSecondaryLight,
            ),
          ),
          const SizedBox(height: 14),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              for (final cls in PlasticClass.values)
                GestureDetector(
                  onTap: () => setState(() => _selectedClass = cls),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(
                      gradient:
                          _selectedClass == cls ? AppColors.mintGradient : null,
                      color:
                          _selectedClass == cls ? null : AppColors.bgLabWhite,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: AppColors.blackInk, width: 2),
                    ),
                    child: Text(
                      cls.shortLabel,
                      style: AppTheme.mono(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: AppColors.blackInk,
                      ),
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 14),
          TextField(
            controller: _notesController,
            maxLines: 2,
            style: AppTheme.ubuntu(fontSize: 13, color: AppColors.blackInk),
            decoration: InputDecoration(
              hintText: 'Catatan kondisi objek (misal: botol terlipat/berlabel)...',
              filled: true,
              fillColor: AppColors.bgLabWhite,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: AppColors.blackInk, width: 2),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: AppColors.blackInk, width: 2),
              ),
            ),
          ),
          const SizedBox(height: 16),
          BrutalButton(
            label: _submitting ? 'Mengirim...' : 'Kirim Koreksi ke Supabase',
            icon: Icons.send_rounded,
            fullWidth: true,
            onPressed: _submitting ? null : _submit,
          ),
        ],
      ),
    );
  }
}
