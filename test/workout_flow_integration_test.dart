import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:workout_timer/controllers/workout_timer_controller.dart';
import 'package:workout_timer/core/theme/app_theme_type.dart';
import 'package:workout_timer/main.dart';
import 'package:workout_timer/models/workout_phase.dart';
import 'package:workout_timer/services/audio_feedback_service.dart';
import 'package:workout_timer/services/wakelock_service.dart';

class TestAudioFeedbackService implements AudioFeedbackService {
  int phaseChanges = 0;
  int countdownTicks = 0;
  int completions = 0;

  @override
  Future<void> init() async {}

  @override
  Future<void> playCountdownTick({
    bool sound = true,
    bool vibration = true,
  }) async {
    countdownTicks++;
  }

  @override
  Future<void> playPhaseChange({
    bool sound = true,
    bool vibration = true,
  }) async {
    phaseChanges++;
  }

  @override
  Future<void> playWorkoutComplete({
    bool sound = true,
    bool vibration = true,
  }) async {
    completions++;
  }

  @override
  void dispose() {}
}

void main() {
  testWidgets('Complete workout lifecycle integration test', (
    WidgetTester tester,
  ) async {
    final mockAudio = TestAudioFeedbackService();
    final mockWakelock = NoopWakelockService();
    final controller = WorkoutTimerController(
      audioService: mockAudio,
      wakelockService: mockWakelock,
    );

    // 1. Launch App
    await tester.pumpWidget(WorkoutTimerApp(controller: controller));
    await tester.pumpAndSettle();

    // 2. Initial state verification
    expect(find.text('SET 1 / 8'), findsOneWidget);
    expect(find.text('READY'), findsWidgets);
    expect(find.text('02:00'), findsWidgets);
    expect(find.text('00:15'), findsOneWidget);
    expect(find.text('START WORKOUT'), findsOneWidget);

    // 3. Open Settings Sheet
    final settingsButton = find.byKey(const ValueKey('settings_button'));
    expect(settingsButton, findsOneWidget);
    await tester.tap(settingsButton);
    await tester.pumpAndSettle();

    // Verify settings sheet opened
    expect(find.text('WORKOUT SETTINGS'), findsOneWidget);
    expect(find.text('Total Sets'), findsOneWidget);

    // Test Theme Selector: switch to Pastel Rose and back
    expect(find.byKey(const ValueKey('theme_pastel_rose')), findsOneWidget);
    await tester.tap(find.byKey(const ValueKey('theme_pastel_rose')));
    await tester.pumpAndSettle();
    expect(controller.themeType, AppThemeType.pastelRose);

    await tester.tap(find.byKey(const ValueKey('theme_carbon')));
    await tester.pumpAndSettle();
    expect(controller.themeType, AppThemeType.carbon);

    // 4. Test manual adjustment of Total Sets in Settings Sheet
    final addSetButton = find.descendant(
      of: find.byType(BottomSheet),
      matching: find.byIcon(Icons.add),
    );
    await tester.tap(addSetButton);
    await tester.pumpAndSettle();
    expect(controller.settings.totalSets, 9);

    // Close settings sheet
    await tester.tap(find.byIcon(Icons.close));
    await tester.pumpAndSettle();

    // 5. Verify timer display on home screen
    expect(find.text('02:00'), findsWidgets);
    expect(find.text('00:15'), findsOneWidget);

    // 6. Test +/- interval adjustment on home screen
    final exerciseAddButton = find.byIcon(Icons.add).first;
    await tester.tap(exerciseAddButton);
    await tester.pumpAndSettle();
    expect(find.text('02:15'), findsWidgets); // 2m + 15s = 2m 15s

    // 7. Start workout
    final playPauseButton = find.byKey(const ValueKey('play_pause_button'));
    await tester.tap(playPauseButton);
    await tester.pumpAndSettle();

    // Should transition into prepare phase (default 5s prepare)
    expect(controller.state.isRunning, true);
    expect(controller.state.phase, WorkoutPhase.prepare);
    expect(find.text('PAUSE'), findsOneWidget);
    expect(find.byKey(const ValueKey('skip_button')), findsOneWidget);
    expect(mockAudio.phaseChanges, 1);

    // 8. Test Pause
    await tester.tap(playPauseButton);
    await tester.pumpAndSettle();
    expect(controller.state.isPaused, true);
    expect(find.text('RESUME'), findsOneWidget);

    // 9. Test Resume
    await tester.tap(playPauseButton);
    await tester.pumpAndSettle();
    expect(controller.state.isPaused, false);
    expect(find.text('PAUSE'), findsOneWidget);

    // 10. Test Skip Phase
    final skipButton = find.byKey(const ValueKey('skip_button'));
    await tester.tap(skipButton);
    await tester.pumpAndSettle();
    // Prepare skips to Work Set 1
    expect(controller.state.phase, WorkoutPhase.work);
    expect(mockAudio.phaseChanges, 2);

    await tester.tap(skipButton);
    await tester.pumpAndSettle();
    // Work skips to Rest Set 1
    expect(controller.state.phase, WorkoutPhase.rest);
    expect(mockAudio.phaseChanges, 3);

    // 11. Test Reset
    final resetButton = find.byKey(const ValueKey('reset_button'));
    expect(resetButton, findsOneWidget);
    await tester.tap(resetButton);
    await tester.pumpAndSettle();

    expect(controller.state.isRunning, false);
    expect(controller.state.phase, WorkoutPhase.idle);
    expect(find.text('START WORKOUT'), findsOneWidget);
  });
}
