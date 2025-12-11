import 'package:flutter/material.dart';
import 'package:who_mobile_project/app_core/theme/colors.dart';
import 'package:who_mobile_project/app_core/theme/text_styles/app_text_styles.dart';

class YRTheme {
  static ThemeData get theme => getTheme(false);

  static ThemeData getTheme(bool isDsaFontEnabled) {
    return ThemeData(
      fontFamily: isDsaFontEnabled ? "EasyReadingPRO" : "Inter",
      scaffoldBackgroundColor: GVColors.white,
      colorScheme: ColorScheme(
        brightness: Brightness.light,
        primary: GVColors.purpleAccent,
        onPrimary: GVColors.white,
        primaryContainer: GVColors.purpleAccent,
        onPrimaryContainer: GVColors.white,
        secondary: GVColors.guidaEvaiOrange,
        onSecondary: GVColors.white,
        secondaryContainer: GVColors.guidaEvaiOrangeWithAlpha10,
        onSecondaryContainer: GVColors.guidaEvaiOrange,
        surface: GVColors.white,
        onSurface: GVColors.black,
        surfaceContainerHighest: GVColors.lightGreyBackground,
        onSurfaceVariant: GVColors.textGrey,
        outline: GVColors.borderGrey,
        outlineVariant: GVColors.lightBorderGrey,
        error: GVColors.redError,
        onError: GVColors.white,
        errorContainer: GVColors.redAlert,
        onErrorContainer: GVColors.white,
      ),

      // Text Theme using centralized AppTextStyles
      textTheme: TextTheme(
        // Headlines
        headlineLarge: AppTextStyles.headingH0.copyWith(color: GVColors.black),
        headlineMedium: AppTextStyles.headingH1.copyWith(color: GVColors.black),
        headlineSmall: AppTextStyles.headingH2.copyWith(color: GVColors.black),

        // Titles
        titleLarge: AppTextStyles.headingH2.copyWith(color: GVColors.black),
        titleMedium: AppTextStyles.headingH3.copyWith(color: GVColors.black),
        titleSmall: AppTextStyles.bodyTextStrong.copyWith(
          color: GVColors.black,
        ),

        // Body text
        bodyLarge: AppTextStyles.bodyText.copyWith(color: GVColors.black),
        bodyMedium: AppTextStyles.bodyText.copyWith(color: GVColors.textGrey),
        bodySmall: AppTextStyles.smallText.copyWith(
          color: GVColors.lightTextGrey,
        ),

        // Labels
        labelLarge: AppTextStyles.buttonPrimary.copyWith(color: GVColors.white),
        labelMedium: AppTextStyles.bodyTextBold.copyWith(color: GVColors.black),
        labelSmall: AppTextStyles.subtitleText.copyWith(
          color: GVColors.lightTextGrey,
        ),
      ),

      // ElevatedButton Theme - Used extensively throughout the app
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: GVColors.purpleAccent,
          foregroundColor: GVColors.white,
          disabledBackgroundColor: GVColors.mediumGrey,
          disabledForegroundColor: GVColors.white,
          elevation: 0,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(60),
          ),
          textStyle: AppTextStyles.buttonPrimary.copyWith(
            color: GVColors.white,
          ),
          minimumSize: const Size(120, 40),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        ),
      ),

      // TextButton Theme - Used for underlined actions
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: GVColors.purpleAccent,
          textStyle: AppTextStyles.buttonSecondary.copyWith(
            color: GVColors.purpleAccent,
            decoration: TextDecoration.underline,
          ),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        ),
      ),

      // OutlinedButton Theme - Used for secondary actions
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: GVColors.purpleAccent,
          side: const BorderSide(color: GVColors.purpleAccent, width: 1),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(60),
          ),
          textStyle: AppTextStyles.buttonPrimary.copyWith(
            color: GVColors.purpleAccent,
          ),
          minimumSize: const Size(120, 40),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        ),
      ),

      // InputDecoration Theme - Based on form field patterns
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: GVColors.lightGreyBackground,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: GVColors.borderGrey, width: 0.5),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: GVColors.borderGrey, width: 0.5),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(
            color: GVColors.guidaEvaiOrange,
            width: 1,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: GVColors.redError, width: 1),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: GVColors.redError, width: 1),
        ),
        contentPadding: const EdgeInsets.all(10),
        hintStyle: const TextStyle(
          fontSize: 12,
          color: GVColors.lightGreyHint,
          letterSpacing: -0.4771,
        ),
        labelStyle: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w300,
          letterSpacing: -0.4771,
          color: GVColors.black,
        ),
        errorStyle: AppTextStyles.inputFieldError,
      ),

      // AppBar Theme
      appBarTheme: AppBarTheme(
        backgroundColor: GVColors.white,
        foregroundColor: GVColors.black,
        elevation: 0,
        shadowColor: Colors.transparent,
        surfaceTintColor: GVColors.white,
        titleTextStyle: AppTextStyles.headingH2.copyWith(color: GVColors.black),
        toolbarTextStyle: AppTextStyles.bodyText.copyWith(
          color: GVColors.black,
        ),
        iconTheme: const IconThemeData(color: GVColors.black, size: 24),
        actionsIconTheme: const IconThemeData(color: GVColors.black, size: 24),
      ),

      // Card Theme
      cardTheme: const CardThemeData(
        color: GVColors.white,
        shadowColor: GVColors.blackWithAlpha10,
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(12)),
          side: BorderSide(color: GVColors.lightBorderGrey, width: 0.5),
        ),
        margin: EdgeInsets.all(8),
      ),

      // Divider Theme
      dividerTheme: const DividerThemeData(
        color: GVColors.dividerGrey,
        thickness: 1,
        space: 1,
      ),

      // Checkbox Theme
      checkboxTheme: CheckboxThemeData(
        fillColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return GVColors.purpleAccent;
          }
          return GVColors.white;
        }),
        checkColor: WidgetStateProperty.all(GVColors.white),
        side: const BorderSide(color: GVColors.borderGrey, width: 1),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(3)),
      ),

      // Switch Theme
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return GVColors.white;
          }
          return GVColors.white;
        }),
        trackColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return GVColors.purpleAccent;
          }
          return GVColors.inactiveSwitch;
        }),
      ),

      // Navigation themes
      navigationBarTheme: NavigationBarThemeData(
        height: 80,
        backgroundColor: GVColors.white,
        indicatorColor: GVColors.purpleAccent,
        labelTextStyle: WidgetStatePropertyAll(
          AppTextStyles.buttonNavigation.copyWith(color: GVColors.black),
        ),
      ),

      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: GVColors.white,
        selectedItemColor: GVColors.purpleAccent,
        unselectedItemColor: GVColors.inactiveNavItemColor,
        selectedLabelStyle: AppTextStyles.buttonNavigation.copyWith(
          color: GVColors.purpleAccent,
        ),
        unselectedLabelStyle: AppTextStyles.buttonNavigation.copyWith(
          color: GVColors.inactiveNavItemColor,
        ),
        type: BottomNavigationBarType.fixed,
        elevation: 8,
      ),

      // Progress Indicator Theme
      progressIndicatorTheme: const ProgressIndicatorThemeData(
        color: GVColors.purpleAccent,
        linearTrackColor: GVColors.lightGreyBackground,
        circularTrackColor: GVColors.lightGreyBackground,
      ),

      // Snackbar Theme
      snackBarTheme: SnackBarThemeData(
        backgroundColor: GVColors.blackWithAlpha87,
        contentTextStyle: AppTextStyles.bodyText.copyWith(
          color: GVColors.white,
        ),
        actionTextColor: GVColors.guidaEvaiOrange,
        behavior: SnackBarBehavior.floating,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(8)),
        ),
      ),
    );
  }
}
