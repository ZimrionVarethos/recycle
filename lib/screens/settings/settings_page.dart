import 'package:flutter/material.dart';
import '../../config/app_constants.dart';
import '../../config/app_theme.dart';
import '../../models/app_settings.dart';
import '../../state/app_controller.dart';
import '../../widgets/common/brutal_button.dart';
import '../../widgets/common/brutal_card.dart';
import 'backend_config_cards.dart';
import 'research_info_sheet.dart';

class SettingsPage extends StatelessWidget {
  final AppController controller;

  const SettingsPage({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    final settings = controller.settings;
    final isLight = settings.isLightLabTheme;

    return SafeArea(
      child: ListView(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 36),
        children: [
          Text(
            'Pengaturan Sistem',
            style: AppTheme.ubuntu(
              fontSize: 24,
              fontWeight: FontWeight.w700,
              color: isLight ? AppColors.blackInk : AppColors.whitePure,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Gunakan Dummy Backend (ML Ringan + Supabase) sekarang, atau beralih ke Python FastAPI kapan saja.',
            style: AppTheme.ubuntu(
              fontSize: 13,
              color: isLight
                  ? AppColors.textSecondaryLight
                  : AppColors.textMutedDark,
            ),
          ),
          const SizedBox(height: 16),
          _buildBackendModeCard(settings),
          const SizedBox(height: 16),
          BackendConfigCards(controller: controller),
          const SizedBox(height: 16),
          _buildPreferencesCard(settings),
          const SizedBox(height: 16),
          _buildResearchCard(context),
        ],
      ),
    );
  }

  Widget _buildBackendModeCard(AppSettings settings) {
    return BrutalCard(
      isDark: true,
      padding: const EdgeInsets.all(14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'MODE BACKEND AKTIF',
            style: AppTheme.mono(
              fontSize: 11,
              fontWeight: FontWeight.w700,
              color: AppColors.mintPistachio,
            ),
          ),
          const SizedBox(height: 10),
          for (final mode in BackendMode.values) ...[
            GestureDetector(
              onTap: () => controller.updateSettings(
                settings.copyWith(backendMode: mode),
              ),
              child: Container(
                margin: const EdgeInsets.only(bottom: 8),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: settings.backendMode == mode
                      ? AppColors.mintPistachio
                      : const Color(0xFF031818),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: settings.backendMode == mode
                        ? AppColors.blackInk
                        : AppColors.mintPistachio,
                    width: 2,
                  ),
                ),
                child: Row(
                  children: [
                    Icon(
                      settings.backendMode == mode
                          ? Icons.radio_button_checked_rounded
                          : Icons.radio_button_off_rounded,
                      color: settings.backendMode == mode
                          ? AppColors.blackInk
                          : AppColors.mintPistachio,
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            mode.label,
                            style: AppTheme.ubuntu(
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                              color: settings.backendMode == mode
                                  ? AppColors.blackInk
                                  : AppColors.whitePure,
                            ),
                          ),
                          Text(
                            mode == BackendMode.dummyLightweightSupabase
                                ? 'Ekstraksi fitur citra 224×224 di perangkat + Supabase log'
                                : 'Kirim multipart foto ke API Python (/predict & /health)',
                            style: AppTheme.ubuntu(
                              fontSize: 11,
                              color: settings.backendMode == mode
                                  ? AppColors.textSecondaryLight
                                  : AppColors.textMutedDark,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildPreferencesCard(AppSettings settings) {
    return BrutalCard(
      backgroundColor: AppColors.whitePure,
      padding: const EdgeInsets.all(14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'PREFERENSI MODEL & TAMPILAN',
            style: AppTheme.mono(
              fontSize: 11,
              fontWeight: FontWeight.w700,
              color: AppColors.greenMid,
            ),
          ),
          const SizedBox(height: 10),
          DropdownButtonFormField<String>(
            initialValue: settings.defaultBackbone,
            decoration: const InputDecoration(
              labelText: 'Backbone CNN Default',
              border: OutlineInputBorder(),
              isDense: true,
            ),
            items: [
              for (final b in AppConstants.backbones)
                DropdownMenuItem(value: b, child: Text(b)),
            ],
            onChanged: (val) {
              if (val != null) {
                controller.updateSettings(settings.copyWith(defaultBackbone: val));
              }
            },
          ),
          SwitchListTile(
            contentPadding: EdgeInsets.zero,
            title: Text(
              'Mode Lab Putih (Light Theme)',
              style: AppTheme.ubuntu(
                fontSize: 13,
                fontWeight: FontWeight.w700,
                color: AppColors.blackInk,
              ),
            ),
            subtitle: Text(
              settings.isLightLabTheme ? 'Aktif: Lab Putih' : 'Aktif: Hutan Gelap',
              style: AppTheme.ubuntu(fontSize: 11),
            ),
            value: settings.isLightLabTheme,
            onChanged: (_) => controller.toggleThemeMode(),
          ),
          SwitchListTile(
            contentPadding: EdgeInsets.zero,
            title: Text(
              'Animasi Laser Scanner Beranda',
              style: AppTheme.ubuntu(
                fontSize: 13,
                fontWeight: FontWeight.w700,
                color: AppColors.blackInk,
              ),
            ),
            value: settings.enableScanAnimation,
            onChanged: (_) => controller.toggleScanAnimation(),
          ),
        ],
      ),
    );
  }

  Widget _buildResearchCard(BuildContext context) {
    return BrutalCard(
      backgroundColor: AppColors.bgSurfaceMuted,
      padding: const EdgeInsets.all(14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '${AppConstants.appName} • ${AppConstants.teamName}',
            style: AppTheme.ubuntu(
              fontSize: 15,
              fontWeight: FontWeight.w700,
              color: AppColors.blackInk,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'ID Perangkat: ${controller.deviceId}',
            style: AppTheme.mono(
              fontSize: 10,
              color: AppColors.textSecondaryLight,
            ),
          ),
          const SizedBox(height: 10),
          SizedBox(
            width: double.infinity,
            child: BrutalButton(
              label: 'Metodologi, Benchmark & Privasi',
              icon: Icons.school_rounded,
              variant: BrutalButtonVariant.white,
              onPressed: () => showResearchInfoSheet(context),
            ),
          ),
        ],
      ),
    );
  }
}
