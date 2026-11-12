import 'package:flutter/material.dart';
import '../config/app_theme.dart';
import '../state/app_controller.dart';
import 'history/history_page.dart';
import 'home/home_page.dart';
import 'scan/scan_page.dart';
import 'settings/settings_page.dart';

class MainShell extends StatelessWidget {
  final AppController controller;

  const MainShell({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (context, _) {
        final isLight = controller.settings.isLightLabTheme;
        final bg = isLight ? AppColors.bgLabWhite : AppColors.bgCanvasDark;

        return Scaffold(
          backgroundColor: bg,
          body: IndexedStack(
            index: controller.currentTabIndex,
            children: [
              HomePage(controller: controller),
              ScanPage(controller: controller),
              HistoryPage(controller: controller),
              SettingsPage(controller: controller),
            ],
          ),
          bottomNavigationBar: _buildBottomBar(
            currentIndex: controller.currentTabIndex,
            historyCount: controller.history.length,
            isLight: isLight,
          ),
        );
      },
    );
  }

  Widget _buildBottomBar({
    required int currentIndex,
    required int historyCount,
    required bool isLight,
  }) {
    final navItems = [
      (Icons.home_rounded, 'Beranda', 0),
      (Icons.qr_code_scanner_rounded, 'Scan', 0),
      (Icons.history_rounded, 'Riwayat', historyCount),
      (Icons.tune_rounded, 'Pengaturan', 0),
    ];

    return Container(
      decoration: BoxDecoration(
        color: isLight ? AppColors.whitePure : AppColors.bgHeroTop,
        border: const Border(
          top: BorderSide(color: AppColors.blackInk, width: 3),
        ),
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              for (int i = 0; i < navItems.length; i++)
                _buildNavItem(
                  index: i,
                  active: currentIndex == i,
                  icon: navItems[i].$1,
                  label: navItems[i].$2,
                  badgeCount: navItems[i].$3,
                  isLight: isLight,
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem({
    required int index,
    required bool active,
    required IconData icon,
    required String label,
    required int badgeCount,
    required bool isLight,
  }) {
    final activeBg = AppColors.mintPistachio;
    final inactiveColor = isLight ? AppColors.blackInk : AppColors.textMutedDark;

    return Expanded(
      child: GestureDetector(
        key: Key('nav_tab_$index'),
        onTap: () => controller.setTab(index),
        behavior: HitTestBehavior.opaque,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 160),
          margin: const EdgeInsets.symmetric(horizontal: 4),
          padding: const EdgeInsets.symmetric(vertical: 7),
          decoration: BoxDecoration(
            color: active ? activeBg : Colors.transparent,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: active ? AppColors.blackInk : Colors.transparent,
              width: 2,
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Stack(
                clipBehavior: Clip.none,
                children: [
                  Icon(
                    icon,
                    size: 22,
                    color: active ? AppColors.blackInk : inactiveColor,
                  ),
                  if (badgeCount > 0)
                    Positioned(
                      right: -10,
                      top: -6,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 5,
                          vertical: 1,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.greenMid,
                          borderRadius: BorderRadius.circular(99),
                          border: Border.all(
                            color: AppColors.blackInk,
                            width: 1.5,
                          ),
                        ),
                        child: Text(
                          badgeCount > 99 ? '99+' : '$badgeCount',
                          style: AppTheme.mono(
                            fontSize: 9,
                            fontWeight: FontWeight.w700,
                            color: AppColors.whitePure,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 3),
              Text(
                label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppTheme.ubuntu(
                  fontSize: 11,
                  fontWeight: active ? FontWeight.w700 : FontWeight.w500,
                  color: active ? AppColors.blackInk : inactiveColor,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
