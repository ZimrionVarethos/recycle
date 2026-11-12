import 'package:flutter/material.dart';
import '../../config/app_theme.dart';
import '../../models/plastic_class.dart';
import '../../models/scan_result.dart';
import '../../state/app_controller.dart';
import '../../widgets/common/brutal_button.dart';
import '../../widgets/common/brutal_card.dart';
import '../detail/scan_result_detail_page.dart';
import 'history_block_card.dart';

class HistoryPage extends StatefulWidget {
  final AppController controller;

  const HistoryPage({super.key, required this.controller});

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  PlasticClass? _filterClass;
  bool _syncing = false;

  Future<void> _syncCloud() async {
    setState(() => _syncing = true);
    final added = await widget.controller.syncHistoryFromSupabase();
    if (!mounted) return;
    setState(() => _syncing = false);

    final hasSupa = widget.controller.settings.hasSupabaseConfig;
    final msg = !hasSupa
        ? 'Konfigurasikan URL & Anon Key Supabase di Pengaturan untuk sinkronisasi cloud.'
        : (added > 0
            ? 'Berhasil menarik $added riwayat baru dari Supabase.'
            : 'Riwayat lokal sudah sinkron dengan Supabase.');

    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }

  Future<void> _confirmClearAll() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Hapus Semua Riwayat?'),
        content: const Text(
          'Semua blok riwayat scan lokal akan dihapus. Log yang sudah masuk Supabase tetap tersimpan di database.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: const Text('Batal'),
          ),
          FilledButton(
            style: FilledButton.styleFrom(backgroundColor: AppColors.errorRed),
            onPressed: () => Navigator.of(ctx).pop(true),
            child: const Text('Hapus'),
          ),
        ],
      ),
    );
    if (confirm == true) {
      await widget.controller.clearHistory();
    }
  }

  void _openDetail(ScanResult item) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => ScanResultDetailPage(
          result: item,
          controller: widget.controller,
          openedFromHistory: true,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final allHistory = widget.controller.history;
    final filtered = _filterClass == null
        ? allHistory
        : allHistory.where((e) => e.predictedClass == _filterClass).toList();
    final isLight = widget.controller.settings.isLightLabTheme;

    return SafeArea(
      child: ListView(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
        children: [
          _buildTopSummary(allHistory.length, isLight),
          const SizedBox(height: 14),
          _buildActionButtons(allHistory.isNotEmpty),
          const SizedBox(height: 14),
          _buildClassFilters(),
          const SizedBox(height: 16),
          if (filtered.isEmpty)
            _buildEmptyState()
          else
            for (final item in filtered) ...[
              HistoryBlockCard(
                item: item,
                onTap: () => _openDetail(item),
                onDelete: () => widget.controller.deleteHistoryItem(item.id),
              ),
              const SizedBox(height: 12),
            ],
        ],
      ),
    );
  }

  Widget _buildTopSummary(int totalCount, bool isLight) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Blok Riwayat Scan',
                style: AppTheme.ubuntu(
                  fontSize: 24,
                  fontWeight: FontWeight.w700,
                  color: isLight ? AppColors.blackInk : AppColors.whitePure,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                'Ketuk salah satu blok untuk membuka detail Grad-CAM & JSON',
                style: AppTheme.ubuntu(
                  fontSize: 12,
                  color: isLight
                      ? AppColors.textSecondaryLight
                      : AppColors.textMutedDark,
                ),
              ),
            ],
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: AppTheme.brutalMint(radius: 10, shadowOffset: 2.5),
          child: Text(
            '$totalCount ITEM',
            style: AppTheme.mono(
              fontSize: 12,
              fontWeight: FontWeight.w700,
              color: AppColors.blackInk,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildActionButtons(bool hasItems) {
    return Row(
      children: [
        Expanded(
          child: BrutalButton(
            label: _syncing ? 'Menyinkron...' : 'Sinkron Supabase',
            icon: Icons.cloud_sync_rounded,
            variant: BrutalButtonVariant.white,
            onPressed: _syncing ? null : _syncCloud,
          ),
        ),
        if (hasItems) ...[
          const SizedBox(width: 10),
          BrutalButton(
            label: 'Bersihkan',
            icon: Icons.delete_sweep_rounded,
            variant: BrutalButtonVariant.dark,
            onPressed: _confirmClearAll,
          ),
        ],
      ],
    );
  }

  Widget _buildClassFilters() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          _filterChip(null, 'Semua'),
          const SizedBox(width: 8),
          for (final cls in PlasticClass.values) ...[
            _filterChip(cls, cls.codeBadge),
            const SizedBox(width: 8),
          ],
        ],
      ),
    );
  }

  Widget _filterChip(PlasticClass? cls, String label) {
    final active = _filterClass == cls;
    return GestureDetector(
      onTap: () => setState(() => _filterClass = cls),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
        decoration: BoxDecoration(
          gradient: active ? AppColors.mintGradient : null,
          color: active ? null : AppColors.whitePure,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: AppColors.blackInk, width: 2),
        ),
        child: Text(
          label,
          style: AppTheme.mono(
            fontSize: 11,
            fontWeight: FontWeight.w700,
            color: AppColors.blackInk,
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return BrutalCard(
      backgroundColor: AppColors.bgSurfaceMuted,
      padding: const EdgeInsets.all(22),
      child: Column(
        children: [
          const Icon(Icons.history_rounded, size: 42, color: AppColors.greenMid),
          const SizedBox(height: 10),
          Text(
            'Belum Ada Riwayat yang Cocok',
            style: AppTheme.ubuntu(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: AppColors.blackInk,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'Setiap klasifikasi dari menu Scan akan otomatis muncul di daftar blok ini.',
            textAlign: TextAlign.center,
            style: AppTheme.ubuntu(
              fontSize: 12,
              color: AppColors.textSecondaryLight,
            ),
          ),
          const SizedBox(height: 14),
          BrutalButton(
            label: 'Pergi ke Scanner',
            icon: Icons.qr_code_scanner_rounded,
            variant: BrutalButtonVariant.mint,
            onPressed: () => widget.controller.setTab(1),
          ),
        ],
      ),
    );
  }
}
