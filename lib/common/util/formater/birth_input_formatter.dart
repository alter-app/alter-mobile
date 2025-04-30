import 'package:flutter/services.dart';

class BirthDayFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final text = newValue.text.replaceAll(RegExp(r'[^0-9]'), ''); // 숫자만 추출
    if (text.isEmpty) {
      return newValue.copyWith(text: '');
    }

    String formatted = '';
    if (text.length <= 4) {
      formatted = text; // YYYY
    } else if (text.length <= 6) {
      formatted = '${text.substring(0, 4)}-${text.substring(4)}'; // YYYY-MM
    } else {
      formatted =
          '${text.substring(0, 4)}-${text.substring(4, 6)}-${text.substring(6, text.length.clamp(6, 8))}'; // YYYY-MM-DD
    }

    return newValue.copyWith(
      text: formatted,
      selection: TextSelection.collapsed(offset: formatted.length),
    );
  }
}
