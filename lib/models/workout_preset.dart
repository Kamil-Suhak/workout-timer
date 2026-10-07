import 'timer_settings.dart';

class WorkoutPreset {
  final String id;
  final String name;
  final String description;
  final TimerSettings settings;

  const WorkoutPreset({
    required this.id,
    required this.name,
    required this.description,
    required this.settings,
  });

  static const List<WorkoutPreset> defaultPresets = [
    WorkoutPreset(
      id: 'standard',
      name: 'Standard Interval',
      description: 'Default 2m work and 15s rest for classic pacing',
      settings: TimerSettings(
        workDuration: Duration(minutes: 2),
        restDuration: Duration(seconds: 15),
        prepareDuration: Duration(seconds: 5),
        totalSets: 8,
      ),
    ),
    WorkoutPreset(
      id: 'tabata',
      name: 'Tabata Protocol',
      description: 'High intensity 20s sprint with 10s micro-recovery',
      settings: TimerSettings(
        workDuration: Duration(seconds: 20),
        restDuration: Duration(seconds: 10),
        prepareDuration: Duration(seconds: 5),
        totalSets: 8,
      ),
    ),
    WorkoutPreset(
      id: 'boxing',
      name: 'Boxing Rounds',
      description: '3 minute championship rounds with 1 minute corner rest',
      settings: TimerSettings(
        workDuration: Duration(minutes: 3),
        restDuration: Duration(minutes: 1),
        prepareDuration: Duration(seconds: 5),
        totalSets: 5,
      ),
    ),
    WorkoutPreset(
      id: 'quick_hiit',
      name: 'Quick HIIT',
      description: '45s high output with 15s quick transitions',
      settings: TimerSettings(
        workDuration: Duration(seconds: 45),
        restDuration: Duration(seconds: 15),
        prepareDuration: Duration(seconds: 5),
        totalSets: 10,
      ),
    ),
  ];
}
