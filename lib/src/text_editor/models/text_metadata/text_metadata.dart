import 'dart:ui';

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
  final List<FontFeature>? fontFeatures;
  final TextAlign alignment;

  const TextMetadata({
    this.color = Colors.black,
    this.fontWeight = FontWeight.w400,
    this.fontStyle = FontStyle.normal,
    this.fontSize = 14,
    this.alignment = TextAlign.start,
    this.decoration = TextDecorationEnum.none,
    this.fontFeatures,
  });

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
        fontFeatures = style.fontFeatures;

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
      fontFeatures: fontFeatures ?? this.fontFeatures,
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
          favourFirst ? metadata1.fontFeatures : metadata2.fontFeatures,
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
      fontFeatures: fontFeatures == other.fontFeatures
          ? fontFeatures
          : favourOther
              ? other.fontFeatures ?? fontFeatures
              : fontFeatures ?? other.fontFeatures,
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
      fontWeight: FontWeight.values[(map['fontWeight'])],
      fontStyle: FontStyle.values[(map['fontStyle'])],
      fontSize: map['fontSize'] as double,
      fontFeatures: (map['fontFeatures'] as List?)
          ?.cast<Map<String, dynamic>>()
          .map((e) => _fontFeatureFromMap(e))
          .toList(),
      alignment: TextAlign.values[(map['alignment'])],
      decoration: TextDecorationEnum.values[(map['decoration'])],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'color': color.toSerializerString,
      'fontWeight': fontWeight.index,
      'fontStyle': fontStyle.index,
      'fontSize': fontSize,
      'fontFeatures': fontFeatures?.map((e) => _fontFeatureToMap(e)).toList(),
      'alignment': alignment.index,
      'decoration': decoration.index,
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
          fontFeatures == other.fontFeatures &&
          alignment == other.alignment;

  @override
  int get hashCode =>
      color.hashCode ^
      fontWeight.hashCode ^
      fontStyle.hashCode ^
      fontSize.hashCode ^
      decoration.hashCode ^
      fontFeatures.hashCode ^
      alignment.hashCode;

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
