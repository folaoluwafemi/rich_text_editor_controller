import 'package:flutter/material.dart';
import 'package:rich_text_editor_controller/rich_text_editor_controller.dart';

void main() => runApp(const ExampleApp());

class ExampleApp extends StatelessWidget {
  const ExampleApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Rich Text Editor Controller Demo',
      theme: ThemeData(
        primarySwatch: Colors.deepOrange,
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final RichTextEditorController controller = RichTextEditorController();

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
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Enter some text',
                ),
              ),
            ),
            MaterialButton(
              onPressed: () {
                final Map<String, dynamic> data = controller.toMap();
                print(data);
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

class MetadataButton extends StatelessWidget {
  final TextMetadata metadata;
  final MetadataValue value;
  final ValueChanged<MetadataValue> onPressed;

  const MetadataButton({
    Key? key,
    required this.metadata,
    required this.value,
    required this.onPressed,
  }) : super(key: key);

  void _onPressed() => onPressed(value);

  @override
  Widget build(BuildContext context) {
    late final bool selected;
    switch (value) {
      case MetadataValue.bold:
        selected = metadata.fontWeight == FontWeight.w700;
        break;
      case MetadataValue.italic:
        selected = metadata.fontStyle == FontStyle.italic;
        break;
      case MetadataValue.alignRight:
        selected = metadata.alignment == TextAlign.right;
        break;
      case MetadataValue.alignCenter:
        selected = metadata.alignment == TextAlign.center;
        break;
      case MetadataValue.alignLeft:
        selected = metadata.alignment == TextAlign.left;
        break;
      case MetadataValue.underline:
        selected = metadata.decoration == TextDecorationEnum.underline;
        break;
      default:
        selected = false;
    }

    return MaterialButton(
      color: selected ? Colors.deepOrange : null,
      elevation: 0,
      highlightElevation: 0,
      onPressed: _onPressed,
      child: Text(
        value.name,
        style: TextStyle(
          color: selected ? Colors.white : null,
        ),
      ),
    );
  }
}

enum MetadataValue {
  color,
  bold,
  italic,
  alignRight,
  alignCenter,
  alignLeft,
  underline,
  superscript,
  subscript,
}
