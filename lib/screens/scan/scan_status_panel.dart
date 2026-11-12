import 'dart:typed_data';
import 'package:flutter/material.dart';
import '../../config/app_constants.dart';
import '../../config/app_theme.dart';
import '../../widgets/common/brutal_button.dart';
import '../../widgets/common/brutal_card.dart';

class ScanStatusPanel extends StatelessWidget {
  final bool isScanning;
  final String? scanError;
  final Uint8List? selectedBytes;
  final String selectedFileName;
  final String activeBackbone;
  final VoidCallback onRunInference;
  final VoidCallback onClearImage;
  final VoidCallback onDismissError;
  final VoidCallback onOpenSettings;

  const ScanStatusPanel({
    super.key,
    required this.isScanning,
    required this.scanError,
    required this.selectedBytes,
    required this.selectedFileName,
    required this.activeBackbone,
    required this.onRunInference,
    required this.onClearImage,
    required this.onDismissError,
    required this.onOpenSettings,
  });

  @override
  Widget build(BuildContext context) {
    if (isScanning) {
      return _buildLoadingState();
    }
    if (scanError != null && scanError!.isNotEmpty) {
      return _buildErrorState(scanError!);
    }
    if (selectedBytes != null) {
      return _buildReadyState(selectedBytes!);
    }
    return _buildEmptyState();
  }

  Widget _buildLoadingState() {
    return BrutalCard(
      isDark: true,
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 28),
      child: Column(
        children: [
          const SizedBox(
            width: 44,
            height: 44,
            child: CircularProgressIndicator(
              strokeWidth: 4,
              color: AppColors.mintPistachio,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'Menganalisis Citra Plastik...',
            style: AppTheme.ubuntu(
              fontSize: 17,
              fontWeight: FontWeight.w700,
              color: AppColors.whitePure,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'Resize ${AppConstants.inputResolution} • Ekstraksi fitur $activeBackbone',
            textAlign: TextAlign.center,
            style: AppTheme.mono(
              fontSize: 11,
              color: AppColors.mintPistachio,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState(String message) {
    return BrutalCard(
      backgroundColor: const Color(0xFFFFF1F0),
      borderColor: AppColors.errorRed,
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.error_outline_rounded, color: AppColors.errorRed),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  'Klasifikasi Gagal',
                  style: AppTheme.ubuntu(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: AppColors.errorRed,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            message,
            style: AppTheme.ubuntu(
              fontSize: 13,
              color: AppColors.blackInk,
              height: 1.4,
            ),
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              Expanded(
                child: BrutalButton(
                  label: 'Tutup Error',
                  icon: Icons.refresh_rounded,
                  variant: BrutalButtonVariant.white,
                  onPressed: onDismissError,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: BrutalButton(
                  label: 'Pengaturan',
                  icon: Icons.tune_rounded,
                  variant: BrutalButtonVariant.mint,
                  onPressed: onOpenSettings,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildReadyState(Uint8List bytes) {
    final kb = (bytes.lengthInBytes / 1024).toStringAsFixed(0);
    return BrutalCard(
      isDark: true,
      padding: const EdgeInsets.all(14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.mintPistachio,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  'SIAP DIKLASIFIKASI • $kb KB',
                  style: AppTheme.mono(
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                    color: AppColors.blackInk,
                  ),
                ),
              ),
              IconButton(
                onPressed: onClearImage,
                tooltip: 'Hapus Foto',
                icon: const Icon(
                  Icons.close_rounded,
                  color: AppColors.whitePure,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Container(
              height: 200,
              width: double.infinity,
              color: const Color(0xFF021616),
              child: Image.memory(bytes, fit: BoxFit.contain),
            ),
          ),
          const SizedBox(height: 10),
          Text(
            selectedFileName,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTheme.mono(fontSize: 11, color: AppColors.textMutedDark),
          ),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            child: BrutalButton(
              label: 'Analisis & Lihat Detail Hasil',
              icon: Icons.auto_awesome_rounded,
              variant: BrutalButtonVariant.mint,
              onPressed: onRunInference,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return BrutalCard(
      backgroundColor: AppColors.bgSurfaceMuted,
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 24),
      child: Column(
        children: [
          Container(
            width: 58,
            height: 58,
            decoration: BoxDecoration(
              gradient: AppColors.mintGradient,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: AppColors.blackInk, width: 2.5),
            ),
            child: const Icon(
              Icons.add_a_photo_rounded,
              size: 28,
              color: AppColors.blackInk,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            'Belum Ada Foto Dipilih',
            style: AppTheme.ubuntu(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: AppColors.blackInk,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Ambil foto lewat kamera, pilih dari galeri, atau uji cepat sampel resin di bawah ini.',
            textAlign: TextAlign.center,
            style: AppTheme.ubuntu(
              fontSize: 12,
              color: AppColors.textSecondaryLight,
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }
}
