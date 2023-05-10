import 'package:flutter/material.dart';

const MaterialColor mypalette =
    MaterialColor(_mypalettePrimaryValue, <int, Color>{
  50: Color(0xFFEAF7F7),
  100: Color(0xFFCCEBEB),
  200: Color(0xFFAADEDE),
  300: Color(0xFF87D0D1),
  400: Color(0xFF6EC6C7),
  500: Color(_mypalettePrimaryValue),
  600: Color(0xFF4DB6B7),
  700: Color(0xFF43ADAE),
  800: Color(0xFF3AA5A6),
  900: Color(0xFF299798),
});
const int _mypalettePrimaryValue = 0xFF54BCBD;

const MaterialColor mypaletteAccent =
    MaterialColor(_mypaletteAccentValue, <int, Color>{
  100: Color(0xFFDAFEFF),
  200: Color(_mypaletteAccentValue),
  400: Color(0xFF74FDFF),
  700: Color(0xFF5BFCFF),
});
const int _mypaletteAccentValue = 0xFFA7FDFF;
