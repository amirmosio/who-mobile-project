import 'package:flutter/material.dart';

class BZColors {
  BZColors._privateConstructor();

  /// main/primary colors
  static const Color bronzeLight = Color(0xFFFBC295);
  static const Color bronzeDark = Color(0xFFBF6B50);
  static const Color details = Color(0xFFF2DDCC);
  static const Color background = Color(0xFFFDFDFD);
  static const Color transparentCardBackground = Color(0x88F2DDCC);
  static const Color bannerGrey = Color(0x88A9A9A9);
  static const Color textFieldHintAndBorderGrey = Color(0xFFCFCFCF);
  static const Color sliderIndexGrey = Color(0x88434343);
  static const Color cardBorderApartmentDetail = Color(0xFFF2DDCC);

  static const Color checkIconDownloadGrey = Color(0xFFCACACA);
  static const Color downloadButtonBackground = Color(0xFFFBFBFB);

  /// shimmer colors
  static const Color shimmer1 = Color(0xFFEBEBF4);
  static const Color shimmer2 = Color(0xFFF4F4F4);
  static const Color shimmer3 = Color(0xFFEBEBF4);

  static const List<Color> shimmerColors = [shimmer1, shimmer2, shimmer3];

  static const Color chartBoxShadowBronzeLight = Color(0xFFF2DDCC);
  static const Color chartBoxShadowBronzeDark = Color(0xFFD79F8D);

  static const Color textOnDarkBronze = Colors.white;
}

class BSColors {
  BSColors._privateConstructor();

  /// main/primary colors
  static const Color redPrimary = Color(0xFFF83C3C);
  static const Color white = Colors.white;
  static const Color black = Colors.black;
  static const Color redBackground = Color(0xFFFACCCC);
  static const Color redProgressBackground = Color(0xFFFFDCDC);
  static const Color redColorSelected = Color(0xFFFB5F5F);

  static const Color pinkSubBackground = Color(0xFFFA85BF);

  static const Color purpleDarkBackground = Color(0xFFA054ED);
  static const Color purpleSubBackground = Color(0xFFBF7FFF);
  static const Color purpleSubSubBackground = Color(0xFFEFD8FD);
  static const Color purpleStartProgress = Color(0xFF3F0069);
  static const Color purpleEndProgress = Color(0xFFB60F9A);

  static const Color blueDarkBackground = Color(0xFF6C71FF);
  static const Color blueSubSubBackground = Color(0xFFD9D8FD);
  static const Color blueSubBackground = Color(0xFF7F7FFF);
  static const Color blueSub2Background = Color(0xFF7F94FF);
  static const Color blueStartProgress = Color(0xFF06005B);
  static const Color blueEndProgress = Color(0xFF0C79F5);

  static const Color lightBlueDarkBackground = Color(0xFF5EB7EE);
  static const Color lightBlueSubBackground = Color(0xFF8BD4F4);
  static const Color lightBlueSubSubBackground = Color(0xFFD8FDF8);
  static const Color lightBlueStartProgress = Color(0xFF001F3C);
  static const Color lightBlueEndProgress = Color(0xFF319BFF);

  static const Color redDarkBackground = Color(0xFFFF6C6C);
  static const Color redDark2Background = Color(0xFFF8B5B5);
  static const Color redSubBackground = Color(0xFFFA8585);
  static const Color redSubSubBackground = Color(0xFFFDD8D8);
  static const Color redStartProgress = Color(0xFF5B0000);
  static const Color redEndProgress = Color(0xFFFF0E0E);

  static const Color redPlayButton1 = Color(0xFFF85454);
  static const Color redPlayButton2 = Color(0xFFF73B3B);

  static const Color progressCounterItem = Color(0xFFF7E5E5);

  /// Badge background colors
  /// Gold
  static const Color goldBackground = Color(0xFFfad272);
  static const Color goldBackground2 = Color(0xFFb28e2d);

  /// Silver
  static const Color silverBackground = Color(0xFFeaeaea);
  static const Color silverBackground2 = Color(0xFF5e5e5e);

  /// Bronze
  static const Color bronzeBackground = Color(0xFFfdbf86);
  static const Color bronzeBackground2 = Color(0xFF6a3a0c);

  static const Color greenProgress = Color(0xFF178222);
  static const Color redProgress = Color(0xFFF83C3C);

  static const Color profileGrey = Colors.grey;
}

class YRColors {
  YRColors._privateConstructor();

  /// Guida e Vai orange color from design
  static const Color guidaEvaiOrange = Color(0xFFF29915);
}

class GVColors {
  GVColors._privateConstructor();

  // Basic colors
  static const Color white = Colors.white;
  static const Color black = Colors.black;
  static const Color transparent = Colors.transparent;
  static const Color grey = Colors.grey;
  static const Color black54 = Colors.black54;

  // Commonly used hex colors
  static const Color lightGreyBackground = Color(0xFFF4F4F4);
  static const Color borderGrey = Color(0xFFD9D9D9);
  static const Color textGrey = Color(0xFF666666);
  static const Color lightTextGrey = Color(0xFF717171);
  static const Color mediumGrey = Color(0xFFAAAAAA);
  static const Color cardBorderGrey = Color(0xFFC6C6C6);

  // Button and interactive colors
  static const Color orange = Color(0xFFFF6900);
  static const Color orangeWithAlpha = Color(0x26FF6900); // 15% alpha
  static const Color greenSuccess = Color(0xFF56A42D);
  static const Color redError = Color(0xFFA91717);
  static const Color redDanger = Color(0xFFFF2828);
  static const Color redAlert = Color(0xFFFF5757);
  static const Color blueInfo = Color(0xFF13AEF6);
  static const Color yellowWarning = Color(0xFFF5AD44);
  static const Color yellowWarningWithAlpha = Color(0x66F5AD44); // 40% alpha

  // Background colors with transparency
  static const Color whiteWithAlpha75 = Color(0xBFFFFFFF); // 75% alpha
  static const Color whiteWithAlpha50 = Color(0x80FFFFFF); // 50% alpha
  static const Color greyWithAlpha30 = Color(0x4D9E9E9E); // 30% alpha
  static const Color blackWithAlpha30 = Color(0x4D000000); // 30% alpha
  static const Color blackWithAlpha50 = Color(0x80000000); // 50% alpha
  static const Color blackWithAlpha60 = Color(0x99000000); // 60% alpha
  static const Color blackWithAlpha87 = Color(0xDD000000); // 87% alpha

  // Additional UI colors found in widgets
  static const Color lightBorderGrey = Color(0xFFD6D6D6);
  static const Color lightGreyButton = Color(0xFFE0E0E0);
  static const Color mediumLightGrey = Color(0xFFBABABA);
  static const Color darkMediumGrey = Color(0xFF818181);
  static const Color lightestGrey = Color(0xFFF5F5F5);

  // Material Design blue (used in time picker)
  static const Color materialBlue = Color(0xFF1976D2);

  // Orange from YRColors for reference (to avoid duplication)
  static const Color guidaEvaiOrange = YRColors.guidaEvaiOrange;
  static const Color guidaEvaiOrangeWithAlpha60 = Color(
    0x99F29915,
  ); // 60% alpha
  static const Color guidaEvaiOrangeWithAlpha10 = Color(
    0x1AF29915,
  ); // 10% alpha

  // Additional specific colors
  static const Color purpleBanner = Color(0xFF5967FF);
  static const Color darkGreen = Color(0xFF008C15);
  static const Color darkGreyBorder = Color(0xFF484848);
  static const Color blackWithAlpha10 = Color(0x1A000000); // 10% alpha

  // Quiz and error specific colors
  static const Color redError2 = Color(0xFFF20000); // Brighter red for errors
  static const Color orangeAccent = Color(
    0xFFED7E00,
  ); // Orange accent for video links
  static const Color darkGreyText = Color(0xFF3B3B3B); // Dark grey for text
  static const Color lightGreyText = Color(
    0xFF858585,
  ); // Light grey for small text
  static const Color lightGreyBorder = Color(0xFFD0D0D0); // Light border color
  static const Color tealChart = Color(0xFF00D4CC); // Teal for charts

  // Quiz result colors
  static const Color greenCorrect = Color(
    0xFF348D00,
  ); // Green for correct answers
  static const Color greenCorrectBg = Color(
    0x33348D00,
  ); // Green background with alpha
  static const Color greyUnanswered = Color(0xFFB0B0B0); // Grey for unanswered
  static const Color greyUnansweredBg = Color(
    0x66C9C9C9,
  ); // Grey background with alpha
  static const Color orangeIncorrect = Color(
    0xFFF56A44,
  ); // Orange for incorrect
  static const Color orangeIncorrectBg = Color(
    0x66F56A44,
  ); // Orange background with alpha

  // Additional button colors
  static const Color greenSuccess2 = Color(
    0xFF4AAE4E,
  ); // Alternative green for buttons

  // Profile and settings specific colors
  static const Color lightGreyProfile = Color(0xFF747474); // Profile email text
  static const Color orangeShadow = Color(0xFFFF9E54); // Profile avatar shadow
  static const Color inactiveSwitch = Color(
    0xFF95959B,
  ); // Inactive switch track
  static const Color lightPinkProgress = Color(
    0xFFFFB6C8,
  ); // Progress bar background

  // Additional colors for UI components
  static const Color greyIcon = Color(0xFF767676); // Grey for icons
  static const Color greyFieldBackground = Color(
    0xFFF8F8F8,
  ); // Form field background
  static const Color violaChiaroMessageBackground = Color(
    0xFFE1D2FF,
  ); // Viola chiaro message background
  static const Color violaVoiceIcon = Color(0xFF874BFF); // Viola voice icon
  static const Color eliminateButtonColor = Color(
    0xFFDC2726,
  ); // Eliminate button color
  static const Color downloadButtonBorder = Color(
    0xFFDFDFDF,
  ); // Download button border
  static const Color inactiveNavItemColor = Color(
    0xFFBFBFBF,
  ); // Inactive nav item color
  static const Color lightGreyHint = Color(0xFF8D8D8D); // Form hint text
  static const Color darkTextBlack = Color(0xFF1C1C1E); // Dark text color
  static const Color greenSuccessWithAlpha10 = Color(
    0x1A56A42D,
  ); // Green background with 10% alpha
  static const Color greenSuccessWithAlpha40 = Color(
    0x6656A42D,
  ); // Green background with 40% alpha
  static const Color greenSuccessWithAlpha50 = Color(
    0x8056A42D,
  ); // Green background with 50% alpha
  static const Color greenDarkText = Color(0xFF386E1C); // Dark green text
  static const Color yellowPendingBg = Color(
    0x99FFC516,
  ); // Yellow background with 60% alpha
  static const Color yellowPendingText = Color(0xFFBD8E00); // Yellow text
  static const Color greyMissingBg = Color(
    0xCCD9D9D9,
  ); // Grey background with 80% alpha
  static const Color greyMissingText = Color(0xFF797979); // Grey text
  static const Color dividerGrey = Color(0xFFE5E5E5); // Divider line color
  static const Color lightGrey2 = Color(
    0xFFB3B3B3,
  ); // Light grey for status text
  static const Color purpleAccent = Color(0xFF3700A4); // Purple for checkboxes
  static const Color redLive = Color(0xFFFF2828); // Red for live indicators
  static const Color redLiveAccent = Color(0xFFFF5757); // Red accent for live
  static const Color lightGreyCard = Color(0xFFF8F8F8); // Light grey for cards
  static const Color dividerLight = Color(0xFFD1D1D1); // Light divider color
  static const Color orangeWithAlpha20 = Color(
    0x33F29915,
  ); // Orange with 20% alpha

  // Dashboard and feature card colors
  static const Color blueFeature = Color(
    0xFF13AEF6,
  ); // Blue for lessons feature
  static const Color greenFeature = Color(0xFF22A866); // Green for live feature
  static const Color purpleFeature = Color(
    0xFFC547DB,
  ); // Purple for statistics feature
  static const Color indigoFeature = Color(
    0xFF6273CF,
  ); // Indigo for guides feature
  static const Color redOrangeFeature = Color(
    0xFFFF592B,
  ); // Red-orange for license feature
  static const Color blackWithAlpha3 = Color(
    0x08000000,
  ); // Black with 3% alpha for shadows

  // Event/reservation status colors
  static const Color eventPending = Color(0x88FFC300);
  static const Color eventConfirmed = Color(0x770000FF);
  static const Color eventApproved = Color(0x77008000);
  static const Color eventRejected = Color(0x77FF0000);
}
