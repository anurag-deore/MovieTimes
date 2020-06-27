import 'package:flutter/material.dart';

final ThemeData kLightTheme = _buildLightTheme();

ThemeData _buildLightTheme() {
  final ThemeData base = ThemeData.light();
  return base.copyWith(
    primaryColor: Colors.white,
    accentColor: Color(0xff8468DD),
    canvasColor: Colors.transparent,
    primaryIconTheme: IconThemeData(color: Colors.black),
    textTheme: TextTheme(
      headline: TextStyle(
          fontFamily: 'Handlee',
          fontWeight: FontWeight.bold,
          color: Colors.black,
          fontSize: 21),
      body1: TextStyle(
          fontFamily: 'Comfortaa',
          fontWeight: FontWeight.bold,
          color: Colors.black,
          fontSize: 18),
      body2: TextStyle(
          fontFamily: 'Comfortaa',
          fontWeight: FontWeight.bold,
          color: Colors.black,
          fontSize: 16),
      caption: TextStyle(
          fontFamily: 'Comfortaa',
          fontWeight: FontWeight.normal,
          color: Colors.black,
          fontSize: 14),
    ),
  );
}

final ThemeData kRedTheme = _buildRedTheme();
ThemeData _buildRedTheme() {
  final ThemeData base = ThemeData.light();
  return base.copyWith(
    primaryColor: Colors.blue[900],
    accentColor: Colors.white,
    canvasColor: Colors.transparent,
    primaryIconTheme: IconThemeData(color: Colors.black),
    textTheme: TextTheme(
      headline: TextStyle(
          fontFamily: 'Handlee',
          fontWeight: FontWeight.bold,
          color: Colors.white,
          fontSize: 21),
      body1: TextStyle(
          fontFamily: 'Comfortaa',
          fontWeight: FontWeight.bold,
          color: Colors.white,
          fontSize: 18),
      body2: TextStyle(
          fontFamily: 'Comfortaa',
          fontWeight: FontWeight.bold,
          color: Colors.white,
          fontSize: 16),
      caption: TextStyle(
          fontFamily: 'Comfortaa',
          fontWeight: FontWeight.normal,
          color: Colors.white,
          fontSize: 14),
    ),
  );
}

final ThemeData kDarkTheme = _buildDarkTheme();

ThemeData _buildDarkTheme() {
  final ThemeData base = ThemeData.dark();
  return base.copyWith(
    primaryColor: Color(0xff242248),
    accentColor: Color(0xff8468DD),
    canvasColor: Colors.transparent,
    primaryIconTheme: IconThemeData(color: Colors.black),
    textTheme: TextTheme(
      headline: TextStyle(
          fontFamily: 'Handlee',
          fontWeight: FontWeight.bold,
          color: Colors.white,
          fontSize: 21),
      body1: TextStyle(
          fontFamily: 'Comfortaa',
          fontWeight: FontWeight.bold,
          color: Colors.white,
          fontSize: 18),
      body2: TextStyle(
          fontFamily: 'Comfortaa',
          fontWeight: FontWeight.bold,
          color: Colors.white,
          fontSize: 16),
      caption: TextStyle(
          fontFamily: 'Comfortaa',
          fontWeight: FontWeight.normal,
          color: Colors.white,
          fontSize: 14),
    ),
  );
}

final ThemeData kAmoledTheme = _buildAmoledTheme();

ThemeData _buildAmoledTheme() {
  final ThemeData base = ThemeData.dark();
  return base.copyWith(
    primaryColor: Colors.black,
    accentColor: Colors.white,
    canvasColor: Colors.transparent,
    primaryIconTheme: IconThemeData(color: Colors.black),
    textTheme: TextTheme(
      headline: TextStyle(
          fontFamily: 'Handlee',
          fontWeight: FontWeight.bold,
          color: Colors.white,
          fontSize: 21),
      body1: TextStyle(
          fontFamily: 'Comfortaa',
          fontWeight: FontWeight.bold,
          color: Colors.white,
          fontSize: 18),
      body2: TextStyle(
          fontFamily: 'Comfortaa',
          fontWeight: FontWeight.bold,
          color: Colors.white,
          fontSize: 16),
      caption: TextStyle(
          fontFamily: 'Comfortaa',
          fontWeight: FontWeight.normal,
          color: Colors.white,
          fontSize: 14),
    ),
  );
}
