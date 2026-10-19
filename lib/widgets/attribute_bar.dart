import 'package:flutter/material.dart';
import '../models/attribute.dart';
import '../theme/app_theme.dart';

class AttributeBar extends StatelessWidget {
  final Attribute attribute;
  final VoidCallback onTap;

  const AttributeBar({
    super.key,
    required this.attribute,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final ratio = attribute.progressRatio;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 4),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  attribute.name,
                  style: const TextStyle(
                    color: AppTheme.onSurface,
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  '${attribute.currentValue} / ${attribute.maxValue}',
                  style: const TextStyle(
                    color: AppTheme.outline,
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 6),
            Container(
              height: 6,
              width: double.infinity,
              decoration: BoxDecoration(
                color: AppTheme.surfaceHighest,
                borderRadius: BorderRadius.circular(999),
              ),
              child: FractionallySizedBox(
                alignment: Alignment.centerLeft,
                widthFactor: ratio == 0 ? 0.03 : ratio,
                child: Container(
                  decoration: BoxDecoration(
                    color: AppTheme.primary,
                    borderRadius: BorderRadius.circular(999),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
