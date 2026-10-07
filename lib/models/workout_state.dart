import 'workout_phase.dart';

class WorkoutState {
  final WorkoutPhase phase;
  final int currentSet;
  final Duration remainingDuration;
  final Duration phaseDuration;
  final Duration totalElapsed;
  final bool isRunning;
  final bool isPaused;

  const WorkoutState({
    required this.phase,
    required this.currentSet,
    required this.remainingDuration,
    required this.phaseDuration,
    required this.totalElapsed,
    required this.isRunning,
    required this.isPaused,
  });

  factory WorkoutState.initial({required Duration initialWorkDuration}) {
    return WorkoutState(
      phase: WorkoutPhase.idle,
      currentSet: 1,
      remainingDuration: initialWorkDuration,
      phaseDuration: initialWorkDuration,
      totalElapsed: Duration.zero,
      isRunning: false,
      isPaused: false,
    );
  }

  double get progress {
    if (phaseDuration.inMilliseconds == 0) return 0.0;
    final elapsed =
        phaseDuration.inMilliseconds - remainingDuration.inMilliseconds;
    return (elapsed / phaseDuration.inMilliseconds).clamp(0.0, 1.0);
  }

  WorkoutState copyWith({
    WorkoutPhase? phase,
    int? currentSet,
    Duration? remainingDuration,
    Duration? phaseDuration,
    Duration? totalElapsed,
    bool? isRunning,
    bool? isPaused,
  }) {
    return WorkoutState(
      phase: phase ?? this.phase,
      currentSet: currentSet ?? this.currentSet,
      remainingDuration: remainingDuration ?? this.remainingDuration,
      phaseDuration: phaseDuration ?? this.phaseDuration,
      totalElapsed: totalElapsed ?? this.totalElapsed,
      isRunning: isRunning ?? this.isRunning,
      isPaused: isPaused ?? this.isPaused,
    );
  }
}
