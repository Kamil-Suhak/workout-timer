class AppConstants {
  AppConstants._();

  static const String appTitle = 'Workout Timer';

  // Default workout durations as requested
  static const Duration defaultWorkDuration = Duration(minutes: 2);
  static const Duration defaultRestDuration = Duration(seconds: 15);
  static const Duration defaultPrepareDuration = Duration(seconds: 5);
  static const int defaultTotalSets = 8;

  // Duration adjustment bounds
  static const Duration minDuration = Duration(seconds: 5);
  static const Duration maxDuration = Duration(minutes: 60);
  static const Duration stepDuration = Duration(seconds: 5);

  // Sound cue countdown thresholds
  static const int countdownCueSeconds = 3;
}
