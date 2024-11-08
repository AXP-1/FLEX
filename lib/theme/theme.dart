import 'package:flutter/material.dart';

final ThemeData darkTheme = ThemeData(
  useMaterial3: true,
  appBarTheme: const AppBarTheme(
    backgroundColor: Colors.black,
    elevation: 0.0,
    surfaceTintColor: Colors.black,
  ),
  brightness: Brightness.dark,
  tabBarTheme: const TabBarTheme(
    labelColor: Colors.white, // لون النص النشط
    unselectedLabelColor: Colors.grey, // لون النص غير النشط
    indicator: BoxDecoration(
      border: Border(
        bottom: BorderSide(color: Colors.white, width: 3.0), // مؤشر التبويب
      ),
    ),
  ),
  colorScheme: const ColorScheme.dark(
    brightness: Brightness.dark,
    surface: Colors.black,
    onSurface: Colors.white,
    surfaceTint: Colors.black12,
    primary: Colors.white,
    onPrimary: Colors.black,
  ),
  navigationBarTheme: const NavigationBarThemeData(
    height: 55,
    indicatorColor: Colors.transparent,
    elevation: 5.0,
    labelBehavior: NavigationDestinationLabelBehavior.alwaysHide,
    backgroundColor: Colors.black,
    iconTheme: WidgetStatePropertyAll<IconThemeData>(
      IconThemeData(
        color: Colors.white,
        size: 30,
      ),
    ),
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ButtonStyle(
      backgroundColor: WidgetStateProperty.all(Colors.white),
      foregroundColor: WidgetStateProperty.all(Colors.black),
    ),
  ),
  outlinedButtonTheme: OutlinedButtonThemeData(
    style: ButtonStyle(
      shape: WidgetStateProperty.all(
        RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
          side: const BorderSide(color: Colors.transparent),
        ),
      ),
      backgroundColor: WidgetStateProperty.all<Color>(
        const Color(0xff242424),
      ),
      minimumSize: WidgetStateProperty.all(Size.zero),
      padding: WidgetStateProperty.all<EdgeInsets>(
        const EdgeInsets.symmetric(
          vertical: 5,
          horizontal: 10,
        ),
      ),
    ),
  ),
);

final ThemeData lightTheme = ThemeData(
  useMaterial3: true,
  appBarTheme: const AppBarTheme(
    backgroundColor: Colors.white,
    elevation: 0.0,
    surfaceTintColor: Colors.white,
  ),
  brightness: Brightness.light,
  tabBarTheme: const TabBarTheme(
    labelColor: Colors.black, // لون النص النشط
    unselectedLabelColor: Colors.grey, // لون النص غير النشط
    indicator: BoxDecoration(
      border: Border(
        bottom: BorderSide(color: Colors.black, width: 3.0), // مؤشر التبويب
      ),
    ),
  ),
  colorScheme: const ColorScheme.light(
    brightness: Brightness.light,
    surface: Colors.white,
    onSurface: Colors.black,
    surfaceTint: Colors.black12,
    primary: Colors.black,
    onPrimary: Colors.white,
  ),
  navigationBarTheme: const NavigationBarThemeData(
    height: 55,
    indicatorColor: Colors.transparent,
    elevation: 5.0,
    labelBehavior: NavigationDestinationLabelBehavior.alwaysHide,
    backgroundColor: Colors.white,
    iconTheme: WidgetStatePropertyAll<IconThemeData>(
      IconThemeData(
        color: Colors.black,
        size: 30,
      ),
    ),
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ButtonStyle(
      backgroundColor: WidgetStateProperty.all(Colors.black),
      foregroundColor: WidgetStateProperty.all(Colors.white),
    ),
  ),
  outlinedButtonTheme: OutlinedButtonThemeData(
    style: ButtonStyle(
      shape: WidgetStateProperty.all(
        RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
          side: const BorderSide(color: Colors.transparent),
        ),
      ),
      backgroundColor: WidgetStateProperty.all<Color>(
        const Color(0xfff1f1f1),
      ),
      minimumSize: WidgetStateProperty.all(Size.zero),
      padding: WidgetStateProperty.all<EdgeInsets>(
        const EdgeInsets.symmetric(
          vertical: 5,
          horizontal: 10,
        ),
      ),
    ),
  ),
);
