import 'package:flutter/material.dart';
import '../../config/app_theme.dart';
import '../../models/scan_result.dart';
import '../../widgets/common/brutal_card.dart';
import '../../widgets/common/plastic_vector_icon.dart';

class HistoryBlockCard extends StatelessWidget {
  final ScanResult item;
  final VoidCallback onTap;
  final VoidCallback onDelete;

  const HistoryBlockCard({
    super.key,
    required this.item,
    required this.onTap,
    required this.onDelete,
  });

  String _formatTimestamp(DateTime dt) {
    final d = dt.day.toString().padLeft(2, '0');
    final m = dt.month.toString().padLeft(2, '0');
    final h = dt.hour.toString().padLeft(2, '0');
    final min = dt.minute.toString().padLeft(2, '0');
    return '$d/$m • $h:$min';
  }

  @override
  Widget build(BuildContext context) {
    final confPct = (item.confidence * 100).toStringAsFixed(1);
    final bytes = item.imageBytes;

    return BrutalCard(
      onTap: onTap,
      backgroundColor: AppColors.whitePure,
      padding: const EdgeInsets.all(12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: 62,
            height: 62,
            decoration: BoxDecoration(
              color: AppColors.bgSurfaceMuted,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.blackInk, width: 2),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: bytes != null
                  ? Image.memory(bytes, fit: BoxFit.cover)
                  : Center(
                      child: PlasticVectorIcon(
                        plasticClass: item.predictedClass,
                        size: 38,
                      ),
                    ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Wrap(
                  spacing: 6,
                  runSpacing: 4,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    _miniTag(
                      item.predictedClass.codeBadge,
                      AppColors.mintPistachio,
                      AppColors.blackInk,
                    ),
                    _miniTag(
                      item.isDemo ? 'DEMO' : 'API',
                      item.isDemo ? AppColors.bgLabWhite : AppColors.greenMid,
                      item.isDemo ? AppColors.blackInk : AppColors.whitePure,
                    ),
                    _miniTag(
                      item.syncedToSupabase ? 'Cloud ✓' : 'Lokal',
                      item.syncedToSupabase
                          ? const Color(0xFFD1FAE5)
                          : const Color(0xFFEDF2F7),
                      AppColors.blackInk,
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Text(
                  item.itemTitle,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTheme.ubuntu(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: AppColors.blackInk,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  '$confPct% • ${item.backbone} • ${_formatTimestamp(item.timestamp)}',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTheme.mono(
                    fontSize: 10,
                    color: AppColors.textSecondaryLight,
                  ),
                ),
              ],
            ),
          ),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                icon: const Icon(
                  Icons.delete_outline_rounded,
                  size: 20,
                  color: AppColors.errorRed,
                ),
                tooltip: 'Hapus riwayat',
                onPressed: onDelete,
                visualDensity: VisualDensity.compact,
              ),
              const Icon(
                Icons.chevron_right_rounded,
                color: AppColors.blackInk,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _miniTag(String text, Color bg, Color fg) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(5),
        border: Border.all(color: AppColors.blackInk, width: 1.2),
      ),
      child: Text(
        text,
        style: AppTheme.mono(
          fontSize: 9,
          fontWeight: FontWeight.w700,
          color: fg,
        ),
      ),
    );
  }
}
