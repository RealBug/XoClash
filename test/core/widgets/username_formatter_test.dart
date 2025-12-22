import 'package:flutter_test/flutter_test.dart';
import 'package:tictac/core/widgets/formatters/username_formatter.dart';

void main() {
  group('UsernameTextFormatter', () {
    test('formatEditUpdate capitalizes first letter of each word', () {
      final UsernameTextFormatter formatter = UsernameTextFormatter();
      const TextEditingValue oldValue = TextEditingValue.empty;
      const TextEditingValue newValue = TextEditingValue(text: 'john doe');

      final TextEditingValue result = formatter.formatEditUpdate(oldValue, newValue);

      expect(result.text, 'John Doe');
      expect(result.selection.baseOffset, greaterThanOrEqualTo(0));
    });

    test('formatEditUpdate handles empty string', () {
      final UsernameTextFormatter formatter = UsernameTextFormatter();
      const TextEditingValue oldValue = TextEditingValue.empty;
      const TextEditingValue newValue = TextEditingValue.empty;

      final TextEditingValue result = formatter.formatEditUpdate(oldValue, newValue);

      expect(result.text, '');
      expect(result.selection.baseOffset, -1);
    });

    test('formatEditUpdate capitalizes single word', () {
      final UsernameTextFormatter formatter = UsernameTextFormatter();
      const TextEditingValue oldValue = TextEditingValue.empty;
      const TextEditingValue newValue = TextEditingValue(text: 'alice');

      final TextEditingValue result = formatter.formatEditUpdate(oldValue, newValue);

      expect(result.text, 'Alice');
    });

    test('formatEditUpdate handles multiple words', () {
      final UsernameTextFormatter formatter = UsernameTextFormatter();
      const TextEditingValue oldValue = TextEditingValue.empty;
      const TextEditingValue newValue = TextEditingValue(text: 'john paul smith');

      final TextEditingValue result = formatter.formatEditUpdate(oldValue, newValue);

      expect(result.text, 'John Paul Smith');
    });

    test('formatEditUpdate handles already capitalized text', () {
      final UsernameTextFormatter formatter = UsernameTextFormatter();
      const TextEditingValue oldValue = TextEditingValue(text: 'John');
      const TextEditingValue newValue = TextEditingValue(text: 'John Doe');

      final TextEditingValue result = formatter.formatEditUpdate(oldValue, newValue);

      expect(result.text, 'John Doe');
    });

    test('formatEditUpdate handles all uppercase text', () {
      final UsernameTextFormatter formatter = UsernameTextFormatter();
      const TextEditingValue oldValue = TextEditingValue.empty;
      const TextEditingValue newValue = TextEditingValue(text: 'JOHN DOE');

      final TextEditingValue result = formatter.formatEditUpdate(oldValue, newValue);

      expect(result.text, 'John Doe');
    });

    test('formatEditUpdate handles mixed case text', () {
      final UsernameTextFormatter formatter = UsernameTextFormatter();
      const TextEditingValue oldValue = TextEditingValue.empty;
      const TextEditingValue newValue = TextEditingValue(text: 'jOhN dOe');

      final TextEditingValue result = formatter.formatEditUpdate(oldValue, newValue);

      expect(result.text, 'John Doe');
    });

    test('formatEditUpdate handles single character', () {
      final UsernameTextFormatter formatter = UsernameTextFormatter();
      const TextEditingValue oldValue = TextEditingValue.empty;
      const TextEditingValue newValue = TextEditingValue(text: 'a');

      final TextEditingValue result = formatter.formatEditUpdate(oldValue, newValue);

      expect(result.text, 'A');
    });
  });
}
