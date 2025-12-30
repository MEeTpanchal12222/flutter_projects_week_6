import 'package:flutter/material.dart';

import '../Extension/responsive_ui_extension.dart';

class AppTextStyles {
  static TextStyle commonTextStyle({
    required BuildContext context,
    required double fontSize,
    required String fontFamily,
    Color? color,
    double? height,
    FontWeight? fontWeight,
    double? letterSpacing,
    double? wordSpacing,
    TextOverflow? overflow = TextOverflow.ellipsis,
    TextDecoration? decoration,
    Color? decorationColor,
    double? decorationThickness,
  }) {
    return TextStyle(
      fontSize: context.responsiveTextSize(fontSize),
      overflow: overflow,
      letterSpacing: letterSpacing,
      fontWeight: fontWeight,
      height: height,
      wordSpacing: wordSpacing,
      fontFamily: fontFamily,
      color: color,
      decoration: decoration,
      decorationColor: decorationColor,
      decorationThickness: decorationThickness,
    );
  }
}
