library date_input_formatter;

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart' show TextField;
import 'dart:math';

// ignore: constant_identifier_names
const INDEX_NOT_FOUND = -1;

///
/// An implementation of [TextInputFormatter] provides a way to input date form
/// with [TextField], such as dd/MM/yyyy. In order to guide user about input form,
/// the formatter will provide [TextField] a placeholder --/--/---- as soon as
/// user start editing. During editing session, the formatter will replace appropriate
/// placeholder characters by user's input.
///
class DateInputFormatter extends TextInputFormatter {
  final String _placeholder = '--/--/----';
  TextEditingValue? _lastNewValue;

  /// Taking minYear and maxYear as parameters from the developer
  final String minYear;
  final String maxYear;

  DateInputFormatter({this.minYear = "1800", this.maxYear = "2200"});

  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    /// provides placeholder text when user start editing

    if (oldValue.text.isEmpty) {
      oldValue = oldValue.copyWith(
        text: _placeholder,
      );
      newValue = newValue.copyWith(
        text: _fillInputToPlaceholder(newValue.text),
      );
      return newValue;
    }

    /// nothing changes, nothing to do
    if (newValue == _lastNewValue) {
      return oldValue;
    }
    _lastNewValue = newValue;

    int offset = newValue.selection.baseOffset;

    /// restrict user's input within the length of date form
    if (offset > 10) {
      return oldValue;
    }

    if (oldValue.text == newValue.text && oldValue.text.isNotEmpty) {
      return newValue;
    }

    final String oldText = oldValue.text;
    final String newText = newValue.text;

    String? resultText;

    /// handle user editing, there're two cases:
    /// 1. user add new digit: replace '-' at cursor's position by user's input.
    /// 2. user delete digit: replace digit at cursor's position by '-'
    int index = _indexOfDifference(newText, oldText);
    if (oldText.length < newText.length) {
      String newChar = newText[index];
      //print("newChar: $newChar --- index: $index");

      // -./../.... below in each conditional statement checking every index of the date
      if (index == 0) {
        if (int.tryParse(newText[0])! > 3) {
          newChar = "3";
        } else {
          newChar = newText[index];
        }
        // .-/../....
      } else if (index == 1) {
        if (int.tryParse(newText[0])! == 0 && int.tryParse(newText[1])! == 0) {
          newChar = "1";
        } else if (int.tryParse(newText[0])! > 2 &&
            (int.tryParse(newText[1])! > 1 || int.tryParse(newText[1])! == 1)) {
          newChar = "1";
        } else {
          newChar = newText[index];
        }
        // ../-./....
      } else if (index == 3) {
        if (int.tryParse(newText[3])! > 1 || int.tryParse(newText[3])! == 1) {
          newChar = "1";
        } else {
          newChar = newText[index];
        }
        // ../.-/....
      } else if (index == 4) {
        if (int.tryParse(newText[3])! == 0 && int.tryParse(newText[4])! == 0) {
          newChar = "1";
        } else if ((int.tryParse(newText[3])! > 1 ||
                int.tryParse(newText[3])! == 1) &&
            (int.tryParse(newText[4])! > 2 || int.tryParse(newText[4])! == 2)) {
          newChar = "2";
        } else {
          newChar = newText[index];
        }
        // ../../-...
      } else if (index == 6) {
        if (int.tryParse(newText[6])! < int.tryParse(minYear[0])!) {
          newChar = minYear[0];
        } else if (int.tryParse(newText[6])! > int.tryParse(maxYear[0])!) {
          newChar = maxYear[0];
        } else {
          newChar = newText[index];
        }
        // ../../.-..
      } else if (index == 7) {
        if (int.tryParse(newText[6])! == int.tryParse(minYear[0])!) {
          if (int.tryParse(newText[7])! < int.tryParse(minYear[1])!) {
            newChar = minYear[1];
          } else if (int.tryParse(newText[7])! > int.tryParse(maxYear[1])!) {
            if (int.tryParse(newText[6])! < int.tryParse(maxYear[1])!) {
              newChar = newText[index];
            } else {
              newChar = maxYear[1];
            }
          } else {
            newChar = newText[index];
          }
        } else if (int.tryParse(newText[6])! == int.tryParse(maxYear[0])!) {
          if (int.tryParse(newText[7])! > int.tryParse(maxYear[1])!) {
            newChar = maxYear[1];
          } else {
            newChar = newText[index];
          }
        } else {
          newChar = newText[index];
        }
        // ../../..-.
      } else if (index == 8) {
        String newTextFirstTwo = newText.substring(6, 8);
        String minYearFirstTwo = minYear.substring(0, 2);
        String maxYearFirstTwo = maxYear.substring(0, 2);

        int newTextFirstTwoInt = int.tryParse(newTextFirstTwo)!;
        int minYearFirstTwoInt = int.tryParse(minYearFirstTwo)!;
        int maxYearFirstTwoInt = int.tryParse(maxYearFirstTwo)!;

        if (newTextFirstTwoInt == minYearFirstTwoInt &&
            int.tryParse(newText[8])! < int.tryParse(minYear[2])!) {
          newChar = minYear[2];
        } else if (newTextFirstTwoInt == maxYearFirstTwoInt &&
            int.tryParse(newText[8])! > int.tryParse(maxYear[2])!) {
          newChar = maxYear[2];
        } else {
          newChar = newText[index];
        }
        // ../../...-
      } else if (index == 9) {
        String newTextFirstThree = newText.substring(6, 9);
        String minYearFirstThree = minYear.substring(0, 3);
        String maxYearFirstThree = maxYear.substring(0, 3);

        int newTextFirstThreeInt = int.tryParse(newTextFirstThree)!;
        int minYearFirstThreeInt = int.tryParse(minYearFirstThree)!;
        int maxYearFirstThreeInt = int.tryParse(maxYearFirstThree)!;

        if (newTextFirstThreeInt == minYearFirstThreeInt &&
            int.tryParse(newText[9])! < int.tryParse(minYear[3])!) {
          newChar = minYear[3];
        } else if (newTextFirstThreeInt == maxYearFirstThreeInt &&
            int.tryParse(newText[9])! > int.tryParse(maxYear[3])!) {
          newChar = maxYear[3];
        } else {
          newChar = newText[index];
        }
      }

      if (index == 2 || index == 5) {
        index++;
        offset++;
      }
      resultText = oldText.replaceRange(index, index + 1, newChar);
      if (offset == 2 || offset == 5) {
        offset++;
      }
    } else if (oldText.length > newText.length) {
      /// delete digit
      if (oldText[index] != '/') {
        resultText = oldText.replaceRange(index, index + 1, '-');
        if (offset == 3 || offset == 6) {
          offset--;
        }
      } else {
        resultText = oldText;
      }
    }

    /// verify the number and position of splash character
    final splashes = resultText!.replaceAll(RegExp(r'[^/]'), '');
    int count = splashes.length;
    if (resultText.length > 10 ||
        count != 2 ||
        resultText[2].toString() != '/' ||
        resultText[5].toString() != '/') {
      return oldValue;
    }

    return oldValue.copyWith(
      text: resultText,
      selection: TextSelection.collapsed(offset: offset),
      composing: defaultTargetPlatform == TargetPlatform.iOS
          ? const TextRange(start: 0, end: 0)
          : TextRange.empty,
    );
  }

  int _indexOfDifference(String? cs1, String? cs2) {
    if (cs1 == cs2) {
      return INDEX_NOT_FOUND;
    }
    if (cs1 == null || cs2 == null) {
      return 0;
    }
    int i;
    for (i = 0; i < cs1.length && i < cs2.length; ++i) {
      if (cs1[i] != cs2[i]) {
        break;
      }
    }
    if (i < cs2.length || i < cs1.length) {
      return i;
    }
    return INDEX_NOT_FOUND;
  }

  String _fillInputToPlaceholder(String? input) {
    if (input == null || input.isEmpty) {
      return _placeholder;
    }
    String result = _placeholder;
    final index = [0, 1, 3, 4, 6, 7, 8, 9];
    final length = min(index.length, input.length);

    for (int i = 0; i < length; i++) {
      String newChar = input[i];

      if (int.tryParse(input)! > 3) {
        newChar = "3";
      }
      result = result.replaceRange(index[i], index[i] + 1, newChar);
    }
    return result;
  }
}
