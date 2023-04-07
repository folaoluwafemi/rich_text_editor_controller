import 'package:flutter/material.dart';
import 'package:rich_text_editor_controller/src/text_editor/text_editor_barrel.dart';
import 'package:rich_text_editor_controller/src/text_editor/controller/text_editor_controller.dart';

class TextEditingCanvas extends StatefulWidget {
  final TextEditorController controller;

  const TextEditingCanvas({
    Key? key,
    required this.controller,
  }) : super(key: key);

  @override
  State<TextEditingCanvas> createState() => _TextEditingCanvasState();
}

class _TextEditingCanvasState extends State<TextEditingCanvas> {
  late TextEditorController controller = widget.controller;

  @override
  void didUpdateWidget(TextEditingCanvas oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.controller != widget.controller) {
      controller = widget.controller;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 900,
      color: Colors.black.withOpacity(0.04),
      child: ValueListenableBuilder<TextEditingValue>(
        valueListenable: controller,
        builder: (_, controllerValue, __) {
          return TextField(
            textAlign: controller.metadata?.alignment ?? TextAlign.start,
            style: TextEditorController.defaultMetadata.style,
            controller: controller,
            decoration: const InputDecoration(
              border: InputBorder.none,
            ),
            smartDashesType: SmartDashesType.enabled,
            maxLines: null,
          );
        },
      ),
    );
  }
}
