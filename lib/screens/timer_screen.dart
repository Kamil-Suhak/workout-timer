import 'package:flutter/material.dart';
import '../controllers/workout_timer_controller.dart';
import '../core/theme/app_colors.dart';
import '../core/theme/app_typography.dart';
import '../models/workout_phase.dart';
import '../widgets/interval_card.dart';
import '../widgets/phase_badge.dart';
import '../widgets/settings_sheet.dart';
import '../widgets/timer_circle.dart';

class TimerScreen extends StatefulWidget {
  final WorkoutTimerController? controller;

  const TimerScreen({
    super.key,
    this.controller,
  });

  @override
  State<TimerScreen> createState() => _TimerScreenState();
}

class _TimerScreenState extends State<TimerScreen> with WidgetsBindingObserver {
  late final WorkoutTimerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = widget.controller ?? WorkoutTimerController();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _controller.syncWithWallClock();
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    if (widget.controller == null) {
      _controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final palette = AppColors.of(context);

    return Scaffold(
      backgroundColor: palette.background,
      body: SafeArea(
        child: ListenableBuilder(
          listenable: _controller,
          builder: (context, _) {
            final state = _controller.state;
            final settings = _controller.settings;

            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
              child: Column(
                children: [
                  // Top navigation & set indicator
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'INTERVAL',
                            style: AppTypography.cardCaption.copyWith(
                              letterSpacing: 2.0,
                              fontWeight: FontWeight.w700,
                              color: palette.textTertiary,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            'SET ${state.currentSet} / ${settings.totalSets}',
                            style: AppTypography.setCounter.copyWith(
                              color: palette.textSecondary,
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          PhaseBadge(phase: state.phase),
                          const SizedBox(width: 8),
                          IconButton(
                            key: const ValueKey('settings_button'),
                            icon: Icon(
                              Icons.tune_rounded,
                              size: 20,
                              color: palette.textSecondary,
                            ),
                            onPressed: () => SettingsSheet.show(context, _controller),
                            tooltip: 'Settings & Presets',
                          ),
                        ],
                      ),
                    ],
                  ),

                  // Central Minimal Timer Dial
                  Expanded(
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 16.0),
                        child: TimerCircle(
                          remainingDuration: state.remainingDuration,
                          progress: state.progress,
                          phase: state.phase,
                        ),
                      ),
                    ),
                  ),

                  // Adjustable Interval Cards
                  IntervalCard(
                    title: 'Exercise',
                    duration: settings.workDuration,
                    accentColor: palette.work,
                    isEnabled: !state.isRunning,
                    onIncrement: () => _controller.adjustWorkDuration(const Duration(seconds: 15)),
                    onDecrement: () => _controller.adjustWorkDuration(const Duration(seconds: -15)),
                  ),
                  const SizedBox(height: 12),
                  IntervalCard(
                    title: 'Rest',
                    duration: settings.restDuration,
                    accentColor: palette.rest,
                    isEnabled: !state.isRunning,
                    onIncrement: () => _controller.adjustRestDuration(const Duration(seconds: 5)),
                    onDecrement: () => _controller.adjustRestDuration(const Duration(seconds: -5)),
                  ),

                  const SizedBox(height: 28),

                  // Bottom Controls Dock
                  Row(
                    children: [
                      // Reset Button
                      if (state.phase != WorkoutPhase.idle) ...[
                        IconButton.filled(
                          key: const ValueKey('reset_button'),
                          onPressed: _controller.reset,
                          style: IconButton.styleFrom(
                            backgroundColor: palette.surfaceElevated,
                            foregroundColor: palette.textSecondary,
                            minimumSize: const Size(56, 56),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                              side: BorderSide(color: palette.border),
                            ),
                          ),
                          icon: const Icon(Icons.refresh_rounded, size: 22),
                          tooltip: 'Reset',
                        ),
                        const SizedBox(width: 12),
                      ],

                      // Skip Phase Button (Visible while workout is running)
                      if (state.isRunning && state.phase != WorkoutPhase.completed) ...[
                        IconButton.filled(
                          key: const ValueKey('skip_button'),
                          onPressed: _controller.skipToNextPhase,
                          style: IconButton.styleFrom(
                            backgroundColor: palette.surfaceElevated,
                            foregroundColor: palette.textSecondary,
                            minimumSize: const Size(56, 56),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                              side: BorderSide(color: palette.border),
                            ),
                          ),
                          icon: const Icon(Icons.skip_next_rounded, size: 22),
                          tooltip: 'Skip Phase',
                        ),
                        const SizedBox(width: 12),
                      ],

                      // Main Play / Pause Button
                      Expanded(
                        child: FilledButton(
                          key: const ValueKey('play_pause_button'),
                          onPressed: () {
                            if (state.phase == WorkoutPhase.completed) {
                              _controller.reset();
                            } else if (state.isRunning && !state.isPaused) {
                              _controller.pause();
                            } else {
                              _controller.start();
                            }
                          },
                          style: FilledButton.styleFrom(
                            backgroundColor: state.isRunning && !state.isPaused
                                ? palette.surfaceElevated
                                : palette.actionPrimary,
                            foregroundColor: state.isRunning && !state.isPaused
                                ? palette.textPrimary
                                : palette.actionPrimaryText,
                            minimumSize: const Size(double.infinity, 56),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                              side: state.isRunning && !state.isPaused
                                  ? BorderSide(color: palette.border)
                                  : BorderSide.none,
                            ),
                          ),
                          child: Text(
                            state.phase == WorkoutPhase.completed
                                ? 'START NEW WORKOUT'
                                : (state.isRunning && !state.isPaused
                                    ? 'PAUSE'
                                    : (state.isPaused ? 'RESUME' : 'START WORKOUT')),
                            style: AppTypography.buttonText.copyWith(
                              letterSpacing: 1.5,
                              color: state.isRunning && !state.isPaused
                                  ? palette.textPrimary
                                  : palette.actionPrimaryText,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
