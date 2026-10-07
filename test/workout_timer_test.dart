import 'package:flutter_test/flutter_test.dart';
import 'package:workout_timer/controllers/workout_timer_controller.dart';
import 'package:workout_timer/core/constants/app_constants.dart';
import 'package:workout_timer/models/timer_settings.dart';
import 'package:workout_timer/models/workout_phase.dart';
import 'package:workout_timer/services/audio_feedback_service.dart';

import 'package:workout_timer/services/wakelock_service.dart';

class MockAudioFeedbackService implements AudioFeedbackService {
  int phaseChangeCalls = 0;
  int countdownTickCalls = 0;
  int completedCalls = 0;

  @override
  Future<void> init() async {}

  @override
  Future<void> playCountdownTick({bool sound = true, bool vibration = true}) async {
    countdownTickCalls++;
  }

  @override
  Future<void> playPhaseChange({bool sound = true, bool vibration = true}) async {
    phaseChangeCalls++;
  }

  @override
  Future<void> playWorkoutComplete({bool sound = true, bool vibration = true}) async {
    completedCalls++;
  }

  @override
  void dispose() {}
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('TimerSettings', () {
    test('default settings have 2m work and 15s rest', () {
      const settings = TimerSettings();
      expect(settings.workDuration, const Duration(minutes: 2));
      expect(settings.restDuration, const Duration(seconds: 15));
      expect(settings.prepareDuration, const Duration(seconds: 5));
      expect(settings.totalSets, AppConstants.defaultTotalSets);
    });

    test('copyWith updates specified fields', () {
      const settings = TimerSettings();
      final updated = settings.copyWith(
        workDuration: const Duration(minutes: 3),
        restDuration: const Duration(seconds: 30),
      );
      expect(updated.workDuration, const Duration(minutes: 3));
      expect(updated.restDuration, const Duration(seconds: 30));
      expect(updated.totalSets, settings.totalSets);
    });
  });

  group('WorkoutTimerController', () {
    late MockAudioFeedbackService mockAudio;
    late NoopWakelockService mockWakelock;
    late WorkoutTimerController controller;

    setUp(() {
      mockAudio = MockAudioFeedbackService();
      mockWakelock = NoopWakelockService();
      controller = WorkoutTimerController(
        audioService: mockAudio,
        wakelockService: mockWakelock,
      );
    });

    tearDown(() {
      controller.dispose();
    });

    test('initializes with idle phase and 2 minute work remaining', () {
      expect(controller.state.phase, WorkoutPhase.idle);
      expect(controller.state.remainingDuration, const Duration(minutes: 2));
      expect(controller.state.currentSet, 1);
      expect(controller.state.isRunning, false);
    });

    test('adjustWorkDuration modifies work duration and updates idle remaining', () {
      controller.adjustWorkDuration(const Duration(seconds: 30));
      expect(controller.settings.workDuration, const Duration(minutes: 2, seconds: 30));
      expect(controller.state.remainingDuration, const Duration(minutes: 2, seconds: 30));

      controller.adjustWorkDuration(const Duration(seconds: -45));
      expect(controller.settings.workDuration, const Duration(minutes: 1, seconds: 45));
      expect(controller.state.remainingDuration, const Duration(minutes: 1, seconds: 45));
    });

    test('adjustRestDuration modifies rest duration', () {
      controller.adjustRestDuration(const Duration(seconds: 10));
      expect(controller.settings.restDuration, const Duration(seconds: 25));

      controller.adjustRestDuration(const Duration(seconds: -15));
      expect(controller.settings.restDuration, const Duration(seconds: 10));
    });

    test('start transitions to prepare phase when prepare duration is set', () {
      controller.start();
      expect(controller.state.phase, WorkoutPhase.prepare);
      expect(controller.state.remainingDuration, const Duration(seconds: 5));
      expect(controller.state.isRunning, true);
      expect(mockAudio.phaseChangeCalls, 1);
    });

    test('start transitions directly to work phase when prepare is zero', () {
      controller.setPrepareDuration(Duration.zero);
      controller.start();
      expect(controller.state.phase, WorkoutPhase.work);
      expect(controller.state.remainingDuration, const Duration(minutes: 2));
      expect(controller.state.isRunning, true);
      expect(controller.state.isPaused, false);
      expect(mockAudio.phaseChangeCalls, 1);
    });

    test('pause stops the running state', () {
      controller.start();
      controller.pause();
      expect(controller.state.isPaused, true);
    });

    test('reset restores initial state', () {
      controller.start();
      controller.reset();
      expect(controller.state.phase, WorkoutPhase.idle);
      expect(controller.state.isRunning, false);
      expect(controller.state.remainingDuration, const Duration(minutes: 2));
    });
  });
}
