import 'package:flutter/widgets.dart';
import 'package:rich_text_editor_controller/rich_text_editor_controller.dart';

typedef IndexRange = ({int from, int to});

class SomeRandomClass {
  final ValueNotifier<TextEditingValue> state;
  final Map<IndexRange, TextMetadata> specifiedTextStyle;

}