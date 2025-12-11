import 'package:flutter/material.dart';
import 'package:who_mobile_project/app_core/theme/colors.dart';

/// Centralized text styles for the Guidaevai app
///
/// This file consolidates all text styles to ensure consistency across the app.
/// Styles are organized by categories: Headings, Body Text, Button Text, etc.
///
/// Usage: AppTextStyles.headingH1, AppTextStyles.bodyText, etc.
class AppTextStyles {
  // Private constructor to prevent instantiation
  AppTextStyles._();

  // ============================================================================
  // HEADINGS - Main headings (font family defined in theme)
  // ============================================================================

  /// Extra large heading (40px, w600) - for hero sections
  static const TextStyle headingH0 = TextStyle(
    fontSize: 40,
    fontWeight: FontWeight.w600,
    height: 1.2,
  );

  /// Large heading (30px, w600) - for page titles
  static const TextStyle headingH1 = TextStyle(
    fontSize: 30,
    fontWeight: FontWeight.w600,
    height: 1.2,
  );

  /// Medium heading (20px, w600) - for section titles
  static const TextStyle headingH2 = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.w600,
    height: 1.2,
  );

  /// Small heading (18px, w600) - for subsection titles
  static const TextStyle headingH3 = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w600,
    height: 1.2,
  );

  /// Extra small heading (16px, w600) - for card titles
  static const TextStyle headingH4 = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    height: 1.2,
  );

  // ============================================================================
  // BODY TEXT - Main content text (font family defined in theme)
  // ============================================================================

  /// Main body text (16px, w400)
  static const TextStyle bodyText = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w400,
    height: 1.5,
  );

  /// Strong body text (16px, w600)
  static const TextStyle bodyTextStrong = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    height: 1.5,
  );

  /// Bold body text (16px, w700)
  static const TextStyle bodyTextBold = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w700,
    height: 1.5,
  );

  /// Large body text (20px, w700) - for emphasis
  static const TextStyle bodyTextLarge = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.w700,
    height: 1.4,
  );

  /// Description text (16px, w500) - for descriptions
  static const TextStyle descriptionText = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w500,
    height: 1.5,
  );

  // ============================================================================
  // SMALL TEXT - For captions, labels, and secondary information
  // ============================================================================

  /// Small text (14px, w400)
  static const TextStyle smallText = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    height: 1.3,
  );

  /// Small bold text (14px, w700)
  static const TextStyle smallTextBold = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w700,
    height: 1.3,
  );

  /// Small strong text (14px, w600)
  static const TextStyle smallTextStrong = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w600,
    height: 1.3,
  );

  /// Light small text (14px, w200)
  static const TextStyle smallTextLight = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w200,
    height: 1.3,
  );

  /// Subtitle text (12px, w400)
  static const TextStyle subtitleText = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w400,
    height: 1.3,
  );

  static const TextStyle subtitleTextLight = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w300,
    height: 1.3,
  );

  // ============================================================================
  // BUTTON TEXT - For various button styles
  // ============================================================================

  /// Primary button text (18px, w800)
  static const TextStyle buttonPrimary = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w800,
    height: 1.2,
  );

  /// Secondary button text (18px, w400)
  static const TextStyle buttonSecondary = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w400,
    height: 1.2,
  );

  /// Small button text (16px, w700)
  static const TextStyle buttonSmall = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w700,
    height: 1.2,
  );

  /// Navigation bar button text (14px, w600)
  static const TextStyle buttonNavigation = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w600,
    height: 1.2,
  );

  // ============================================================================
  // FORM FIELD TEXT - For input fields and labels
  // ============================================================================

  /// Input field label (16px, w300)
  static const TextStyle inputFieldLabel = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w300,
    height: 1.3,
  );

  static const TextStyle inputField = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w400,
  );

  /// Field title (18px, w500)
  static const TextStyle fieldTitle = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w500,
    height: 1.3,
  );

  /// Input field error text (12px, w400, Lato, red)
  static const TextStyle inputFieldError = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w400,
    color: GVColors.redError,
    height: 1.3,
  );

  // ============================================================================
  // SPECIAL PURPOSE TEXT - For specific UI components
  // ============================================================================

  /// Tab bar selected text (16px, w700)
  static const TextStyle tabBarSelected = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w700,
    height: 1.2,
  );

  /// Tab bar unselected text (16px, w300)
  static const TextStyle tabBarUnselected = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w300,
    height: 1.2,
  );

  /// Chart title text (14px, w700)
  static const TextStyle chartTitle = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w700,
    height: 1.2,
  );

  /// Chart value text (16px, w600)
  static const TextStyle chartValue = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    height: 1.2,
  );

  /// Settings title text (12px, w500)
  static const TextStyle settingsTitle = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w500,
    height: 1.2,
  );

  /// Settings action text (16px, w600)
  static const TextStyle settingsAction = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    height: 1.2,
  );

  /// Timer text (30px, w400)
  static const TextStyle timer = TextStyle(
    fontSize: 30,
    fontWeight: FontWeight.w400,
    height: 1.2,
  );

  /// Calling status text (20px, w400)
  static const TextStyle callingStatus = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.w400,
    height: 1.2,
  );

  /// Success message text (20px, w100)
  static const TextStyle successMessage = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.w100,
    height: 1.2,
  );

  /// Ranking board name text (14px, w500)
  static const TextStyle rankingBoardName = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w500,
    height: 1.2,
  );

  /// Suggested password text (14px, w600)
  static const TextStyle suggestedPassword = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w600,
    height: 1.2,
  );

  /// Card holder text (14px, w700)
  static const TextStyle cardHolder = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w700,
    height: 1.2,
  );

  /// IVA text (14px, w300)
  static const TextStyle ivaText = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w300,
    height: 1.2,
  );

  /// View detail text (14px, w300)
  static const TextStyle viewDetail = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w300,
    height: 1.2,
  );

  /// Slider index text (14px, w600)
  static const TextStyle sliderIndex = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w600,
    height: 1.2,
  );

  /// Booking confirmation title text (25px, w600)
  static const TextStyle bookingConfirmationTitle = TextStyle(
    fontSize: 25,
    fontWeight: FontWeight.w600,
    height: 1.2,
  );
}
