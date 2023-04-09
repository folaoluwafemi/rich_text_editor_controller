import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:rich_text_editor_controller/rich_text_editor_controller.dart';

/// A [TextFormField] that uses a [RichTextEditorController] to control the text.
///
/// The only relevance of this widget over [TextFormField] is that it listens to changes in the controller and rebuilds on text align change.
class RichTextFormField extends TextFormField {
  @override
  // ignore: overridden_fields
  final RichTextEditorController controller;

  final FocusNode? focusNode;
  final InputDecoration? decoration;
  final TextInputType? keyboardType;
  final TextCapitalization textCapitalization;
  final TextInputAction? textInputAction;
  final TextStyle? style;
  final StrutStyle? strutStyle;
  final TextDirection? textDirection;
  final TextAlign textAlign;
  final TextAlignVertical? textAlignVertical;
  final bool autofocus;
  final bool readOnly;
  final bool? showCursor;
  final String obscuringCharacter;
  final bool obscureText;
  final bool autocorrect;
  final SmartDashesType? smartDashesType;
  final SmartQuotesType? smartQuotesType;
  final bool enableSuggestions;
  final MaxLengthEnforcement? maxLengthEnforcement;
  final int? maxLines;
  final int? minLines;
  final bool expands;
  final int? maxLength;
  final ValueChanged<String>? onChanged;
  final GestureTapCallback? onTap;
  final TapRegionCallback? onTapOutside;
  final VoidCallback? onEditingComplete;
  final ValueChanged<String>? onFieldSubmitted;
  final List<TextInputFormatter>? inputFormatters;
  final double cursorWidth;
  final double? cursorHeight;
  final Radius? cursorRadius;
  final Color? cursorColor;
  final Brightness? keyboardAppearance;
  final EdgeInsets scrollPadding;
  final bool? enableInteractiveSelection;
  final TextSelectionControls? selectionControls;
  final InputCounterWidgetBuilder? buildCounter;
  final ScrollPhysics? scrollPhysics;
  final Iterable<String>? autofillHints;
  final ScrollController? scrollController;
  final bool enableIMEPersonalizedLearning;
  final MouseCursor? mouseCursor;
  final EditableTextContextMenuBuilder? contextMenuBuilder;

  RichTextFormField({
    required this.controller,
    super.initialValue,
    super.autovalidateMode,
    this.focusNode,
    this.decoration = const InputDecoration(),
    this.keyboardType,
    this.textCapitalization = TextCapitalization.none,
    this.textInputAction,
    this.style,
    this.strutStyle,
    this.textDirection,
    this.textAlign = TextAlign.start,
    this.textAlignVertical,
    this.autofocus = false,
    this.readOnly = false,
    this.showCursor,
    this.obscuringCharacter = '•',
    this.obscureText = false,
    this.autocorrect = true,
    this.smartDashesType,
    this.smartQuotesType,
    this.enableSuggestions = true,
    this.maxLengthEnforcement,
    this.maxLines = 1,
    this.minLines,
    this.expands = false,
    this.maxLength,
    this.onChanged,
    this.onTap,
    this.onTapOutside,
    this.onEditingComplete,
    this.onFieldSubmitted,
    this.inputFormatters,
    super.enabled,
    this.cursorWidth = 2.0,
    this.cursorHeight,
    this.cursorRadius,
    this.cursorColor,
    this.keyboardAppearance,
    this.scrollPadding = const EdgeInsets.all(20.0),
    this.enableInteractiveSelection,
    this.selectionControls,
    this.buildCounter,
    this.scrollPhysics,
    this.autofillHints,
    this.scrollController,
    this.enableIMEPersonalizedLearning = true,
    this.mouseCursor,
    this.contextMenuBuilder,
    super.key,
    super.onSaved,
    super.validator,
  });

  @override
  FormFieldState<String> createState() => _RichTextFormFieldState();
}

class _RichTextFormFieldState extends FormFieldState<String> {
  late RichTextEditorController controller = _richTextFormField.controller;

  RichTextFormField get _richTextFormField => super.widget as RichTextFormField;

  @override
  void didUpdateWidget(RichTextFormField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.controller != _richTextFormField.controller) {
      controller = _richTextFormField.controller;
    }
  }

  @override
  Widget build(BuildContext context) {
    ///value listenable builder added to listen to changes in the controller and rebuild on text align change
    return ValueListenableBuilder<TextEditingValue>(
      valueListenable: controller,
      builder: (_, controllerValue, __) {
        return TextFormField(
          ///this is the only line that is different from the original text field
          textAlign:
              controller.metadata?.alignment ?? _richTextFormField.textAlign,
          key: _richTextFormField.key,
          controller: controller,
          focusNode: _richTextFormField.focusNode,
          decoration: _richTextFormField.decoration,
          keyboardType: _richTextFormField.keyboardType,
          textInputAction: _richTextFormField.textInputAction,
          textCapitalization: _richTextFormField.textCapitalization,
          style: _richTextFormField.style,
          strutStyle: _richTextFormField.strutStyle,
          textAlignVertical: _richTextFormField.textAlignVertical,
          textDirection: _richTextFormField.textDirection,
          readOnly: _richTextFormField.readOnly,
          showCursor: _richTextFormField.showCursor,
          autofocus: _richTextFormField.autofocus,
          obscuringCharacter: _richTextFormField.obscuringCharacter,
          obscureText: _richTextFormField.obscureText,
          autocorrect: _richTextFormField.autocorrect,
          smartDashesType: _richTextFormField.smartDashesType,
          smartQuotesType: _richTextFormField.smartQuotesType,
          enableSuggestions: _richTextFormField.enableSuggestions,
          maxLines: _richTextFormField.maxLines,
          minLines: _richTextFormField.minLines,
          expands: _richTextFormField.expands,
          maxLength: _richTextFormField.maxLength,
          maxLengthEnforcement: _richTextFormField.maxLengthEnforcement,
          onChanged: _richTextFormField.onChanged,
          onTap: _richTextFormField.onTap,
          onTapOutside: _richTextFormField.onTapOutside,
          onEditingComplete: _richTextFormField.onEditingComplete,
          onFieldSubmitted: _richTextFormField.onFieldSubmitted,
          onSaved: _richTextFormField.onSaved,
          validator: _richTextFormField.validator,
          inputFormatters: _richTextFormField.inputFormatters,
          enabled: _richTextFormField.enabled,
          cursorWidth: _richTextFormField.cursorWidth,
          cursorHeight: _richTextFormField.cursorHeight,
          cursorRadius: _richTextFormField.cursorRadius,
          cursorColor: _richTextFormField.cursorColor,
          keyboardAppearance: _richTextFormField.keyboardAppearance,
          scrollPadding: _richTextFormField.scrollPadding,
          enableInteractiveSelection:
              _richTextFormField.enableInteractiveSelection,
          selectionControls: _richTextFormField.selectionControls,
          buildCounter: _richTextFormField.buildCounter,
          scrollController: _richTextFormField.scrollController,
          scrollPhysics: _richTextFormField.scrollPhysics,
          autofillHints: _richTextFormField.autofillHints,
          contextMenuBuilder: _richTextFormField.contextMenuBuilder,
          autovalidateMode: _richTextFormField.autovalidateMode,
          enableIMEPersonalizedLearning:
              _richTextFormField.enableIMEPersonalizedLearning,
          initialValue: _richTextFormField.initialValue,
          mouseCursor: _richTextFormField.mouseCursor,
          restorationId: _richTextFormField.restorationId,
        );
      },
    );
  }
}
