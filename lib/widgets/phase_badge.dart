import 'package:flutter/material.dart';
import '../models/workout_phase.dart';
import '../core/theme/app_colors.dart';
import '../core/theme/app_typography.dart';

class PhaseBadge extends StatelessWidget {
  final WorkoutPhase phase;

  const PhaseBadge({
    super.key,
    required this.phase,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
      decoration: BoxDecoration(
        color: phase.subtleColor,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: phase.accentColor.withValues(alpha: 0.35),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 7,
            height: 7,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: phase.accentColor,
            ),
          ),
          const SizedBox(width: 8),
          Text(
            phase.displayName,
            style: AppTypography.phaseLabel.copyWith(
              color: phase == WorkoutPhase.idle ? AppColors.textSecondary : phase.accentColor,
            ),
          ),
        ],
      ),
    );
  }
}
