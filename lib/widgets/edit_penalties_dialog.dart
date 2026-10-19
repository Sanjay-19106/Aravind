import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/system_state.dart';
import '../theme/app_theme.dart';

class EditPenaltiesDialog extends StatefulWidget {
  const EditPenaltiesDialog({super.key});

  @override
  State<EditPenaltiesDialog> createState() => _EditPenaltiesDialogState();
}

class _EditPenaltiesDialogState extends State<EditPenaltiesDialog> {
  late TextEditingController _controller;
  late bool _pledgeActive;

  @override
  void initState() {
    super.initState();
    final system = Provider.of<SystemState>(context, listen: false);
    _controller = TextEditingController(text: system.penalty.penaltyText);
    _pledgeActive = system.penalty.isPledgeActive;
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: AppTheme.surfaceLow,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: const BorderSide(color: AppTheme.surfaceHigh, width: 1),
      ),
      insetPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 32,
                  height: 32,
                  decoration: const BoxDecoration(
                    color: AppTheme.surfaceHigh,
                    shape: BoxShape.circle,
                  ),
                  child: const Center(
                    child: Icon(
                      Icons.shield_outlined,
                      color: AppTheme.primary,
                      size: 18,
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                const Text(
                  'Penalty Protocol',
                  style: TextStyle(
                    color: AppTheme.onSurface,
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            const Text(
              'Enforce real-world consequences for missed daily resets. The system shows zero mercy.',
              style: TextStyle(
                color: AppTheme.outline,
                fontSize: 13,
                height: 1.4,
              ),
            ),
            const SizedBox(height: 18),
            const Text(
              'MANDATORY LEVERAGE / PHYSICAL FRICTION',
              style: TextStyle(
                color: AppTheme.outline,
                fontSize: 10,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.0,
              ),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _controller,
              style: const TextStyle(color: AppTheme.onSurface, fontSize: 14),
              decoration: InputDecoration(
                filled: true,
                fillColor: AppTheme.surfaceLowest,
                hintText: 'e.g. 100 pushups & 12h screen limit',
                hintStyle: const TextStyle(color: AppTheme.outline),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: AppTheme.surfaceHigh),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: AppTheme.surfaceHigh),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: AppTheme.primary),
                ),
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              ),
            ),
            const SizedBox(height: 16),
            SwitchListTile(
              contentPadding: EdgeInsets.zero,
              title: const Text(
                'Pledge Active',
                style: TextStyle(
                  color: AppTheme.onSurface,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
              subtitle: const Text(
                'Activate automatic penalty triggers on midnight reset',
                style: TextStyle(color: AppTheme.outline, fontSize: 12),
              ),
              value: _pledgeActive,
              activeThumbColor: AppTheme.primary,
              activeTrackColor: AppTheme.surfaceHighest,
              inactiveTrackColor: AppTheme.surfaceLowest,
              onChanged: (val) {
                setState(() {
                  _pledgeActive = val;
                });
              },
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    style: TextButton.styleFrom(
                      foregroundColor: AppTheme.outline,
                    ),
                    child: const Text('Cancel'),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.primary,
                      foregroundColor: AppTheme.onPrimary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(999),
                      ),
                    ),
                    onPressed: () {
                      final text = _controller.text.trim();
                      if (text.isNotEmpty) {
                        Provider.of<SystemState>(context, listen: false)
                            .updatePenaltyConfig(text, _pledgeActive);
                      }
                      Navigator.of(context).pop();
                    },
                    child: const Text(
                      'Lock In Stakes',
                      style: TextStyle(fontWeight: FontWeight.w600),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
