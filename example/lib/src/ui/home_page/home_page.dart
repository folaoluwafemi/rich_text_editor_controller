import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:rich_text_editor_controller/rich_text_editor_controller.dart';

part 'custom/metadata_button.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final RichTextEditorController controller = RichTextEditorController(
    metadata: const TextMetadata(
      fontSize: 30,
      color: Colors.white,
    ),
  );

  @override
  void dispose() {
    super.dispose();
    controller.dispose();
  }

  void onMetadataButtonPressed(MetadataValue value) {
    //switch through value and call the appropriate method on the controller
    switch (value) {
      case MetadataValue.bold:
        controller.toggleBold();
        break;
      case MetadataValue.italic:
        controller.toggleItalic();
        break;
      case MetadataValue.underline:
        controller.toggleUnderline();
        break;
      case MetadataValue.color:
        controller.metadata?.color == Colors.deepOrange
            ? controller.changeColor(Colors.black)
            : controller.changeColor(Colors.deepOrange);
        break;
      case MetadataValue.alignRight:
        controller.changeAlignment(TextAlign.right);
        break;
      case MetadataValue.alignCenter:
        controller.changeAlignment(TextAlign.center);
        break;
      case MetadataValue.alignLeft:
        controller.changeAlignment(TextAlign.left);
        break;
      case MetadataValue.superscript:
        controller.toggleSuperscript();
        break;
      case MetadataValue.subscript:
        controller.toggleSubscript();
        break;
      case MetadataValue.bulletPoints:
        controller.toggleListMode();
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Rich Text Editor Controller Demo'),
      ),
      body: SafeArea(
        child: Column(
          children: [
            ValueListenableBuilder<TextEditingValue>(
                valueListenable: controller,
                builder: (_, __, ___) {
                  return Wrap(
                    children: [
                      ...MetadataValue.values.map(
                        (value) => Padding(
                          padding: const EdgeInsets.only(left: 8.0),
                          child: MetadataButton(
                            metadata: controller.metadata ??
                                RichTextEditorController.defaultMetadata,
                            value: value,
                            onPressed: onMetadataButtonPressed,
                          ),
                        ),
                      ),
                    ],
                  );
                }),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: RichTextField(
                controller: controller,
                maxLines: 20,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Colors.white,
                      fontSize: 30,
                    ),
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Enter some text',
                ),
              ),
            ),
            MaterialButton(
              onPressed: () {
                final Map<String, dynamic> data = controller.toMap();
                if (kDebugMode) {
                  print(data);
                }
                //add call to your dto/repository here to save the data
              },
              color: Colors.deepOrange,
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 8),
              child: const Text(
                'Save',
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
