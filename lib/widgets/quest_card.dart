import 'package:flutter/material.dart';
import '../models/quest.dart';
import '../theme/app_theme.dart';

class QuestCard extends StatelessWidget {
  final Quest quest;
  final VoidCallback onToggle;

  const QuestCard({
    super.key,
    required this.quest,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onToggle,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: quest.isCompleted
              ? AppTheme.surfaceContainer.withValues(alpha: 0.6)
              : AppTheme.surfaceLow,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: quest.isCompleted
                ? AppTheme.surfaceHighest
                : AppTheme.surfaceHigh.withValues(alpha: 0.4),
            width: 1,
          ),
        ),
        child: Row(
          children: [
            // Checkbox button
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: 28,
              height: 28,
              decoration: BoxDecoration(
                color: quest.isCompleted
                    ? AppTheme.primary
                    : AppTheme.surfaceHighest,
                shape: BoxShape.circle,
              ),
              child: Center(
                child: AnimatedScale(
                  scale: quest.isCompleted ? 1.0 : 0.0,
                  duration: const Duration(milliseconds: 180),
                  child: const Icon(
                    Icons.check,
                    color: AppTheme.onPrimary,
                    size: 18,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 14),
            // Quest Details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    quest.title,
                    style: TextStyle(
                      color: quest.isCompleted
                          ? AppTheme.outline
                          : AppTheme.onSurface,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      decoration: quest.isCompleted
                          ? TextDecoration.lineThrough
                          : TextDecoration.none,
                      decorationColor: AppTheme.outline,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Text(
                        quest.duration,
                        style: const TextStyle(
                          color: AppTheme.outline,
                          fontSize: 13,
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.symmetric(horizontal: 8),
                        width: 3,
                        height: 3,
                        decoration: const BoxDecoration(
                          color: AppTheme.surfaceHighest,
                          shape: BoxShape.circle,
                        ),
                      ),
                      Text(
                        '+${quest.attributeGain} ${quest.attributeCode}',
                        style: const TextStyle(
                          color: AppTheme.onSurfaceVariant,
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            // EXP Badge
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: quest.isCompleted
                    ? AppTheme.surfaceHighest.withValues(alpha: 0.5)
                    : AppTheme.surfaceHigh,
                borderRadius: BorderRadius.circular(999),
              ),
              child: Text(
                '+${quest.expGain} EXP',
                style: TextStyle(
                  color: quest.isCompleted
                      ? AppTheme.outline
                      : AppTheme.onSurface,
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.5,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
