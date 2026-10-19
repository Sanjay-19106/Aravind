import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../services/system_state.dart';
import '../theme/app_theme.dart';
import '../widgets/penalty_banner.dart';

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final system = Provider.of<SystemState>(context);
    final profile = system.profile;
    final logs = system.logs;

    final now = DateTime.now();
    final currentDayIndex = now.weekday - 1; // 0 = Mon, 6 = Sun
    final daysOfWeek = ['M', 'T', 'W', 'T', 'F', 'S', 'S'];

    // Calculate weekly pace (completed quests today / total quests today * 100)
    final weeklyPace = (system.completionPercentage * 100).round();

    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const PenaltyBanner(),

          // Title & Subtitle
          const Text(
            'MOMENTUM LEDGER',
            style: TextStyle(
              color: AppTheme.outline,
              fontSize: 11,
              fontWeight: FontWeight.w600,
              letterSpacing: 1.2,
            ),
          ),
          const SizedBox(height: 2),
          const Text(
            'History',
            style: TextStyle(
              color: AppTheme.primary,
              fontSize: 32,
              fontWeight: FontWeight.w700,
              letterSpacing: -0.8,
            ),
          ),

          const SizedBox(height: 20),

          // Current Rhythm Card
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: AppTheme.surfaceContainer,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: AppTheme.surfaceHigh.withValues(alpha: 0.5), width: 1),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'CURRENT RHYTHM',
                          style: TextStyle(
                            color: AppTheme.outline,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1.2,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.baseline,
                          textBaseline: TextBaseline.alphabetic,
                          children: [
                            Text(
                              '${profile.streakDays}',
                              style: const TextStyle(
                                color: AppTheme.primary,
                                fontSize: 36,
                                fontWeight: FontWeight.w700,
                                letterSpacing: -1.0,
                              ),
                            ),
                            const SizedBox(width: 6),
                            const Text(
                              'Day Streak',
                              style: TextStyle(
                                color: AppTheme.onSurfaceVariant,
                                fontSize: 15,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        const Text(
                          'WEEKLY PACE',
                          style: TextStyle(
                            color: AppTheme.outline,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1.2,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '$weeklyPace%',
                          style: const TextStyle(
                            color: AppTheme.onSurface,
                            fontSize: 24,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 14),
                Container(
                  height: 6,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: AppTheme.surfaceHighest,
                    borderRadius: BorderRadius.circular(999),
                  ),
                  child: FractionallySizedBox(
                    alignment: Alignment.centerLeft,
                    widthFactor: (weeklyPace / 100).clamp(0.04, 1.0),
                    child: Container(
                      decoration: BoxDecoration(
                        color: AppTheme.primary,
                        borderRadius: BorderRadius.circular(999),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                const Text(
                  'Your consistency counter activates the moment your first quest is recorded.',
                  style: TextStyle(
                    color: AppTheme.outline,
                    fontSize: 13,
                    height: 1.3,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          // Weekly Overview Card
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: AppTheme.surfaceContainer,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: AppTheme.surfaceHigh.withValues(alpha: 0.5), width: 1),
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'WEEKLY OVERVIEW',
                      style: TextStyle(
                        color: AppTheme.outline,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.2,
                      ),
                    ),
                    Text(
                      'Week ${((now.difference(DateTime(now.year, 1, 1)).inDays) / 7).ceil()}',
                      style: const TextStyle(
                        color: AppTheme.onSurfaceVariant,
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: List.generate(7, (index) {
                    final isToday = index == currentDayIndex;
                    final isPast = index < currentDayIndex;

                    return Column(
                      children: [
                        Text(
                          daysOfWeek[index],
                          style: TextStyle(
                            color: isToday ? AppTheme.primary : AppTheme.outline,
                            fontSize: 12,
                            fontWeight: isToday ? FontWeight.bold : FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Container(
                          width: 36,
                          height: 36,
                          decoration: BoxDecoration(
                            color: isToday ? AppTheme.surfaceBright : AppTheme.surfaceHighest,
                            shape: BoxShape.circle,
                            border: isToday
                                ? Border.all(color: AppTheme.primary, width: 1)
                                : null,
                          ),
                          child: Center(
                            child: isToday
                                ? Container(
                                    width: 10,
                                    height: 10,
                                    decoration: const BoxDecoration(
                                      color: AppTheme.primary,
                                      shape: BoxShape.circle,
                                    ),
                                  )
                                : Container(
                                    width: 6,
                                    height: 6,
                                    decoration: BoxDecoration(
                                      color: isPast
                                          ? AppTheme.outline
                                          : AppTheme.outlineVariant,
                                      shape: BoxShape.circle,
                                    ),
                                  ),
                          ),
                        ),
                      ],
                    );
                  }),
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          // 2 Metric Tiles: Completed Daily Quests & Accumulated Total EXP
          Row(
            children: [
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    color: AppTheme.surfaceContainer,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: AppTheme.surfaceHigh.withValues(alpha: 0.5), width: 1),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'COMPLETED',
                            style: TextStyle(
                              color: AppTheme.outline,
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 1.0,
                            ),
                          ),
                          Icon(Icons.task_alt, size: 18, color: AppTheme.outline),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        '${profile.totalCompletedQuests}',
                        style: const TextStyle(
                          color: AppTheme.primary,
                          fontSize: 32,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 2),
                      const Text(
                        'Daily Quests',
                        style: TextStyle(
                          color: AppTheme.onSurfaceVariant,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    color: AppTheme.surfaceContainer,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: AppTheme.surfaceHigh.withValues(alpha: 0.5), width: 1),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'ACCUMULATED',
                            style: TextStyle(
                              color: AppTheme.outline,
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 1.0,
                            ),
                          ),
                          Icon(Icons.bolt, size: 18, color: AppTheme.outline),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        '${profile.totalAccumulatedExp}',
                        style: const TextStyle(
                          color: AppTheme.primary,
                          fontSize: 32,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 2),
                      const Text(
                        'Total EXP',
                        style: TextStyle(
                          color: AppTheme.onSurfaceVariant,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 24),

          // Recent Activity (Session Log)
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Recent Activity',
                style: TextStyle(
                  color: AppTheme.primary,
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                'SESSION LOG',
                style: TextStyle(
                  color: AppTheme.outline,
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.2,
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: AppTheme.surfaceContainer,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: AppTheme.surfaceHigh.withValues(alpha: 0.5), width: 1),
            ),
            child: Column(
              children: [
                ...logs.take(6).map((log) {
                  final timeStr = DateFormat('MMM dd, hh:mm a').format(log.timestamp);
                  IconData icon;
                  Color iconColor = AppTheme.outline;

                  switch (log.type) {
                    case 'QUEST_COMPLETE':
                      icon = Icons.check_circle_outline;
                      iconColor = AppTheme.primary;
                      break;
                    case 'PENALTY':
                      icon = Icons.warning_amber_rounded;
                      iconColor = AppTheme.error;
                      break;
                    case 'ASCENSION':
                      icon = Icons.auto_awesome;
                      iconColor = AppTheme.hunterCyan;
                      break;
                    case 'INIT':
                      icon = Icons.flag_outlined;
                      break;
                    default:
                      icon = Icons.drive_file_rename_outline;
                  }

                  return Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: 28,
                          height: 28,
                          decoration: const BoxDecoration(
                            color: AppTheme.surfaceHighest,
                            shape: BoxShape.circle,
                          ),
                          child: Center(
                            child: Icon(icon, color: iconColor, size: 15),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                timeStr,
                                style: const TextStyle(
                                  color: AppTheme.outline,
                                  fontSize: 11,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                log.title,
                                style: const TextStyle(
                                  color: AppTheme.onSurface,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                log.description,
                                style: const TextStyle(
                                  color: AppTheme.onSurfaceVariant,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                }),
                const SizedBox(height: 8),
                // Begin Your Streak prompt
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppTheme.surfaceLow,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.lightbulb_outline, size: 18, color: AppTheme.primary),
                          SizedBox(width: 8),
                          Text(
                            'Begin Your Streak',
                            style: TextStyle(
                              color: AppTheme.primary,
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 6),
                      Text(
                        'Complete your first quest today to see detailed progress trends, recovery windows, and streak milestones populate here in real time.',
                        style: TextStyle(
                          color: AppTheme.onSurfaceVariant,
                          fontSize: 12,
                          height: 1.4,
                        ),
                      ),
                    ],
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
}
