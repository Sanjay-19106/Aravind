import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/system_state.dart';
import '../theme/app_theme.dart';

class PenaltyBanner extends StatelessWidget {
  const PenaltyBanner({super.key});

  @override
  Widget build(BuildContext context) {
    final system = Provider.of<SystemState>(context);
    final penalty = system.penalty;

    if (!penalty.isUnderPenalty) {
      return const SizedBox.shrink();
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.errorContainer.withValues(alpha: 0.35),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppTheme.error, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.warning_amber_rounded, color: AppTheme.error, size: 20),
              SizedBox(width: 8),
              Text(
                'PENALTY PROTOCOL ACTIVE',
                style: TextStyle(
                  color: AppTheme.error,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.0,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            'Daily quota was breached. Mandatory physical consequence: ${penalty.penaltyText}',
            style: const TextStyle(
              color: AppTheme.onSurface,
              fontSize: 14,
              height: 1.3,
            ),
          ),
          const SizedBox(height: 12),
          Align(
            alignment: Alignment.centerRight,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.error,
                foregroundColor: AppTheme.surfaceLowest,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(999),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                elevation: 0,
              ),
              onPressed: () {
                system.clearPenaltyFulfillment();
              },
              child: const Text(
                'Acknowledge & Atoned',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
