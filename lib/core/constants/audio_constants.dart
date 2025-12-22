/// Audio-related constants
class AudioConstants {
  AudioConstants._();

  // Audio generation
  static const int sampleRate = 44100;
  static const int wavHeaderSize = 44;
  static const int bytesPerSample = 2;
  static const int bitsPerSample = 16;
  static const int wavFileSizeOffset = 36;
  static const int maxSampleValue = 32767;
  static const int minSampleValue = -32768;
  static const double audioVolume = 0.5;
  static const double audioEnvelopeMax = 0.3;

  // Sound frequencies (Hz)
  static const double frequencyError = 200.0;
  static const double frequencyMove = 440.0;
  static const double frequencyWin1 = 523.0;
  static const double frequencyWin2 = 659.0;
  static const double frequencyWin3 = 784.0;
  static const double frequencyLose1 = 392.0;
  static const double frequencyLose2 = 330.0;
  static const double frequencyLose3 = 262.0;
  static const double frequencyDraw = 330.0;

  // Sound durations (milliseconds)
  static const int durationError = 50;
  static const int durationMove = 50;
  static const int durationWin1 = 100;
  static const int durationWin2 = 100;
  static const int durationWin3 = 200;
  static const int durationLose1 = 150;
  static const int durationLose2 = 150;
  static const int durationLose3 = 200;
  static const int durationDraw = 100;

  // Sound delays (milliseconds)
  static const int delayWinBetweenNotes = 80;
  static const int delayLoseBetweenNotes = 100;

  // Conversion
  static const double millisecondsToSeconds = 1000.0;
}





