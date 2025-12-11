import 'package:flutter/material.dart';

/// App size constants for consistent spacing
class AppSizes {
  AppSizes._();

  // Padding & Margin
  static const double paddingXS = 4.0;
  static const double paddingS = 8.0;
  static const double paddingM = 16.0;
  static const double paddingL = 24.0;
  static const double paddingXL = 32.0;
  static const double paddingXXL = 48.0;

  // Border Radius
  static const double radiusS = 8.0;
  static const double radiusM = 12.0;
  static const double radiusL = 16.0;
  static const double radiusXL = 24.0;
  static const double radiusCircle = 100.0;

  // Icon Sizes
  static const double iconS = 16.0;
  static const double iconM = 24.0;
  static const double iconL = 32.0;
  static const double iconXL = 48.0;

  // Font Sizes
  static const double fontXS = 10.0;
  static const double fontS = 12.0;
  static const double fontM = 14.0;
  static const double fontL = 16.0;
  static const double fontXL = 20.0;
  static const double fontXXL = 24.0;
  static const double fontTitle = 28.0;
  static const double fontHeader = 32.0;

  // Button Heights
  static const double buttonHeight = 56.0;
  static const double buttonHeightS = 44.0;

  // Card
  static const double cardElevation = 4.0;
  static const double cardRadius = 16.0;

  // App Bar
  static const double appBarHeight = 60.0;

  // Bottom Navigation
  static const double bottomNavHeight = 70.0;

  // FAB
  static const double fabSize = 56.0;

  // Spacing Widget helpers
  static const SizedBox verticalSpaceXS = SizedBox(height: paddingXS);
  static const SizedBox verticalSpaceS = SizedBox(height: paddingS);
  static const SizedBox verticalSpaceM = SizedBox(height: paddingM);
  static const SizedBox verticalSpaceL = SizedBox(height: paddingL);
  static const SizedBox verticalSpaceXL = SizedBox(height: paddingXL);

  static const SizedBox horizontalSpaceXS = SizedBox(width: paddingXS);
  static const SizedBox horizontalSpaceS = SizedBox(width: paddingS);
  static const SizedBox horizontalSpaceM = SizedBox(width: paddingM);
  static const SizedBox horizontalSpaceL = SizedBox(width: paddingL);
  static const SizedBox horizontalSpaceXL = SizedBox(width: paddingXL);
}
