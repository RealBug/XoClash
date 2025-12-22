import 'dart:convert';
import 'dart:math';
import 'dart:typed_data';

import 'package:audioplayers/audioplayers.dart';
import 'package:injectable/injectable.dart';
import 'package:tictac/core/constants/audio_constants.dart';
import 'package:tictac/core/services/audio_service.dart';
import 'package:tictac/core/services/logger_service.dart';

@Injectable(as: AudioService)
class AudioServiceImpl implements AudioService {

  AudioServiceImpl(this._logger, [@factoryParam AudioPlayer? audioPlayer])
      : _fxPlayer = audioPlayer ?? AudioPlayer();
  final LoggerService _logger;
  final AudioPlayer _fxPlayer;
  bool _fxEnabled = true;

  @override
  void setFxEnabled(bool enabled) {
    _fxEnabled = enabled;
  }

  Future<void> _playTone(double frequency, int durationMs) async {
    if (!_fxEnabled) {
      return;
    }

    try {
      final wavBytes = _generateWav(frequency, durationMs);
      final base64 = base64Encode(wavBytes);
      final dataUrl = 'data:audio/wav;base64,$base64';
      await _fxPlayer.play(UrlSource(dataUrl),
          volume: AudioConstants.audioVolume);
    } catch (e, stackTrace) {
      _logger.error('Failed to play audio tone', e, stackTrace);
    }
  }

  Uint8List _generateWav(double frequency, int durationMs) {
    final duration = durationMs / AudioConstants.millisecondsToSeconds;
    final numSamples = (AudioConstants.sampleRate * duration).round();

    final samples = Float32List(numSamples);
    for (var i = 0; i < numSamples; i++) {
      final t = i / AudioConstants.sampleRate;
      final wave = sin(2 * pi * frequency * t);
      final envelope = 1.0 - (i / numSamples);
      samples[i] =
          (wave * envelope * AudioConstants.audioEnvelopeMax).clamp(-1.0, 1.0);
    }

    final wav = Uint8List(AudioConstants.wavHeaderSize +
        numSamples * AudioConstants.bytesPerSample);
    var offset = 0;

    wav[offset++] = 0x52;
    wav[offset++] = 0x49;
    wav[offset++] = 0x46;
    wav[offset++] = 0x46;

    final fileSize = AudioConstants.wavFileSizeOffset +
        numSamples * AudioConstants.bytesPerSample;
    wav[offset++] = fileSize & 0xFF;
    wav[offset++] = (fileSize >> 8) & 0xFF;
    wav[offset++] = (fileSize >> 16) & 0xFF;
    wav[offset++] = (fileSize >> 24) & 0xFF;

    wav[offset++] = 0x57;
    wav[offset++] = 0x41;
    wav[offset++] = 0x56;
    wav[offset++] = 0x45;

    wav[offset++] = 0x66;
    wav[offset++] = 0x6D;
    wav[offset++] = 0x74;
    wav[offset++] = 0x20;

    wav[offset++] = AudioConstants.bitsPerSample;
    wav[offset++] = 0;
    wav[offset++] = 0;
    wav[offset++] = 0;

    wav[offset++] = 1; // Audio format (PCM)
    wav[offset++] = 0;

    wav[offset++] = 1; // Number of channels (mono)
    wav[offset++] = 0;

    wav[offset++] = AudioConstants.sampleRate & 0xFF;
    wav[offset++] = (AudioConstants.sampleRate >> 8) & 0xFF;
    wav[offset++] = (AudioConstants.sampleRate >> 16) & 0xFF;
    wav[offset++] = (AudioConstants.sampleRate >> 24) & 0xFF;

    const int byteRate = AudioConstants.sampleRate * AudioConstants.bytesPerSample;
    wav[offset++] = byteRate & 0xFF;
    wav[offset++] = (byteRate >> 8) & 0xFF;
    wav[offset++] = (byteRate >> 16) & 0xFF;
    wav[offset++] = (byteRate >> 24) & 0xFF;

    wav[offset++] = AudioConstants.bytesPerSample; // Block align
    wav[offset++] = 0;

    wav[offset++] = AudioConstants.bitsPerSample;
    wav[offset++] = 0;

    wav[offset++] = 0x64;
    wav[offset++] = 0x61;
    wav[offset++] = 0x74;
    wav[offset++] = 0x61;

    final dataSize = numSamples * AudioConstants.bytesPerSample;
    wav[offset++] = dataSize & 0xFF;
    wav[offset++] = (dataSize >> 8) & 0xFF;
    wav[offset++] = (dataSize >> 16) & 0xFF;
    wav[offset++] = (dataSize >> 24) & 0xFF;

    for (var i = 0; i < numSamples; i++) {
      final sample = (samples[i] * AudioConstants.maxSampleValue)
          .round()
          .clamp(AudioConstants.minSampleValue, AudioConstants.maxSampleValue);
      wav[offset++] = sample & 0xFF;
      wav[offset++] = (sample >> 8) & 0xFF;
    }

    return wav;
  }

  @override
  Future<void> playMoveSound() async {
    if (!_fxEnabled) {
      return;
    }
    await _playTone(AudioConstants.frequencyMove, AudioConstants.durationMove);
  }

  @override
  Future<void> playWinSound() async {
    if (!_fxEnabled) {
      return;
    }
    await _playTone(AudioConstants.frequencyWin1, AudioConstants.durationWin1);
    await Future<void>.delayed(
        const Duration(milliseconds: AudioConstants.delayWinBetweenNotes));
    await _playTone(AudioConstants.frequencyWin2, AudioConstants.durationWin2);
    await Future<void>.delayed(
        const Duration(milliseconds: AudioConstants.delayWinBetweenNotes));
    await _playTone(AudioConstants.frequencyWin3, AudioConstants.durationWin3);
  }

  @override
  Future<void> playLoseSound() async {
    if (!_fxEnabled) {
      return;
    }
    await _playTone(
        AudioConstants.frequencyLose1, AudioConstants.durationLose1);
    await Future<void>.delayed(
        const Duration(milliseconds: AudioConstants.delayLoseBetweenNotes));
    await _playTone(
        AudioConstants.frequencyLose2, AudioConstants.durationLose2);
    await Future<void>.delayed(
        const Duration(milliseconds: AudioConstants.delayLoseBetweenNotes));
    await _playTone(
        AudioConstants.frequencyLose3, AudioConstants.durationLose3);
  }

  @override
  Future<void> playDrawSound() async {
    if (!_fxEnabled) {
      return;
    }
    await _playTone(AudioConstants.frequencyDraw, AudioConstants.durationDraw);
  }

  @override
  Future<void> playErrorSound() async {
    if (!_fxEnabled) {
      return;
    }
    await _playTone(
        AudioConstants.frequencyError, AudioConstants.durationError);
  }

  @override
  void dispose() {
    _fxPlayer.dispose();
  }
}
