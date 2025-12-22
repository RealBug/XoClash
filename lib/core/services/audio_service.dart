abstract class AudioService {
  Future<void> playMoveSound();
  Future<void> playWinSound();
  Future<void> playLoseSound();
  Future<void> playDrawSound();
  Future<void> playErrorSound();
  void setFxEnabled(bool enabled);
  void dispose();
}
