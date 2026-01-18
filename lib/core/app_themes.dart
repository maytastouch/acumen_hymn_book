import 'package:flutter/material.dart';

// ignore: constant_identifier_names
enum AppTheme { LightTheme, DarkTheme }

final appThemeData = {
  AppTheme.LightTheme: ThemeData(
    brightness: Brightness.light,
    primaryColor: Colors.white, // Changed from AppColors.pageColor
    scaffoldBackgroundColor: Colors.white, // Changed from AppColors.pageColor
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.white, // AppBar background
      iconTheme: IconThemeData(color: Colors.black), // AppBar icons
      foregroundColor: Colors.black, // AppBar text color
    ), // BottomAppBar
    cardColor: Colors.white, // Changed from AppColors.pageColor
    dividerColor: Colors.black12, // Dialogs
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: Colors.white, // Changed from AppColors.pageColor
      foregroundColor: Colors.black, // FAB foreground
    ),
    navigationBarTheme: const NavigationBarThemeData(
      backgroundColor: Colors.white, // Changed from AppColors.pageColor
      indicatorColor: Colors.black, // Selected item indicator
    ),
    textSelectionTheme: const TextSelectionThemeData(
      cursorColor: Colors.black, // Cursor color
      selectionColor: Colors.black26, // Text selection color
      selectionHandleColor: Colors.black, // Handle color
    ),

    bottomAppBarTheme: const BottomAppBarThemeData(color: Colors.white),
    dialogTheme: const DialogThemeData(backgroundColor: Colors.white),
    // Define additional properties as needed...
  ),
  AppTheme.DarkTheme: ThemeData(
    brightness: Brightness.dark,
    primaryColor: Colors.black,
    scaffoldBackgroundColor: Colors.black, // Scaffold background
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.black, // AppBar background
      iconTheme: IconThemeData(color: Colors.white), // AppBar icons
    ), // BottomAppBar
    cardColor: Colors.black, // Cards
    dividerColor: Colors.white24, // Dialogs
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: Colors.black, // FAB background
      foregroundColor: Colors.white, // FAB foreground
    ),
    navigationBarTheme: const NavigationBarThemeData(
      backgroundColor: Colors.black, // Bottom navigation bar
      indicatorColor: Colors.white, // Selected item indicator
    ),
    textSelectionTheme: const TextSelectionThemeData(
      cursorColor: Colors.white, // Cursor color
      selectionColor: Colors.white38, // Text selection color
      selectionHandleColor: Colors.white, // Handle color
    ),

    bottomAppBarTheme: const BottomAppBarThemeData(color: Colors.black),
    dialogTheme: const DialogThemeData(backgroundColor: Colors.black),
    // Add other properties as needed...
  ),
};
