import 'package:flutter/services.dart';
import 'package:audioplayers/audioplayers.dart';

abstract class AudioFeedbackService {
  Future<void> init();
  Future<void> playCountdownTick({bool sound = true, bool vibration = true});
  Future<void> playPhaseChange({bool sound = true, bool vibration = true});
  Future<void> playWorkoutComplete({bool sound = true, bool vibration = true});
  void dispose();
}

class DefaultAudioFeedbackService implements AudioFeedbackService {
  final AudioPlayer _player = AudioPlayer();
  bool _isInitialized = false;

  @override
  Future<void> init() async {
    if (_isInitialized) return;
    _isInitialized = true;
    try {
      await AudioPlayer.global.setAudioContext(
        AudioContext(
          android: const AudioContextAndroid(
            isSpeakerphoneOn: false,
            stayAwake: false,
            contentType: AndroidContentType.sonification,
            usageType: AndroidUsageType.assistanceSonification,
            audioFocus: AndroidAudioFocus.gainTransientMayDuck,
          ),
          iOS: AudioContextIOS(
            category: AVAudioSessionCategory.ambient,
            options: const {
              AVAudioSessionOptions.mixWithOthers,
              AVAudioSessionOptions.duckOthers,
            },
          ),
        ),
      );
    } catch (_) {
      // AudioContext configuration may not be supported on mock or desktop runners
    }
  }

  @override
  Future<void> playCountdownTick({
    bool sound = true,
    bool vibration = true,
  }) async {
    if (vibration) {
      await HapticFeedback.selectionClick();
    }
    if (sound) {
      try {
        await _player.stop();
        await _player.play(
          AssetSource('audio/tick.wav'),
          mode: PlayerMode.lowLatency,
        );
      } catch (_) {
        await SystemSound.play(SystemSoundType.click);
      }
    }
  }

  @override
  Future<void> playPhaseChange({
    bool sound = true,
    bool vibration = true,
  }) async {
    if (vibration) {
      await HapticFeedback.heavyImpact();
    }
    if (sound) {
      try {
        await _player.stop();
        await _player.play(
          AssetSource('audio/phase_change.wav'),
          mode: PlayerMode.lowLatency,
        );
      } catch (_) {
        await SystemSound.play(SystemSoundType.alert);
      }
    }
  }

  @override
  Future<void> playWorkoutComplete({
    bool sound = true,
    bool vibration = true,
  }) async {
    if (vibration) {
      await HapticFeedback.mediumImpact();
      await Future.delayed(const Duration(milliseconds: 120));
      await HapticFeedback.heavyImpact();
    }
    if (sound) {
      try {
        await _player.stop();
        await _player.play(
          AssetSource('audio/complete.wav'),
          mode: PlayerMode.lowLatency,
        );
      } catch (_) {
        await SystemSound.play(SystemSoundType.alert);
      }
    }
  }

  @override
  void dispose() {
    _player.dispose();
  }
}
