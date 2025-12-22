import 'package:flutter_test/flutter_test.dart';
import 'package:tictac/core/constants/app_constants.dart';
import 'package:tictac/core/widgets/formatters/game_id_formatter.dart';

void main() {
  group('GameIdTextFormatter', () {
    test('formatEditUpdate converts to uppercase', () {
      final GameIdTextFormatter formatter = GameIdTextFormatter();
      const TextEditingValue oldValue = TextEditingValue.empty;
      const TextEditingValue newValue = TextEditingValue(text: 'abc234');

      final TextEditingValue result = formatter.formatEditUpdate(oldValue, newValue);

      expect(result.text, 'ABC234');
    });

    test('formatEditUpdate filters invalid characters', () {
      final GameIdTextFormatter formatter = GameIdTextFormatter();
      const TextEditingValue oldValue = TextEditingValue.empty;
      const TextEditingValue newValue = TextEditingValue(text: 'ABC1I0XYZ');

      final TextEditingValue result = formatter.formatEditUpdate(oldValue, newValue);

      expect(result.text.length, lessThanOrEqualTo(AppConstants.gameIdLength));
      expect(result.text.split('').every((String char) => AppConstants.gameIdChars.contains(char)), isTrue);
      expect(result.text.contains('I'), isFalse);
      expect(result.text.contains('0'), isFalse);
      expect(result.text.contains('1'), isFalse);
      expect(result.text, 'ABCXYZ');
    });

    test('formatEditUpdate limits to gameIdLength', () {
      final GameIdTextFormatter formatter = GameIdTextFormatter();
      const TextEditingValue oldValue = TextEditingValue.empty;
      final String longText = AppConstants.gameIdChars.substring(0, AppConstants.gameIdLength + 5);
      final TextEditingValue newValue = TextEditingValue(text: longText);

      final TextEditingValue result = formatter.formatEditUpdate(oldValue, newValue);

      expect(result.text.length, AppConstants.gameIdLength);
    });

    test('formatEditUpdate handles empty string', () {
      final GameIdTextFormatter formatter = GameIdTextFormatter();
      const TextEditingValue oldValue = TextEditingValue.empty;
      const TextEditingValue newValue = TextEditingValue.empty;

      final TextEditingValue result = formatter.formatEditUpdate(oldValue, newValue);

      expect(result.text, isEmpty);
    });

    test('formatEditUpdate filters out invalid lowercase letters', () {
      final GameIdTextFormatter formatter = GameIdTextFormatter();
      const TextEditingValue oldValue = TextEditingValue.empty;
      const TextEditingValue newValue = TextEditingValue(text: 'abcdefghijklmnopqrstuvwxyz');

      final TextEditingValue result = formatter.formatEditUpdate(oldValue, newValue);

      const String validChars = 'ABCDEFGHJKLMNPQRSTUVWXYZ';
      final String expectedText = newValue.text.toUpperCase().split('').where((String char) => validChars.contains(char)).join();
      final String expectedLimited =
          expectedText.length > AppConstants.gameIdLength ? expectedText.substring(0, AppConstants.gameIdLength) : expectedText;
      expect(result.text, expectedLimited);
      expect(result.text.split('').every((String char) => AppConstants.gameIdChars.contains(char)), isTrue);
      expect(result.text.length, lessThanOrEqualTo(AppConstants.gameIdLength));
    });

    test('formatEditUpdate preserves valid characters only', () {
      final GameIdTextFormatter formatter = GameIdTextFormatter();
      const TextEditingValue oldValue = TextEditingValue.empty;
      const TextEditingValue newValue = TextEditingValue(text: 'ABCD23456789');

      final TextEditingValue result = formatter.formatEditUpdate(oldValue, newValue);

      expect(result.text.split('').every((String char) => AppConstants.gameIdChars.contains(char)), isTrue);
    });
  });
}
