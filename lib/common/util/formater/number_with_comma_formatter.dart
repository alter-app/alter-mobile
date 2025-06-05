import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

class NumberWithCommaFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final text = newValue.text.replaceAll(RegExp(r'[^0-9]'), '');
    if (text.isEmpty) {
      return newValue.copyWith(text: '');
    }
    final number = int.tryParse(text);
    if (number == null) {
      return newValue.copyWith(text: '');
    }

    String formatted = '';
    final formatter = NumberFormat("#,###", "en_US");
    formatted = formatter.format(number);

    return newValue.copyWith(
      text: formatted,
      selection: TextSelection.collapsed(offset: formatted.length),
    );
  }
}
