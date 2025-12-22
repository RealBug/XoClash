import 'package:flutter/services.dart';

class UsernameTextFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    if (newValue.text.isEmpty) {
      return newValue;
    }

    final String text = newValue.text;
    final List<String> words = text.split(' ');
    final String capitalizedWords = words.map((String word) {
      if (word.isEmpty) {
        return word;
      }
      return word[0].toUpperCase() + word.substring(1).toLowerCase();
    }).join(' ');

    return TextEditingValue(
      text: capitalizedWords,
      selection: TextSelection.collapsed(
        offset: capitalizedWords.length,
      ),
    );
  }
}


