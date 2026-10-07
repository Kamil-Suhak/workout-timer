import '../core/constants/app_constants.dart';

class TimerSettings {
  final Duration workDuration;
  final Duration restDuration;
  final Duration prepareDuration;
  final int totalSets;
  final bool soundEnabled;
  final bool vibrationEnabled;

  const TimerSettings({
    this.workDuration = AppConstants.defaultWorkDuration,
    this.restDuration = AppConstants.defaultRestDuration,
    this.prepareDuration = AppConstants.defaultPrepareDuration,
    this.totalSets = AppConstants.defaultTotalSets,
    this.soundEnabled = true,
    this.vibrationEnabled = true,
  });

  TimerSettings copyWith({
    Duration? workDuration,
    Duration? restDuration,
    Duration? prepareDuration,
    int? totalSets,
    bool? soundEnabled,
    bool? vibrationEnabled,
  }) {
    return TimerSettings(
      workDuration: workDuration ?? this.workDuration,
      restDuration: restDuration ?? this.restDuration,
      prepareDuration: prepareDuration ?? this.prepareDuration,
      totalSets: totalSets ?? this.totalSets,
      soundEnabled: soundEnabled ?? this.soundEnabled,
      vibrationEnabled: vibrationEnabled ?? this.vibrationEnabled,
    );
  }

  Duration get totalWorkoutDuration {
    final intervalDuration = (workDuration + restDuration) * totalSets;
    return prepareDuration + intervalDuration;
  }
}
