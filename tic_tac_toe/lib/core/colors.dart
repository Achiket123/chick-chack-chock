import 'package:flutter/material.dart';

class AppColors {
  // Dark Theme Base Colors
  static const Color primaryColor = Color(0xFFBB86FC); // Soft Purple
  static const Color secondaryColor = Color(0xFF03DAC6); // Teal
  static const Color backgroundColor = Color(0xFF121212); // True Black
  static const Color surfaceColor = Color(
    0xFF1E1E1E,
  ); // Slightly lighter black for cards
  static const Color textColor = Color(0xFFEDEDED); // Light gray-white
  static const Color disabledTextColor = Color(0xFF777777); // Muted gray

  // Feedback Colors
  static const Color errorColor = Color(0xFFCF6679); // Desaturated red
  static const Color successColor = Color(0xFF00E676); // Green Accent
  static const Color warningColor = Color(0xFFFFC400); // Amber
  static const Color infoColor = Color(0xFF64B5F6); // Light Blue

  // Button Colors
  static const Color buttonColor = primaryColor;
  static const Color buttonTextColor = backgroundColor;
  static const Color buttonBorderColor = Color(0xFFBB86FC);
  static const Color buttonDisabledColor = Color(0xFF2C2C2C);
  static const Color buttonDisabledTextColor = disabledTextColor;
  static const Color buttonDisabledBorderColor = Color(0xFF2C2C2C);

  // Dark ThemeData
  static ThemeData themeData = ThemeData(
    scrollbarTheme: ScrollbarThemeData(),
    brightness: Brightness.dark,
    primaryColor: primaryColor,
    scaffoldBackgroundColor: backgroundColor,
    canvasColor: backgroundColor,
    cardColor: surfaceColor,

    fontFamily: 'Roboto',
    colorScheme: ColorScheme(
      brightness: Brightness.dark,
      primary: primaryColor,
      primaryContainer: Color(0xFF3700B3),
      secondary: secondaryColor,
      secondaryContainer: Color(0xFF03DAC6),
      surface: surfaceColor,
      background: backgroundColor,
      error: errorColor,
      onPrimary: backgroundColor,
      onSecondary: backgroundColor,
      onSurface: textColor,
      onBackground: textColor,
      onError: backgroundColor,
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: Color(0xFF1F1B24),
      foregroundColor: Colors.white,
      elevation: 0,
      titleTextStyle: TextStyle(
        color: Colors.white,
        fontSize: 20,
        fontWeight: FontWeight.w600,
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        foregroundColor: buttonTextColor,
        backgroundColor: buttonColor,
        disabledBackgroundColor: buttonDisabledColor,
        disabledForegroundColor: buttonDisabledTextColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        elevation: 2,
      ),
    ),
    textTheme: const TextTheme(
      bodyLarge: TextStyle(color: textColor),
      bodyMedium: TextStyle(color: textColor),
      labelLarge: TextStyle(color: textColor),
      titleLarge: TextStyle(color: textColor, fontWeight: FontWeight.bold),
    ),
  );
}
