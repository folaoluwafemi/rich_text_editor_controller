import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rich_text_editor_controller/src/utils/function/util_functions/util_functions.dart';

void main() {
  test('colorFromMap returns a Color object from a valid map', () {
    final Map<String, String> map = {'color': '0xFF0000'};
    final Color color = UtilFunctions.colorFromMap(map);
    expect(color, isInstanceOf<Color>());
    expect(color.value, equals(0xFF0000));
  });

  test('colorFromMap throws an exception when the map is invalid', () {
    final Map<String, String> map = {'color': 'invalid_value'};
    expect(() => UtilFunctions.colorFromMap(map), throwsFormatException);
  });
}
