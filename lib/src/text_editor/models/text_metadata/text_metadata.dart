import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:rich_text_editor_controller/src/text_editor/models/text_metadata/text_metadata_enum.dart';
import 'package:rich_text_editor_controller/src/utils/utils_barrel.dart';

part 'text_decoration_enum.dart';

class TextMetadata {
  final Color color;
  final FontWeight fontWeight;
  final FontStyle fontStyle;
  final double fontSize;
  final TextDecorationEnum decoration;
  final List<FontFeature>? _fontFeatures;
  final TextAlign alignment;

  List<FontFeature>? get fontFeatures {
    final List<FontFeature>? fontFeatures = _fontFeatures;
    if (fontFeatures == null) return null;
    return List<FontFeature>.unmodifiable(fontFeatures);
  }

  const TextMetadata({
    this.color = Colors.black,
    this.fontWeight = FontWeight.w400,
    this.fontStyle = FontStyle.normal,
    this.fontSize = 14,
    this.alignment = TextAlign.start,
    this.decoration = TextDecorationEnum.none,
    List<FontFeature>? fontFeatures,
  }) : _fontFeatures = fontFeatures;

  TextMetadata.fromTextStyle(
    TextStyle style, {
    this.alignment = TextAlign.start,
  })  : color = style.color ?? Colors.black,
        fontWeight = style.fontWeight ?? FontWeight.w400,
        fontStyle = style.fontStyle ?? FontStyle.normal,
        fontSize = style.fontSize ?? 14,
        decoration = style.decoration == null
            ? TextDecorationEnum.none
            : TextDecorationEnum.fromDecoration(style.decoration!),
        _fontFeatures = style.fontFeatures;

  TextMetadata copyWith({
    Color? color,
    FontWeight? fontWeight,
    FontStyle? fontStyle,
    double? fontSize,
    TextDecorationEnum? decoration,
    List<FontFeature>? fontFeatures,
    TextAlign? alignment,
  }) {
    return TextMetadata(
      color: color ?? this.color,
      fontWeight: fontWeight ?? this.fontWeight,
      fontStyle: fontStyle ?? this.fontStyle,
      fontSize: fontSize ?? this.fontSize,
      decoration: decoration ?? this.decoration,
      fontFeatures: fontFeatures ?? _fontFeatures,
      alignment: alignment ?? this.alignment,
    );
  }

  /// This method is used to combine two [TextMetadata] objects relative to
  /// the specified [TextMetadataChange]
  TextMetadata combineWhatChanged(
    TextMetadataChange change,
    TextMetadata other,
  ) {
    switch (change) {
      case TextMetadataChange.all:
        return other;
      case TextMetadataChange.color:
        return copyWith(color: other.color);
      case TextMetadataChange.fontWeight:
        return copyWith(fontWeight: other.fontWeight);
      case TextMetadataChange.fontStyle:
        return copyWith(fontStyle: other.fontStyle);
      case TextMetadataChange.fontSize:
        return copyWith(fontSize: other.fontSize);
      case TextMetadataChange.alignment:
        return copyWith(alignment: other.alignment);
      case TextMetadataChange.fontDecoration:
        return copyWith(decoration: other.decoration);
      case TextMetadataChange.fontFeatures:
        return copyWith(fontFeatures: other.fontFeatures);
    }
  }

  TextStyle get style => TextStyle(
        fontSize: fontSize,
        color: color,
        decoration: decoration.value,
        fontWeight: fontWeight,
        fontStyle: fontStyle,
        fontFeatures: fontFeatures,
      );

  TextStyle get styleWithoutFontFeatures => TextStyle(
        fontSize: fontSize,
        color: color,
        decoration: decoration.value,
        fontWeight: fontWeight,
        fontStyle: fontStyle,
      );

  factory TextMetadata.combineWhereNotEqual(
    final TextMetadata metadata1,
    final TextMetadata metadata2, {
    bool favourFirst = true,
  }) {
    return TextMetadata(
      color: favourFirst ? metadata1.color : metadata2.color,
      fontWeight: favourFirst ? metadata1.fontWeight : metadata2.fontWeight,
      fontStyle: favourFirst ? metadata1.fontStyle : metadata2.fontStyle,
      fontSize: favourFirst ? metadata1.fontSize : metadata2.fontSize,
      decoration: favourFirst ? metadata1.decoration : metadata2.decoration,
      fontFeatures:
          favourFirst ? metadata1._fontFeatures : metadata2._fontFeatures,
      alignment: favourFirst ? metadata1.alignment : metadata2.alignment,
    );
  }

  TextMetadata combineWith(
    TextMetadata other, {
    bool favourOther = true,
  }) {
    return TextMetadata(
      color: color == other.color
          ? color
          : favourOther
              ? other.color
              : color,
      fontWeight: fontWeight == other.fontWeight
          ? fontWeight
          : favourOther
              ? other.fontWeight
              : fontWeight,
      fontStyle: fontStyle == other.fontStyle
          ? fontStyle
          : favourOther
              ? other.fontStyle
              : fontStyle,
      fontSize: fontSize == other.fontSize
          ? fontSize
          : favourOther
              ? other.fontSize
              : fontSize,
      decoration: decoration == other.decoration
          ? decoration
          : favourOther
              ? other.decoration
              : decoration,
      fontFeatures: listEquals(_fontFeatures, other._fontFeatures)
          ? _fontFeatures
          : favourOther
              ? other._fontFeatures ?? _fontFeatures
              : _fontFeatures ?? other._fontFeatures,
      alignment: alignment == other.alignment
          ? alignment
          : favourOther
              ? other.alignment
              : alignment,
    );
  }

  factory TextMetadata.fromMap(Map<String, dynamic> map) {
    return TextMetadata(
      color: UtilFunctions.colorFromMap(map),
      fontWeight: _fontWeightFromMap(map['fontWeight']),
      fontStyle: _enumValueFromMap(
        FontStyle.values,
        map['fontStyle'],
        'fontStyle',
      ),
      fontSize: (map['fontSize'] as num).toDouble(),
      fontFeatures: (map['fontFeatures'] as List?)
          ?.cast<Map<String, dynamic>>()
          .map((e) => _fontFeatureFromMap(e))
          .toList(),
      alignment: _enumValueFromMap(
        TextAlign.values,
        map['alignment'],
        'alignment',
      ),
      decoration: _enumValueFromMap(
        TextDecorationEnum.values,
        map['decoration'],
        'decoration',
      ),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'color': color.toSerializerString,
      'fontWeight': 'w${fontWeight.value}',
      'fontStyle': fontStyle.name,
      'fontSize': fontSize,
      'fontFeatures': fontFeatures?.map((e) => _fontFeatureToMap(e)).toList(),
      'alignment': alignment.name,
      'decoration': decoration.name,
    };
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TextMetadata &&
          runtimeType == other.runtimeType &&
          color == other.color &&
          fontWeight == other.fontWeight &&
          fontStyle == other.fontStyle &&
          fontSize == other.fontSize &&
          decoration == other.decoration &&
          listEquals(_fontFeatures, other._fontFeatures) &&
          alignment == other.alignment;

  @override
  int get hashCode => Object.hash(
        color,
        fontWeight,
        fontStyle,
        fontSize,
        decoration,
        _fontFeatures == null ? null : Object.hashAll(_fontFeatures!),
        alignment,
      );

  @override
  String toString() {
    return '''
TextMetadata{
      color: $color,
      fontWeight: $fontWeight,
      fontStyle: $fontStyle,
      fontSize: $fontSize,
      decoration: $decoration,
      fontFeatures: $fontFeatures,
      alignment: $alignment
    }''';
  }
}

T _enumValueFromMap<T extends Enum>(
  List<T> values,
  Object? value,
  String field,
) {
  if (value is String) {
    for (final T enumValue in values) {
      if (enumValue.name == value) return enumValue;
    }
  }

  if (value is int && value >= 0 && value < values.length) {
    return values[value];
  }

  throw FormatException('Invalid $field value: $value');
}

FontWeight _fontWeightFromMap(Object? value) {
  if (value is String) {
    for (final FontWeight fontWeight in FontWeight.values) {
      if ('w${fontWeight.value}' == value) return fontWeight;
    }
  }

  if (value is int && value >= 0 && value < FontWeight.values.length) {
    return FontWeight.values[value];
  }

  throw FormatException('Invalid fontWeight value: $value');
}

FontFeature _fontFeatureFromMap(Map map) {
  return FontFeature(
    map['feature'],
    map['value'],
  );
}

Map<String, dynamic> _fontFeatureToMap(FontFeature feature) {
  return {
    'feature': feature.feature,
    'value': feature.value,
  };
}
