import 'package:rich_text_editor_controller/src/text_editor/models/text_editor_models_barrel.dart';
import 'package:rich_text_editor_controller/src/utils/utils_barrel.dart';

part 'text_deltas_utils.dart';

/// Sugar for working with list of [TextDelta]s.
typedef TextDeltas = List<TextDelta>;

extension TextDeltasExtension on TextDeltas {
  String get text {
    if (isEmpty) return '';
    final StringBuffer stringBuffer = StringBuffer(first.char);
    for (int i = 1; i < length; i++) {
      stringBuffer.write(this[i].char);
    }
    return stringBuffer.toString();
  }

  ///creates a value copy of the list
  TextDeltas get copy => List.from(this);
}
