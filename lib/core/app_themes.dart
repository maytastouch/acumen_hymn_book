import 'package:flutter/material.dart';

import 'constants/app_colors.dart';

// ignore: constant_identifier_names
enum AppTheme { LightTheme, DarkTheme }

final appThemeData = {
  AppTheme.LightTheme: ThemeData(
    brightness: Brightness.light,
    primaryColor: AppColors.pageColor, // Using your main color
    scaffoldBackgroundColor: AppColors.pageColor, // Scaffold background
    appBarTheme: const AppBarTheme(
      color: Colors.white, // AppBar background
      iconTheme: IconThemeData(color: Colors.black), // AppBar icons
      foregroundColor: Colors.black, // AppBar text color
    ), // BottomAppBar
    cardColor: AppColors.pageColor, // Cards
    dividerColor: Colors.black12, // General background color
    dialogBackgroundColor: AppColors.pageColor, // Dialogs
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: AppColors.pageColor, // FAB background
      foregroundColor: Colors.black, // FAB foreground
    ),
    navigationBarTheme: const NavigationBarThemeData(
      backgroundColor: AppColors.pageColor, // Bottom navigation bar
      indicatorColor: Colors.black, // Selected item indicator
    ),
    textSelectionTheme: const TextSelectionThemeData(
      cursorColor: Colors.black, // Cursor color
      selectionColor: Colors.black26, // Text selection color
      selectionHandleColor: Colors.black, // Handle color
    ),

    bottomAppBarTheme: const BottomAppBarTheme(color: AppColors.pageColor),
    // Define additional properties as needed...
  ),
  AppTheme.DarkTheme: ThemeData(
    brightness: Brightness.dark,
    primaryColor: Colors.black,
    scaffoldBackgroundColor: Colors.black, // Scaffold background
    appBarTheme: const AppBarTheme(
      color: Colors.black, // AppBar background
      iconTheme: IconThemeData(color: Colors.white), // AppBar icons
    ), // BottomAppBar
    cardColor: Colors.black, // Cards
    dividerColor: Colors.white24, // Background color for widgets like Drawer
    dialogBackgroundColor: Colors.black, // Dialogs
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

    bottomAppBarTheme: const BottomAppBarTheme(color: Colors.black),
    // Add other properties as needed...
  ),
};
