import 'package:flutter/material.dart';
import 'app_colors.dart';

extension ThemeExtension on BuildContext {
  // Get theme-aware background color
  Color get backgroundColor {
    return Theme.of(this).brightness == Brightness.dark
        ? AppColors.backgroundDark
        : AppColors.background;
  }

  // Get theme-aware card color
  Color get cardColor {
    return Theme.of(this).brightness == Brightness.dark
        ? AppColors.cardDark
        : AppColors.card;
  }

  // Get theme-aware foreground/text color
  Color get foregroundColor {
    return Theme.of(this).brightness == Brightness.dark
        ? AppColors.foregroundDark
        : AppColors.foreground;
  }

  // Get theme-aware muted foreground color
  Color get mutedForegroundColor {
    return Theme.of(this).brightness == Brightness.dark
        ? AppColors.mutedForegroundDark
        : AppColors.mutedForeground;
  }

  // Get theme-aware border color
  Color get borderColor {
    return Theme.of(this).brightness == Brightness.dark
        ? AppColors.borderDark
        : AppColors.border;
  }

  // Get theme-aware muted background color
  Color get mutedColor {
    return Theme.of(this).brightness == Brightness.dark
        ? AppColors.mutedDark
        : AppColors.muted;
  }
}

