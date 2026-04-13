import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
/// The [AppTheme] defines light and dark themes for the app.
///
/// Theme setup for FlexColorScheme package v8.
/// Use same major flex_color_scheme package version. If you use a
/// lower minor version, some properties may not be supported.
/// In that case, remove them after copying this theme to your
/// app or upgrade the package to version 8.4.0.
///
/// Use it in a [MaterialApp] like this:
///
/// MaterialApp(
///   theme: AppTheme.light,
///   darkTheme: AppTheme.dark,
/// );
abstract final class AppTheme {
  // The FlexColorScheme defined light mode ThemeData.
  static ThemeData light = FlexThemeData.light(
    // Using FlexColorScheme built-in FlexScheme enum based colors
    scheme: FlexScheme.shadBlue,
    // Component theme configurations for light mode.
    subThemesData: const FlexSubThemesData(
      inputDecoratorIsFilled: true,
      alignedDropdown: true,
      tooltipRadius: 4,
      tooltipSchemeColor: SchemeColor.inverseSurface,
      tooltipOpacity: 0.9,
      snackBarElevation: 6,
      snackBarBackgroundSchemeColor: SchemeColor.inverseSurface,
      navigationRailUseIndicator: true,
    ),
    // ColorScheme seed generation configuration for light mode.
    keyColors: const FlexKeyColors(
    ),
    // Direct ThemeData properties.
    visualDensity: FlexColorScheme.comfortablePlatformDensity,
    cupertinoOverrideTheme: const CupertinoThemeData(applyThemeToAll: true),
  );

  // The FlexColorScheme defined dark mode ThemeData.
  static ThemeData dark = FlexThemeData.dark(
    // Using FlexColorScheme built-in FlexScheme enum based colors.
    scheme: FlexScheme.shadBlue,
    // Component theme configurations for dark mode.
    subThemesData: const FlexSubThemesData(
      blendOnColors: true,
      inputDecoratorIsFilled: true,
      alignedDropdown: true,
      tooltipRadius: 4,
      tooltipSchemeColor: SchemeColor.inverseSurface,
      tooltipOpacity: 0.9,
      snackBarElevation: 6,
      snackBarBackgroundSchemeColor: SchemeColor.inverseSurface,
      navigationRailUseIndicator: true,
    ),
    // ColorScheme seed configuration setup for dark mode.
    keyColors: const FlexKeyColors(
    ),
    // Direct ThemeData properties.
    visualDensity: FlexColorScheme.comfortablePlatformDensity,
    cupertinoOverrideTheme: const CupertinoThemeData(applyThemeToAll: true),
  );
}
