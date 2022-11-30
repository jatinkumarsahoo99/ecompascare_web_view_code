import 'package:flutter/material.dart';

class Themes {
  static final light = ThemeData.light().copyWith(
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.white,
      foregroundColor: Colors.black,
      centerTitle: false,
    ),
    tabBarTheme: const TabBarTheme(
      labelColor: Colors.black,
    ),
    textTheme: const TextTheme(
      ///Example Used for ____
      ///[alternative of headline6 | fontSize: 24]
      titleLarge: TextStyle(color: Colors.black),

      ///Example Used for ListTile title
      ///[alternative of subtitle1 | fontSize: 16, normal weight]
      titleMedium: TextStyle(color: Colors.black),

      ///[alternative of subtitle2 | fontSize: 14, medium weight]
      titleSmall: TextStyle(color: Colors.black),

      ///Example Used for ____
      ///[alternative of bodyText1]
      bodyLarge: TextStyle(color: Colors.black),

      ///Example Used for Normal text in a row, column etc
      bodyMedium: TextStyle(color: Colors.black),

      ///[alternative of caption | fontSize: 12, medium weight]
      bodySmall: TextStyle(color: Colors.black),

      ///Example Used for ____
      ///[alternative of headline5]
      headlineSmall: TextStyle(color: Colors.black),
      // headline5: TextStyle(color: Colors.black),

      // bodyText1: TextStyle(color: Colors.black),
    ),
  );
}
