import 'package:flutter/material.dart';

class AppColors {
  static const Color primary = Color(0xFFFF0083);
  static const Color primaryLight = Color(0xFFFF4DA6);
  static const Color primaryDark = Color(0xFFCC0066);
  
  static const Color secondary = Color(0xFF9C27B0);
  static const Color secondaryLight = Color(0xFFBA68C8);
  static const Color secondaryDark = Color(0xFF7B1FA2);
  
  static const Color accent = Color(0xFF00BCD4);
  static const Color accentLight = Color(0xFF4DD0E1);
  
  static const Color white = Color(0xFFFFFFFF);
  static const Color gray = Color(0xFFF7F7F7);
  static const Color textDark = Color(0xFF333333);
  static const Color textLight = Color(0xFF666666);
  static const Color error = Color(0xFFD32F2F);

  static const Color slate50 = Color(0xFFFAFAFA);
  static const Color slate100 = Color(0xFFE7E5E4);
  static const Color slate200 = Color(0xFFD6D3D1);
  static const Color slate300 = Color(0xFFCED0CE);
  static const Color slate400 = Color(0xFFADB5BD);
  static const Color slate500 = Color(0xFF8899A6);
  static const Color slate600 = Color(0xFF525252);
  static const Color slate700 = Color(0xFF3C3C3C);
  static const Color slate800 = Color(0xFF272727);
  static const Color slate900 = Color(0xFF1A1A1A);
  
  static const Color backgroundLight = Color(0xFFF8F7FC);
  static const Color backgroundLighter = Color(0xFFFCFBFF);
  
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [primary, primaryLight],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  
  static const LinearGradient secondaryGradient = LinearGradient(
    colors: [secondary, secondaryLight],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  
  static const LinearGradient accentGradient = LinearGradient(
    colors: [primaryLight, secondaryLight],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}
