import 'package:flutter/material.dart';

final appTheme = ThemeData(
  useMaterial3: true,
  // colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal),
  // colorScheme: ColorScheme.fromSeed(seedColor: Colors.orange),
  // colorScheme: ColorScheme.fromSeed(seedColor: Colors.purple),
  // colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
  // colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
  // colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
  colorScheme: ColorScheme.fromSeed(
    seedColor: const Color(0xFFFF6F61), // Coral
    brightness: Brightness.light,
  ),
  scaffoldBackgroundColor: const Color(0xFFFFF6F1),
  snackBarTheme: const SnackBarThemeData(behavior: SnackBarBehavior.floating),
);