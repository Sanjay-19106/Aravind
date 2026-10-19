import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/system_state.dart';
import '../theme/app_theme.dart';
import '../widgets/brutalist_header.dart';
import 'status_screen.dart';
import 'daily_quests_screen.dart';
import 'history_screen.dart';
import 'profile_screen.dart';

class MainNavigationScreen extends StatefulWidget {
  const MainNavigationScreen({super.key});

  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  final List<Widget> _screens = const [
    StatusScreen(),
    DailyQuestsScreen(),
    HistoryScreen(),
    ProfileScreen(),
  ];

  final List<String> _titles = const [
    'Status',
    'Daily Quests',
    'History',
    'Profile',
  ];

  @override
  Widget build(BuildContext context) {
    final system = Provider.of<SystemState>(context);
    final currentIndex = system.currentTabIndex;

    // Toast listener
    if (system.toastMessage != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ScaffoldMessenger.of(context).hideCurrentSnackBar();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: AppTheme.surfaceBright,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(999),
            ),
            margin: const EdgeInsets.only(bottom: 80, left: 32, right: 32),
            duration: const Duration(milliseconds: 2000),
            content: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.verified, color: AppTheme.primary, size: 18),
                const SizedBox(width: 8),
                Flexible(
                  child: Text(
                    system.toastMessage!,
                    style: const TextStyle(
                      color: AppTheme.primary,
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
        );
        system.clearToast();
      });
    }

    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: BrutalistHeader(
        title: _titles[currentIndex],
        onAvatarTap: () {
          system.switchTab(3); // Jump to Profile
        },
      ),
      body: IndexedStack(
        index: currentIndex,
        children: _screens,
      ),
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          color: AppTheme.surface,
          border: Border(
            top: BorderSide(color: AppTheme.surfaceHigh, width: 1),
          ),
        ),
        child: SafeArea(
          child: SizedBox(
            height: 64,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildNavItem(
                  index: 0,
                  icon: Icons.auto_awesome,
                  label: 'Status',
                  isSelected: currentIndex == 0,
                  onTap: () => system.switchTab(0),
                ),
                _buildNavItem(
                  index: 1,
                  icon: Icons.check_circle_outline,
                  label: 'Daily Quests',
                  isSelected: currentIndex == 1,
                  onTap: () => system.switchTab(1),
                ),
                _buildNavItem(
                  index: 2,
                  icon: Icons.calendar_today_outlined,
                  label: 'History',
                  isSelected: currentIndex == 2,
                  onTap: () => system.switchTab(2),
                ),
                _buildNavItem(
                  index: 3,
                  icon: Icons.account_circle_outlined,
                  label: 'Profile',
                  isSelected: currentIndex == 3,
                  onTap: () => system.switchTab(3),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem({
    required int index,
    required IconData icon,
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 22,
              color: isSelected ? AppTheme.primary : AppTheme.outline,
            ),
            const SizedBox(height: 4),
            Text(
              label.toUpperCase(),
              style: TextStyle(
                color: isSelected ? AppTheme.primary : AppTheme.outline,
                fontSize: 10,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                letterSpacing: 0.8,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
