part of '../home_page.dart';

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
