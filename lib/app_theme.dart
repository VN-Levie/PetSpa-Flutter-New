import 'package:flutter/material.dart';

class AppTheme {
  AppTheme._();

  // Màu cũ thay vào đây
  static const Color notWhite = Color(0xFFEDF0F2);
  static const Color nearlyWhite = Color(0xFFFEFEFE);
  static const Color white = Color(0xFFFFFFFF);
  static const Color nearlyBlack = Color(0xFF213333);
  static const Color grey = Color(0xFF3A5160);
  static const Color dark_grey = Color(0xFF313A44);

  // Màu cũ từ MaterialColors
  static const Color primary = Color.fromRGBO(255, 204, 179, 1);
  static const Color label = Color.fromRGBO(255, 153, 153, 1.0);
  static const Color info = Color.fromRGBO(255, 229, 204, 1.0);
  static const Color error = Color.fromRGBO(255, 102, 102, 1.0);
  static const Color success = Color.fromRGBO(204, 255, 204, 1.0);
  static const Color warning = Color.fromRGBO(255, 204, 153, 1.0);
  static const Color muted = Color.fromRGBO(204, 204, 204, 1.0);
  static const Color input = Color.fromRGBO(255, 229, 204, 1.0);
  static const Color active = Color.fromRGBO(255, 183, 147, 1.0);
  static const Color placeholder = Color.fromRGBO(255, 229, 204, 1.0);
  static const Color switchOff = Color.fromRGBO(255, 229, 204, 1.0);
  static const Color gradientStart = Color.fromRGBO(255, 153, 102, 1.0);
  static const Color gradientEnd = Color.fromRGBO(255, 102, 51, 1.0);
  static const Color priceColor = Color.fromRGBO(255, 229, 204, 1.0);
  static const Color border = Color.fromRGBO(255, 204, 179, 1.0);
  static const Color captionColor = Color.fromRGBO(153, 102, 102, 1.0);
  static const Color bgColorScreen = Color.fromRGBO(255, 255, 255, 1.0);
  static const Color drawerHeader = Color.fromRGBO(255, 204, 179, 1.0);
  static const Color signStartGradient = Color.fromRGBO(255, 153, 102, 1.0);
  static const Color signEndGradient = Color.fromRGBO(255, 102, 51, 1.0);
  static const Color socialFacebook = Color.fromRGBO(99, 129, 192, 1.0);
  static const Color socialTwitter = Color.fromRGBO(131, 232, 252, 1.0);
  static const Color socialDribbble = Color.fromRGBO(244, 136, 197, 1.0);
  static const Color defaultButton = Color.fromRGBO(255, 204, 179, 0.8);
  static const Color textButton = Color.fromRGBO(112, 69, 69, 1);

  // Các màu mới
  static const Color darkText = Color(0xFF253840);
  static const Color darkerText = Color(0xFF17262A);
  static const Color lightText = Color(0xFF4A6572);
  static const Color deactivatedText = Color(0xFF767676);
  static const Color dismissibleBackground = Color(0xFF364A54);
  static const Color chipBackground = Color(0xFFEEF1F3);
  static const Color spacer = Color(0xFFF2F2F2);

  static const String fontName = 'WorkSans';

  static const TextTheme textTheme = TextTheme(
    displayLarge: display1,
    headlineMedium: headline,
    titleLarge: title,
    titleMedium: subtitle,
    bodyMedium: body2,
    bodyLarge: body1,
    bodySmall: caption,
  );

  static const TextStyle display1 = TextStyle(
    // h4 -> display1
    fontFamily: fontName,
    fontWeight: FontWeight.bold,
    fontSize: 36,
    letterSpacing: 0.4,
    height: 0.9,
    color: darkerText,
  );

  static const TextStyle headline = TextStyle(
    // h5 -> headline
    fontFamily: fontName,
    fontWeight: FontWeight.bold,
    fontSize: 24,
    letterSpacing: 0.27,
    color: darkerText,
  );

  static const TextStyle title = TextStyle(
    // h6 -> title
    fontFamily: fontName,
    fontWeight: FontWeight.bold,
    fontSize: 16,
    letterSpacing: 0.18,
    color: darkerText,
  );

  static const TextStyle subtitle = TextStyle(
    // subtitle2 -> subtitle
    fontFamily: fontName,
    fontWeight: FontWeight.w400,
    fontSize: 14,
    letterSpacing: -0.04,
    color: darkText,
  );

  static const TextStyle body2 = TextStyle(
    // body1 -> body2
    fontFamily: fontName,
    fontWeight: FontWeight.w400,
    fontSize: 14,
    letterSpacing: 0.2,
    color: darkText,
  );

  static const TextStyle body1 = TextStyle(
    // body2 -> body1
    fontFamily: fontName,
    fontWeight: FontWeight.w400,
    fontSize: 16,
    letterSpacing: -0.05,
    color: darkText,
  );

  static const TextStyle caption = TextStyle(
    // Caption -> caption
    fontFamily: fontName,
    fontWeight: FontWeight.w400,
    fontSize: 12,
    letterSpacing: 0.2,
    color: lightText,
  );
}
