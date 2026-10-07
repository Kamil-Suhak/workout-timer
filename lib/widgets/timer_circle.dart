import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../models/workout_phase.dart';
import '../core/theme/app_colors.dart';
import '../core/theme/app_typography.dart';
import '../core/utils/time_formatter.dart';

class TimerCircle extends StatelessWidget {
  final Duration remainingDuration;
  final double progress;
  final WorkoutPhase phase;

  const TimerCircle({
    super.key,
    required this.remainingDuration,
    required this.progress,
    required this.phase,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final diameter = math.min(constraints.maxWidth, constraints.maxHeight);
        final safeDiameter = diameter.isFinite && diameter > 0 ? diameter : 260.0;

        return SizedBox(
          width: safeDiameter,
          height: safeDiameter,
          child: Stack(
            alignment: Alignment.center,
            children: [
              CustomPaint(
                size: Size(safeDiameter, safeDiameter),
                painter: _MinimalDialPainter(
                  progress: progress,
                  accentColor: phase.accentColor,
                  trackColor: AppColors.borderSubtle,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(28.0),
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        TimeFormatter.formatMinutesSeconds(remainingDuration),
                        style: AppTypography.timerHuge,
                      ),
                      const SizedBox(height: 6),
                      Text(
                        phase.displayName,
                        style: AppTypography.phaseLabel.copyWith(
                          color: phase == WorkoutPhase.idle
                              ? AppColors.textTertiary
                              : phase.accentColor,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _MinimalDialPainter extends CustomPainter {
  final double progress;
  final Color accentColor;
  final Color trackColor;

  _MinimalDialPainter({
    required this.progress,
    required this.accentColor,
    required this.trackColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = (math.min(size.width, size.height) / 2) - 16;
    const strokeWidth = 5.0;

    // Background track
    final trackPaint = Paint()
      ..color = trackColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    canvas.drawCircle(center, radius, trackPaint);

    // Active progress arc
    if (progress > 0) {
      final activePaint = Paint()
        ..color = accentColor
        ..style = PaintingStyle.stroke
        ..strokeWidth = strokeWidth
        ..strokeCap = StrokeCap.round;

      const startAngle = -math.pi / 2;
      final sweepAngle = 2 * math.pi * progress.clamp(0.0, 1.0);

      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        startAngle,
        sweepAngle,
        false,
        activePaint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant _MinimalDialPainter oldDelegate) {
    return oldDelegate.progress != progress ||
        oldDelegate.accentColor != accentColor ||
        oldDelegate.trackColor != trackColor;
  }
}
