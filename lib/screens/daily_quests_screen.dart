import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/system_state.dart';
import '../theme/app_theme.dart';
import '../widgets/quest_card.dart';
import '../widgets/penalty_banner.dart';
import '../widgets/edit_penalties_dialog.dart';
import '../widgets/custom_quest_dialog.dart';

class DailyQuestsScreen extends StatelessWidget {
  const DailyQuestsScreen({super.key});

  String _calculateResetTime() {
    final now = DateTime.now();
    final midnight = DateTime(now.year, now.month, now.day + 1);
    final diff = midnight.difference(now);
    final hours = diff.inHours;
    final mins = diff.inMinutes.remainder(60);
    return 'Resets in ${hours}h ${mins}m';
  }

  @override
  Widget build(BuildContext context) {
    final system = Provider.of<SystemState>(context);
    final quests = system.quests;
    final completedCount = system.completedQuestsCount;
    final totalCount = system.totalQuestsCount;
    final pct = (system.completionPercentage * 100).round();

    return Scaffold(
      backgroundColor: Colors.transparent,
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppTheme.primary,
        foregroundColor: AppTheme.onPrimary,
        elevation: 4,
        onPressed: () {
          showDialog(
            context: context,
            builder: (ctx) => const CustomQuestDialog(),
          );
        },
        child: const Icon(Icons.add, size: 24),
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const PenaltyBanner(),

            // Header & Overview
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Daily Quests',
                      style: TextStyle(
                        color: AppTheme.onSurface,
                        fontSize: 28,
                        fontWeight: FontWeight.w700,
                        letterSpacing: -0.8,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      "Today's Routine • $completedCount of $totalCount Completed",
                      style: const TextStyle(
                        color: AppTheme.onSurfaceVariant,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                    color: AppTheme.surfaceHigh,
                    borderRadius: BorderRadius.circular(999),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.schedule, size: 14, color: AppTheme.outline),
                      const SizedBox(width: 5),
                      Text(
                        _calculateResetTime(),
                        style: const TextStyle(
                          color: AppTheme.onSurfaceVariant,
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),

            // Segmented Minimalist Progress Indicator
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'COMPLETION',
                      style: TextStyle(
                        color: AppTheme.outline,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.2,
                      ),
                    ),
                    Text(
                      '$pct%',
                      style: const TextStyle(
                        color: AppTheme.primary,
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: List.generate(totalCount, (index) {
                    final isFilled = index < completedCount;
                    return Expanded(
                      child: Container(
                        margin: EdgeInsets.only(right: index == totalCount - 1 ? 0 : 6),
                        height: 6,
                        decoration: BoxDecoration(
                          color: isFilled ? AppTheme.primary : AppTheme.surfaceHighest,
                          borderRadius: BorderRadius.circular(999),
                        ),
                      ),
                    );
                  }),
                ),
              ],
            ),

            const SizedBox(height: 24),

            // Quest Habit Modules List
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: quests.length,
              separatorBuilder: (context, index) => const SizedBox(height: 10),
              itemBuilder: (context, index) {
                final quest = quests[index];
                return QuestCard(
                  quest: quest,
                  onToggle: () {
                    system.toggleQuest(quest.id);
                  },
                );
              },
            ),

            const SizedBox(height: 24),

            // Daily Commitment / Penalty Protocol Module
            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: AppTheme.surfaceLow,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: AppTheme.surfaceHigh.withValues(alpha: 0.5), width: 1),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 34,
                        height: 34,
                        decoration: const BoxDecoration(
                          color: AppTheme.surfaceHigh,
                          shape: BoxShape.circle,
                        ),
                        child: const Center(
                          child: Icon(
                            Icons.verified_user_outlined,
                            color: AppTheme.outline,
                            size: 18,
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Daily Commitment',
                              style: TextStyle(
                                color: AppTheme.onSurface,
                                fontSize: 17,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 4),
                            RichText(
                              text: TextSpan(
                                text: "Incomplete quests trigger tomorrow's penalty: ",
                                style: const TextStyle(
                                  color: AppTheme.onSurfaceVariant,
                                  fontSize: 13,
                                  height: 1.4,
                                ),
                                children: [
                                  TextSpan(
                                    text: system.penalty.penaltyText,
                                    style: const TextStyle(
                                      color: AppTheme.onSurface,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Icon(
                            system.penalty.isPledgeActive
                                ? Icons.check_circle_outline
                                : Icons.info_outline,
                            size: 16,
                            color: system.penalty.isPledgeActive
                                ? AppTheme.primary
                                : AppTheme.outline,
                          ),
                          const SizedBox(width: 6),
                          Text(
                            system.penalty.isPledgeActive ? 'Pledge Active' : 'Pledge Paused',
                            style: TextStyle(
                              color: system.penalty.isPledgeActive
                                  ? AppTheme.primary
                                  : AppTheme.outline,
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppTheme.surfaceHigh,
                          foregroundColor: AppTheme.onSurface,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(999),
                          ),
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          elevation: 0,
                        ),
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (ctx) => const EditPenaltiesDialog(),
                          );
                        },
                        child: const Text(
                          'Edit Penalties',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 80),
          ],
        ),
      ),
    );
  }
}
