import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/system_state.dart';
import '../theme/app_theme.dart';
import '../widgets/edit_penalties_dialog.dart';
import '../widgets/custom_quest_dialog.dart';
import '../widgets/penalty_banner.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  void _showResetConfirm(BuildContext context, SystemState system) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppTheme.surfaceLow,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: const BorderSide(color: AppTheme.errorContainer, width: 1),
        ),
        title: const Row(
          children: [
            Icon(Icons.warning_amber_rounded, color: AppTheme.error),
            SizedBox(width: 8),
            Text(
              'Reset System Data',
              style: TextStyle(color: AppTheme.error, fontSize: 18),
            ),
          ],
        ),
        content: const Text(
          'This will purge all quest logs, streak data, accumulated EXP, and attribute scores. You will return to Day 0 Novice baseline.',
          style: TextStyle(color: AppTheme.onSurfaceVariant, fontSize: 13, height: 1.4),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Cancel', style: TextStyle(color: AppTheme.outline)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.errorContainer,
              foregroundColor: AppTheme.error,
            ),
            onPressed: () {
              Navigator.of(ctx).pop();
              system.resetAllData();
            },
            child: const Text('Purge Everything'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final system = Provider.of<SystemState>(context);
    final profile = system.profile;
    final consistencyPct = (system.completionPercentage * 100).round();

    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const PenaltyBanner(),

          // Hunter ID Card
          Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: AppTheme.surfaceLow,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: AppTheme.surfaceHigh.withValues(alpha: 0.5), width: 1),
            ),
            child: Row(
              children: [
                Stack(
                  children: [
                    Container(
                      width: 58,
                      height: 58,
                      decoration: const BoxDecoration(
                        color: AppTheme.primary,
                        shape: BoxShape.circle,
                      ),
                      child: const Center(
                        child: Text(
                          'AR',
                          style: TextStyle(
                            color: AppTheme.onPrimary,
                            fontSize: 22,
                            fontWeight: FontWeight.w700,
                            letterSpacing: -1.0,
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: Container(
                        width: 16,
                        height: 16,
                        decoration: BoxDecoration(
                          color: AppTheme.surfaceLow,
                          shape: BoxShape.circle,
                          border: Border.all(color: AppTheme.surfaceLow, width: 2),
                        ),
                        child: Container(
                          decoration: const BoxDecoration(
                            color: AppTheme.outline,
                            shape: BoxShape.circle,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            profile.alterEgo,
                            style: const TextStyle(
                              color: AppTheme.onSurface,
                              fontSize: 18,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const SizedBox(width: 6),
                          Text(
                            '(${profile.name})',
                            style: const TextStyle(
                              color: AppTheme.outline,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              color: AppTheme.surfaceHigh,
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              profile.rank,
                              style: const TextStyle(
                                color: AppTheme.onSurface,
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 0.8,
                              ),
                            ),
                          ),
                          const SizedBox(width: 6),
                          const Text(
                            '•',
                            style: TextStyle(color: AppTheme.outline, fontSize: 10),
                          ),
                          const SizedBox(width: 6),
                          Text(
                            profile.rankDescription,
                            style: const TextStyle(
                              color: AppTheme.onSurfaceVariant,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      const Row(
                        children: [
                          Icon(Icons.calendar_today, size: 12, color: AppTheme.outline),
                          SizedBox(width: 5),
                          Text(
                            'Joined today',
                            style: TextStyle(
                              color: AppTheme.outline,
                              fontSize: 11,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // 3 Metric Tiles (Level, Buffs, Consistency)
          Row(
            children: [
              Expanded(
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
                  decoration: BoxDecoration(
                    color: AppTheme.surfaceLow,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: AppTheme.surfaceHigh.withValues(alpha: 0.5), width: 1),
                  ),
                  child: Column(
                    children: [
                      const Text(
                        'LEVEL',
                        style: TextStyle(
                          color: AppTheme.outline,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1.0,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${profile.level}',
                        style: const TextStyle(
                          color: AppTheme.primary,
                          fontSize: 28,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        '${profile.currentExp} / ${profile.maxExpPerLevel} XP',
                        style: const TextStyle(
                          color: AppTheme.outline,
                          fontSize: 10,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
                  decoration: BoxDecoration(
                    color: AppTheme.surfaceLow,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: AppTheme.surfaceHigh.withValues(alpha: 0.5), width: 1),
                  ),
                  child: const Column(
                    children: [
                      Text(
                        'BUFFS',
                        style: TextStyle(
                          color: AppTheme.outline,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1.0,
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        'None',
                        style: TextStyle(
                          color: AppTheme.onSurface,
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(height: 6),
                      Text(
                        'Dormant',
                        style: TextStyle(
                          color: AppTheme.outline,
                          fontSize: 10,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
                  decoration: BoxDecoration(
                    color: AppTheme.surfaceLow,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: AppTheme.surfaceHigh.withValues(alpha: 0.5), width: 1),
                  ),
                  child: Column(
                    children: [
                      const Text(
                        'CONSISTENCY',
                        style: TextStyle(
                          color: AppTheme.outline,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1.0,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '$consistencyPct%',
                        style: const TextStyle(
                          color: AppTheme.primary,
                          fontSize: 28,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 2),
                      const Text(
                        'Day 1',
                        style: TextStyle(
                          color: AppTheme.outline,
                          fontSize: 10,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 24),

          // Growth & Routine Section
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'GROWTH & ROUTINE',
                style: TextStyle(
                  color: AppTheme.outline,
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.2,
                ),
              ),
              Text(
                'Configuration',
                style: TextStyle(
                  color: AppTheme.outline,
                  fontSize: 11,
                ),
              ),
            ],
          ),

          const SizedBox(height: 10),

          Container(
            decoration: BoxDecoration(
              color: AppTheme.surfaceLow,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: AppTheme.surfaceHigh.withValues(alpha: 0.5), width: 1),
            ),
            child: Column(
              children: [
                _buildConfigItem(
                  icon: Icons.tune,
                  title: 'Edit Attributes & Goals',
                  subtitle: 'Target physical, mental & focus metrics',
                  onTap: () {
                    system.switchTab(0); // Jump to status attributes
                  },
                ),
                const Divider(height: 1, color: AppTheme.surfaceHigh),
                _buildConfigItem(
                  icon: Icons.checklist,
                  title: 'Custom Daily Quests',
                  subtitle: 'Craft non-negotiable personal trials',
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (ctx) => const CustomQuestDialog(),
                    );
                  },
                ),
                const Divider(height: 1, color: AppTheme.surfaceHigh),
                _buildConfigItem(
                  icon: Icons.shield_outlined,
                  title: 'Accountability & Penalties',
                  subtitle: 'Set stakes for missed commitments',
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (ctx) => const EditPenaltiesDialog(),
                    );
                  },
                ),
                const Divider(height: 1, color: AppTheme.surfaceHigh),
                _buildConfigItem(
                  icon: Icons.notifications_outlined,
                  title: 'Notifications & Reminders',
                  subtitle: 'Wake windows, checkpoints & alerts',
                  onTap: () {
                    system.showToast('Reminder cycle configured for 06:00 AM');
                  },
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          // System & Storage
          const Text(
            'SYSTEM & STORAGE',
            style: TextStyle(
              color: AppTheme.outline,
              fontSize: 11,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.2,
            ),
          ),

          const SizedBox(height: 10),

          Container(
            decoration: BoxDecoration(
              color: AppTheme.surfaceLow,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: AppTheme.surfaceHigh.withValues(alpha: 0.5), width: 1),
            ),
            child: Column(
              children: [
                InkWell(
                  onTap: () => _showResetConfirm(context, system),
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
                  child: const Padding(
                    padding: EdgeInsets.all(16),
                    child: Row(
                      children: [
                        Icon(Icons.restart_alt, color: AppTheme.error, size: 22),
                        SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Reset Progress & Data',
                                style: TextStyle(
                                  color: AppTheme.error,
                                  fontSize: 15,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              SizedBox(height: 2),
                              Text(
                                'Wipe records, return to Novice zero',
                                style: TextStyle(
                                  color: AppTheme.outline,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Icon(Icons.chevron_right, color: AppTheme.error, size: 20),
                      ],
                    ),
                  ),
                ),
                const Divider(height: 1, color: AppTheme.surfaceHigh),
                const Padding(
                  padding: EdgeInsets.all(16),
                  child: Row(
                    children: [
                      Icon(Icons.terminal, color: AppTheme.outline, size: 20),
                      SizedBox(width: 14),
                      Expanded(
                        child: Text(
                          'App Version',
                          style: TextStyle(
                            color: AppTheme.onSurface,
                            fontSize: 15,
                          ),
                        ),
                      ),
                      Text(
                        'v1.0.0',
                        style: TextStyle(
                          color: AppTheme.outline,
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 32),

          // Brutalist Footer Motto
          const Center(
            child: Column(
              children: [
                SizedBox(
                  width: 4,
                  height: 4,
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      color: AppTheme.outline,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  'DISCIPLINE EQUALS FREEDOM • EVERY SINGLE DAY.',
                  style: TextStyle(
                    color: AppTheme.outline,
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 1.5,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 40),
        ],
      ),
    );
  }

  Widget _buildConfigItem({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          children: [
            Container(
              width: 34,
              height: 34,
              decoration: BoxDecoration(
                color: AppTheme.surfaceHigh,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Center(
                child: Icon(icon, color: AppTheme.primary, size: 18),
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      color: AppTheme.onSurface,
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      color: AppTheme.outline,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(Icons.chevron_right, color: AppTheme.outline, size: 20),
          ],
        ),
      ),
    );
  }
}
