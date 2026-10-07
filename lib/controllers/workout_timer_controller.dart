import 'dart:async';
import 'package:flutter/foundation.dart';
import '../core/theme/app_theme_type.dart';
import '../models/timer_settings.dart';
import '../models/workout_phase.dart';
import '../models/workout_preset.dart';
import '../models/workout_state.dart';
import '../services/audio_feedback_service.dart';
import '../services/wakelock_service.dart';

class WorkoutTimerController extends ChangeNotifier {
  TimerSettings _settings;
  WorkoutState _state;
  final AudioFeedbackService _audioService;
  final WakelockService _wakelockService;
  AppThemeType _themeType;
  Timer? _ticker;
  DateTime? _phaseTargetTimestamp;
  int _lastPlayedCountdownSecond = -1;

  WorkoutTimerController({
    TimerSettings? settings,
    AudioFeedbackService? audioService,
    WakelockService? wakelockService,
    AppThemeType? initialTheme,
  })  : _settings = settings ?? const TimerSettings(),
        _audioService = audioService ?? DefaultAudioFeedbackService(),
        _wakelockService = wakelockService ?? DefaultWakelockService(),
        _themeType = initialTheme ?? AppThemeType.carbon,
        _state = WorkoutState.initial(
          initialWorkDuration: (settings ?? const TimerSettings()).workDuration,
        );

  TimerSettings get settings => _settings;
  WorkoutState get state => _state;
  AppThemeType get themeType => _themeType;

  void setTheme(AppThemeType type) {
    if (_themeType == type) return;
    _themeType = type;
    notifyListeners();
  }

  void updateSettings(TimerSettings newSettings) {
    if (_state.isRunning) return;
    _settings = newSettings;
    if (_state.phase == WorkoutPhase.idle) {
      _state = WorkoutState.initial(initialWorkDuration: _settings.workDuration);
    }
    notifyListeners();
  }

  void applyPreset(WorkoutPreset preset) {
    if (_state.isRunning) return;
    updateSettings(preset.settings);
  }

  void toggleSound() {
    _settings = _settings.copyWith(soundEnabled: !_settings.soundEnabled);
    notifyListeners();
  }

  void toggleVibration() {
    _settings = _settings.copyWith(vibrationEnabled: !_settings.vibrationEnabled);
    notifyListeners();
  }

  void adjustWorkDuration(Duration delta) {
    if (_state.isRunning) return;
    final newDuration = _settings.workDuration + delta;
    if (newDuration < const Duration(seconds: 5) || newDuration > const Duration(minutes: 60)) {
      return;
    }
    _settings = _settings.copyWith(workDuration: newDuration);
    if (_state.phase == WorkoutPhase.idle) {
      _state = _state.copyWith(
        remainingDuration: newDuration,
        phaseDuration: newDuration,
      );
    }
    notifyListeners();
  }

  void adjustRestDuration(Duration delta) {
    if (_state.isRunning) return;
    final newDuration = _settings.restDuration + delta;
    if (newDuration < const Duration(seconds: 5) || newDuration > const Duration(minutes: 60)) {
      return;
    }
    _settings = _settings.copyWith(restDuration: newDuration);
    notifyListeners();
  }

  void adjustTotalSets(int delta) {
    if (_state.isRunning) return;
    final newSets = (_settings.totalSets + delta).clamp(1, 99);
    _settings = _settings.copyWith(totalSets: newSets);
    notifyListeners();
  }

  void setPrepareDuration(Duration duration) {
    if (_state.isRunning) return;
    _settings = _settings.copyWith(prepareDuration: duration);
    notifyListeners();
  }

  void start() {
    if (_state.isRunning && !_state.isPaused) return;

    _acquireWakelock();

    if (_state.phase == WorkoutPhase.idle) {
      if (_settings.prepareDuration > Duration.zero) {
        _state = _state.copyWith(
          phase: WorkoutPhase.prepare,
          currentSet: 1,
          remainingDuration: _settings.prepareDuration,
          phaseDuration: _settings.prepareDuration,
          isRunning: true,
          isPaused: false,
        );
        _audioService.playPhaseChange(
          sound: _settings.soundEnabled,
          vibration: _settings.vibrationEnabled,
        );
      } else {
        _state = _state.copyWith(
          phase: WorkoutPhase.work,
          currentSet: 1,
          remainingDuration: _settings.workDuration,
          phaseDuration: _settings.workDuration,
          isRunning: true,
          isPaused: false,
        );
        _audioService.playPhaseChange(
          sound: _settings.soundEnabled,
          vibration: _settings.vibrationEnabled,
        );
      }
    } else {
      _state = _state.copyWith(isRunning: true, isPaused: false);
    }

    _lastPlayedCountdownSecond = -1;
    _phaseTargetTimestamp = DateTime.now().add(_state.remainingDuration);
    _startTicker();
    notifyListeners();
  }

  void pause() {
    if (!_state.isRunning || _state.isPaused) return;
    _ticker?.cancel();
    _releaseWakelock();

    if (_phaseTargetTimestamp != null) {
      final remaining = _phaseTargetTimestamp!.difference(DateTime.now());
      _state = _state.copyWith(
        remainingDuration: remaining > Duration.zero ? remaining : Duration.zero,
        isPaused: true,
      );
    } else {
      _state = _state.copyWith(isPaused: true);
    }

    notifyListeners();
  }

  void reset() {
    _ticker?.cancel();
    _releaseWakelock();
    _phaseTargetTimestamp = null;
    _lastPlayedCountdownSecond = -1;
    _state = WorkoutState.initial(initialWorkDuration: _settings.workDuration);
    notifyListeners();
  }

  void skipToNextPhase() {
    if (!_state.isRunning) return;
    _transitionToNextPhase();
  }

  void syncWithWallClock() {
    if (!_state.isRunning || _state.isPaused || _phaseTargetTimestamp == null) return;
    _evaluateTick();
  }

  void _startTicker() {
    _ticker?.cancel();
    _ticker = Timer.periodic(const Duration(milliseconds: 250), (_) {
      _evaluateTick();
    });
  }

  void _evaluateTick() {
    if (_phaseTargetTimestamp == null) return;
    final now = DateTime.now();
    final difference = _phaseTargetTimestamp!.difference(now);

    if (difference <= Duration.zero) {
      _transitionToNextPhase();
    } else {
      final secondsLeft = difference.inSeconds;
      if (secondsLeft <= 3 && secondsLeft > 0 && secondsLeft != _lastPlayedCountdownSecond) {
        _lastPlayedCountdownSecond = secondsLeft;
        _audioService.playCountdownTick(
          sound: _settings.soundEnabled,
          vibration: _settings.vibrationEnabled,
        );
      }

      _state = _state.copyWith(
        remainingDuration: difference,
        totalElapsed: _state.totalElapsed + const Duration(milliseconds: 250),
      );
      notifyListeners();
    }
  }

  void _transitionToNextPhase() {
    _lastPlayedCountdownSecond = -1;

    if (_state.phase == WorkoutPhase.prepare) {
      // Prepare -> Work Set 1
      _state = _state.copyWith(
        phase: WorkoutPhase.work,
        remainingDuration: _settings.workDuration,
        phaseDuration: _settings.workDuration,
      );
      _phaseTargetTimestamp = DateTime.now().add(_settings.workDuration);
      _audioService.playPhaseChange(
        sound: _settings.soundEnabled,
        vibration: _settings.vibrationEnabled,
      );
    } else if (_state.phase == WorkoutPhase.work) {
      // Work -> Rest (or Finished if last set and no rest needed)
      if (_state.currentSet >= _settings.totalSets && _settings.restDuration == Duration.zero) {
        _completeWorkout();
        return;
      }

      _state = _state.copyWith(
        phase: WorkoutPhase.rest,
        remainingDuration: _settings.restDuration,
        phaseDuration: _settings.restDuration,
      );
      _phaseTargetTimestamp = DateTime.now().add(_settings.restDuration);
      _audioService.playPhaseChange(
        sound: _settings.soundEnabled,
        vibration: _settings.vibrationEnabled,
      );
    } else if (_state.phase == WorkoutPhase.rest) {
      // Rest -> Next Work Set OR Finished
      if (_state.currentSet >= _settings.totalSets) {
        _completeWorkout();
      } else {
        _state = _state.copyWith(
          phase: WorkoutPhase.work,
          currentSet: _state.currentSet + 1,
          remainingDuration: _settings.workDuration,
          phaseDuration: _settings.workDuration,
        );
        _phaseTargetTimestamp = DateTime.now().add(_settings.workDuration);
        _audioService.playPhaseChange(
          sound: _settings.soundEnabled,
          vibration: _settings.vibrationEnabled,
        );
      }
    }

    notifyListeners();
  }

  void _completeWorkout() {
    _ticker?.cancel();
    _releaseWakelock();
    _phaseTargetTimestamp = null;
    _state = _state.copyWith(
      phase: WorkoutPhase.completed,
      remainingDuration: Duration.zero,
      isRunning: false,
      isPaused: false,
    );
    _audioService.playWorkoutComplete(
      sound: _settings.soundEnabled,
      vibration: _settings.vibrationEnabled,
    );
  }

  void _acquireWakelock() {
    _wakelockService.enable();
  }

  void _releaseWakelock() {
    _wakelockService.disable();
  }

  @override
  void dispose() {
    _ticker?.cancel();
    _releaseWakelock();
    _audioService.dispose();
    super.dispose();
  }
}
