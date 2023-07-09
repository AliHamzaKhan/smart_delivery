

import 'package:flutter/material.dart';

import '../Constant/Colors.dart';

ThemeData darkTheme = ThemeData(
    secondaryHeaderColor: alterColor,
    brightness: Brightness.dark,
    primaryColor: appbackgroundColor,
    buttonTheme: ButtonThemeData(
      buttonColor: alterColor,
      disabledColor: subBackgroundColor,
    ));

ThemeData lightTheme = ThemeData(
    secondaryHeaderColor: alterColorLight,
    brightness: Brightness.light,
    primaryColor: appbackgroundColorLight,
    buttonTheme: ButtonThemeData(
      buttonColor: alterColorLight,
      disabledColor: subBackgroundColorLight,
    ));

// usage
// backgroundColor: context.theme.backgroundColor,