import 'package:flutter/material.dart';

final ThemeData appTheme = ThemeData(
  colorScheme: const ColorScheme(
    primary: Color(0xfff3dfa2),
    primaryContainer: Color(0xffe7c763),
    secondary: Color(0xffb71f3a),
    secondaryContainer: Color(0xff801025),
    surface: Colors.white,
    background: Colors.white,
    error: Color(0xffb28c17),
    onPrimary: Colors.white,
    onSecondary: Colors.black,
    onSurface: Colors.black,
    onBackground: Colors.black,
    onError: Colors.white,
    brightness: Brightness.light,
  ),
  appBarTheme: const AppBarTheme(
    color: Color(0xfff3dfa2),
    iconTheme: IconThemeData(
      color: Colors.black,
    ),
    centerTitle: true,
    titleTextStyle: TextStyle(
      fontFamily: 'Averia Serif Libre',
      color: Colors.black,
      fontSize: 24,
    ),
  ),
  textTheme: const TextTheme(
    headline1: TextStyle(
      color: Colors.black,
      fontSize: 18,
    ),
    headline2: TextStyle(
      color: Colors.black,
      fontSize: 16,
    ),
    headline3: TextStyle(
      color: Colors.black,
      fontSize: 14,
    ),
    headline4: TextStyle(
      color: Colors.black,
      fontSize: 12,
    ),
  ),
  iconTheme: const IconThemeData(
    color: Colors.black,
  ),
  inputDecorationTheme: const InputDecorationTheme(
    contentPadding: EdgeInsets.symmetric(
      horizontal: 12.0,
      vertical: 8.0,
    ),
    filled: true,
    fillColor: Color(0xFFF2F2F2),
    border: OutlineInputBorder(
      borderSide: BorderSide(
        color: Colors.black45,
      ),
    ),
    hintStyle: TextStyle(
      color: Colors.black45,
      fontSize: 16.0,
      fontWeight: FontWeight.w300,
    ),
    labelStyle: TextStyle(
      color: Colors.black87,
      fontSize: 16.0,
      fontWeight: FontWeight.w500,
    ),
  ),
  textSelectionTheme: const TextSelectionThemeData(
    cursorColor: Colors.black,
  ),
);
