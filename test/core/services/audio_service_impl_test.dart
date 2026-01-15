import 'package:audioplayers/audioplayers.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:tictac/core/services/audio_service_impl.dart';
import 'package:tictac/core/services/logger_service.dart';

class MockLoggerService extends Mock implements LoggerService {}

class MockAudioPlayer extends Mock implements AudioPlayer {}

class FakeSource extends Fake implements Source {}

void main() {
  setUpAll(() {
    TestWidgetsFlutterBinding.ensureInitialized();
    registerFallbackValue(FakeSource());
  });

  group('AudioServiceImpl', () {
    late MockLoggerService mockLogger;
    late MockAudioPlayer mockAudioPlayer;
    late AudioServiceImpl audioService;

    setUp(() {
      mockLogger = MockLoggerService();
      mockAudioPlayer = MockAudioPlayer();
      audioService = AudioServiceImpl(mockLogger, mockAudioPlayer);

      // Setup default stub for play method
      when(() => mockAudioPlayer.play(any(), volume: any(named: 'volume'))).thenAnswer((_) async {});
      when(() => mockAudioPlayer.dispose()).thenAnswer((_) async {});
    });

    group('setFxEnabled', () {
      test('should enable sound effects', () {
        audioService.setFxEnabled(true);
        // No exception means success - internal state changed
        expect(() => audioService.setFxEnabled(true), returnsNormally);
      });

      test('should disable sound effects', () {
        audioService.setFxEnabled(false);
        expect(() => audioService.setFxEnabled(false), returnsNormally);
      });
    });

    group('playMoveSound', () {
      test('should play move sound when fx enabled', () async {
        audioService.setFxEnabled(true);
        await audioService.playMoveSound();

        // Verify audio player was called
        verify(() => mockAudioPlayer.play(any(), volume: any(named: 'volume'))).called(1);
      });

      test('should not play sound when fx disabled', () async {
        audioService.setFxEnabled(false);
        await audioService.playMoveSound();

        // Verify audio player was not called
        verifyNever(() => mockAudioPlayer.play(any(), volume: any(named: 'volume')));
      });
    });

    group('playWinSound', () {
      test('should play win sound sequence when fx enabled', () async {
        audioService.setFxEnabled(true);
        await audioService.playWinSound();

        // Win sound plays 3 tones
        verify(() => mockAudioPlayer.play(any(), volume: any(named: 'volume'))).called(3);
      });

      test('should not play sound when fx disabled', () async {
        audioService.setFxEnabled(false);
        await audioService.playWinSound();

        verifyNever(() => mockAudioPlayer.play(any(), volume: any(named: 'volume')));
      });
    });

    group('playLoseSound', () {
      test('should play lose sound sequence when fx enabled', () async {
        audioService.setFxEnabled(true);
        await audioService.playLoseSound();

        // Lose sound plays 3 tones
        verify(() => mockAudioPlayer.play(any(), volume: any(named: 'volume'))).called(3);
      });

      test('should not play sound when fx disabled', () async {
        audioService.setFxEnabled(false);
        await audioService.playLoseSound();

        verifyNever(() => mockAudioPlayer.play(any(), volume: any(named: 'volume')));
      });
    });

    group('playDrawSound', () {
      test('should play draw sound when fx enabled', () async {
        audioService.setFxEnabled(true);
        await audioService.playDrawSound();

        verify(() => mockAudioPlayer.play(any(), volume: any(named: 'volume'))).called(1);
      });

      test('should not play sound when fx disabled', () async {
        audioService.setFxEnabled(false);
        await audioService.playDrawSound();

        verifyNever(() => mockAudioPlayer.play(any(), volume: any(named: 'volume')));
      });
    });

    group('playErrorSound', () {
      test('should play error sound when fx enabled', () async {
        audioService.setFxEnabled(true);
        await audioService.playErrorSound();

        verify(() => mockAudioPlayer.play(any(), volume: any(named: 'volume'))).called(1);
      });

      test('should not play sound when fx disabled', () async {
        audioService.setFxEnabled(false);
        await audioService.playErrorSound();

        verifyNever(() => mockAudioPlayer.play(any(), volume: any(named: 'volume')));
      });
    });

    group('error handling', () {
      test('should handle audio player errors gracefully', () async {
        when(() => mockAudioPlayer.play(any(), volume: any(named: 'volume'))).thenThrow(Exception('Audio error'));

        audioService.setFxEnabled(true);

        // Should not throw
        await expectLater(
          audioService.playMoveSound(),
          completes,
        );

        // Verify error was logged
        verify(() => mockLogger.error(
              'Failed to play audio tone',
              any(),
              any(),
            )).called(1);
      });
    });

    group('dispose', () {
      test('should dispose audio player', () {
        audioService.dispose();

        verify(() => mockAudioPlayer.dispose()).called(1);
      });
    });
  });
}
