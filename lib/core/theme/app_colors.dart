import 'package:flutter/material.dart';

class AppColors {
  // Primary Colors
  static const Color primary = Color(0xFF2196F3); // hsl(207, 85%, 51%)
  static const Color primaryForeground = Color(0xFFFFFFFF);
  
  // Accent Colors
  static const Color accent = Color(0xFF26A69A); // hsl(180, 70%, 45%)
  static const Color accentForeground = Color(0xFFFFFFFF);
  
  // Background Colors - Light Mode
  static const Color background = Color(0xFFFFFFFF);
  static const Color foreground = Color(0xFF1A1D21); // hsl(220, 20%, 10%)
  
  // Card Colors
  static const Color card = Color(0xFFFFFFFF);
  static const Color cardForeground = Color(0xFF1A1D21);
  
  // Muted Colors
  static const Color muted = Color(0xFFF1F3F5); // hsl(220, 15%, 95%)
  static const Color mutedForeground = Color(0xFF6B7280); // hsl(220, 10%, 45%)
  
  // Border Colors
  static const Color border = Color(0xFFE5E7EB); // hsl(220, 15%, 90%)
  static const Color inputBorder = Color(0xFFE5E7EB);
  
  // Custom Suvidha Colors
  static const Color suvidhaBlue = Color(0xFF2196F3);
  static const Color suvidhaDark = Color(0xFF1A1F2E); // hsl(220, 25%, 12%)
  static const Color suvidhaCyan = Color(0xFF26A69A); // hsl(185, 75%, 45%)
  static const Color suvidhaLightBlue = Color(0xFFE3F2FD); // hsl(207, 85%, 96%)
  static const Color suvidhaNavy = Color(0xFF1A365D); // hsl(220, 50%, 20%)
  
  // Gradient Colors
  static const LinearGradient navGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [suvidhaCyan, suvidhaBlue],
  );
  
  static const LinearGradient buttonGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [suvidhaBlue, Color(0xFF1976D2)],
  );
  
  // Status Colors
  static const Color success = Color(0xFF22C55E);
  static const Color warning = Color(0xFFF59E0B);
  static const Color error = Color(0xFFEF4444);
  static const Color amber = Color(0xFFFBBF24);
  
  // Dark Mode Colors
  static const Color backgroundDark = Color(0xFF121418); // hsl(220, 25%, 8%)
  static const Color foregroundDark = Color(0xFFFAFAFA);
  static const Color cardDark = Color(0xFF1A1F2E);
  static const Color cardForegroundDark = Color(0xFFFAFAFA);
  static const Color mutedDark = Color(0xFF262D3D);
  static const Color mutedForegroundDark = Color(0xFF9CA3AF);
  static const Color borderDark = Color(0xFF2D3748);
}


