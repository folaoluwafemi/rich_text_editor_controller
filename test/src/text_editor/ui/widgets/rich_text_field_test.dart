import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rich_text_editor_controller/rich_text_editor_controller.dart';

void main() {
  testWidgets('RichTextField should use the text alignment from the controller',
      (WidgetTester tester) async {
    final RichTextEditorController controller = RichTextEditorController();
    final RichTextField richTextField = RichTextField(
      controller: controller,
      textAlign: TextAlign.center,
    );

    await tester.pumpWidget(MaterialApp(home: Scaffold(body: richTextField)));

    // Verify that the text alignment is initially set to the center.
    expect(find.byType(TextField), findsOneWidget);
    final TextField textFieldWidget = tester.widget<TextField>(
      find.byType(TextField),
    );
    expect(textFieldWidget.textAlign, TextAlign.center);

    // Update the controller's text alignment.
    controller.metadata = const TextMetadata(alignment: TextAlign.right);
    await tester.pump();

    // Verify that the text alignment is now set to the right.
    expect(find.byType(TextField), findsOneWidget);
    final TextField updatedTextFieldWidget = tester.widget<TextField>(
      find.byType(TextField),
    );
    expect(updatedTextFieldWidget.textAlign, TextAlign.right);
  });
}
