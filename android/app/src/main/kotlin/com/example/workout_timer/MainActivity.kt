package com.example.workout_timer

import android.content.Context
import android.media.AudioAttributes
import android.os.Build
import android.os.VibrationEffect
import android.os.Vibrator
import android.os.VibratorManager
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {
    private val vibrationChannel = "com.example.workout_timer/vibration"

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, vibrationChannel)
            .setMethodCallHandler { call, result ->
                when (call.method) {
                    "vibrate" -> {
                        val duration = (call.argument<Number>("duration") ?: 100).toLong()
                        val amplitude = (call.argument<Number>("amplitude") ?: 255).toInt().coerceIn(1, 255)
                        vibrate(duration, amplitude)
                        result.success(null)
                    }
                    "vibratePattern" -> {
                        val timingsList = call.argument<List<Number>>("timings") ?: listOf(0, 100)
                        val amplitudesList = call.argument<List<Number>>("amplitudes")
                        val timings = timingsList.map { it.toLong() }.toLongArray()
                        val amplitudes = amplitudesList?.map { it.toInt().coerceIn(0, 255) }?.toIntArray()
                        vibratePattern(timings, amplitudes)
                        result.success(null)
                    }
                    "cancel" -> {
                        cancelVibration()
                        result.success(null)
                    }
                    else -> result.notImplemented()
                }
            }
    }

    private fun getVibrator(): Vibrator {
        return if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.S) {
            val vibratorManager = getSystemService(Context.VIBRATOR_MANAGER_SERVICE) as VibratorManager
            vibratorManager.defaultVibrator
        } else {
            @Suppress("DEPRECATION")
            getSystemService(Context.VIBRATOR_SERVICE) as Vibrator
        }
    }

    private fun getAlarmAudioAttributes(): AudioAttributes {
        return AudioAttributes.Builder()
            .setContentType(AudioAttributes.CONTENT_TYPE_SONIFICATION)
            .setUsage(AudioAttributes.USAGE_ALARM)
            .build()
    }

    private fun vibrate(durationMs: Long, amplitude: Int) {
        val vibrator = getVibrator()
        if (!vibrator.hasVibrator()) return

        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            val safeAmplitude = if (vibrator.hasAmplitudeControl()) {
                amplitude
            } else {
                VibrationEffect.DEFAULT_AMPLITUDE
            }
            val effect = VibrationEffect.createOneShot(durationMs, safeAmplitude)
            vibrator.vibrate(effect, getAlarmAudioAttributes())
        } else {
            @Suppress("DEPRECATION")
            vibrator.vibrate(durationMs)
        }
    }

    private fun vibratePattern(timings: LongArray, amplitudes: IntArray?) {
        val vibrator = getVibrator()
        if (!vibrator.hasVibrator()) return

        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            val effect = if (amplitudes != null && amplitudes.size == timings.size && vibrator.hasAmplitudeControl()) {
                VibrationEffect.createWaveform(timings, amplitudes, -1)
            } else {
                VibrationEffect.createWaveform(timings, -1)
            }
            vibrator.vibrate(effect, getAlarmAudioAttributes())
        } else {
            @Suppress("DEPRECATION")
            vibrator.vibrate(timings, -1)
        }
    }

    private fun cancelVibration() {
        val vibrator = getVibrator()
        vibrator.cancel()
    }
}
