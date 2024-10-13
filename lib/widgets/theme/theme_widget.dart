import 'package:flutter/material.dart';

class ThemeWidget {
  static final lightTheme = ThemeData(
    
    brightness: Brightness.light,
    scaffoldBackgroundColor: Colors.white,
    canvasColor: const Color.fromARGB(255, 197, 204, 248),
    textTheme: const TextTheme(
      titleLarge: TextStyle(
        color: Colors.white,
        fontWeight: FontWeight.bold,
        fontSize: 26,
      ),
      titleMedium: TextStyle(
        color: Colors.black,
        fontWeight: FontWeight.bold,
        fontSize: 26,
      ),
      titleSmall: TextStyle(
        color: Color(0xFF5F60B9),
        fontSize: 18,
      ),
      bodyMedium: TextStyle(color: Colors.black87, fontSize: 18),
      displayLarge: TextStyle(
        color: Colors.black,
        fontWeight: FontWeight.bold,
        fontSize: 26,
      ),
    ),
    colorScheme: ColorScheme.fromSeed(
      brightness: Brightness.light,
      seedColor: const Color(0xFF5F60B9),
      background: const Color(0xfff3f4fa),
    ),
    elevatedButtonTheme: const ElevatedButtonThemeData(
        style: ButtonStyle(
      foregroundColor: MaterialStatePropertyAll<Color>(Colors.white),
      backgroundColor: MaterialStatePropertyAll<Color>(Color(0xFF5F60B9)),
    )),
    //s useMaterial3: true,
    appBarTheme: const AppBarTheme(
      actionsIconTheme: IconThemeData(color: Colors.white),
      titleTextStyle: TextStyle(
        color: Colors.white,
        fontSize: 22,
        fontWeight: FontWeight.bold,
      ),
      color: Color(0xFF5F60B9),
      //s foregroundColor: Colors.white,
    ),
    snackBarTheme: const SnackBarThemeData(
      backgroundColor: Color(0xFF5F60B9),
      actionTextColor: Colors.white,
    ),
    cardColor: const Color(0xFFF6F7F9),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        minimumSize: const Size(50, 50),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
      ),
    ),
    inputDecorationTheme: const InputDecorationTheme(
      hintStyle: TextStyle(
        fontSize: 12,
      ),
    ),
    cardTheme: const CardTheme(
      elevation: 10,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(30)),
      ),
      
    ),
  );

  static final darkTheme = ThemeData(
    primaryColor: const Color(0xFF5F60B9),
    brightness: Brightness.dark,
    scaffoldBackgroundColor: Colors.black,
    canvasColor: const Color.fromARGB(255, 197, 204, 248),
    textTheme: const TextTheme(
      titleLarge: TextStyle(
        color: Colors.white,
        fontWeight: FontWeight.bold,
        fontSize: 26,
      ),
      titleMedium: TextStyle(
        color: Colors.black,
        fontWeight: FontWeight.bold,
        fontSize: 26,
      ),
      titleSmall: TextStyle(
        color: Color(0xFF5F60B9),
        fontSize: 18,
      ),
      bodyMedium: TextStyle(color: Colors.white70, fontSize: 18),
      displayLarge:TextStyle(
        color: Colors.white,
        fontWeight: FontWeight.bold,
        fontSize: 26,
      ),
    ),
    colorScheme: ColorScheme.fromSeed(
      brightness: Brightness.dark,
      seedColor: const Color(0xFF5F60B9),
      background: const Color(0xfff3f4fa),
    ),
    elevatedButtonTheme: const ElevatedButtonThemeData(
        style: ButtonStyle(
      foregroundColor: MaterialStatePropertyAll<Color>(Colors.white),
      backgroundColor: MaterialStatePropertyAll<Color>(Color(0xFF5F60B9)),
    )),
    //s useMaterial3: true,
    appBarTheme: const AppBarTheme(
      actionsIconTheme: IconThemeData(color: Colors.white),
      titleTextStyle: TextStyle(
        color: Colors.white,
        fontSize: 22,
        fontWeight: FontWeight.bold,
      ),
      color: Color(0xFF5F60B9),
      //s foregroundColor: Colors.white,
    ),
    snackBarTheme: const SnackBarThemeData(
      backgroundColor: Color(0xFF5F60B9),
      actionTextColor: Colors.white,
    ),
    cardColor: null,//const Color.fromARGB(255, 166, 167, 169),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        minimumSize: const Size(50, 50),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
      ),
    ),
    inputDecorationTheme: const InputDecorationTheme(
      hintStyle: TextStyle(
        fontSize: 12,
      ),
    ),
    cardTheme: const CardTheme(
      elevation: 10,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(28)),
      ),
      //margin: EdgeInsets.all(20),
    ),
  );
}
