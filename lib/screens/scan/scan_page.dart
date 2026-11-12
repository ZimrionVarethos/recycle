import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../../config/app_constants.dart';
import '../../config/app_theme.dart';
import '../../models/scan_result.dart';
import '../../state/app_controller.dart';
import '../../widgets/common/brutal_button.dart';
import '../detail/scan_result_detail_page.dart';
import 'scan_options_cards.dart';
import 'scan_status_panel.dart';

class ScanPage extends StatefulWidget {
  final AppController controller;

  const ScanPage({super.key, required this.controller});

  @override
  State<ScanPage> createState() => _ScanPageState();
}

class _ScanPageState extends State<ScanPage> {
  final ImagePicker _picker = ImagePicker();
  Uint8List? _selectedBytes;
  String _selectedFileName = '';
  String? _backboneOverride;

  String get _activeBackbone =>
      _backboneOverride ?? widget.controller.settings.defaultBackbone;

  Future<void> _pickImage(ImageSource source) async {
    widget.controller.clearScanError();
    try {
      final XFile? file = await _picker.pickImage(
        source: source,
        maxWidth: 1024,
        imageQuality: 88,
      );
      if (file == null) return;
      final bytes = await file.readAsBytes();
      if (!mounted) return;
      setState(() {
        _selectedBytes = bytes;
        _selectedFileName = file.name;
      });
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Tidak dapat membuka ${source == ImageSource.camera ? 'kamera' : 'galeri'}: $e',
          ),
        ),
      );
    }
  }

  Future<void> _classifySelectedImage() async {
    final bytes = _selectedBytes;
    if (bytes == null) return;
    final ScanResult? result = await widget.controller.scanImageBytes(
      bytes: bytes,
      fileName: _selectedFileName,
      backboneOverride: _activeBackbone,
    );
    if (!mounted || result == null) return;
    _openResultDetail(result);
  }

  Future<void> _classifyQuickSample() async {
    final ScanResult? result = await widget.controller.scanSample(
      sampleClass: widget.controller.preselectedSample,
      backboneOverride: _activeBackbone,
    );
    if (!mounted || result == null) return;
    _openResultDetail(result);
  }

  void _openResultDetail(ScanResult result) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => ScanResultDetailPage(
          result: result,
          controller: widget.controller,
          openedFromHistory: false,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final settings = widget.controller.settings;
    final isLight = settings.isLightLabTheme;

    return SafeArea(
      child: ListView(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
        children: [
          _buildHeader(settings.backendMode.shortTag, isLight),
          const SizedBox(height: 16),
          ScanStatusPanel(
            isScanning: widget.controller.isScanning,
            scanError: widget.controller.scanError,
            selectedBytes: _selectedBytes,
            selectedFileName: _selectedFileName,
            activeBackbone: _activeBackbone,
            onRunInference: _classifySelectedImage,
            onClearImage: () => setState(() {
              _selectedBytes = null;
              _selectedFileName = '';
            }),
            onDismissError: widget.controller.clearScanError,
            onOpenSettings: () => widget.controller.setTab(3),
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              Expanded(
                child: BrutalButton(
                  label: 'Kamera',
                  icon: Icons.camera_alt_rounded,
                  variant: BrutalButtonVariant.mint,
                  onPressed: widget.controller.isScanning
                      ? null
                      : () => _pickImage(ImageSource.camera),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: BrutalButton(
                  label: 'Galeri',
                  icon: Icons.photo_library_rounded,
                  variant: BrutalButtonVariant.white,
                  onPressed: widget.controller.isScanning
                      ? null
                      : () => _pickImage(ImageSource.gallery),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ScanBackboneCard(
            activeBackbone: _activeBackbone,
            onSelectBackbone: (model) =>
                setState(() => _backboneOverride = model),
          ),
          const SizedBox(height: 16),
          QuickSampleCard(
            selectedSample: widget.controller.preselectedSample,
            isScanning: widget.controller.isScanning,
            onSelectSample: widget.controller.setPreselectedSample,
            onRunSample: _classifyQuickSample,
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(String backendTag, bool isLight) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            GestureDetector(
              onTap: () => widget.controller.setTab(3),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: AppTheme.brutalMint(radius: 8, shadowOffset: 2),
                child: Text(
                  backendTag,
                  style: AppTheme.mono(
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                    color: AppColors.blackInk,
                  ),
                ),
              ),
            ),
            Text(
              '${AppConstants.currentTrainingNote} • ${AppConstants.releaseTargetNote}',
              style: AppTheme.mono(
                fontSize: 10,
                color: isLight
                    ? AppColors.textSecondaryLight
                    : AppColors.mintPistachio,
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        Text(
          'Scanner Klasifikasi Plastik',
          style: AppTheme.ubuntu(
            fontSize: 24,
            fontWeight: FontWeight.w700,
            color: isLight ? AppColors.blackInk : AppColors.whitePure,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          'Hasil scan otomatis membuka halaman detail baru & tersimpan ke blok Riwayat.',
          style: AppTheme.ubuntu(
            fontSize: 13,
            color: isLight
                ? AppColors.textSecondaryLight
                : AppColors.textMutedDark,
          ),
        ),
      ],
    );
  }
}
