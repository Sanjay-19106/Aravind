import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/system_state.dart';
import '../theme/app_theme.dart';

class CustomQuestDialog extends StatefulWidget {
  const CustomQuestDialog({super.key});

  @override
  State<CustomQuestDialog> createState() => _CustomQuestDialogState();
}

class _CustomQuestDialogState extends State<CustomQuestDialog> {
  final _titleController = TextEditingController();
  final _durationController = TextEditingController();
  String _selectedAttr = 'STR';
  final int _attrGain = 10;
  final int _expGain = 10;

  @override
  void dispose() {
    _titleController.dispose();
    _durationController.dispose();
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
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'New Daily Protocol',
                style: TextStyle(
                  color: AppTheme.onSurface,
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 6),
              const Text(
                'Define a non-negotiable trial to accelerate alter ego evolution.',
                style: TextStyle(color: AppTheme.outline, fontSize: 13),
              ),
              const SizedBox(height: 18),
              const Text(
                'PROTOCOL OBJECTIVE',
                style: TextStyle(
                  color: AppTheme.outline,
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.0,
                ),
              ),
              const SizedBox(height: 6),
              TextField(
                controller: _titleController,
                style: const TextStyle(color: AppTheme.onSurface, fontSize: 14),
                decoration: InputDecoration(
                  filled: true,
                  fillColor: AppTheme.surfaceLowest,
                  hintText: 'e.g. Cold Shower & Breathing Drills',
                  hintStyle: const TextStyle(color: AppTheme.outline),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: AppTheme.surfaceHigh),
                  ),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                ),
              ),
              const SizedBox(height: 14),
              const Text(
                'CADENCE / DURATION',
                style: TextStyle(
                  color: AppTheme.outline,
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.0,
                ),
              ),
              const SizedBox(height: 6),
              TextField(
                controller: _durationController,
                style: const TextStyle(color: AppTheme.onSurface, fontSize: 14),
                decoration: InputDecoration(
                  filled: true,
                  fillColor: AppTheme.surfaceLowest,
                  hintText: 'e.g. 15 mins morning',
                  hintStyle: const TextStyle(color: AppTheme.outline),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: AppTheme.surfaceHigh),
                  ),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                ),
              ),
              const SizedBox(height: 14),
              const Text(
                'PRIMARY ATTRIBUTE VECTOR',
                style: TextStyle(
                  color: AppTheme.outline,
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.0,
                ),
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: ['STR', 'INT', 'WIL', 'CHA', 'FOC'].map((attr) {
                  final isSelected = _selectedAttr == attr;
                  return GestureDetector(
                    onTap: () => setState(() => _selectedAttr = attr),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      decoration: BoxDecoration(
                        color: isSelected ? AppTheme.primary : AppTheme.surfaceHighest,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        attr,
                        style: TextStyle(
                          color: isSelected ? AppTheme.onPrimary : AppTheme.outline,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  );
                }).toList(),
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
                        final title = _titleController.text.trim();
                        final duration = _durationController.text.trim();
                        if (title.isNotEmpty) {
                          Provider.of<SystemState>(context, listen: false).addCustomQuest(
                            title: title,
                            duration: duration.isEmpty ? 'Daily' : duration,
                            attributeCode: _selectedAttr,
                            attributeGain: _attrGain,
                            expGain: _expGain,
                          );
                        }
                        Navigator.of(context).pop();
                      },
                      child: const Text(
                        'Enforce Protocol',
                        style: TextStyle(fontWeight: FontWeight.w600),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
