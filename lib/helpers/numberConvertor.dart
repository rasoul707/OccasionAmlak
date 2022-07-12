import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

const standardNumber = [
  '.',
  '',
  '0',
  '1',
  '2',
  '3',
  '4',
  '5',
  '6',
  '7',
  '8',
  '9'
];
const noStandard = ['٫', '٬', '۰', '۱', '۲', '۳', '۴', '۵', '۶', '۷', '۸', '۹'];

String standardizeNumber(String input) {
  for (int i = 0; i < standardNumber.length; i++) {
    input = input.replaceAll(noStandard[i], standardNumber[i]);
  }
  for (int i = 0; i < input.length; i++) {
    if (!standardNumber.contains(input.substring(i, i + 1))) {
      input = input.replaceAll(input.substring(i, i + 1), '');
    }
  }

  return input;
}

String persianNumber(dynamic input) {
  final oCcy = NumberFormat("###.##", "fa_IR");
  return oCcy.format(input);
}

String priceFormat(dynamic input) {
  final oCcy = NumberFormat("#,###", "fa_IR");
  return oCcy.format(input);
}

class CurrencyInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    if (newValue.selection.baseOffset == 0) {
      return newValue;
    }

    final standard = standardizeNumber(newValue.text);
    double? value = double.tryParse(standard);
    final formatted = priceFormat(value);
    return newValue.copyWith(
        text: formatted,
        selection: TextSelection.collapsed(offset: formatted.length));
  }
}

class NumberInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    if (newValue.selection.baseOffset == 0) {
      return newValue;
    }

    final standard = standardizeNumber(newValue.text);
    if (standard == '') return newValue.copyWith(text: '');
    double? value = double.tryParse(standard);
    final formatted = persianNumber(value);

    return newValue.copyWith(
        text: formatted,
        selection: TextSelection.collapsed(offset: formatted.length));
  }
}
