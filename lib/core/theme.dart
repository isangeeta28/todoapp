import 'package:flutter/material.dart';

final ThemeData lightTheme = ThemeData(
  brightness: Brightness.light,
  primarySwatch: Colors.blue,
);

final ThemeData darkTheme = ThemeData(
  brightness: Brightness.dark,
  primarySwatch: Colors.blueGrey,
);

final ThemeData customTheme = ThemeData(
  brightness: Brightness.light,
  primaryColor: Colors.teal,
  appBarTheme: AppBarTheme(backgroundColor: Colors.teal),
);
