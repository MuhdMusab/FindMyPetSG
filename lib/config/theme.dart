import 'package:flutter/material.dart';

ThemeData theme() {
  return ThemeData(
    primaryColor: Colors.white,
    scaffoldBackgroundColor: Colors.white,
    primarySwatch: const MaterialColor(
        0xFFFFFFFF,
        const <int, Color>{
          50: const Color(0xFFFFFFFF),
          100: const Color(0xFFFFFFFF),
          200: const Color(0xFFFFFFFF),
          300: const Color(0xFFFFFFFF),
          400: const Color(0xFFFFFFFF),
          500: const Color(0xFFFFFFFF),
          600: const Color(0xFFFFFFFF),
          700: const Color(0xFFFFFFFF),
          800: const Color(0xFFFFFFFF),
          900: const Color(0xFFFFFFFF),
        }),
    visualDensity: VisualDensity.adaptivePlatformDensity,
    fontFamily: 'Futura',
    // textTheme: TextTheme(
    //   headline1: TextStyle(
    //     color: Color(0xFF2b2e4a),
    //     fontWeight: FontWeight.bold,
    //     fontSize: 36,
    //   ),
    //   headline2: TextStyle(
    //     color: Color(0xFF2b2e4a),
    //     fontWeight: FontWeight.bold,
    //     fontSize: 24,
    //   ),
    //   headline3: TextStyle(
    //     color: Color(0xFF2b2e4a),
    //     fontWeight: FontWeight.bold,
    //     fontSize: 18,
    //   ),
    //   headline4: TextStyle(
    //     color: Color(0xFF2b2e4a),
    //     fontWeight: FontWeight.bold,
    //     fontSize: 16,
    //   ),
    //   headline5: TextStyle(
    //     color: Color(0xFF2b2e4a),
    //     fontWeight: FontWeight.bold,
    //     fontSize: 14,
    //   ),
    //   headline6: TextStyle(
    //     color: Color(0xFF2b2e4a),
    //     fontWeight: FontWeight.normal,
    //     fontSize: 14,
    //   ),
    //   bodyText1: TextStyle(
    //     color: Color(0xFF2b2e4a),
    //     fontWeight: FontWeight.normal,
    //     fontSize: 12,
    //   ),
    //   bodyText2: TextStyle(
    //     color: Color(0xFF2b2e4a),
    //     fontWeight: FontWeight.normal,
    //     fontSize: 10,
    //   ),
    // ),
  );
}