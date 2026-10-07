import 'package:flutter/material.dart';
import '../core/theme/app_colors.dart';
import '../core/theme/app_typography.dart';
import '../core/utils/time_formatter.dart';

class IntervalCard extends StatelessWidget {
  final String title;
  final Duration duration;
  final Color accentColor;
  final VoidCallback onIncrement;
  final VoidCallback onDecrement;
  final bool isEnabled;

  const IntervalCard({
    super.key,
    required this.title,
    required this.duration,
    required this.accentColor,
    required this.onIncrement,
    required this.onDecrement,
    this.isEnabled = true,
  });

  @override
  Widget build(BuildContext context) {
    final palette = AppColors.of(context);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: palette.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: palette.border),
      ),
      child: Row(
        children: [
          Container(
            width: 3,
            height: 36,
            decoration: BoxDecoration(
              color: accentColor,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  title.toUpperCase(),
                  style: AppTypography.cardCaption.copyWith(
                    fontWeight: FontWeight.w600,
                    letterSpacing: 1.2,
                    color: palette.textTertiary,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  TimeFormatter.formatMinutesSeconds(duration),
                  style: AppTypography.timerMedium.copyWith(
                    color: palette.textPrimary,
                  ),
                ),
              ],
            ),
          ),
          _StepperButton(
            icon: Icons.remove,
            onPressed: isEnabled ? onDecrement : null,
          ),
          const SizedBox(width: 8),
          _StepperButton(
            icon: Icons.add,
            onPressed: isEnabled ? onIncrement : null,
          ),
        ],
      ),
    );
  }
}

class _StepperButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback? onPressed;

  const _StepperButton({required this.icon, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    final palette = AppColors.of(context);
    final enabled = onPressed != null;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(10),
        child: Container(
          width: 38,
          height: 38,
          decoration: BoxDecoration(
            color: enabled ? palette.surfaceElevated : palette.surface,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: enabled ? palette.border : palette.borderSubtle,
            ),
          ),
          child: Icon(
            icon,
            size: 18,
            color: enabled ? palette.textPrimary : palette.textTertiary,
          ),
        ),
      ),
    );
  }
}
