import 'dart:io';
import 'dart:math' as math;
import 'dart:typed_data';

Uint8List generateWav({
  required int sampleRate,
  required double durationSeconds,
  required double Function(double t) sampleGenerator,
}) {
  final numSamples = (sampleRate * durationSeconds).round();
  final subChunk2Size = numSamples * 2; // 16-bit mono = 2 bytes per sample
  final chunkSize = 36 + subChunk2Size;

  final byteData = ByteData(44 + subChunk2Size);

  // RIFF Header
  byteData.setUint8(0, 0x52); // 'R'
  byteData.setUint8(1, 0x49); // 'I'
  byteData.setUint8(2, 0x46); // 'F'
  byteData.setUint8(3, 0x46); // 'F'
  byteData.setUint32(4, chunkSize, Endian.little);
  byteData.setUint8(8, 0x57);  // 'W'
  byteData.setUint8(9, 0x41);  // 'A'
  byteData.setUint8(10, 0x56); // 'V'
  byteData.setUint8(11, 0x45); // 'E'

  // fmt Subchunk
  byteData.setUint8(12, 0x66); // 'f'
  byteData.setUint8(13, 0x6D); // 'm'
  byteData.setUint8(14, 0x74); // 't'
  byteData.setUint8(15, 0x20); // ' '
  byteData.setUint32(16, 16, Endian.little); // Subchunk1Size (16 for PCM)
  byteData.setUint16(20, 1, Endian.little);  // AudioFormat (1 = PCM)
  byteData.setUint16(22, 1, Endian.little);  // NumChannels (1 = mono)
  byteData.setUint32(24, sampleRate, Endian.little); // SampleRate
  byteData.setUint32(28, sampleRate * 2, Endian.little); // ByteRate (SampleRate * 1 * 2)
  byteData.setUint16(32, 2, Endian.little);  // BlockAlign
  byteData.setUint16(34, 16, Endian.little); // BitsPerSample

  // data Subchunk
  byteData.setUint8(36, 0x64); // 'd'
  byteData.setUint8(37, 0x61); // 'a'
  byteData.setUint8(38, 0x74); // 't'
  byteData.setUint8(39, 0x61); // 'a'
  byteData.setUint32(40, subChunk2Size, Endian.little);

  // Sample data
  int offset = 44;
  for (int i = 0; i < numSamples; i++) {
    final t = i / sampleRate;
    final value = sampleGenerator(t).clamp(-1.0, 1.0);
    final pcm = (value * 32767).round().clamp(-32768, 32767);
    byteData.setInt16(offset, pcm, Endian.little);
    offset += 2;
  }

  return byteData.buffer.asUint8List();
}

void main() {
  const sampleRate = 44100;
  final dir = Directory('assets/audio');
  if (!dir.existsSync()) {
    dir.createSync(recursive: true);
  }

  // 1. Countdown Tick (880 Hz crisp athletic ping, 80ms)
  final tickWav = generateWav(
    sampleRate: sampleRate,
    durationSeconds: 0.08,
    sampleGenerator: (t) {
      final envelope = math.exp(-t * 40); // Fast decay
      return math.sin(2 * math.pi * 880 * t) * envelope;
    },
  );
  File('assets/audio/tick.wav').writeAsBytesSync(tickWav);

  // 2. Phase Change (Ascending chime: 587 Hz D5 -> 880 Hz A5, 250ms)
  final phaseWav = generateWav(
    sampleRate: sampleRate,
    durationSeconds: 0.25,
    sampleGenerator: (t) {
      final freq = t < 0.12 ? 587.33 : 880.0;
      final localT = t < 0.12 ? t : (t - 0.12);
      final envelope = math.exp(-localT * 12);
      return (math.sin(2 * math.pi * freq * t) + 0.3 * math.sin(2 * math.pi * freq * 2 * t)) * envelope;
    },
  );
  File('assets/audio/phase_change.wav').writeAsBytesSync(phaseWav);

  // 3. Complete (3-tone triumphant chord: 523 Hz -> 659 Hz -> 784 Hz, 500ms)
  final completeWav = generateWav(
    sampleRate: sampleRate,
    durationSeconds: 0.5,
    sampleGenerator: (t) {
      final freq = t < 0.15 ? 523.25 : (t < 0.30 ? 659.25 : 783.99);
      final localT = t < 0.15 ? t : (t < 0.30 ? t - 0.15 : t - 0.30);
      final envelope = math.exp(-localT * 8);
      return math.sin(2 * math.pi * freq * t) * envelope;
    },
  );
  File('assets/audio/complete.wav').writeAsBytesSync(completeWav);

}
