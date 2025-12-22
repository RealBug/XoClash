import 'package:flutter/services.dart';
import 'package:tictac/core/constants/app_constants.dart';

class GameIdTextFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    if (newValue.text.isEmpty) {
      return newValue;
    }

    final String text = newValue.text.toUpperCase();
    final String filteredText = text.split('').where((String char) {
      return AppConstants.gameIdChars.contains(char);
    }).join();

    final String limitedText = filteredText.length > AppConstants.gameIdLength
        ? filteredText.substring(0, AppConstants.gameIdLength)
        : filteredText;

    return TextEditingValue(
      text: limitedText,
      selection: TextSelection.collapsed(offset: limitedText.length),
    );
  }
}


