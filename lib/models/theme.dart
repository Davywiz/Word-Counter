import 'package:flutter/material.dart';


class LaunchThemes {
  static ThemeData light() {
    return ThemeData(
      brightness: Brightness.light,
      primarySwatch: Colors.cyan,
    );
  }

  
  static ThemeData dark() {
    return ThemeData(
      brightness: Brightness.dark,
      primarySwatch: Colors.cyan,
    );
  }
}
