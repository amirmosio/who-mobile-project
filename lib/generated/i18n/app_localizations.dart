import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_it.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'i18n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('it'),
  ];

  /// No description provided for @welcome_back.
  ///
  /// In en, this message translates to:
  /// **'Welcome back!'**
  String get welcome_back;

  /// No description provided for @login.
  ///
  /// In en, this message translates to:
  /// **'Login'**
  String get login;

  /// No description provided for @enter_your_email.
  ///
  /// In en, this message translates to:
  /// **'Enter your email'**
  String get enter_your_email;

  /// No description provided for @email.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get email;

  /// No description provided for @password.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get password;

  /// No description provided for @enter_your_password.
  ///
  /// In en, this message translates to:
  /// **'Enter your password'**
  String get enter_your_password;

  /// No description provided for @forgot_password.
  ///
  /// In en, this message translates to:
  /// **'Forgot password'**
  String get forgot_password;

  /// No description provided for @communication_error.
  ///
  /// In en, this message translates to:
  /// **'Communication error'**
  String get communication_error;

  /// No description provided for @open.
  ///
  /// In en, this message translates to:
  /// **'Open'**
  String get open;

  /// Close button text for dialogs
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get close;

  /// No description provided for @manually.
  ///
  /// In en, this message translates to:
  /// **'Manually'**
  String get manually;

  /// Date label
  ///
  /// In en, this message translates to:
  /// **'Date:'**
  String get date;

  /// Time label
  ///
  /// In en, this message translates to:
  /// **'Time:'**
  String get time;

  /// No description provided for @mandatory_field.
  ///
  /// In en, this message translates to:
  /// **'Mandatory field'**
  String get mandatory_field;

  /// No description provided for @invalid_field.
  ///
  /// In en, this message translates to:
  /// **'Invalid input'**
  String get invalid_field;

  /// No description provided for @invalid_phone_number.
  ///
  /// In en, this message translates to:
  /// **'Invalid phone number format'**
  String get invalid_phone_number;

  /// No description provided for @phone_must_include_country_code.
  ///
  /// In en, this message translates to:
  /// **'Phone number must include country code (e.g., +39)'**
  String get phone_must_include_country_code;

  /// No description provided for @passwords_do_not_match.
  ///
  /// In en, this message translates to:
  /// **'Passwords do not match'**
  String get passwords_do_not_match;

  /// No description provided for @no_item_found.
  ///
  /// In en, this message translates to:
  /// **'No items found'**
  String get no_item_found;

  /// No description provided for @the_list_is_currently_empty.
  ///
  /// In en, this message translates to:
  /// **'The list is currently empty.'**
  String get the_list_is_currently_empty;

  /// No description provided for @please_try_again_later.
  ///
  /// In en, this message translates to:
  /// **'Please check your internet and try again later.'**
  String get please_try_again_later;

  /// No description provided for @unauthorized_request.
  ///
  /// In en, this message translates to:
  /// **'Your session is no longer valid. You need to log in again. Redirecting to the login page...'**
  String get unauthorized_request;

  /// No description provided for @select_dates.
  ///
  /// In en, this message translates to:
  /// **'Select dates'**
  String get select_dates;

  /// No description provided for @save.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// No description provided for @continue_as_guest.
  ///
  /// In en, this message translates to:
  /// **'Continue as Guest'**
  String get continue_as_guest;

  /// No description provided for @guest.
  ///
  /// In en, this message translates to:
  /// **'Guest'**
  String get guest;

  /// No description provided for @guest_account.
  ///
  /// In en, this message translates to:
  /// **'Guest Account'**
  String get guest_account;

  /// No description provided for @guest_account_type.
  ///
  /// In en, this message translates to:
  /// **'Guest Account'**
  String get guest_account_type;

  /// No description provided for @guest_user.
  ///
  /// In en, this message translates to:
  /// **'Guest User'**
  String get guest_user;

  /// No description provided for @guest_registration_successful.
  ///
  /// In en, this message translates to:
  /// **'Guest registration successful'**
  String get guest_registration_successful;

  /// No description provided for @guest_registration_description.
  ///
  /// In en, this message translates to:
  /// **'Create a temporary account to start using the app immediately. You can upgrade to a full account later.'**
  String get guest_registration_description;

  /// No description provided for @guest_account_limitations.
  ///
  /// In en, this message translates to:
  /// **'Note: Guest accounts have limited features and data is stored temporarily.'**
  String get guest_account_limitations;

  /// No description provided for @guest_account_info_description.
  ///
  /// In en, this message translates to:
  /// **'This is a temporary guest account. Create a full account to unlock all features and secure your data.'**
  String get guest_account_info_description;

  /// No description provided for @guest_conversion_benefits.
  ///
  /// In en, this message translates to:
  /// **'Get full access, secure data storage, and personalized features.'**
  String get guest_conversion_benefits;

  /// No description provided for @convert_to_full_account.
  ///
  /// In en, this message translates to:
  /// **'Upgrade Account'**
  String get convert_to_full_account;

  /// No description provided for @upgrade_your_account.
  ///
  /// In en, this message translates to:
  /// **'Upgrade Your Account'**
  String get upgrade_your_account;

  /// No description provided for @upgrade.
  ///
  /// In en, this message translates to:
  /// **'Upgrade'**
  String get upgrade;

  /// No description provided for @dismiss.
  ///
  /// In en, this message translates to:
  /// **'Dismiss'**
  String get dismiss;

  /// No description provided for @clear_guest_data.
  ///
  /// In en, this message translates to:
  /// **'Clear Guest Data'**
  String get clear_guest_data;

  /// No description provided for @clear_guest_data_confirmation.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to clear all guest data? This action cannot be undone.'**
  String get clear_guest_data_confirmation;

  /// No description provided for @clear.
  ///
  /// In en, this message translates to:
  /// **'Clear'**
  String get clear;

  /// No description provided for @clear_data.
  ///
  /// In en, this message translates to:
  /// **'Clear Data'**
  String get clear_data;

  /// No description provided for @quick_guest_start.
  ///
  /// In en, this message translates to:
  /// **'Quick Start'**
  String get quick_guest_start;

  /// First name label
  ///
  /// In en, this message translates to:
  /// **'First Name'**
  String get first_name;

  /// Last name label
  ///
  /// In en, this message translates to:
  /// **'Last Name'**
  String get last_name;

  /// No description provided for @first_name_required.
  ///
  /// In en, this message translates to:
  /// **'First name is required'**
  String get first_name_required;

  /// No description provided for @last_name_required.
  ///
  /// In en, this message translates to:
  /// **'Last name is required'**
  String get last_name_required;

  /// No description provided for @accept_marketing_communications.
  ///
  /// In en, this message translates to:
  /// **'Accept marketing communications'**
  String get accept_marketing_communications;

  /// No description provided for @created_at.
  ///
  /// In en, this message translates to:
  /// **'Created'**
  String get created_at;

  /// Cancel button
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @account_type.
  ///
  /// In en, this message translates to:
  /// **'Account Type'**
  String get account_type;

  /// No description provided for @welcome_to_guidaevai.
  ///
  /// In en, this message translates to:
  /// **'Welcome to GuidaEVAI'**
  String get welcome_to_guidaevai;

  /// No description provided for @intro_community_description.
  ///
  /// In en, this message translates to:
  /// **'Enter your data here'**
  String get intro_community_description;

  /// No description provided for @intro_feature_learning.
  ///
  /// In en, this message translates to:
  /// **'Complete Learning'**
  String get intro_feature_learning;

  /// No description provided for @intro_feature_learning_desc.
  ///
  /// In en, this message translates to:
  /// **'Theory, practice, and exam preparation'**
  String get intro_feature_learning_desc;

  /// No description provided for @intro_feature_practice.
  ///
  /// In en, this message translates to:
  /// **'Practice Tests'**
  String get intro_feature_practice;

  /// No description provided for @intro_feature_practice_desc.
  ///
  /// In en, this message translates to:
  /// **'Thousands of questions to practice'**
  String get intro_feature_practice_desc;

  /// No description provided for @intro_feature_community.
  ///
  /// In en, this message translates to:
  /// **'Community Support'**
  String get intro_feature_community;

  /// No description provided for @intro_feature_community_desc.
  ///
  /// In en, this message translates to:
  /// **'Connect with other learners'**
  String get intro_feature_community_desc;

  /// No description provided for @get_started.
  ///
  /// In en, this message translates to:
  /// **'Get Started'**
  String get get_started;

  /// No description provided for @whats_your_name.
  ///
  /// In en, this message translates to:
  /// **'What\'s your name?'**
  String get whats_your_name;

  /// No description provided for @name_minimum_3_characters.
  ///
  /// In en, this message translates to:
  /// **'Name must be at least 3 characters'**
  String get name_minimum_3_characters;

  /// No description provided for @intro_select_license_type.
  ///
  /// In en, this message translates to:
  /// **'Select Your License Type'**
  String get intro_select_license_type;

  /// No description provided for @intro_license_description.
  ///
  /// In en, this message translates to:
  /// **'Choose the license category you want to study for'**
  String get intro_license_description;

  /// No description provided for @intro_license_group.
  ///
  /// In en, this message translates to:
  /// **'License Category'**
  String get intro_license_group;

  /// No description provided for @intro_license_specific_type.
  ///
  /// In en, this message translates to:
  /// **'Specific License Type'**
  String get intro_license_specific_type;

  /// No description provided for @intro_license_classica.
  ///
  /// In en, this message translates to:
  /// **'Classic'**
  String get intro_license_classica;

  /// No description provided for @intro_license_classica_desc.
  ///
  /// In en, this message translates to:
  /// **'Standard car and motorcycle licenses'**
  String get intro_license_classica_desc;

  /// No description provided for @intro_license_superiori.
  ///
  /// In en, this message translates to:
  /// **'Professional'**
  String get intro_license_superiori;

  /// No description provided for @intro_license_superiori_desc.
  ///
  /// In en, this message translates to:
  /// **'Commercial and professional licenses'**
  String get intro_license_superiori_desc;

  /// No description provided for @intro_license_cap.
  ///
  /// In en, this message translates to:
  /// **'CAP'**
  String get intro_license_cap;

  /// No description provided for @intro_license_cap_desc.
  ///
  /// In en, this message translates to:
  /// **'Professional competence certificate'**
  String get intro_license_cap_desc;

  /// No description provided for @intro_license_revisione.
  ///
  /// In en, this message translates to:
  /// **'Revision'**
  String get intro_license_revisione;

  /// No description provided for @intro_license_revisione_desc.
  ///
  /// In en, this message translates to:
  /// **'License renewal and review'**
  String get intro_license_revisione_desc;

  /// No description provided for @intro_final_configuration.
  ///
  /// In en, this message translates to:
  /// **'Final Configuration'**
  String get intro_final_configuration;

  /// No description provided for @intro_configuration_description.
  ///
  /// In en, this message translates to:
  /// **'Review your selections and complete the setup'**
  String get intro_configuration_description;

  /// No description provided for @intro_your_selections.
  ///
  /// In en, this message translates to:
  /// **'Your Selections'**
  String get intro_your_selections;

  /// No description provided for @intro_license_type.
  ///
  /// In en, this message translates to:
  /// **'License Type'**
  String get intro_license_type;

  /// No description provided for @intro_confirm_age_over_16.
  ///
  /// In en, this message translates to:
  /// **'I confirm I am over 16 years old'**
  String get intro_confirm_age_over_16;

  /// No description provided for @intro_age_requirement.
  ///
  /// In en, this message translates to:
  /// **'Required to use the app'**
  String get intro_age_requirement;

  /// No description provided for @intro_accept_privacy_policy.
  ///
  /// In en, this message translates to:
  /// **'I accept the Privacy Policy'**
  String get intro_accept_privacy_policy;

  /// No description provided for @intro_privacy_required.
  ///
  /// In en, this message translates to:
  /// **'Required to continue'**
  String get intro_privacy_required;

  /// No description provided for @intro_terms_required.
  ///
  /// In en, this message translates to:
  /// **'Required to continue'**
  String get intro_terms_required;

  /// No description provided for @intro_accept_marketing.
  ///
  /// In en, this message translates to:
  /// **'I want to receive marketing communications'**
  String get intro_accept_marketing;

  /// No description provided for @intro_marketing_optional.
  ///
  /// In en, this message translates to:
  /// **'Optional - you can change this later'**
  String get intro_marketing_optional;

  /// No description provided for @intro_terms_note.
  ///
  /// In en, this message translates to:
  /// **'By continuing, you agree to our Terms of Service and Privacy Policy'**
  String get intro_terms_note;

  /// No description provided for @intro_start_using_app.
  ///
  /// In en, this message translates to:
  /// **'Start Using the App'**
  String get intro_start_using_app;

  /// No description provided for @income.
  ///
  /// In en, this message translates to:
  /// **'INCOME'**
  String get income;

  /// No description provided for @non_income.
  ///
  /// In en, this message translates to:
  /// **'NON-INCOME'**
  String get non_income;

  /// No description provided for @month.
  ///
  /// In en, this message translates to:
  /// **'Month'**
  String get month;

  /// No description provided for @week.
  ///
  /// In en, this message translates to:
  /// **'Week'**
  String get week;

  /// No description provided for @day.
  ///
  /// In en, this message translates to:
  /// **'Day'**
  String get day;

  /// No description provided for @italian.
  ///
  /// In en, this message translates to:
  /// **'Italian'**
  String get italian;

  /// English language option
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get english;

  /// Spanish language option
  ///
  /// In en, this message translates to:
  /// **'Spanish'**
  String get spanish;

  /// French language option
  ///
  /// In en, this message translates to:
  /// **'French'**
  String get french;

  /// No description provided for @german.
  ///
  /// In en, this message translates to:
  /// **'German'**
  String get german;

  /// No description provided for @arabic.
  ///
  /// In en, this message translates to:
  /// **'Arabic'**
  String get arabic;

  /// No description provided for @owner.
  ///
  /// In en, this message translates to:
  /// **'Owner'**
  String get owner;

  /// No description provided for @administrator.
  ///
  /// In en, this message translates to:
  /// **'Administrator'**
  String get administrator;

  /// No description provided for @operator.
  ///
  /// In en, this message translates to:
  /// **'Operator'**
  String get operator;

  /// No description provided for @pending.
  ///
  /// In en, this message translates to:
  /// **'Pending'**
  String get pending;

  /// No description provided for @confirmed.
  ///
  /// In en, this message translates to:
  /// **'Confirmed'**
  String get confirmed;

  /// No description provided for @approved.
  ///
  /// In en, this message translates to:
  /// **'Approved'**
  String get approved;

  /// No description provided for @rejected.
  ///
  /// In en, this message translates to:
  /// **'Rejected'**
  String get rejected;

  /// No description provided for @account_verification.
  ///
  /// In en, this message translates to:
  /// **'Account verification'**
  String get account_verification;

  /// No description provided for @check_your_email.
  ///
  /// In en, this message translates to:
  /// **'Check your email'**
  String get check_your_email;

  /// No description provided for @insert_otp_code_receieved_at_email.
  ///
  /// In en, this message translates to:
  /// **'Enter the OTP code received at the email'**
  String get insert_otp_code_receieved_at_email;

  /// No description provided for @continue_title.
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get continue_title;

  /// Register button text
  ///
  /// In en, this message translates to:
  /// **'Register'**
  String get register;

  /// No description provided for @personal_data.
  ///
  /// In en, this message translates to:
  /// **'Personal data'**
  String get personal_data;

  /// No description provided for @enter_your_first_name.
  ///
  /// In en, this message translates to:
  /// **'Enter your first name'**
  String get enter_your_first_name;

  /// No description provided for @name.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get name;

  /// No description provided for @surname.
  ///
  /// In en, this message translates to:
  /// **'Surname'**
  String get surname;

  /// No description provided for @enter_your_last_name.
  ///
  /// In en, this message translates to:
  /// **'Enter your last name'**
  String get enter_your_last_name;

  /// Phone number label
  ///
  /// In en, this message translates to:
  /// **'Phone Number'**
  String get phone_number;

  /// No description provided for @enter_your_phone_number.
  ///
  /// In en, this message translates to:
  /// **'Enter your phone number'**
  String get enter_your_phone_number;

  /// No description provided for @confirm_password.
  ///
  /// In en, this message translates to:
  /// **'Confirm password'**
  String get confirm_password;

  /// No description provided for @write_password.
  ///
  /// In en, this message translates to:
  /// **'Write password'**
  String get write_password;

  /// No description provided for @modify_password.
  ///
  /// In en, this message translates to:
  /// **'Modify password'**
  String get modify_password;

  /// No description provided for @enter_new_password.
  ///
  /// In en, this message translates to:
  /// **'Insert new password'**
  String get enter_new_password;

  /// No description provided for @password_requirements.
  ///
  /// In en, this message translates to:
  /// **'Minimum 12–16 characters, Uppercase letters (A–Z), Lowercase letters (a–z), Numbers (0–9), Special characters'**
  String get password_requirements;

  /// Password hint text
  ///
  /// In en, this message translates to:
  /// **'Your password'**
  String get password_hint;

  /// No description provided for @send.
  ///
  /// In en, this message translates to:
  /// **'Send'**
  String get send;

  /// No description provided for @update_app.
  ///
  /// In en, this message translates to:
  /// **'Update the app'**
  String get update_app;

  /// No description provided for @you_app_is_updated_however_a_new_version.
  ///
  /// In en, this message translates to:
  /// **'Your app is up-to-date with the current version. However, a newer version is available. You can update it from your store. Current version: {current_version}.'**
  String you_app_is_updated_however_a_new_version(String current_version);

  /// No description provided for @you_app_is_outdated_update.
  ///
  /// In en, this message translates to:
  /// **'Your app is outdated. Update to the latest version to continue using the app. Current version: {current_version}.'**
  String you_app_is_outdated_update(String current_version);

  /// No description provided for @platform_not_found.
  ///
  /// In en, this message translates to:
  /// **'Platform not not found in our supported devices.'**
  String get platform_not_found;

  /// No description provided for @connection_timeout.
  ///
  /// In en, this message translates to:
  /// **'Connection timeout'**
  String get connection_timeout;

  /// No description provided for @receive_timeout.
  ///
  /// In en, this message translates to:
  /// **'Receive timeout'**
  String get receive_timeout;

  /// No description provided for @user_is_not_authorized.
  ///
  /// In en, this message translates to:
  /// **'User is not authorized'**
  String get user_is_not_authorized;

  /// No description provided for @email_not_registered.
  ///
  /// In en, this message translates to:
  /// **'Email not registered'**
  String get email_not_registered;

  /// No description provided for @not_handled.
  ///
  /// In en, this message translates to:
  /// **'Unknown Exception'**
  String get not_handled;

  /// No description provided for @conflict.
  ///
  /// In en, this message translates to:
  /// **'Conflict'**
  String get conflict;

  /// No description provided for @validation.
  ///
  /// In en, this message translates to:
  /// **'Validation'**
  String get validation;

  /// No description provided for @home.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get home;

  /// No description provided for @calls.
  ///
  /// In en, this message translates to:
  /// **'Calls'**
  String get calls;

  /// No description provided for @menu.
  ///
  /// In en, this message translates to:
  /// **'Menu'**
  String get menu;

  /// No description provided for @store.
  ///
  /// In en, this message translates to:
  /// **'Store'**
  String get store;

  /// No description provided for @profile.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get profile;

  /// No description provided for @news.
  ///
  /// In en, this message translates to:
  /// **'News'**
  String get news;

  /// Welcome message for the user on the dashboard page.
  ///
  /// In en, this message translates to:
  /// **'Welcome back, {name}!'**
  String welcomeBack(String name);

  /// Prompt to continue learning on the dashboard page.
  ///
  /// In en, this message translates to:
  /// **'Continue learning'**
  String get continueLearning;

  /// Label for overall progress bar on the dashboard page.
  ///
  /// In en, this message translates to:
  /// **'Overall progress'**
  String get overallProgress;

  /// Label for the user's learning streak on the dashboard page.
  ///
  /// In en, this message translates to:
  /// **'Streak'**
  String get streak;

  /// Days label
  ///
  /// In en, this message translates to:
  /// **'Days'**
  String get days;

  /// Label for Unit 1 Basics card on the dashboard page.
  ///
  /// In en, this message translates to:
  /// **'Unit 1: Basics'**
  String get unit1Basics;

  /// Label for quizzes card on the dashboard page.
  ///
  /// In en, this message translates to:
  /// **'Quizzes'**
  String get quizzes;

  /// Label for lessons card on the dashboard page.
  ///
  /// In en, this message translates to:
  /// **'Lessons'**
  String get lessons;

  /// Label for video lessons card on the dashboard page.
  ///
  /// In en, this message translates to:
  /// **'Video Lessons'**
  String get videoLessons;

  /// Label for my license card on the dashboard page.
  ///
  /// In en, this message translates to:
  /// **'My License'**
  String get myLicense;

  /// No description provided for @choose_email_for_verification_code.
  ///
  /// In en, this message translates to:
  /// **'Choose which email you want to receive the verification code on:'**
  String get choose_email_for_verification_code;

  /// No description provided for @alternative_email_address.
  ///
  /// In en, this message translates to:
  /// **'Alternative email address'**
  String get alternative_email_address;

  /// No description provided for @select.
  ///
  /// In en, this message translates to:
  /// **'Select'**
  String get select;

  /// No description provided for @monday.
  ///
  /// In en, this message translates to:
  /// **'Monday'**
  String get monday;

  /// No description provided for @tuesday.
  ///
  /// In en, this message translates to:
  /// **'Tuesday'**
  String get tuesday;

  /// No description provided for @wednesday.
  ///
  /// In en, this message translates to:
  /// **'Wednesday'**
  String get wednesday;

  /// No description provided for @thursday.
  ///
  /// In en, this message translates to:
  /// **'Thursday'**
  String get thursday;

  /// No description provided for @friday.
  ///
  /// In en, this message translates to:
  /// **'Friday'**
  String get friday;

  /// No description provided for @saturday.
  ///
  /// In en, this message translates to:
  /// **'Saturday'**
  String get saturday;

  /// No description provided for @sunday.
  ///
  /// In en, this message translates to:
  /// **'Sunday'**
  String get sunday;

  /// No description provided for @username.
  ///
  /// In en, this message translates to:
  /// **'Username'**
  String get username;

  /// No description provided for @copy_profile_link.
  ///
  /// In en, this message translates to:
  /// **'Copy the profile link'**
  String get copy_profile_link;

  /// Go back button text
  ///
  /// In en, this message translates to:
  /// **'GO BACK'**
  String get go_back;

  /// No description provided for @password_reset_success_title.
  ///
  /// In en, this message translates to:
  /// **'Password reset successfully'**
  String get password_reset_success_title;

  /// No description provided for @password_reset_success_subtitle.
  ///
  /// In en, this message translates to:
  /// **'You can now log in using your new password'**
  String get password_reset_success_subtitle;

  /// No description provided for @go_to_login.
  ///
  /// In en, this message translates to:
  /// **'Go to login'**
  String get go_to_login;

  /// No description provided for @email_link_sent.
  ///
  /// In en, this message translates to:
  /// **'A link has been sent to your email. Please follow the procedure.'**
  String get email_link_sent;

  /// My progress section title
  ///
  /// In en, this message translates to:
  /// **'My Progress'**
  String get myProgress;

  /// Live page title
  ///
  /// In en, this message translates to:
  /// **'Live'**
  String get live;

  /// Label for quiz progress.
  ///
  /// In en, this message translates to:
  /// **'Quiz'**
  String get quiz;

  /// Label for preparation percentage.
  ///
  /// In en, this message translates to:
  /// **'Preparation: {percentage}%'**
  String preparation(String percentage);

  /// Label for show progress chart button.
  ///
  /// In en, this message translates to:
  /// **'Show progress chart'**
  String get showProgressChart;

  /// Title for steps section in my license page.
  ///
  /// In en, this message translates to:
  /// **'The steps'**
  String get theSteps;

  /// Title for upload documents step.
  ///
  /// In en, this message translates to:
  /// **'Upload documents'**
  String get uploadDocuments;

  /// Subtitle for upload documents.
  ///
  /// In en, this message translates to:
  /// **'Complete your dossier'**
  String get completeYourDossier;

  /// Status for uploaded documents.
  ///
  /// In en, this message translates to:
  /// **'{uploaded}/{total} Uploaded'**
  String documentsUploaded(String uploaded, String total);

  /// Title for book medical visit step.
  ///
  /// In en, this message translates to:
  /// **'Book medical visit'**
  String get bookMedicalVisit;

  /// Subtitle for medical visit.
  ///
  /// In en, this message translates to:
  /// **'Medical certificate'**
  String get medicalCertificate;

  /// Status available after document upload.
  ///
  /// In en, this message translates to:
  /// **'Available after document upload'**
  String get availableAfterDocumentUpload;

  /// Status when ready to book medical visit.
  ///
  /// In en, this message translates to:
  /// **'Ready to book'**
  String get readyToBook;

  /// Status when all documents need to be completed.
  ///
  /// In en, this message translates to:
  /// **'Complete all documents'**
  String get completeAllDocuments;

  /// Status when medical exam needs to be booked before theory exam.
  ///
  /// In en, this message translates to:
  /// **'Book medical exam first'**
  String get bookMedicalExamFirst;

  /// Title for book theoretical exam step.
  ///
  /// In en, this message translates to:
  /// **'Book theoretical exam'**
  String get bookTheoreticalExam;

  /// Status available after booking.
  ///
  /// In en, this message translates to:
  /// **'Available after booking'**
  String get availableAfterBooking;

  /// Label for help button.
  ///
  /// In en, this message translates to:
  /// **'Need help?'**
  String get needHelp;

  /// Banner text indicating limited seats available.
  ///
  /// In en, this message translates to:
  /// **'LIMITED SEATS'**
  String get limitedSeats;

  /// Banner text showing exam date and price.
  ///
  /// In en, this message translates to:
  /// **'October exam for only 9.90€'**
  String get examOctoberPrice;

  /// Call to action button text for registration.
  ///
  /// In en, this message translates to:
  /// **'Register now!'**
  String get registerNow;

  /// Personalized greeting for Giacomo on the dashboard.
  ///
  /// In en, this message translates to:
  /// **'Hello Giacomo!'**
  String get ciaoGiacomo;

  /// Encouragement text to take quizzes.
  ///
  /// In en, this message translates to:
  /// **'It\'s time to take some quizzes!'**
  String get timeForQuiz;

  /// Greeting message from Salvo in the chat bubble.
  ///
  /// In en, this message translates to:
  /// **'Hi! I\'m Salvo, your virtual but real instructor\nHow can I help you today?'**
  String get salvoGreeting;

  /// Label for Salvo AI chat button with AI indicator.
  ///
  /// In en, this message translates to:
  /// **'Ask Salvo (AI)'**
  String get askSalvoAI;

  /// Label for support/assistance button.
  ///
  /// In en, this message translates to:
  /// **'Support'**
  String get support;

  /// Option to review a topic in the chat bubble.
  ///
  /// In en, this message translates to:
  /// **'I want to review a topic'**
  String get reviewTopic;

  /// Option to ask about quiz questions in the chat bubble.
  ///
  /// In en, this message translates to:
  /// **'I have doubts about a quiz question'**
  String get quizDoubts;

  /// Option to request a full simulation in the chat bubble.
  ///
  /// In en, this message translates to:
  /// **'I want a full simulation'**
  String get fullSimulation;

  /// Profile page title
  ///
  /// In en, this message translates to:
  /// **'User Area'**
  String get user_area;

  /// Logout button text
  ///
  /// In en, this message translates to:
  /// **'Logout'**
  String get logout;

  /// Logout confirmation dialog title
  ///
  /// In en, this message translates to:
  /// **'Confirm Logout'**
  String get logout_confirmation_title;

  /// Logout confirmation dialog message
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to log out of your account?'**
  String get logout_confirmation_message;

  /// Edit profile button text
  ///
  /// In en, this message translates to:
  /// **'Edit profile'**
  String get edit_profile;

  /// Edit profile page title
  ///
  /// In en, this message translates to:
  /// **'Edit Profile'**
  String get edit_profile_title;

  /// Phone field label
  ///
  /// In en, this message translates to:
  /// **'Phone'**
  String get phone;

  /// Save changes button text
  ///
  /// In en, this message translates to:
  /// **'Save Changes'**
  String get save_changes;

  /// Success message after profile update
  ///
  /// In en, this message translates to:
  /// **'Profile updated successfully'**
  String get profile_updated_successfully;

  /// Error message when license type update fails
  ///
  /// In en, this message translates to:
  /// **'Failed to update license type. Please try again.'**
  String get failed_to_update_license_type;

  /// Change password button text
  ///
  /// In en, this message translates to:
  /// **'Change Password'**
  String get change_password;

  /// First name field placeholder
  ///
  /// In en, this message translates to:
  /// **'Enter your first name'**
  String get enter_first_name;

  /// Last name field placeholder
  ///
  /// In en, this message translates to:
  /// **'Enter your last name'**
  String get enter_last_name;

  /// Phone field placeholder
  ///
  /// In en, this message translates to:
  /// **'Enter your phone number'**
  String get enter_phone;

  /// Phone validation error
  ///
  /// In en, this message translates to:
  /// **'Phone must be at least 10 digits'**
  String get phone_must_be_at_least_10_digits;

  /// Text shown when user name is not available
  ///
  /// In en, this message translates to:
  /// **'Name not available'**
  String get profile_name_not_available;

  /// Text shown when user email is not available
  ///
  /// In en, this message translates to:
  /// **'Email not available'**
  String get profile_email_not_available;

  /// Merge accounts button text
  ///
  /// In en, this message translates to:
  /// **'Merge your accounts'**
  String get merge_accounts;

  /// Preparation status section title
  ///
  /// In en, this message translates to:
  /// **'Preparation status'**
  String get preparation_status;

  /// Next step label
  ///
  /// In en, this message translates to:
  /// **'Next step'**
  String get next_step;

  /// Quiz reminder title
  ///
  /// In en, this message translates to:
  /// **'Quiz Reminder'**
  String get quiz_reminder;

  /// Quiz reminder description
  ///
  /// In en, this message translates to:
  /// **'Set the time when you want your virtual instructor to remind you to take quizzes'**
  String get quiz_reminder_description;

  /// Set time button text
  ///
  /// In en, this message translates to:
  /// **'Set time'**
  String get set_time;

  /// Quiz reminder notification title
  ///
  /// In en, this message translates to:
  /// **'Time to practice!'**
  String get quiz_reminder_title;

  /// Quiz reminder notification body
  ///
  /// In en, this message translates to:
  /// **'{firstName}, time to practice your quiz!'**
  String quiz_reminder_body(String firstName);

  /// Language setting
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// Dyslexia font setting
  ///
  /// In en, this message translates to:
  /// **'DSA font'**
  String get dyslexia_font;

  /// Improve readability setting
  ///
  /// In en, this message translates to:
  /// **'Improve readability'**
  String get improve_readability;

  /// Write a review section
  ///
  /// In en, this message translates to:
  /// **'Write a review'**
  String get write_review;

  /// Rate our app description
  ///
  /// In en, this message translates to:
  /// **'Rate our app on the stores'**
  String get rate_app;

  /// Contact us section
  ///
  /// In en, this message translates to:
  /// **'Contact us'**
  String get contact_us;

  /// Chat support option
  ///
  /// In en, this message translates to:
  /// **'Chat support'**
  String get chat_support;

  /// Email support option
  ///
  /// In en, this message translates to:
  /// **'Email support'**
  String get email_support;

  /// Privacy and conditions section
  ///
  /// In en, this message translates to:
  /// **'Privacy and conditions'**
  String get privacy_conditions;

  /// Terms of service menu item
  ///
  /// In en, this message translates to:
  /// **'Terms of Service'**
  String get terms_of_service;

  /// Terms and Conditions document name
  ///
  /// In en, this message translates to:
  /// **'Terms and Conditions'**
  String get terms_and_conditions;

  /// Privacy policy menu item
  ///
  /// In en, this message translates to:
  /// **'Privacy Policy'**
  String get privacy_policy;

  /// Accept data sharing setting
  ///
  /// In en, this message translates to:
  /// **'I accept to share my data'**
  String get accept_data_sharing;

  /// Delete account section
  ///
  /// In en, this message translates to:
  /// **'Delete account'**
  String get delete_account;

  /// Delete profile permanently description
  ///
  /// In en, this message translates to:
  /// **'Delete your profile permanently'**
  String get delete_profile;

  /// Instruction to type confirmation text for account deletion
  ///
  /// In en, this message translates to:
  /// **'Type \"Guida e vai\" to confirm'**
  String get type_to_confirm_deletion;

  /// Error message when account deletion fails
  ///
  /// In en, this message translates to:
  /// **'Error deleting account. Please try again.'**
  String get error_deleting_account;

  /// Merge accounts page title
  ///
  /// In en, this message translates to:
  /// **'Merge your accounts'**
  String get merge_your_accounts;

  /// Account unification page description
  ///
  /// In en, this message translates to:
  /// **'Enter the email of the other account and follow the instructions we will send you by email to proceed with the merge and synchronize all your progress.'**
  String get account_unification_description;

  /// Instruction for merging accounts
  ///
  /// In en, this message translates to:
  /// **'Enter the credentials or use social authentication to merge another account with your current account. All data (quizzes, subscriptions, etc.) will be transferred to your current account.'**
  String get merge_accounts_instruction;

  /// Warning about active subscriptions during merge
  ///
  /// In en, this message translates to:
  /// **'Note: Both accounts cannot have active subscriptions simultaneously'**
  String get merge_accounts_warning;

  /// Merge with social account section title
  ///
  /// In en, this message translates to:
  /// **'Merge with Social Account'**
  String get merge_with_social_account;

  /// Or text for divider
  ///
  /// In en, this message translates to:
  /// **'or'**
  String get or_lowercase;

  /// Merge with credentials section title
  ///
  /// In en, this message translates to:
  /// **'Merge with Email and Password'**
  String get merge_with_credentials;

  /// Title for merge confirmation dialog
  ///
  /// In en, this message translates to:
  /// **'Confirm Account Merge'**
  String get merge_accounts_confirmation_title;

  /// Message for merge confirmation dialog
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to merge these accounts? This action cannot be undone. All data from the other account will be transferred to your current account.'**
  String get merge_accounts_confirmation_message;

  /// Success message title
  ///
  /// In en, this message translates to:
  /// **'Success'**
  String get success;

  /// Success message after merging accounts
  ///
  /// In en, this message translates to:
  /// **'Accounts have been successfully merged! The app will restart to refresh your data.'**
  String get merge_accounts_success_message;

  /// Message when Google sign in is cancelled
  ///
  /// In en, this message translates to:
  /// **'Google sign in was cancelled'**
  String get google_sign_in_cancelled;

  /// Message when Apple sign in is cancelled
  ///
  /// In en, this message translates to:
  /// **'Apple sign in was cancelled'**
  String get apple_sign_in_cancelled;

  /// Email input placeholder
  ///
  /// In en, this message translates to:
  /// **'enter@youremail.com'**
  String get enter_email_placeholder;

  /// Send code button text
  ///
  /// In en, this message translates to:
  /// **'Send the code'**
  String get send_code;

  /// Select time dialog title
  ///
  /// In en, this message translates to:
  /// **'Select time'**
  String get select_time;

  /// AM time period
  ///
  /// In en, this message translates to:
  /// **'AM'**
  String get am;

  /// PM time period
  ///
  /// In en, this message translates to:
  /// **'PM'**
  String get pm;

  /// OK button text
  ///
  /// In en, this message translates to:
  /// **'OK'**
  String get ok;

  /// Cancel button text
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel_button;

  /// Ministerial quiz card title
  ///
  /// In en, this message translates to:
  /// **'Ministerial Quiz'**
  String get ministerial_quiz;

  /// Start quiz button text
  ///
  /// In en, this message translates to:
  /// **'Start quiz'**
  String get start_quiz;

  /// Create topic combinations description
  ///
  /// In en, this message translates to:
  /// **'Create topic combinations and start the quiz'**
  String get create_topic_combinations;

  /// Start button text
  ///
  /// In en, this message translates to:
  /// **'Start'**
  String get start_button;

  /// Booking summary card title
  ///
  /// In en, this message translates to:
  /// **'Booking summary'**
  String get booking_summary;

  /// Default instructor name
  ///
  /// In en, this message translates to:
  /// **'Lorenzo'**
  String get default_instructor;

  /// Traffic lights and officers topic
  ///
  /// In en, this message translates to:
  /// **'Traffic Lights and Officers'**
  String get traffic_lights_topic;

  /// Ministerial quiz sheet title
  ///
  /// In en, this message translates to:
  /// **'Ministerial Quiz'**
  String get ministerial_quiz_sheet;

  /// Live calendar page title
  ///
  /// In en, this message translates to:
  /// **'Live calendar'**
  String get live_calendar;

  /// Book your next live session
  ///
  /// In en, this message translates to:
  /// **'Book your next live session'**
  String get book_next_live;

  /// Recorded live sessions
  ///
  /// In en, this message translates to:
  /// **'Recorded Lives'**
  String get recorded_lives;

  /// Live in progress indicator
  ///
  /// In en, this message translates to:
  /// **'Live'**
  String get live_in_progress;

  /// Road priorities topic
  ///
  /// In en, this message translates to:
  /// **'Road Priorities'**
  String get road_priorities;

  /// Learn fundamental priority rules
  ///
  /// In en, this message translates to:
  /// **'Learn fundamental priority rules'**
  String get learn_priority_rules;

  /// Join now button
  ///
  /// In en, this message translates to:
  /// **'Join Now'**
  String get join_now;

  /// My upcoming live sessions
  ///
  /// In en, this message translates to:
  /// **'My Upcoming Lives'**
  String get my_upcoming_lives;

  /// My previous live sessions
  ///
  /// In en, this message translates to:
  /// **'My Previous Lives'**
  String get my_previous_lives;

  /// Quiz with theory card title
  ///
  /// In en, this message translates to:
  /// **'Quiz with Theory'**
  String get quiz_with_theory;

  /// Quiz progress text
  ///
  /// In en, this message translates to:
  /// **'{completed} quizzes completed out of {total}'**
  String quizzes_completed(int completed, int total);

  /// Select topics description
  ///
  /// In en, this message translates to:
  /// **'Select ministerial topics and create a personalized quiz'**
  String get select_topics;

  /// Error statistics title
  ///
  /// In en, this message translates to:
  /// **'Error Statistics'**
  String get error_statistics;

  /// Review errors button text
  ///
  /// In en, this message translates to:
  /// **'Review errors'**
  String get review_errors;

  /// Total errors label
  ///
  /// In en, this message translates to:
  /// **'Total errors'**
  String get total_errors;

  /// Errors per month label
  ///
  /// In en, this message translates to:
  /// **'Errors per month'**
  String get errors_per_month;

  /// Select topics for review description
  ///
  /// In en, this message translates to:
  /// **'Select the topics you want to review and create a personalized quiz'**
  String get select_review_topics;

  /// Banner placeholder text
  ///
  /// In en, this message translates to:
  /// **'Banner'**
  String get banner;

  /// Question number indicator
  ///
  /// In en, this message translates to:
  /// **'Question {current} of {total}'**
  String quiz_question_number(int current, int total);

  /// Time remaining indicator
  ///
  /// In en, this message translates to:
  /// **'Time remaining: {time}s'**
  String quiz_time_remaining(int time);

  /// True answer button
  ///
  /// In en, this message translates to:
  /// **'TRUE'**
  String get quiz_true;

  /// False answer button
  ///
  /// In en, this message translates to:
  /// **'FALSE'**
  String get quiz_false;

  /// Listen button
  ///
  /// In en, this message translates to:
  /// **'Listen'**
  String get quiz_listen;

  /// Loading quiz message
  ///
  /// In en, this message translates to:
  /// **'Loading quiz...'**
  String get loading_quiz;

  /// Translate button
  ///
  /// In en, this message translates to:
  /// **'Translate'**
  String get quiz_translate;

  /// End quiz button
  ///
  /// In en, this message translates to:
  /// **'End'**
  String get quiz_end;

  /// Attention dialog title
  ///
  /// In en, this message translates to:
  /// **'ATTENTION'**
  String get attention;

  /// End quiz confirmation dialog message
  ///
  /// In en, this message translates to:
  /// **'You have not yet answered all the questions.\nAre you sure you want to end the quiz now?'**
  String get quit_quiz_message;

  /// Complete quiz confirmation dialog message when all questions answered
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to end the quiz now?'**
  String get complete_quiz_message;

  /// Back button confirmation dialog message
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to go back? You will lose all progress.'**
  String get back_quiz_message;

  /// End quiz button text
  ///
  /// In en, this message translates to:
  /// **'END'**
  String get end_quiz;

  /// Message shown when no topics are selected for quiz
  ///
  /// In en, this message translates to:
  /// **'Please select topics first'**
  String get no_topics_selected;

  /// Message when no topics are available
  ///
  /// In en, this message translates to:
  /// **'No topics available'**
  String get no_topics_available;

  /// Correct answer feedback
  ///
  /// In en, this message translates to:
  /// **'Correct!'**
  String get quiz_correct_answer;

  /// Wrong answer feedback
  ///
  /// In en, this message translates to:
  /// **'Wrong!'**
  String get quiz_wrong_answer;

  /// Timeout message
  ///
  /// In en, this message translates to:
  /// **'Time\'s up!'**
  String get quiz_timeout;

  /// Quiz results title
  ///
  /// In en, this message translates to:
  /// **'Quiz Results'**
  String get quiz_results;

  /// Quiz score display
  ///
  /// In en, this message translates to:
  /// **'Score: {correct}/{total}'**
  String quiz_score(int correct, int total);

  /// Quiz percentage score
  ///
  /// In en, this message translates to:
  /// **'{percentage}%'**
  String quiz_percentage(double percentage);

  /// Quiz completion message
  ///
  /// In en, this message translates to:
  /// **'Quiz completed!'**
  String get quiz_completed;

  /// Login loading message
  ///
  /// In en, this message translates to:
  /// **'Signing in, please wait...'**
  String get signing_in_please_wait;

  /// Quiz error message
  ///
  /// In en, this message translates to:
  /// **'Error loading quiz'**
  String get quiz_error;

  /// Quiz result page title
  ///
  /// In en, this message translates to:
  /// **'Quiz Result'**
  String get quiz_result_title;

  /// Quiz failed status
  ///
  /// In en, this message translates to:
  /// **'Failed'**
  String get failed;

  /// Quiz passed status
  ///
  /// In en, this message translates to:
  /// **'Passed'**
  String get passed;

  /// Minutes abbreviation
  ///
  /// In en, this message translates to:
  /// **'min'**
  String get minutes;

  /// Retry quiz button
  ///
  /// In en, this message translates to:
  /// **'Retry quiz'**
  String get retry_quiz;

  /// Correct answers label
  ///
  /// In en, this message translates to:
  /// **'Correct'**
  String get correct;

  /// Unanswered questions label
  ///
  /// In en, this message translates to:
  /// **'Unanswered'**
  String get unanswered;

  /// Incorrect answers label
  ///
  /// In en, this message translates to:
  /// **'Incorrect'**
  String get incorrect;

  /// Question analysis section title
  ///
  /// In en, this message translates to:
  /// **'Question Analysis'**
  String get question_analysis;

  /// Label for correct answer
  ///
  /// In en, this message translates to:
  /// **'Correct Answer'**
  String get correct_answer;

  /// User answer text
  ///
  /// In en, this message translates to:
  /// **'Your answer: {answer}'**
  String your_answer(String answer);

  /// Video correction link
  ///
  /// In en, this message translates to:
  /// **'Video correction'**
  String get video_correction;

  /// Consult theory link
  ///
  /// In en, this message translates to:
  /// **'Consult theory'**
  String get consult_theory;

  /// True answer option
  ///
  /// In en, this message translates to:
  /// **'True'**
  String get true_answer;

  /// False answer option
  ///
  /// In en, this message translates to:
  /// **'False'**
  String get false_answer;

  /// Not answered status
  ///
  /// In en, this message translates to:
  /// **'Not answered'**
  String get not_answered;

  /// Booking confirmation page title
  ///
  /// In en, this message translates to:
  /// **'Booking completed successfully!'**
  String get booking_success_title;

  /// Instructor label
  ///
  /// In en, this message translates to:
  /// **'Instructor'**
  String get instructor;

  /// Topic label
  ///
  /// In en, this message translates to:
  /// **'Topic:'**
  String get topic;

  /// Book button text
  ///
  /// In en, this message translates to:
  /// **'Book'**
  String get book;

  /// Document upload progress title
  ///
  /// In en, this message translates to:
  /// **'Document upload'**
  String get documentUploadProgress;

  /// Upload instructions title
  ///
  /// In en, this message translates to:
  /// **'Upload instructions'**
  String get uploadInstructions;

  /// Upload instructions list
  ///
  /// In en, this message translates to:
  /// **'• Upload files or take clear and well-lit photos\n• Make sure all texts are readable\n• Supported format: JPG, PNG, PDF\n• Maximum size: 5MB per file'**
  String get uploadInstructionsList;

  /// Required documents title
  ///
  /// In en, this message translates to:
  /// **'Required documents'**
  String get requiredDocuments;

  /// Identity card document title
  ///
  /// In en, this message translates to:
  /// **'Identity card'**
  String get identityCard;

  /// Health card document title
  ///
  /// In en, this message translates to:
  /// **'Health card'**
  String get healthCard;

  /// Front and back required subtitle
  ///
  /// In en, this message translates to:
  /// **'Front and back required'**
  String get frontAndBackRequired;

  /// Residence permit document title
  ///
  /// In en, this message translates to:
  /// **'Residence permit'**
  String get residencePermit;

  /// Only for non-EU citizens subtitle
  ///
  /// In en, this message translates to:
  /// **'Only for non-EU citizens'**
  String get onlyForNonEuCitizens;

  /// Issued by authorized doctor subtitle
  ///
  /// In en, this message translates to:
  /// **'Issued by authorized doctor'**
  String get issuedByAuthorizedDoctor;

  /// Passport photo document title
  ///
  /// In en, this message translates to:
  /// **'Passport photo'**
  String get passportPhoto;

  /// JPG, PNG format subtitle
  ///
  /// In en, this message translates to:
  /// **'JPG, PNG format'**
  String get jpgPngFormat;

  /// Digital signature document title
  ///
  /// In en, this message translates to:
  /// **'Digital signature'**
  String get digitalSignature;

  /// Signature on white background subtitle
  ///
  /// In en, this message translates to:
  /// **'Signature on white background'**
  String get signatureOnWhiteBackground;

  /// Pending approval status
  ///
  /// In en, this message translates to:
  /// **'Pending approval'**
  String get pendingApproval;

  /// Italian citizen checkbox label
  ///
  /// In en, this message translates to:
  /// **'I am an Italian citizen'**
  String get iAmItalianCitizen;

  /// Residence matches ID card question
  ///
  /// In en, this message translates to:
  /// **'Does your residence match the one on your ID card?'**
  String get residenceMatchesIdCard;

  /// Document upload success message
  ///
  /// In en, this message translates to:
  /// **'Document uploaded successfully'**
  String get documentUploadSuccess;

  /// Document upload error message
  ///
  /// In en, this message translates to:
  /// **'Error uploading document: {error}'**
  String documentUploadError(String error);

  /// Certificate of residence document title
  ///
  /// In en, this message translates to:
  /// **'Certificate of residence'**
  String get certificateOfResidence;

  /// Certificate of residence subtitle
  ///
  /// In en, this message translates to:
  /// **'Only if different from ID card'**
  String get onlyIfDifferentFromIdCard;

  /// Missing status
  ///
  /// In en, this message translates to:
  /// **'Missing'**
  String get missing;

  /// Yes button
  ///
  /// In en, this message translates to:
  /// **'Yes'**
  String get yes;

  /// No button
  ///
  /// In en, this message translates to:
  /// **'No'**
  String get no;

  /// Medical visit booking page title
  ///
  /// In en, this message translates to:
  /// **'Book medical visit'**
  String get medical_visit_booking_title;

  /// Booking steps section title
  ///
  /// In en, this message translates to:
  /// **'Steps to book medical visit'**
  String get booking_steps_title;

  /// First booking step
  ///
  /// In en, this message translates to:
  /// **'Find the nearest center to you'**
  String get booking_step_find_center;

  /// Second booking step
  ///
  /// In en, this message translates to:
  /// **'Express 3 time preferences'**
  String get booking_step_preferences;

  /// Third booking step
  ///
  /// In en, this message translates to:
  /// **'Wait for the call to confirm'**
  String get booking_step_wait_call;

  /// Where do you live now section title
  ///
  /// In en, this message translates to:
  /// **'Where do you live now?'**
  String get where_do_you_live;

  /// Enter city instruction
  ///
  /// In en, this message translates to:
  /// **'Enter the city where you live now'**
  String get enter_city_where_you_live;

  /// City input placeholder
  ///
  /// In en, this message translates to:
  /// **'City'**
  String get city_placeholder;

  /// Enter province instruction
  ///
  /// In en, this message translates to:
  /// **'Enter the province where you live now'**
  String get enter_province_where_you_live;

  /// Province input placeholder
  ///
  /// In en, this message translates to:
  /// **'Province'**
  String get province_placeholder;

  /// Medical visit center location info
  ///
  /// In en, this message translates to:
  /// **'The medical visit will be booked at the center closest to your home.'**
  String get medical_visit_nearest_center;

  /// Book in another city checkbox label
  ///
  /// In en, this message translates to:
  /// **'Book in another city'**
  String get book_in_another_city;

  /// Time preferences section title
  ///
  /// In en, this message translates to:
  /// **'Time preferences'**
  String get time_preferences;

  /// Select three availability instruction
  ///
  /// In en, this message translates to:
  /// **'Select at least 3 availability for your medical visit'**
  String get select_three_availability;

  /// Preferences dropdown placeholder
  ///
  /// In en, this message translates to:
  /// **'Preferences'**
  String get preferences_placeholder;

  /// Request medical visit booking button text
  ///
  /// In en, this message translates to:
  /// **'Request medical visit booking'**
  String get request_medical_visit_booking;

  /// Congratulations message for exam readiness
  ///
  /// In en, this message translates to:
  /// **'Congratulations! You\'re ready for the exam'**
  String get congratulationsReadyForExam;

  /// Preparation completed 100% message
  ///
  /// In en, this message translates to:
  /// **'Preparation completed 100%'**
  String get preparationCompleted100;

  /// Recommended school section title
  ///
  /// In en, this message translates to:
  /// **'Recommended school for you'**
  String get recommendedSchoolForYou;

  /// Select at least 3 availabilities instruction
  ///
  /// In en, this message translates to:
  /// **'Select at least 3 availabilities for your theoretical exam'**
  String get selectAtLeast3Availabilities;

  /// Preferences dropdown label
  ///
  /// In en, this message translates to:
  /// **'Preferences'**
  String get preferences;

  /// Request theoretical exam booking button text
  ///
  /// In en, this message translates to:
  /// **'Request theoretical exam booking'**
  String get requestTheoreticalExamBooking;

  /// Booking request sent confirmation message
  ///
  /// In en, this message translates to:
  /// **'Booking request sent!'**
  String get bookingRequestSent;

  /// Morning time slot option
  ///
  /// In en, this message translates to:
  /// **'Morning (9:00 - 12:00)'**
  String get morningSlot;

  /// Afternoon time slot option
  ///
  /// In en, this message translates to:
  /// **'Afternoon (14:00 - 17:00)'**
  String get afternoonSlot;

  /// Morning time period
  ///
  /// In en, this message translates to:
  /// **'Morning'**
  String get morning;

  /// Afternoon time period
  ///
  /// In en, this message translates to:
  /// **'Afternoon'**
  String get afternoon;

  /// Time preference selection header
  ///
  /// In en, this message translates to:
  /// **'Express your preference'**
  String get express_your_preference;

  /// Evening time slot option
  ///
  /// In en, this message translates to:
  /// **'Evening (17:00 - 19:00)'**
  String get eveningSlot;

  /// Book theoretical exam page title
  ///
  /// In en, this message translates to:
  /// **'Book theoretical exam'**
  String get book_theoretical_exam;

  /// Book medical visit page title
  ///
  /// In en, this message translates to:
  /// **'Book medical visit'**
  String get book_medical_visit;

  /// Upload documents page title
  ///
  /// In en, this message translates to:
  /// **'Upload documents'**
  String get upload_documents;

  /// Summary section title
  ///
  /// In en, this message translates to:
  /// **'Summary'**
  String get summary;

  /// FAQ section title
  ///
  /// In en, this message translates to:
  /// **'Frequently asked questions'**
  String get frequently_asked_questions;

  /// Quiz result page title
  ///
  /// In en, this message translates to:
  /// **'Quiz result'**
  String get quiz_result;

  /// Recorded live sessions page title
  ///
  /// In en, this message translates to:
  /// **'Recorded live'**
  String get recorded_live;

  /// Topic title
  ///
  /// In en, this message translates to:
  /// **'General definitions and duties in road use'**
  String get general_definitions_road_use;

  /// Danger signals topic
  ///
  /// In en, this message translates to:
  /// **'Danger signals'**
  String get danger_signals;

  /// Prohibition road signals topic
  ///
  /// In en, this message translates to:
  /// **'Prohibition road signals'**
  String get prohibition_road_signals;

  /// Topic title
  ///
  /// In en, this message translates to:
  /// **'Mandatory road signals'**
  String get mandatory_road_signals;

  /// Topic title
  ///
  /// In en, this message translates to:
  /// **'Priority road signals'**
  String get priority_road_signals;

  /// Topic title
  ///
  /// In en, this message translates to:
  /// **'Horizontal marking and obstacle signs'**
  String get horizontal_marking_obstacle_signs;

  /// Topic title
  ///
  /// In en, this message translates to:
  /// **'Traffic light signals and traffic agents'**
  String get traffic_light_signals;

  /// Topic title
  ///
  /// In en, this message translates to:
  /// **'Indication signals'**
  String get indication_signals;

  /// Booking confirmation page title
  ///
  /// In en, this message translates to:
  /// **'Booking confirmation'**
  String get booking_confirmation;

  /// Button text for virtual teacher quiz
  ///
  /// In en, this message translates to:
  /// **'Virtual Teacher Quiz'**
  String get virtual_teacher_quiz;

  /// Road definition
  ///
  /// In en, this message translates to:
  /// **'Road'**
  String get road;

  /// Carriageway definition
  ///
  /// In en, this message translates to:
  /// **'Carriageway'**
  String get carriageway;

  /// Lane definition
  ///
  /// In en, this message translates to:
  /// **'Lane'**
  String get lane;

  /// Acceleration lane definition
  ///
  /// In en, this message translates to:
  /// **'Acceleration lane'**
  String get acceleration_lane;

  /// Deceleration lane definition
  ///
  /// In en, this message translates to:
  /// **'Deceleration lane'**
  String get deceleration_lane;

  /// Road shoulder definition
  ///
  /// In en, this message translates to:
  /// **'Shoulder'**
  String get shoulder;

  /// Sidewalk definition
  ///
  /// In en, this message translates to:
  /// **'Sidewalk'**
  String get sidewalk;

  /// Generic danger signals topic
  ///
  /// In en, this message translates to:
  /// **'Generic danger signals'**
  String get generic_danger_signals;

  /// Dangerous curve signals topic
  ///
  /// In en, this message translates to:
  /// **'Dangerous curve signals'**
  String get dangerous_curve_signals;

  /// Crossing signals topic
  ///
  /// In en, this message translates to:
  /// **'Crossing signals'**
  String get crossing_signals;

  /// Transit prohibitions topic
  ///
  /// In en, this message translates to:
  /// **'Transit prohibitions'**
  String get transit_prohibitions;

  /// Speed prohibitions topic
  ///
  /// In en, this message translates to:
  /// **'Speed prohibitions'**
  String get speed_prohibitions;

  /// Parking prohibitions topic
  ///
  /// In en, this message translates to:
  /// **'Parking prohibitions'**
  String get parking_prohibitions;

  /// Direction obligations topic
  ///
  /// In en, this message translates to:
  /// **'Direction obligations'**
  String get direction_obligations;

  /// Speed obligations topic
  ///
  /// In en, this message translates to:
  /// **'Speed obligations'**
  String get speed_obligations;

  /// Vehicle category obligations topic
  ///
  /// In en, this message translates to:
  /// **'Vehicle category obligations'**
  String get vehicle_category_obligations;

  /// Right of way topic
  ///
  /// In en, this message translates to:
  /// **'Right of way'**
  String get right_of_way;

  /// Give way topic
  ///
  /// In en, this message translates to:
  /// **'Give way'**
  String get give_way;

  /// Stop and halt topic
  ///
  /// In en, this message translates to:
  /// **'Stop and halt'**
  String get stop_and_halt;

  /// Longitudinal stripes topic
  ///
  /// In en, this message translates to:
  /// **'Longitudinal stripes'**
  String get longitudinal_stripes;

  /// Transverse stripes topic
  ///
  /// In en, this message translates to:
  /// **'Transverse stripes'**
  String get transverse_stripes;

  /// Pedestrian crossings topic
  ///
  /// In en, this message translates to:
  /// **'Pedestrian crossings'**
  String get pedestrian_crossings;

  /// Traffic lights topic
  ///
  /// In en, this message translates to:
  /// **'Traffic lights'**
  String get traffic_lights;

  /// Agent signals topic
  ///
  /// In en, this message translates to:
  /// **'Agent signals'**
  String get agent_signals;

  /// Special traffic lights topic
  ///
  /// In en, this message translates to:
  /// **'Special traffic lights'**
  String get special_traffic_lights;

  /// Generic topic title
  ///
  /// In en, this message translates to:
  /// **'Generic topic'**
  String get generic_topic;

  /// Manual topics page title
  ///
  /// In en, this message translates to:
  /// **'Manual topics'**
  String get manual_topics;

  /// Safety behaviors topic
  ///
  /// In en, this message translates to:
  /// **'Safety behaviors'**
  String get safety_behaviors;

  /// Emergency procedures topic
  ///
  /// In en, this message translates to:
  /// **'Emergency procedures'**
  String get emergency_procedures;

  /// Workplace safety regulations topic
  ///
  /// In en, this message translates to:
  /// **'Workplace safety regulations'**
  String get workplace_safety_regulations;

  /// Risks and prevention topic
  ///
  /// In en, this message translates to:
  /// **'Risks and prevention'**
  String get risks_and_prevention;

  /// Correct use of protection devices topic
  ///
  /// In en, this message translates to:
  /// **'Correct use of protection devices'**
  String get correct_use_protection_devices;

  /// Select topic instruction
  ///
  /// In en, this message translates to:
  /// **'Select topic'**
  String get select_topic;

  /// My license page title
  ///
  /// In en, this message translates to:
  /// **'My license'**
  String get my_license;

  /// License type label
  ///
  /// In en, this message translates to:
  /// **'License Type'**
  String get license_type;

  /// Message when no license type is selected
  ///
  /// In en, this message translates to:
  /// **'No license type selected'**
  String get license_type_not_selected;

  /// Revision label for license type
  ///
  /// In en, this message translates to:
  /// **'Revision'**
  String get revision;

  /// Questions label
  ///
  /// In en, this message translates to:
  /// **'questions'**
  String get questions;

  /// Theory page title
  ///
  /// In en, this message translates to:
  /// **'Theory'**
  String get theory;

  /// Search teacher placeholder
  ///
  /// In en, this message translates to:
  /// **'Search teacher in our network'**
  String get search_teacher_network;

  /// Search topic placeholder
  ///
  /// In en, this message translates to:
  /// **'Search topic'**
  String get search_topic;

  /// Password input placeholder
  ///
  /// In en, this message translates to:
  /// **'Your password'**
  String get your_password;

  /// Base URL input placeholder
  ///
  /// In en, this message translates to:
  /// **'Enter base URL'**
  String get enter_base_url;

  /// Base websocket URL input placeholder
  ///
  /// In en, this message translates to:
  /// **'Enter base websocket URL'**
  String get enter_base_websocket_url;

  /// Token input placeholder
  ///
  /// In en, this message translates to:
  /// **'Token'**
  String get token;

  /// Statistics label
  ///
  /// In en, this message translates to:
  /// **'Statistics'**
  String get statistics;

  /// Guides label
  ///
  /// In en, this message translates to:
  /// **'Guides'**
  String get guides;

  /// Completed guides count
  ///
  /// In en, this message translates to:
  /// **'Completed guides'**
  String get completedGuides;

  /// My guides button text
  ///
  /// In en, this message translates to:
  /// **'My guides'**
  String get myGuides;

  /// Past guides section title
  ///
  /// In en, this message translates to:
  /// **'Past guides'**
  String get pastGuides;

  /// Message when no current guide bookings
  ///
  /// In en, this message translates to:
  /// **'You have no scheduled guides'**
  String get noCurrentBookings;

  /// Message when no past guide bookings
  ///
  /// In en, this message translates to:
  /// **'You have no completed guides'**
  String get noPastBookings;

  /// Cancel booking dialog title
  ///
  /// In en, this message translates to:
  /// **'Cancel booking'**
  String get cancelBooking;

  /// Cancel booking confirmation message
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to cancel this booking?'**
  String get cancelBookingConfirmation;

  /// Confirm cancel button text
  ///
  /// In en, this message translates to:
  /// **'Confirm cancellation'**
  String get confirmCancel;

  /// Booking cancelled success message
  ///
  /// In en, this message translates to:
  /// **'Booking cancelled successfully'**
  String get bookingCancelled;

  /// Guide rebooked success message
  ///
  /// In en, this message translates to:
  /// **'Guide rebooked successfully'**
  String get guideRebooked;

  /// Book again button text
  ///
  /// In en, this message translates to:
  /// **'Book again'**
  String get bookAgain;

  /// Cannot cancel guide message
  ///
  /// In en, this message translates to:
  /// **'You cannot cancel this guide'**
  String get cannotCancelGuide;

  /// Upcoming appointments section title
  ///
  /// In en, this message translates to:
  /// **'Upcoming appointments'**
  String get upcomingAppointments;

  /// Next appointment label
  ///
  /// In en, this message translates to:
  /// **'Next appointment'**
  String get nextAppointment;

  /// Message when no upcoming appointments
  ///
  /// In en, this message translates to:
  /// **'You have no upcoming appointments'**
  String get noUpcomingAppointments;

  /// Appointment with instructor label
  ///
  /// In en, this message translates to:
  /// **'Appointment with {instructorName}'**
  String appointmentWith(String instructorName);

  /// Cancel appointment button text
  ///
  /// In en, this message translates to:
  /// **'Cancel appointment'**
  String get cancelAppointment;

  /// Cancel appointment confirmation message
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to cancel this appointment?'**
  String get cancelAppointmentConfirmation;

  /// Appointment cancelled success message
  ///
  /// In en, this message translates to:
  /// **'Appointment cancelled successfully'**
  String get appointmentCancelled;

  /// Cannot cancel appointment within 24 hours message
  ///
  /// In en, this message translates to:
  /// **'You cannot cancel appointments within 24 hours of the scheduled time'**
  String get cannotCancelWithin24Hours;

  /// Reminder message for appointment tomorrow
  ///
  /// In en, this message translates to:
  /// **'Reminder: Your appointment is tomorrow'**
  String get reminderDayBefore;

  /// Reminder message for appointment in 1 hour
  ///
  /// In en, this message translates to:
  /// **'Reminder: Your appointment is in 1 hour'**
  String get reminderHourBefore;

  /// Appointment progress section title
  ///
  /// In en, this message translates to:
  /// **'Progress'**
  String get appointmentProgress;

  /// Total appointments label
  ///
  /// In en, this message translates to:
  /// **'Total'**
  String get totalAppointments;

  /// Upcoming appointments label
  ///
  /// In en, this message translates to:
  /// **'Upcoming'**
  String get upcoming;

  /// Cancelled appointments label
  ///
  /// In en, this message translates to:
  /// **'Cancelled'**
  String get cancelled;

  /// Total hours of appointments label
  ///
  /// In en, this message translates to:
  /// **'Total hours'**
  String get totalHours;

  /// Completion rate label
  ///
  /// In en, this message translates to:
  /// **'Completion rate'**
  String get completionRate;

  /// CTA title for guest users interested in guides
  ///
  /// In en, this message translates to:
  /// **'Interested in driving lessons with us?'**
  String get interestedInGuides;

  /// CTA message for guest users to leave phone number
  ///
  /// In en, this message translates to:
  /// **'Leave your phone number if you\'re interested in taking driving lessons with us'**
  String get leaveYourPhoneNumber;

  /// Phone number field label
  ///
  /// In en, this message translates to:
  /// **'Phone number'**
  String get phoneNumber;

  /// Submit button text
  ///
  /// In en, this message translates to:
  /// **'Submit'**
  String get submit;

  /// Thank you message after submitting phone number
  ///
  /// In en, this message translates to:
  /// **'Thank you for your interest! We will contact you soon.'**
  String get thankYouForInterest;

  /// Title text for the three questions form
  ///
  /// In en, this message translates to:
  /// **'Answer 3 questions:'**
  String get answer3Questions;

  /// Message when instructors are near user location
  ///
  /// In en, this message translates to:
  /// **'We have instructors near your location'**
  String get instructorsNearYou;

  /// Available instructors title
  ///
  /// In en, this message translates to:
  /// **'Available instructors'**
  String get availableInstructors;

  /// See all button text
  ///
  /// In en, this message translates to:
  /// **'See all'**
  String get seeAll;

  /// Select zone hint text
  ///
  /// In en, this message translates to:
  /// **'Select the area where you want to take driving lessons'**
  String get selectZoneHint;

  /// Available today badge
  ///
  /// In en, this message translates to:
  /// **'Available today'**
  String get availableToday;

  /// Available instructors in Milano title
  ///
  /// In en, this message translates to:
  /// **'Available instructors in Milano'**
  String get availableInstructorsInMilano;

  /// Booking successful message
  ///
  /// In en, this message translates to:
  /// **'Booking completed successfully!'**
  String get bookingSuccessful;

  /// Success message when live lesson is booked
  ///
  /// In en, this message translates to:
  /// **'Lesson booked successfully!'**
  String get success_booking;

  /// Booking summary title
  ///
  /// In en, this message translates to:
  /// **'Booking summary'**
  String get bookingSummary;

  /// Location label for city selection
  ///
  /// In en, this message translates to:
  /// **'Location'**
  String get location;

  /// Address label
  ///
  /// In en, this message translates to:
  /// **'Address'**
  String get address;

  /// Code sent confirmation message
  ///
  /// In en, this message translates to:
  /// **'Code sent to {email}'**
  String code_sent_to_email(String email);

  /// Booking request sent confirmation
  ///
  /// In en, this message translates to:
  /// **'Booking request sent!'**
  String get booking_request_sent;

  /// Feature coming soon message
  ///
  /// In en, this message translates to:
  /// **'Feature coming soon!'**
  String get feature_coming_soon;

  /// Message when audio is playing
  ///
  /// In en, this message translates to:
  /// **'Playing audio...'**
  String get playing_audio;

  /// June month abbreviation
  ///
  /// In en, this message translates to:
  /// **'Jun'**
  String get june_abbr;

  /// May month abbreviation
  ///
  /// In en, this message translates to:
  /// **'May'**
  String get may_abbr;

  /// April month abbreviation
  ///
  /// In en, this message translates to:
  /// **'Apr'**
  String get april_abbr;

  /// March month abbreviation
  ///
  /// In en, this message translates to:
  /// **'Mar'**
  String get march_abbr;

  /// February month abbreviation
  ///
  /// In en, this message translates to:
  /// **'Feb'**
  String get february_abbr;

  /// January month abbreviation
  ///
  /// In en, this message translates to:
  /// **'Jan'**
  String get january_abbr;

  /// Changes apply next time message
  ///
  /// In en, this message translates to:
  /// **'Changes would apply next time you open the app.'**
  String get changes_apply_next_app_open;

  /// Current base URL label
  ///
  /// In en, this message translates to:
  /// **'Current Base URL:'**
  String get current_base_url;

  /// Current websocket URL label
  ///
  /// In en, this message translates to:
  /// **'Current Websocket URL:'**
  String get current_websocket_url;

  /// Done button text
  ///
  /// In en, this message translates to:
  /// **'Done'**
  String get done;

  /// Back to home button text
  ///
  /// In en, this message translates to:
  /// **'Back to Home'**
  String get back_to_home;

  /// Step 1 of 2 indicator
  ///
  /// In en, this message translates to:
  /// **'1/2'**
  String get one_of_two;

  /// Step 2 of 2 indicator
  ///
  /// In en, this message translates to:
  /// **'2/2'**
  String get two_of_two;

  /// ID document subtitle
  ///
  /// In en, this message translates to:
  /// **'ID Document'**
  String get document_ci;

  /// Autoscuola Aurelia Milano name
  ///
  /// In en, this message translates to:
  /// **'Autoscuola Aurelia Milano'**
  String get autoscuola_aurelia_milano;

  /// Via Brera address
  ///
  /// In en, this message translates to:
  /// **'Via Brera, 12 - Milan'**
  String get via_brera_address;

  /// E-Book label
  ///
  /// In en, this message translates to:
  /// **'E-Book'**
  String get e_book;

  /// Tagbook label
  ///
  /// In en, this message translates to:
  /// **'Tagbook'**
  String get tagbook;

  /// Exercise label
  ///
  /// In en, this message translates to:
  /// **'Exercise'**
  String get exercise;

  /// Buy now button
  ///
  /// In en, this message translates to:
  /// **'Buy Now'**
  String get buy_now;

  /// Physical theory book description
  ///
  /// In en, this message translates to:
  /// **'Physical theory book with QR codes'**
  String get physical_theory_book;

  /// Learn with physical book description
  ///
  /// In en, this message translates to:
  /// **'Learn with physical book'**
  String get learn_with_physical_book;

  /// Scan and practice description
  ///
  /// In en, this message translates to:
  /// **'Scan and practice'**
  String get scan_and_practice;

  /// QR scanner instructions
  ///
  /// In en, this message translates to:
  /// **'Scan QR code from your manual book to start practicing'**
  String get scan_qr_code_from_manual_book;

  /// QR scanner camera instructions
  ///
  /// In en, this message translates to:
  /// **'Point your camera at the QR code'**
  String get point_camera_at_qr_code;

  /// Invalid QR code error message
  ///
  /// In en, this message translates to:
  /// **'Invalid QR code'**
  String get invalid_qr_code;

  /// Exercise showcase title
  ///
  /// In en, this message translates to:
  /// **'Exercise'**
  String get theory_showcase_exercise_title;

  /// Exercise showcase description
  ///
  /// In en, this message translates to:
  /// **'Scan QR codes from your manual book to practice with targeted questions'**
  String get theory_showcase_exercise_description;

  /// Welcome message on login page
  ///
  /// In en, this message translates to:
  /// **'Welcome!'**
  String get welcome;

  /// Login page subtitle
  ///
  /// In en, this message translates to:
  /// **'Access your account to continue'**
  String get login_to_continue;

  /// Remember me checkbox label
  ///
  /// In en, this message translates to:
  /// **'Remember me'**
  String get remember_me;

  /// Forgot password link text
  ///
  /// In en, this message translates to:
  /// **'Forgot password?'**
  String get forgot_password_question;

  /// Login button text
  ///
  /// In en, this message translates to:
  /// **'Log in'**
  String get login_button;

  /// No account text
  ///
  /// In en, this message translates to:
  /// **'Don\'t have an account? '**
  String get no_account;

  /// Register here link text
  ///
  /// In en, this message translates to:
  /// **'Update here'**
  String get register_here;

  /// No description provided for @account_not_found.
  ///
  /// In en, this message translates to:
  /// **'Account Not Found'**
  String get account_not_found;

  /// No description provided for @account_not_found_message.
  ///
  /// In en, this message translates to:
  /// **'No account found with {provider}. Would you like to create a new account?'**
  String account_not_found_message(Object provider);

  /// Create account title
  ///
  /// In en, this message translates to:
  /// **'Create an account'**
  String get create_account;

  /// No description provided for @complete_registration.
  ///
  /// In en, this message translates to:
  /// **'Complete Registration'**
  String get complete_registration;

  /// No description provided for @welcome_social_user.
  ///
  /// In en, this message translates to:
  /// **'Welcome! Let\'s complete your registration with {provider}'**
  String welcome_social_user(Object provider);

  /// No description provided for @complete_your_profile.
  ///
  /// In en, this message translates to:
  /// **'Complete Your Profile'**
  String get complete_your_profile;

  /// No description provided for @accept_terms.
  ///
  /// In en, this message translates to:
  /// **'I accept the Terms and Conditions'**
  String get accept_terms;

  /// No description provided for @accept_privacy_policy.
  ///
  /// In en, this message translates to:
  /// **'I accept the Privacy Policy'**
  String get accept_privacy_policy;

  /// No description provided for @accept_terms_and_privacy.
  ///
  /// In en, this message translates to:
  /// **'Please accept both Terms and Privacy Policy to continue'**
  String get accept_terms_and_privacy;

  /// No description provided for @registration_successful.
  ///
  /// In en, this message translates to:
  /// **'Registration completed successfully!'**
  String get registration_successful;

  /// No description provided for @registration_successful_title.
  ///
  /// In en, this message translates to:
  /// **'Welcome!'**
  String get registration_successful_title;

  /// No description provided for @registration_successful_message.
  ///
  /// In en, this message translates to:
  /// **'Your account has been created successfully. You\'re now ready to explore all the features.'**
  String get registration_successful_message;

  /// No description provided for @continue_to_app.
  ///
  /// In en, this message translates to:
  /// **'Continue to App'**
  String get continue_to_app;

  /// No description provided for @continue_with_email.
  ///
  /// In en, this message translates to:
  /// **'Continue with Email'**
  String get continue_with_email;

  /// No description provided for @check_other_options.
  ///
  /// In en, this message translates to:
  /// **'Check other options'**
  String get check_other_options;

  /// No description provided for @registration_failed.
  ///
  /// In en, this message translates to:
  /// **'Registration failed. Please try again.'**
  String get registration_failed;

  /// No description provided for @registration_error.
  ///
  /// In en, this message translates to:
  /// **'An error occurred during registration.'**
  String get registration_error;

  /// Search topic hint text
  ///
  /// In en, this message translates to:
  /// **'Search topic'**
  String get search_topic_hint;

  /// Study suggestions text
  ///
  /// In en, this message translates to:
  /// **'Suggestions based on your studies'**
  String get study_suggestions;

  /// Traffic lights and officers suggestion
  ///
  /// In en, this message translates to:
  /// **'Traffic lights and officers'**
  String get traffic_lights_and_officers;

  /// Right of way suggestion
  ///
  /// In en, this message translates to:
  /// **'Right of way'**
  String get right_of_way_topics;

  /// Intersections suggestion
  ///
  /// In en, this message translates to:
  /// **'Intersections'**
  String get intersections;

  /// Book button text
  ///
  /// In en, this message translates to:
  /// **'Book'**
  String get book_button;

  /// Duration label
  ///
  /// In en, this message translates to:
  /// **'Duration - '**
  String get duration_label;

  /// Completed badge text
  ///
  /// In en, this message translates to:
  /// **'Completed'**
  String get completed_badge;

  /// Sunday abbreviation
  ///
  /// In en, this message translates to:
  /// **'S'**
  String get weekday_sun;

  /// Monday abbreviation
  ///
  /// In en, this message translates to:
  /// **'M'**
  String get weekday_mon;

  /// Tuesday abbreviation
  ///
  /// In en, this message translates to:
  /// **'T'**
  String get weekday_tue;

  /// Wednesday abbreviation
  ///
  /// In en, this message translates to:
  /// **'W'**
  String get weekday_wed;

  /// Thursday abbreviation
  ///
  /// In en, this message translates to:
  /// **'T'**
  String get weekday_thu;

  /// Friday abbreviation
  ///
  /// In en, this message translates to:
  /// **'F'**
  String get weekday_fri;

  /// Saturday abbreviation
  ///
  /// In en, this message translates to:
  /// **'S'**
  String get weekday_sat;

  /// January month name
  ///
  /// In en, this message translates to:
  /// **'January'**
  String get january;

  /// February month name
  ///
  /// In en, this message translates to:
  /// **'February'**
  String get february;

  /// March month name
  ///
  /// In en, this message translates to:
  /// **'March'**
  String get march;

  /// April month name
  ///
  /// In en, this message translates to:
  /// **'April'**
  String get april;

  /// May month name
  ///
  /// In en, this message translates to:
  /// **'May'**
  String get may;

  /// June month name
  ///
  /// In en, this message translates to:
  /// **'June'**
  String get june;

  /// July month name
  ///
  /// In en, this message translates to:
  /// **'July'**
  String get july;

  /// August month name
  ///
  /// In en, this message translates to:
  /// **'August'**
  String get august;

  /// September month name
  ///
  /// In en, this message translates to:
  /// **'September'**
  String get september;

  /// October month name
  ///
  /// In en, this message translates to:
  /// **'October'**
  String get october;

  /// November month name
  ///
  /// In en, this message translates to:
  /// **'November'**
  String get november;

  /// December month name
  ///
  /// In en, this message translates to:
  /// **'December'**
  String get december;

  /// Live count suffix
  ///
  /// In en, this message translates to:
  /// **'live'**
  String get live_count;

  /// First name hint text
  ///
  /// In en, this message translates to:
  /// **'Mario'**
  String get first_name_hint;

  /// Last name hint text
  ///
  /// In en, this message translates to:
  /// **'Rossi'**
  String get last_name_hint;

  /// Continue registration button
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get continue_registration;

  /// Step 1 of 3 progress indicator
  ///
  /// In en, this message translates to:
  /// **'Step 1 of 3'**
  String get step_1_of_3;

  /// Already have account text
  ///
  /// In en, this message translates to:
  /// **'Already have an account?'**
  String get already_have_account;

  /// Login link text
  ///
  /// In en, this message translates to:
  /// **'Log in'**
  String get login_link;

  /// Step 2 of 3 progress indicator
  ///
  /// In en, this message translates to:
  /// **'Step 2 of 3'**
  String get step_2_of_3;

  /// Email hint text
  ///
  /// In en, this message translates to:
  /// **'enter@youremail.com'**
  String get email_hint;

  /// Phone number hint text with country code
  ///
  /// In en, this message translates to:
  /// **'+39 1234567890'**
  String get phone_hint;

  /// Step 3 of 3 progress indicator
  ///
  /// In en, this message translates to:
  /// **'Step 3 of 3'**
  String get step_3_of_3;

  /// Confirm password hint text
  ///
  /// In en, this message translates to:
  /// **'Confirm your password'**
  String get confirm_password_hint;

  /// Register button text
  ///
  /// In en, this message translates to:
  /// **'Register'**
  String get register_button;

  /// Reset password title
  ///
  /// In en, this message translates to:
  /// **'Reset Password'**
  String get reset_password;

  /// Reset password subtitle
  ///
  /// In en, this message translates to:
  /// **'Enter your email to receive reset instructions'**
  String get reset_password_subtitle;

  /// Send reset email button
  ///
  /// In en, this message translates to:
  /// **'Send Email'**
  String get send_reset_email;

  /// Verify email step title
  ///
  /// In en, this message translates to:
  /// **'Verify Your Email'**
  String get verify_email_title;

  /// Verify email step subtitle
  ///
  /// In en, this message translates to:
  /// **'We sent a verification code to'**
  String get verify_email_subtitle;

  /// Verification code label
  ///
  /// In en, this message translates to:
  /// **'Verification Code'**
  String get verification_code;

  /// Verification code hint
  ///
  /// In en, this message translates to:
  /// **'123456'**
  String get verification_code_hint;

  /// Verify code button
  ///
  /// In en, this message translates to:
  /// **'Verify Code'**
  String get verify_code;

  /// New password step title
  ///
  /// In en, this message translates to:
  /// **'New Password'**
  String get new_password_title;

  /// New password step subtitle
  ///
  /// In en, this message translates to:
  /// **'Create a new secure password'**
  String get new_password_subtitle;

  /// New password label
  ///
  /// In en, this message translates to:
  /// **'New Password'**
  String get new_password;

  /// New password hint
  ///
  /// In en, this message translates to:
  /// **'Your new password'**
  String get new_password_hint;

  /// Confirm new password label
  ///
  /// In en, this message translates to:
  /// **'Confirm New Password'**
  String get confirm_new_password;

  /// Confirm new password hint
  ///
  /// In en, this message translates to:
  /// **'Confirm your new password'**
  String get confirm_new_password_hint;

  /// Update password button
  ///
  /// In en, this message translates to:
  /// **'Update Password'**
  String get update_password;

  /// Back to login link
  ///
  /// In en, this message translates to:
  /// **'Back to Login'**
  String get back_to_login;

  /// Resend code link
  ///
  /// In en, this message translates to:
  /// **'Resend Code'**
  String get resend_code;

  /// Title for theoretical manual with video card
  ///
  /// In en, this message translates to:
  /// **'Theoretical manual with video'**
  String get theoretical_manual_with_video;

  /// Description for theoretical manual with video card
  ///
  /// In en, this message translates to:
  /// **'Study theory together with the virtual teacher'**
  String get study_theory_with_virtual_teacher;

  /// Description for e-book card
  ///
  /// In en, this message translates to:
  /// **'Your digital theory manual'**
  String get your_digital_theory_manual;

  /// Button text to start QR code scan
  ///
  /// In en, this message translates to:
  /// **'Start scan'**
  String get start_scan;

  /// Description for tagbook scan functionality
  ///
  /// In en, this message translates to:
  /// **'Scan the QR code and practice'**
  String get scan_qr_code_and_practice;

  /// Text for viewing progress
  ///
  /// In en, this message translates to:
  /// **'View your progress'**
  String get view_your_progress;

  /// Progress view by topic
  ///
  /// In en, this message translates to:
  /// **'By topic'**
  String get by_topic;

  /// Label for topic in virtual teacher quiz
  ///
  /// In en, this message translates to:
  /// **'Topic:'**
  String get topic_label;

  /// Label for answers progress
  ///
  /// In en, this message translates to:
  /// **'Answers'**
  String get answers;

  /// Progress indicator showing current question of total
  ///
  /// In en, this message translates to:
  /// **'{current} of {total}'**
  String question_of_total(int current, int total);

  /// Subtitle text for virtual teacher quiz
  ///
  /// In en, this message translates to:
  /// **'Verify your preparation and answer the quizzes'**
  String get verify_preparation_and_answer;

  /// Feedback message when true is selected
  ///
  /// In en, this message translates to:
  /// **'Selected: TRUE'**
  String get selected_true;

  /// Feedback message when false is selected
  ///
  /// In en, this message translates to:
  /// **'Selected: FALSE'**
  String get selected_false;

  /// Street address label
  ///
  /// In en, this message translates to:
  /// **'Street'**
  String get street;

  /// House number label
  ///
  /// In en, this message translates to:
  /// **'House Number'**
  String get house_number;

  /// Postal code label
  ///
  /// In en, this message translates to:
  /// **'Postal Code'**
  String get postal_code;

  /// Street input placeholder
  ///
  /// In en, this message translates to:
  /// **'Enter street name'**
  String get street_placeholder;

  /// House number input placeholder
  ///
  /// In en, this message translates to:
  /// **'Enter house number'**
  String get house_number_placeholder;

  /// Postal code input placeholder
  ///
  /// In en, this message translates to:
  /// **'Enter postal code'**
  String get postal_code_placeholder;

  /// Alternative address section title
  ///
  /// In en, this message translates to:
  /// **'Alternative Address'**
  String get alternative_address;

  /// Alternative address description
  ///
  /// In en, this message translates to:
  /// **'Enter the address where you want to book the medical visit'**
  String get alternative_address_description;

  /// City label
  ///
  /// In en, this message translates to:
  /// **'City'**
  String get city;

  /// City search autocomplete placeholder
  ///
  /// In en, this message translates to:
  /// **'Search for a city...'**
  String get search_city_placeholder;

  /// Title for assistance/support chat page
  ///
  /// In en, this message translates to:
  /// **'Assistance'**
  String get assistance;

  /// Email subject line for iOS assistance requests
  ///
  /// In en, this message translates to:
  /// **'Suggestions / assistance Quiz Patente iOS'**
  String get email_assistance_subject_ios;

  /// Email subject line for Android assistance requests
  ///
  /// In en, this message translates to:
  /// **'Suggestions / assistance Quiz Patente Android'**
  String get email_assistance_subject_android;

  /// Email subject line for generic assistance requests
  ///
  /// In en, this message translates to:
  /// **'Suggestions / assistance Quiz Patente'**
  String get email_assistance_subject_generic;

  /// Message shown when user cannot cancel a guide booking
  ///
  /// In en, this message translates to:
  /// **'You cannot cancel the guide'**
  String get cannot_cancel_guide;

  /// Button text to download concept map
  ///
  /// In en, this message translates to:
  /// **'Download concept map'**
  String get download_concept_map;

  /// Title for conceptual mind map modal
  ///
  /// In en, this message translates to:
  /// **'Conceptual Mind Map'**
  String get conceptual_mind_map;

  /// Review section title
  ///
  /// In en, this message translates to:
  /// **'Write a review'**
  String get write_a_review;

  /// Review section subtitle
  ///
  /// In en, this message translates to:
  /// **'Rate our app on the stores'**
  String get rate_our_app_on_stores;

  /// Write feedback for us text
  ///
  /// In en, this message translates to:
  /// **'Write your feedback for us'**
  String get write_your_feedback_for_us;

  /// Account unification banner title
  ///
  /// In en, this message translates to:
  /// **'Account Unification'**
  String get account_unification;

  /// Short account unification description
  ///
  /// In en, this message translates to:
  /// **'Merge your accounts in the Profile section to sync all progress.'**
  String get account_unification_short_description;

  /// Exam preparation title
  ///
  /// In en, this message translates to:
  /// **'Exam preparation'**
  String get exam_preparation;

  /// Ministerial sheets label
  ///
  /// In en, this message translates to:
  /// **'Ministerial sheets'**
  String get ministerial_sheets;

  /// Ministerial sheets completed count
  ///
  /// In en, this message translates to:
  /// **'Ministerial sheets completed'**
  String get ministerial_sheets_completed;

  /// Average errors in last 20 sheets
  ///
  /// In en, this message translates to:
  /// **'Average errors last 20 sheets'**
  String get average_errors_last_20_sheets;

  /// Show statistics button text
  ///
  /// In en, this message translates to:
  /// **'Show statistics'**
  String get show_statistics;

  /// Out of label for progress
  ///
  /// In en, this message translates to:
  /// **'out of'**
  String get out_of;

  /// Progress section heading
  ///
  /// In en, this message translates to:
  /// **'Progress'**
  String get progress;

  /// Errors this week label
  ///
  /// In en, this message translates to:
  /// **'errors this week'**
  String get errors_this_week;

  /// Overview tab title
  ///
  /// In en, this message translates to:
  /// **'Overview'**
  String get overview;

  /// Topics tab title
  ///
  /// In en, this message translates to:
  /// **'Topics'**
  String get topics;

  /// Trends tab title
  ///
  /// In en, this message translates to:
  /// **'Trends'**
  String get trends;

  /// Weekly progress title
  ///
  /// In en, this message translates to:
  /// **'Weekly progress'**
  String get weekly_progress;

  /// Studied topics title
  ///
  /// In en, this message translates to:
  /// **'Studied topics'**
  String get studied_topics;

  /// General completion label
  ///
  /// In en, this message translates to:
  /// **'General completion'**
  String get general_completion;

  /// Text for completed status
  ///
  /// In en, this message translates to:
  /// **'Completed'**
  String get completed;

  /// In progress status
  ///
  /// In en, this message translates to:
  /// **'In progress'**
  String get in_progress;

  /// To start status
  ///
  /// In en, this message translates to:
  /// **'To start'**
  String get to_start;

  /// Monday abbreviation in Italian
  ///
  /// In en, this message translates to:
  /// **'L'**
  String get weekday_l;

  /// Tuesday/Wednesday abbreviation in Italian
  ///
  /// In en, this message translates to:
  /// **'M'**
  String get weekday_m;

  /// Thursday abbreviation in Italian
  ///
  /// In en, this message translates to:
  /// **'G'**
  String get weekday_g;

  /// Friday abbreviation in Italian
  ///
  /// In en, this message translates to:
  /// **'V'**
  String get weekday_v;

  /// Saturday abbreviation in Italian
  ///
  /// In en, this message translates to:
  /// **'S'**
  String get weekday_s;

  /// Sunday abbreviation in Italian
  ///
  /// In en, this message translates to:
  /// **'D'**
  String get weekday_d;

  /// Horizontal marking topic
  ///
  /// In en, this message translates to:
  /// **'Horizontal marking'**
  String get horizontal_marking;

  /// Correct quizzes label
  ///
  /// In en, this message translates to:
  /// **'Correct quizzes'**
  String get correct_quizzes;

  /// Wrong quizzes label
  ///
  /// In en, this message translates to:
  /// **'Wrong quizzes'**
  String get wrong_quizzes;

  /// Average time label
  ///
  /// In en, this message translates to:
  /// **'Average time'**
  String get average_time;

  /// Review button text
  ///
  /// In en, this message translates to:
  /// **'Review'**
  String get review;

  /// View errors button text
  ///
  /// In en, this message translates to:
  /// **'View errors'**
  String get view_errors;

  /// Errors text for trend indicators
  ///
  /// In en, this message translates to:
  /// **'errors'**
  String get errors;

  /// Daily ministerial sheets chart title
  ///
  /// In en, this message translates to:
  /// **'Daily ministerial sheets'**
  String get daily_ministerial_sheets;

  /// Error trends chart title
  ///
  /// In en, this message translates to:
  /// **'Error trends'**
  String get error_trends;

  /// Last week time period
  ///
  /// In en, this message translates to:
  /// **'Last week'**
  String get last_week;

  /// Weekly total label
  ///
  /// In en, this message translates to:
  /// **'Weekly total:'**
  String get weekly_total;

  /// Sheets unit
  ///
  /// In en, this message translates to:
  /// **'sheets'**
  String get sheets;

  /// Current average label
  ///
  /// In en, this message translates to:
  /// **'Current average'**
  String get current_average;

  /// 7-day average label
  ///
  /// In en, this message translates to:
  /// **'7-day average'**
  String get sevenDayAverage;

  /// Exam threshold label
  ///
  /// In en, this message translates to:
  /// **'Exam threshold'**
  String get exam_threshold;

  /// Or conjunction
  ///
  /// In en, this message translates to:
  /// **'or'**
  String get or;

  /// Google sign in button text
  ///
  /// In en, this message translates to:
  /// **'Continue with Google'**
  String get continue_with_google;

  /// Apple sign in button text
  ///
  /// In en, this message translates to:
  /// **'Continue with Apple'**
  String get continue_with_apple;

  /// Facebook sign in button text
  ///
  /// In en, this message translates to:
  /// **'Continue with Facebook'**
  String get continue_with_facebook;

  /// Header for list of recent accounts
  ///
  /// In en, this message translates to:
  /// **'Recent accounts'**
  String get recent_accounts;

  /// Button to clear all stored accounts
  ///
  /// In en, this message translates to:
  /// **'Clear all'**
  String get clear_all;

  /// Header for all accounts bottom sheet
  ///
  /// In en, this message translates to:
  /// **'All accounts'**
  String get all_accounts;

  /// Remove account dialog title
  ///
  /// In en, this message translates to:
  /// **'Remove account'**
  String get remove_account;

  /// Remove account confirmation message
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to remove {email} from this device?'**
  String remove_account_confirmation(String email);

  /// Clear all accounts dialog title
  ///
  /// In en, this message translates to:
  /// **'Clear all accounts'**
  String get clear_all_accounts;

  /// Clear all accounts confirmation message
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to remove all saved accounts from this device?'**
  String get clear_all_accounts_confirmation;

  /// Remove button text
  ///
  /// In en, this message translates to:
  /// **'Remove'**
  String get remove;

  /// See more accounts button text
  ///
  /// In en, this message translates to:
  /// **'See {count} more accounts'**
  String see_more_accounts(int count);

  /// Error message for invalid login credentials
  ///
  /// In en, this message translates to:
  /// **'Invalid email or password. Please check your credentials and try again.'**
  String get invalid_credentials;

  /// Error message for invalid email format
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid email address'**
  String get invalid_email;

  /// Text shown when user is not logged in
  ///
  /// In en, this message translates to:
  /// **'User not logged in'**
  String get user_not_logged_in;

  /// Text encouraging user to log in
  ///
  /// In en, this message translates to:
  /// **'Log in to access all features'**
  String get login_to_access_features;

  /// Snackbar message shown to non-authenticated users on dashboard
  ///
  /// In en, this message translates to:
  /// **'You\'re browsing as a guest. Log in to access all features and save your progress!'**
  String get dashboard_guest_mode_message;

  /// Text shown when user is logged in as a guest
  ///
  /// In en, this message translates to:
  /// **'Logged in as Guest'**
  String get logged_in_as_guest;

  /// Title for guest user profile section
  ///
  /// In en, this message translates to:
  /// **'Guest User Area'**
  String get guest_user_area;

  /// Status message for active guest account
  ///
  /// In en, this message translates to:
  /// **'Guest Account Active'**
  String get guest_account_active;

  /// Error message when stored account tokens have expired
  ///
  /// In en, this message translates to:
  /// **'Problem with this account. It has been expired. Login again'**
  String get account_expired;

  /// Title for confirm medical visit page
  ///
  /// In en, this message translates to:
  /// **'Confirm medical visit'**
  String get confirm_medical_visit;

  /// Title for medical visit location page
  ///
  /// In en, this message translates to:
  /// **'Medical visit location'**
  String get medical_visit_location;

  /// Title for medical visit timing page
  ///
  /// In en, this message translates to:
  /// **'Medical visit timing'**
  String get medical_visit_timing;

  /// Almost done message
  ///
  /// In en, this message translates to:
  /// **'Almost done!'**
  String get almost_done;

  /// Progress message for 1-10%
  ///
  /// In en, this message translates to:
  /// **'Great start! Every expert was once a beginner'**
  String get progress_just_started;

  /// Progress message for 10-25%
  ///
  /// In en, this message translates to:
  /// **'You\'re building a solid foundation!'**
  String get progress_building_foundation;

  /// Progress message for 25-40%
  ///
  /// In en, this message translates to:
  /// **'You\'re gaining momentum! Keep it up'**
  String get progress_gaining_momentum;

  /// Progress message for 40-50%
  ///
  /// In en, this message translates to:
  /// **'Halfway there! Your hard work is paying off'**
  String get progress_halfway;

  /// Progress message for 50-60%
  ///
  /// In en, this message translates to:
  /// **'Over halfway! You\'re doing amazing'**
  String get progress_over_halfway;

  /// Progress message for 60-75%
  ///
  /// In en, this message translates to:
  /// **'Strong progress! The finish line is in sight'**
  String get progress_strong_progress;

  /// Progress message for 75-85%
  ///
  /// In en, this message translates to:
  /// **'Final stretch! You\'ve got this'**
  String get progress_final_stretch;

  /// Progress message for 85-95%
  ///
  /// In en, this message translates to:
  /// **'Almost there! Just a little more to go'**
  String get progress_almost_there;

  /// Progress message for 95-99%
  ///
  /// In en, this message translates to:
  /// **'Outstanding! You\'re nearly perfect'**
  String get progress_excellence;

  /// Check your data message
  ///
  /// In en, this message translates to:
  /// **'Check your data'**
  String get check_your_data;

  /// Where do you live now question
  ///
  /// In en, this message translates to:
  /// **'Where do you live now?'**
  String get where_do_you_live_now;

  /// Find nearest center message
  ///
  /// In en, this message translates to:
  /// **'Find the nearest center to you'**
  String get find_nearest_center;

  /// When do you prefer question
  ///
  /// In en, this message translates to:
  /// **'When do you prefer?'**
  String get when_do_you_prefer;

  /// Select 3 time slots instruction
  ///
  /// In en, this message translates to:
  /// **'Select 3 time slots'**
  String get select_3_time_slots;

  /// City where you live label
  ///
  /// In en, this message translates to:
  /// **'The city where you live now'**
  String get city_where_you_live;

  /// Province where you live label
  ///
  /// In en, this message translates to:
  /// **'The province where you live now'**
  String get province_where_you_live;

  /// City examples placeholder
  ///
  /// In en, this message translates to:
  /// **'E.g. Milan, Rome, Naples...'**
  String get city_examples;

  /// Select placeholder
  ///
  /// In en, this message translates to:
  /// **'Select'**
  String get select_placeholder;

  /// Where label
  ///
  /// In en, this message translates to:
  /// **'Where'**
  String get where;

  /// When label
  ///
  /// In en, this message translates to:
  /// **'When'**
  String get when;

  /// Reason for city change label
  ///
  /// In en, this message translates to:
  /// **'Reason for city change:'**
  String get reason_city_change;

  /// Change visit city checkbox label
  ///
  /// In en, this message translates to:
  /// **'Change visit city'**
  String get change_visit_city;

  /// Useful if visit far from home description
  ///
  /// In en, this message translates to:
  /// **'Useful if you need to request the visit far from home'**
  String get useful_if_visit_far_from_home;

  /// Reason for change label
  ///
  /// In en, this message translates to:
  /// **'Reason for change:'**
  String get reason_for_change;

  /// Why change city placeholder
  ///
  /// In en, this message translates to:
  /// **'Why do you want to change the medical visit city?'**
  String get why_change_city_placeholder;

  /// Medical visit location info
  ///
  /// In en, this message translates to:
  /// **'The medical visit will be requested at the center closest to the indicated location.'**
  String get medical_visit_requested_nearest_center;

  /// Call confirmation message
  ///
  /// In en, this message translates to:
  /// **'You will receive a call within 24 hours to confirm the appointment.'**
  String get you_will_receive_call_24h;

  /// Request booking button
  ///
  /// In en, this message translates to:
  /// **'Request booking'**
  String get request_booking;

  /// Back button
  ///
  /// In en, this message translates to:
  /// **'Back'**
  String get back;

  /// Select availability label
  ///
  /// In en, this message translates to:
  /// **'Select availability'**
  String get select_availability;

  /// Choose 3 preferred time slots instruction
  ///
  /// In en, this message translates to:
  /// **'Choose 3 preferred time slots'**
  String get choose_3_preferred_time_slots;

  /// Select more time slots message
  ///
  /// In en, this message translates to:
  /// **'Select {count} more time slots to continue'**
  String select_more_time_slots(int count);

  /// Confirm theoretical exam title
  ///
  /// In en, this message translates to:
  /// **'Confirm theoretical exam'**
  String get confirm_theoretical_exam;

  /// Driving school label
  ///
  /// In en, this message translates to:
  /// **'Driving school'**
  String get driving_school;

  /// Distance from address
  ///
  /// In en, this message translates to:
  /// **'2.3 km from your address'**
  String get km_from_address;

  /// Time availability label
  ///
  /// In en, this message translates to:
  /// **'Time availability'**
  String get time_availability;

  /// Call confirmation for exam message
  ///
  /// In en, this message translates to:
  /// **'You will receive a call within 24 hours to confirm the exam date.'**
  String get call_24h_confirm_exam;

  /// Request exam booking button
  ///
  /// In en, this message translates to:
  /// **'Request exam booking'**
  String get request_exam_booking;

  /// Booking request success message
  ///
  /// In en, this message translates to:
  /// **'Booking request sent successfully!'**
  String get booking_request_sent_successfully;

  /// Exam booking request success message
  ///
  /// In en, this message translates to:
  /// **'Exam booking request sent successfully!'**
  String get exam_booking_request_sent_successfully;

  /// Error message when booking medical visit fails
  ///
  /// In en, this message translates to:
  /// **'Error booking medical visit. Please try again.'**
  String get error_booking_medical_visit;

  /// Showcase title for theoretical manual
  ///
  /// In en, this message translates to:
  /// **'Theoretical Manual'**
  String get theory_showcase_manual_title;

  /// Showcase description for theoretical manual
  ///
  /// In en, this message translates to:
  /// **'Access your interactive theoretical manual with video lessons and virtual teacher support.'**
  String get theory_showcase_manual_description;

  /// Showcase title for e-book
  ///
  /// In en, this message translates to:
  /// **'E-Book'**
  String get theory_showcase_ebook_title;

  /// Showcase description for e-book
  ///
  /// In en, this message translates to:
  /// **'Your digital theory manual, always available for offline study.'**
  String get theory_showcase_ebook_description;

  /// Showcase title for tagbook
  ///
  /// In en, this message translates to:
  /// **'Tagbook'**
  String get theory_showcase_tagbook_title;

  /// Showcase description for tagbook
  ///
  /// In en, this message translates to:
  /// **'Scan QR codes to practice and view your progress by topic.'**
  String get theory_showcase_tagbook_description;

  /// Showcase title for banner
  ///
  /// In en, this message translates to:
  /// **'Banner'**
  String get theory_showcase_banner_title;

  /// Showcase description for banner
  ///
  /// In en, this message translates to:
  /// **'Stay updated with announcements and important information.'**
  String get theory_showcase_banner_description;

  /// Title for e-book chapters page
  ///
  /// In en, this message translates to:
  /// **'E-Book Chapters'**
  String get ebook_chapters_title;

  /// Message when no e-book chapters are available
  ///
  /// In en, this message translates to:
  /// **'No chapters available'**
  String get ebook_no_chapters;

  /// Error message when e-book fails to load
  ///
  /// In en, this message translates to:
  /// **'Failed to load e-book content. Please check your connection and try again.'**
  String get ebook_load_error;

  /// Tooltip for increasing text size
  ///
  /// In en, this message translates to:
  /// **'Increase text size'**
  String get ebook_increase_text_size;

  /// Tooltip for decreasing text size
  ///
  /// In en, this message translates to:
  /// **'Decrease text size'**
  String get ebook_decrease_text_size;

  /// Refresh button label
  ///
  /// In en, this message translates to:
  /// **'Refresh'**
  String get refresh;

  /// Retry button text
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get retry;

  /// E-book activation page title
  ///
  /// In en, this message translates to:
  /// **'E-Book Activation'**
  String get ebook_activation;

  /// Title for ebook code entry screen
  ///
  /// In en, this message translates to:
  /// **'Activate Your E-Book'**
  String get ebook_enter_code_title;

  /// Description for ebook code entry
  ///
  /// In en, this message translates to:
  /// **'Enter your activation code to access the digital theory manual'**
  String get ebook_enter_code_description;

  /// Label for ebook code input field
  ///
  /// In en, this message translates to:
  /// **'Activation Code'**
  String get ebook_code;

  /// Hint text for ebook code input
  ///
  /// In en, this message translates to:
  /// **'Enter your code'**
  String get ebook_code_hint;

  /// Error message when code field is empty
  ///
  /// In en, this message translates to:
  /// **'Please enter an activation code'**
  String get ebook_code_required;

  /// Error message for invalid ebook code
  ///
  /// In en, this message translates to:
  /// **'Invalid code. Please check and try again'**
  String get ebook_code_invalid;

  /// Message when user already has active ebook
  ///
  /// In en, this message translates to:
  /// **'E-Book is already active'**
  String get ebook_code_active;

  /// Button to activate ebook code
  ///
  /// In en, this message translates to:
  /// **'Activate'**
  String get ebook_activate;

  /// Title when ebook chapters are locked
  ///
  /// In en, this message translates to:
  /// **'E-Book Access Required'**
  String get ebook_locked_title;

  /// Description when ebook is locked
  ///
  /// In en, this message translates to:
  /// **'Enter an activation code to access e-book chapters'**
  String get ebook_locked_description;

  /// Button to go to code entry page
  ///
  /// In en, this message translates to:
  /// **'Enter Code'**
  String get ebook_enter_code;

  /// Title for ministerial sheet info dialog
  ///
  /// In en, this message translates to:
  /// **'MINISTERIAL SHEET'**
  String get ministerial_sheet_info_title;

  /// Description for ministerial sheet info dialog
  ///
  /// In en, this message translates to:
  /// **'Choose whether to practice on an exam test (i.e., the same quizzes you will find in the exam session) or on one or more topics. You will not have the manual available.'**
  String get ministerial_sheet_info_description;

  /// Title for ministerial sheet with manual info dialog
  ///
  /// In en, this message translates to:
  /// **'MINISTERIAL SHEET WITH MANUAL'**
  String get ministerial_sheet_with_manual_info_title;

  /// Description for ministerial sheet with manual info dialog
  ///
  /// In en, this message translates to:
  /// **'Choose whether to practice on an exam test (i.e., the same quizzes you will find in the exam session) or on one or more topics. You will have the manual available.'**
  String get ministerial_sheet_with_manual_info_description;

  /// Title for error review info dialog
  ///
  /// In en, this message translates to:
  /// **'ERROR REVIEW'**
  String get error_review_info_title;

  /// Description for error review info dialog
  ///
  /// In en, this message translates to:
  /// **'Choose whether to practice on quizzes you got wrong, or on one or more topics.'**
  String get error_review_info_description;

  /// Title for error review topic selection page
  ///
  /// In en, this message translates to:
  /// **'Select Error Review Topics'**
  String get select_error_review_topics;

  /// Button text for starting error review quiz
  ///
  /// In en, this message translates to:
  /// **'Create topic combinations and start error review quiz'**
  String get create_error_review_combinations;

  /// Message when no manuals are available
  ///
  /// In en, this message translates to:
  /// **'No manuals available'**
  String get no_manuals_available;

  /// Message when no manuals match search query
  ///
  /// In en, this message translates to:
  /// **'No manuals found for \"{query}\"'**
  String no_manuals_found(String query);

  /// Message when manual has no content
  ///
  /// In en, this message translates to:
  /// **'No content available'**
  String get no_content_available;

  /// Button text to mark manual as completed
  ///
  /// In en, this message translates to:
  /// **'Mark as completed'**
  String get mark_as_completed;

  /// Link text to read more content
  ///
  /// In en, this message translates to:
  /// **'Read more'**
  String get read_more;

  /// Title for manual detail page
  ///
  /// In en, this message translates to:
  /// **'Manual Detail'**
  String get manual_detail;

  /// Button text to open related manual/theory
  ///
  /// In en, this message translates to:
  /// **'Open Manual'**
  String get open_manual;

  /// Message when no topics match search query
  ///
  /// In en, this message translates to:
  /// **'No topics found for \"{query}\"'**
  String no_topics_found(String query);

  /// Title for lesson summary sheet
  ///
  /// In en, this message translates to:
  /// **'Lesson Summary'**
  String get lesson_summary;

  /// Label for material/content section
  ///
  /// In en, this message translates to:
  /// **'Material'**
  String get material;

  /// Button text to start text-to-speech
  ///
  /// In en, this message translates to:
  /// **'Read Aloud'**
  String get read_aloud;

  /// Error message when translation cannot be fetched
  ///
  /// In en, this message translates to:
  /// **'Translation unavailable, showing original content'**
  String get translation_unavailable;

  /// Button text to stop text-to-speech
  ///
  /// In en, this message translates to:
  /// **'Stop Reading'**
  String get stop_reading;

  /// Title for images section
  ///
  /// In en, this message translates to:
  /// **'Images'**
  String get images;

  /// Title for quiz questions page
  ///
  /// In en, this message translates to:
  /// **'Quiz Questions'**
  String get quiz_questions;

  /// Filter option for all questions
  ///
  /// In en, this message translates to:
  /// **'All Questions'**
  String get all_questions;

  /// Filter option for true/false questions
  ///
  /// In en, this message translates to:
  /// **'True/False Only'**
  String get true_false_only;

  /// Filter option for multiple choice questions
  ///
  /// In en, this message translates to:
  /// **'Multiple Choice Only'**
  String get multiple_choice_only;

  /// Button text to filter questions
  ///
  /// In en, this message translates to:
  /// **'Filter Questions'**
  String get filter_questions;

  /// Label for question text
  ///
  /// In en, this message translates to:
  /// **'Question'**
  String get question;

  /// Label for answer text
  ///
  /// In en, this message translates to:
  /// **'Answer'**
  String get answer;

  /// Label for explanation text
  ///
  /// In en, this message translates to:
  /// **'Explanation'**
  String get explanation;

  /// Title for feedback dialog
  ///
  /// In en, this message translates to:
  /// **'Send Feedback'**
  String get feedback_title;

  /// Description text for feedback dialog
  ///
  /// In en, this message translates to:
  /// **'Help us improve the app by sharing your thoughts, reporting bugs, or suggesting new features.'**
  String get feedback_description;

  /// Simplified description text for feedback dialog
  ///
  /// In en, this message translates to:
  /// **'Help us improve the app! Your feedback is valuable.'**
  String get feedback_description_simple;

  /// Label for feedback type selection
  ///
  /// In en, this message translates to:
  /// **'Feedback Type'**
  String get feedback_type;

  /// Option for bug report feedback type
  ///
  /// In en, this message translates to:
  /// **'Bug Report'**
  String get feedback_type_bug;

  /// Option for feature request feedback type
  ///
  /// In en, this message translates to:
  /// **'Feature Request'**
  String get feedback_type_feature;

  /// Option for improvement feedback type
  ///
  /// In en, this message translates to:
  /// **'Improvement'**
  String get feedback_type_improvement;

  /// Option for other feedback type
  ///
  /// In en, this message translates to:
  /// **'Other'**
  String get feedback_type_other;

  /// Label for name field in feedback form
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get feedback_name;

  /// Hint text for name field
  ///
  /// In en, this message translates to:
  /// **'Enter your name'**
  String get feedback_name_hint;

  /// Validation message for required name field
  ///
  /// In en, this message translates to:
  /// **'Name is required'**
  String get feedback_name_required;

  /// Label for email field in feedback form
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get feedback_email;

  /// Hint text for email field
  ///
  /// In en, this message translates to:
  /// **'Enter your email address'**
  String get feedback_email_hint;

  /// Validation message for required email field
  ///
  /// In en, this message translates to:
  /// **'Email is required'**
  String get feedback_email_required;

  /// Validation message for invalid email format
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid email address'**
  String get feedback_email_invalid;

  /// Label for comments field in feedback form
  ///
  /// In en, this message translates to:
  /// **'Comments'**
  String get feedback_comments;

  /// Hint text for comments field
  ///
  /// In en, this message translates to:
  /// **'Describe your feedback, bug report, or feature request...'**
  String get feedback_comments_hint;

  /// Simplified hint text for comments field
  ///
  /// In en, this message translates to:
  /// **'Tell us what\'s on your mind...'**
  String get feedback_comments_hint_simple;

  /// Validation message for required comments field
  ///
  /// In en, this message translates to:
  /// **'Comments are required'**
  String get feedback_comments_required;

  /// Validation message for minimum comment length
  ///
  /// In en, this message translates to:
  /// **'Please provide at least 10 characters'**
  String get feedback_comments_min_length;

  /// Simplified validation message for minimum comment length
  ///
  /// In en, this message translates to:
  /// **'Please provide at least 5 characters'**
  String get feedback_comments_min_length_simple;

  /// Button text to submit feedback
  ///
  /// In en, this message translates to:
  /// **'Submit Feedback'**
  String get feedback_submit;

  /// Question asking when user wants to get driver's license
  ///
  /// In en, this message translates to:
  /// **'When do you want to get your driver\'s license?'**
  String get when_want_license;

  /// Hint text for when user wants license field
  ///
  /// In en, this message translates to:
  /// **'e.g. In 6 months, Next year'**
  String get when_want_license_hint;

  /// Question asking user's current age
  ///
  /// In en, this message translates to:
  /// **'How old are you now?'**
  String get current_age;

  /// Hint text for current age field
  ///
  /// In en, this message translates to:
  /// **'Enter your age'**
  String get current_age_hint;

  /// Success message after feedback submission
  ///
  /// In en, this message translates to:
  /// **'Thank you! Your feedback has been submitted successfully.'**
  String get feedback_submitted_successfully;

  /// Error message when feedback submission fails
  ///
  /// In en, this message translates to:
  /// **'Failed to submit feedback. Please try again.'**
  String get feedback_submission_failed;

  /// Label for feedback floating button
  ///
  /// In en, this message translates to:
  /// **'Feedback'**
  String get feedback_button_label;

  /// Error message when language content update fails
  ///
  /// In en, this message translates to:
  /// **'Failed to update content. Please try again.'**
  String get failed_to_update_content;

  /// Section title for residential address
  ///
  /// In en, this message translates to:
  /// **'Your Residential Address'**
  String get your_residential_address;

  /// Placeholder text for address field
  ///
  /// In en, this message translates to:
  /// **'Enter your address'**
  String get address_placeholder;

  /// Zip code label
  ///
  /// In en, this message translates to:
  /// **'Zip Code'**
  String get zip_code;

  /// Placeholder text for zip code field
  ///
  /// In en, this message translates to:
  /// **'Enter zip code'**
  String get zip_code_placeholder;

  /// Province label
  ///
  /// In en, this message translates to:
  /// **'Province'**
  String get province;

  /// Placeholder for province dropdown
  ///
  /// In en, this message translates to:
  /// **'Select province'**
  String get select_province;

  /// Message explaining why address is required for subscription
  ///
  /// In en, this message translates to:
  /// **'Leave us your address so we can best manage your medical visit and/or your guides ☺️'**
  String get address_required_for_subscription;

  /// Info message about residential address
  ///
  /// In en, this message translates to:
  /// **'Is this your correct residential address? It\'s important for finding the nearest medical center.'**
  String get residential_address_info;

  /// Button text to update address
  ///
  /// In en, this message translates to:
  /// **'Update Address'**
  String get update_address;

  /// No description provided for @confirm_change.
  ///
  /// In en, this message translates to:
  /// **'Confirm Change'**
  String get confirm_change;

  /// Success message when address is updated
  ///
  /// In en, this message translates to:
  /// **'Address updated successfully'**
  String get address_updated_successfully;

  /// Error message when address update fails
  ///
  /// In en, this message translates to:
  /// **'Error updating address. Please try again.'**
  String get error_updating_address;

  /// Theory exam title
  ///
  /// In en, this message translates to:
  /// **'Theory Exam'**
  String get theoryExam;

  /// Book theory exam button
  ///
  /// In en, this message translates to:
  /// **'Book Theory Exam'**
  String get bookTheoryExam;

  /// Ready to book theory exam message
  ///
  /// In en, this message translates to:
  /// **'You\'re ready to book your theory exam!'**
  String get readyToBookTheoryExam;

  /// Complete requirements message
  ///
  /// In en, this message translates to:
  /// **'Complete your documents and medical exam first'**
  String get completeDocumentsAndMedicalExam;

  /// Scheduling theory exam message
  ///
  /// In en, this message translates to:
  /// **'We are scheduling your theory exam'**
  String get schedulingYourTheoryExam;

  /// Theory exam scheduling detailed message
  ///
  /// In en, this message translates to:
  /// **'You will soon know the date of your theory exam. We are looking for the first available date. We will give you a date for the theory exam within {waitingTime}'**
  String theoryExamSchedulingMessage(String waitingTime);

  /// Countdown title
  ///
  /// In en, this message translates to:
  /// **'How much time until your theory exam'**
  String get howMuchTimeUntilYourTheoryExam;

  /// Your theory exam title
  ///
  /// In en, this message translates to:
  /// **'Your Theory Exam'**
  String get yourTheoryExam;

  /// Motorization office data title
  ///
  /// In en, this message translates to:
  /// **'Motorization Office Data'**
  String get motorisationOfficeData;

  /// Open in maps button
  ///
  /// In en, this message translates to:
  /// **'Open in Maps'**
  String get openInMaps;

  /// Question if user took the exam
  ///
  /// In en, this message translates to:
  /// **'Did you take the theory exam?'**
  String get didYouTakeTheTheoryExam;

  /// Question if user passed the exam
  ///
  /// In en, this message translates to:
  /// **'Did you pass the theory exam?'**
  String get didYouPassTheTheoryExam;

  /// Congratulations message
  ///
  /// In en, this message translates to:
  /// **'Congratulations on your success!'**
  String get congratulationsOnYourSuccess;

  /// Completed first step message
  ///
  /// In en, this message translates to:
  /// **'You completed the first step towards your license'**
  String get completedFirstStepTowardLicense;

  /// Warning when user is not ready for exam
  ///
  /// In en, this message translates to:
  /// **'According to our systems you\'re not ready for the theory exam. Do you want to book anyway?'**
  String get notReadyForExamWarning;

  /// Book anyway button
  ///
  /// In en, this message translates to:
  /// **'Book Anyway'**
  String get bookAnyway;

  /// Success message for booking
  ///
  /// In en, this message translates to:
  /// **'Theory exam booked successfully!'**
  String get theoryExamBookedSuccessfully;

  /// Error message for booking
  ///
  /// In en, this message translates to:
  /// **'Error booking theory exam. Please try again.'**
  String get errorBookingTheoryExam;

  /// Success message for confirmation
  ///
  /// In en, this message translates to:
  /// **'Theory exam confirmed successfully!'**
  String get theoryExamConfirmedSuccessfully;

  /// Error message for confirmation
  ///
  /// In en, this message translates to:
  /// **'Error confirming theory exam. Please try again.'**
  String get errorConfirmingTheoryExam;

  /// Reschedule exam title
  ///
  /// In en, this message translates to:
  /// **'Reschedule Exam'**
  String get rescheduleExam;

  /// Reschedule confirmation message
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to reschedule your theory exam?'**
  String get rescheduleExamConfirmation;

  /// Reschedule button
  ///
  /// In en, this message translates to:
  /// **'Reschedule'**
  String get reschedule;

  /// Success message for rescheduling
  ///
  /// In en, this message translates to:
  /// **'Theory exam rescheduled successfully!'**
  String get theoryExamRescheduledSuccessfully;

  /// Error message for rescheduling
  ///
  /// In en, this message translates to:
  /// **'Error rescheduling theory exam. Please try again.'**
  String get errorReschedulingTheoryExam;

  /// Congratulations for passing
  ///
  /// In en, this message translates to:
  /// **'Congratulations! You passed the theory exam!'**
  String get congratulationsYouPassedTheTheoryExam;

  /// Result submitted message
  ///
  /// In en, this message translates to:
  /// **'Result submitted successfully'**
  String get resultSubmittedSuccessfully;

  /// Error submitting result
  ///
  /// In en, this message translates to:
  /// **'Error submitting result. Please try again.'**
  String get errorSubmittingResult;

  /// Error opening maps
  ///
  /// In en, this message translates to:
  /// **'Could not open maps'**
  String get errorOpeningMaps;

  /// Scheduling in progress status
  ///
  /// In en, this message translates to:
  /// **'Scheduling in progress...'**
  String get schedulingInProgress;

  /// Exam date passed status
  ///
  /// In en, this message translates to:
  /// **'Exam date has passed'**
  String get examDatePassed;

  /// Exam completed status
  ///
  /// In en, this message translates to:
  /// **'Exam completed!'**
  String get examCompleted;

  /// Months label
  ///
  /// In en, this message translates to:
  /// **'Months'**
  String get months;

  /// Hours label
  ///
  /// In en, this message translates to:
  /// **'Hours'**
  String get hours;

  /// Error loading data message
  ///
  /// In en, this message translates to:
  /// **'Error loading data. Please try again.'**
  String get errorLoadingData;

  /// Warning title
  ///
  /// In en, this message translates to:
  /// **'Warning'**
  String get warning;

  /// Confirm button
  ///
  /// In en, this message translates to:
  /// **'Confirm'**
  String get confirm;

  /// ZIP code label
  ///
  /// In en, this message translates to:
  /// **'ZIP Code'**
  String get zipCode;

  /// Message when no lesson topics are available
  ///
  /// In en, this message translates to:
  /// **'No lesson topics available'**
  String get noLessonTopicsAvailable;

  /// Message when no topics match the search query
  ///
  /// In en, this message translates to:
  /// **'No topics found for \"{query}\"'**
  String noTopicsFoundForQuery(String query);

  /// Suggestion to try different search terms
  ///
  /// In en, this message translates to:
  /// **'Try searching with different keywords'**
  String get trySearchingDifferentKeywords;

  /// Error message when lesson topics fail to load
  ///
  /// In en, this message translates to:
  /// **'Error loading lesson topics'**
  String get errorLoadingLessonTopics;

  /// Message when no recorded videos are available
  ///
  /// In en, this message translates to:
  /// **'No recorded videos available'**
  String get noRecordedVideosAvailable;

  /// Message when no videos match the search query
  ///
  /// In en, this message translates to:
  /// **'No videos found for \"{query}\"'**
  String noVideosFoundForQuery(String query);

  /// Error message when videos fail to load
  ///
  /// In en, this message translates to:
  /// **'Error loading videos'**
  String get errorLoadingVideos;

  /// Default title for video with no title
  ///
  /// In en, this message translates to:
  /// **'Untitled Video'**
  String get untitledVideo;

  /// Default text when teacher information is not available
  ///
  /// In en, this message translates to:
  /// **'Unknown Teacher'**
  String get unknownTeacher;

  /// Default text when no date is available
  ///
  /// In en, this message translates to:
  /// **'No date available'**
  String get noDateAvailable;

  /// Booked status label
  ///
  /// In en, this message translates to:
  /// **'Booked'**
  String get prenotato;

  /// Initialization step: Database migration
  ///
  /// In en, this message translates to:
  /// **'Migrating'**
  String get init_step_migration;

  /// Initialization step: Authentication
  ///
  /// In en, this message translates to:
  /// **'Authenticating'**
  String get init_step_auth;

  /// Initialization step: Data sync
  ///
  /// In en, this message translates to:
  /// **'Syncing'**
  String get init_step_sync;

  /// Initialization step: Database update
  ///
  /// In en, this message translates to:
  /// **'Updating'**
  String get init_step_database_update;

  /// Initialization step: Version check
  ///
  /// In en, this message translates to:
  /// **'Finalizing'**
  String get init_step_version;

  /// Initialization step: Starting up
  ///
  /// In en, this message translates to:
  /// **'Starting'**
  String get init_step_starting;

  /// Info message explaining view-only mode
  ///
  /// In en, this message translates to:
  /// **'You will join as a viewer. You can see and hear the host, but cannot interact.'**
  String get view_only_mode_info;

  /// Label shown while joining a meeting
  ///
  /// In en, this message translates to:
  /// **'Joining Meeting...'**
  String get joining_meeting;

  /// Title for magic activation page
  ///
  /// In en, this message translates to:
  /// **'Activate Subscription'**
  String get magic_activation_title;

  /// Message shown while validating activation code
  ///
  /// In en, this message translates to:
  /// **'Validating your activation code...'**
  String get magic_activation_validating;

  /// Error message for invalid activation code
  ///
  /// In en, this message translates to:
  /// **'This activation code is invalid or has already been used.'**
  String get magic_activation_invalid_code;

  /// Error message when activation fails
  ///
  /// In en, this message translates to:
  /// **'Failed to activate subscription. Please try again.'**
  String get magic_activation_failed;

  /// Title for login required dialog
  ///
  /// In en, this message translates to:
  /// **'Login Required'**
  String get magic_activation_login_required_title;

  /// Message explaining login is required for activation
  ///
  /// In en, this message translates to:
  /// **'To activate your subscription, please login or create an account first.'**
  String get magic_activation_login_required_message;

  /// Title when code is validated and ready to activate
  ///
  /// In en, this message translates to:
  /// **'Ready to Activate'**
  String get magic_activation_ready_title;

  /// Confirmation message showing which account will be activated
  ///
  /// In en, this message translates to:
  /// **'Activate subscription for {email}?'**
  String magic_activation_confirm_for_account(String email);

  /// Message prompting user to login to activate
  ///
  /// In en, this message translates to:
  /// **'Please login or create an account to activate your subscription.'**
  String get magic_activation_login_to_activate;

  /// Button text to activate subscription
  ///
  /// In en, this message translates to:
  /// **'Activate Now'**
  String get magic_activation_activate_button;

  /// Button text to login before activating
  ///
  /// In en, this message translates to:
  /// **'Login to Activate'**
  String get magic_activation_login_button;

  /// Cancel button text
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get magic_activation_cancel;

  /// Title shown when activation is successful
  ///
  /// In en, this message translates to:
  /// **'Subscription Activated!'**
  String get magic_activation_success_title;

  /// Success message after activation
  ///
  /// In en, this message translates to:
  /// **'Your subscription has been successfully activated. Enjoy full access to all features!'**
  String get magic_activation_success_message;

  /// Success message showing which account was activated
  ///
  /// In en, this message translates to:
  /// **'Subscription activated for: {email}'**
  String magic_activation_success_for_account(String email);

  /// Message shown when account was auto-created during activation
  ///
  /// In en, this message translates to:
  /// **'We created an account for you!\n\nEmail: {email}\nPassword: {password}\n\nPlease save these credentials to log in later.'**
  String magic_activation_account_created(String email, String password);

  /// Button text to go to main app
  ///
  /// In en, this message translates to:
  /// **'Go to App'**
  String get magic_activation_go_to_app;

  /// Title shown when there's an activation error
  ///
  /// In en, this message translates to:
  /// **'Activation Error'**
  String get magic_activation_error_title;

  /// Button text to retry activation
  ///
  /// In en, this message translates to:
  /// **'Try Again'**
  String get magic_activation_retry;

  /// Error when activation code has no phone number for auto-registration
  ///
  /// In en, this message translates to:
  /// **'This activation code is not associated with a phone number. Please contact support.'**
  String get magic_activation_no_phone;

  /// Message shown while auto-creating account
  ///
  /// In en, this message translates to:
  /// **'Creating your account...'**
  String get magic_activation_creating_account;

  /// Message explaining auto account creation for guest users
  ///
  /// In en, this message translates to:
  /// **'An account will be automatically created for you using your phone number.'**
  String get magic_activation_will_create_account;

  /// Header for teacher view of comments
  ///
  /// In en, this message translates to:
  /// **'Student comments'**
  String get live_comments_student_comments;

  /// Header for student view of comments
  ///
  /// In en, this message translates to:
  /// **'Your comments'**
  String get live_comments_your_comments;

  /// Empty state for teacher when no comments
  ///
  /// In en, this message translates to:
  /// **'No comments received yet'**
  String get live_comments_no_comments_teacher;

  /// Empty state for student when no comments
  ///
  /// In en, this message translates to:
  /// **'You haven\'t sent any comments yet'**
  String get live_comments_no_comments_student;

  /// Encouragement to send first comment
  ///
  /// In en, this message translates to:
  /// **'Send your first comment below!'**
  String get live_comments_send_first_comment;

  /// Hint text for comment input field
  ///
  /// In en, this message translates to:
  /// **'Write a comment for the teacher...'**
  String get live_comments_write_comment_hint;

  /// Error message when comments fail to load
  ///
  /// In en, this message translates to:
  /// **'Error loading'**
  String get live_comments_loading_error;

  /// Title for delete comment confirmation dialog
  ///
  /// In en, this message translates to:
  /// **'Delete comment?'**
  String get live_comments_delete_comment_title;

  /// Message for delete comment confirmation dialog
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete this comment?'**
  String get live_comments_delete_comment_message;

  /// Delete button text
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get live_comments_delete;

  /// Title for uploading front side of document
  ///
  /// In en, this message translates to:
  /// **'Upload Front Side'**
  String get uploadFrontSide;

  /// Title for uploading back side of document
  ///
  /// In en, this message translates to:
  /// **'Upload Back Side'**
  String get uploadBackSide;

  /// Label for front side of document
  ///
  /// In en, this message translates to:
  /// **'Front Side'**
  String get frontSide;

  /// Label for back side of document
  ///
  /// In en, this message translates to:
  /// **'Back Side'**
  String get backSide;

  /// Button to confirm and proceed with upload
  ///
  /// In en, this message translates to:
  /// **'Confirm Upload'**
  String get confirmUpload;

  /// Title for uploading single-sided document
  ///
  /// In en, this message translates to:
  /// **'Upload Document'**
  String get uploadDocument;

  /// Option to take photo with camera
  ///
  /// In en, this message translates to:
  /// **'Take Photo'**
  String get takePhoto;

  /// Option to choose image from gallery
  ///
  /// In en, this message translates to:
  /// **'Choose from Gallery'**
  String get chooseFromGallery;

  /// Error message when selected file is larger than 5MB
  ///
  /// In en, this message translates to:
  /// **'File size exceeds 5MB. Please choose a smaller file.'**
  String get fileSizeTooLarge;

  /// Description for recorded lives section
  ///
  /// In en, this message translates to:
  /// **'Watch past live sessions: organized by topic'**
  String get recorded_lives_description;

  /// Error message when lessons fail to load
  ///
  /// In en, this message translates to:
  /// **'Error loading lessons'**
  String get error_loading_lessons;

  /// Message when no upcoming lessons are available
  ///
  /// In en, this message translates to:
  /// **'No upcoming lessons'**
  String get no_upcoming_lessons;

  /// Placeholder when date is not available
  ///
  /// In en, this message translates to:
  /// **'Date not available'**
  String get date_not_available;

  /// Placeholder when time is not available
  ///
  /// In en, this message translates to:
  /// **'Time not available'**
  String get time_not_available;

  /// Error message for invalid booking ID
  ///
  /// In en, this message translates to:
  /// **'Invalid booking ID'**
  String get invalid_booking_id;

  /// Error message when booking cancellation fails
  ///
  /// In en, this message translates to:
  /// **'Failed to cancel booking'**
  String get failed_to_cancel_booking;

  /// Title for the tag book feature
  ///
  /// In en, this message translates to:
  /// **'Tag Book'**
  String get tag_book;

  /// Description for tag book feature
  ///
  /// In en, this message translates to:
  /// **'Scan QR codes from the tag book'**
  String get tag_book_description;

  /// Header for detected QR codes list
  ///
  /// In en, this message translates to:
  /// **'Detected QR Codes'**
  String get detected_qr_codes;

  /// Message when no QR codes found
  ///
  /// In en, this message translates to:
  /// **'No QR codes detected on this page'**
  String get no_qr_codes_detected;

  /// Success message when QR code is copied
  ///
  /// In en, this message translates to:
  /// **'QR code copied to clipboard'**
  String get qr_code_copied;

  /// Loading message while scanning
  ///
  /// In en, this message translates to:
  /// **'Scanning for QR codes...'**
  String get scanning_for_qr_codes;

  /// Error message when PDF fails to load
  ///
  /// In en, this message translates to:
  /// **'Error loading PDF'**
  String get error_loading_pdf;

  /// Error message when QR code scanning fails
  ///
  /// In en, this message translates to:
  /// **'Failed to scan QR codes'**
  String get failed_to_scan_qr_codes;

  /// Comments page title
  ///
  /// In en, this message translates to:
  /// **'Comments'**
  String get comments;

  /// Add comment button text
  ///
  /// In en, this message translates to:
  /// **'Add Comment'**
  String get addComment;

  /// Comment text field label
  ///
  /// In en, this message translates to:
  /// **'Comment'**
  String get commentText;

  /// Comment text field placeholder
  ///
  /// In en, this message translates to:
  /// **'Enter your comment...'**
  String get enterYourComment;

  /// Validation message when comment is empty
  ///
  /// In en, this message translates to:
  /// **'Please enter a comment'**
  String get commentRequired;

  /// Category label
  ///
  /// In en, this message translates to:
  /// **'Category'**
  String get category;

  /// Installation category name
  ///
  /// In en, this message translates to:
  /// **'Installation'**
  String get commentCategoryInstall;

  /// Maintenance category name
  ///
  /// In en, this message translates to:
  /// **'Maintenance'**
  String get commentCategoryMaintenance;

  /// Disassembly category name
  ///
  /// In en, this message translates to:
  /// **'Disassembly'**
  String get commentCategoryDisassemble;

  /// General category name
  ///
  /// In en, this message translates to:
  /// **'General'**
  String get commentCategoryGeneral;

  /// Title when no comments exist
  ///
  /// In en, this message translates to:
  /// **'No Comments'**
  String get noComments;

  /// Description when no comments exist
  ///
  /// In en, this message translates to:
  /// **'Be the first to add a comment'**
  String get noCommentsDescription;

  /// Error title when comments fail to load
  ///
  /// In en, this message translates to:
  /// **'Error Loading Comments'**
  String get errorLoadingComments;

  /// Delete comment dialog title
  ///
  /// In en, this message translates to:
  /// **'Delete Comment'**
  String get deleteComment;

  /// Delete comment confirmation message
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete this comment? This action cannot be undone.'**
  String get deleteCommentConfirmation;

  /// Success message when comment is added
  ///
  /// In en, this message translates to:
  /// **'Comment added successfully'**
  String get commentAddedSuccess;

  /// Success message when comment is deleted
  ///
  /// In en, this message translates to:
  /// **'Comment deleted'**
  String get commentDeletedSuccess;

  /// Error message for comment operations
  ///
  /// In en, this message translates to:
  /// **'Failed to process comment'**
  String get commentError;

  /// Access denied title
  ///
  /// In en, this message translates to:
  /// **'Access Denied'**
  String get accessDenied;

  /// Message when user lacks admin access for comments
  ///
  /// In en, this message translates to:
  /// **'Admin privileges are required to access comments.'**
  String get adminRequiredForComments;

  /// All filter option
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get all;

  /// Delete button text
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete;

  /// Profile settings page title
  ///
  /// In en, this message translates to:
  /// **'Profile & Settings'**
  String get profile_settings_title;

  /// Account section title
  ///
  /// In en, this message translates to:
  /// **'Account'**
  String get section_account;

  /// Admin login button
  ///
  /// In en, this message translates to:
  /// **'Login as Admin'**
  String get login_as_admin;

  /// Admin login subtitle
  ///
  /// In en, this message translates to:
  /// **'Sign in to access admin features'**
  String get login_as_admin_subtitle;

  /// Logout button
  ///
  /// In en, this message translates to:
  /// **'Logout'**
  String get logout_button;

  /// Logout subtitle
  ///
  /// In en, this message translates to:
  /// **'Sign out from your account'**
  String get logout_subtitle;

  /// Logout confirmation dialog message
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to logout?'**
  String get logout_confirmation;

  /// Administration section title
  ///
  /// In en, this message translates to:
  /// **'Administration'**
  String get section_administration;

  /// Admin panel menu item
  ///
  /// In en, this message translates to:
  /// **'Admin Panel'**
  String get admin_panel;

  /// Admin panel subtitle
  ///
  /// In en, this message translates to:
  /// **'Manage admin users'**
  String get admin_panel_subtitle;

  /// Analytics menu item
  ///
  /// In en, this message translates to:
  /// **'Analytics'**
  String get analytics_menu;

  /// Analytics subtitle
  ///
  /// In en, this message translates to:
  /// **'View app statistics'**
  String get analytics_subtitle;

  /// App configuration menu item
  ///
  /// In en, this message translates to:
  /// **'App Configuration'**
  String get app_configuration;

  /// App configuration subtitle
  ///
  /// In en, this message translates to:
  /// **'Manage app settings'**
  String get app_configuration_subtitle;

  /// Settings section title
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get section_settings;

  /// Notifications menu item
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get notifications_menu;

  /// Notifications subtitle
  ///
  /// In en, this message translates to:
  /// **'Manage notification preferences'**
  String get notifications_subtitle;

  /// Language menu item
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language_setting;

  /// Language subtitle
  ///
  /// In en, this message translates to:
  /// **'Change app language'**
  String get language_subtitle;

  /// Appearance menu item
  ///
  /// In en, this message translates to:
  /// **'Appearance'**
  String get appearance_menu;

  /// Appearance subtitle
  ///
  /// In en, this message translates to:
  /// **'Light/Dark mode settings'**
  String get appearance_subtitle;

  /// About section title
  ///
  /// In en, this message translates to:
  /// **'About'**
  String get section_about;

  /// About app menu item
  ///
  /// In en, this message translates to:
  /// **'About WHO Mobile'**
  String get about_app;

  /// About app subtitle
  ///
  /// In en, this message translates to:
  /// **'App information and version'**
  String get about_app_subtitle;

  /// Privacy policy subtitle
  ///
  /// In en, this message translates to:
  /// **'Read our privacy policy'**
  String get privacy_policy_subtitle;

  /// Terms of service subtitle
  ///
  /// In en, this message translates to:
  /// **'Read our terms of service'**
  String get terms_of_service_subtitle;

  /// Coming soon message
  ///
  /// In en, this message translates to:
  /// **'Coming soon!'**
  String get coming_soon;

  /// Error loading profile message
  ///
  /// In en, this message translates to:
  /// **'Error loading profile'**
  String get error_loading_profile;

  /// Language picker dialog title
  ///
  /// In en, this message translates to:
  /// **'Select Language'**
  String get select_language;

  /// Language change success message
  ///
  /// In en, this message translates to:
  /// **'Language changed successfully'**
  String get language_changed;

  /// Generic error message
  ///
  /// In en, this message translates to:
  /// **'An error occurred'**
  String get an_error_occurred;

  /// Dashboard page title
  ///
  /// In en, this message translates to:
  /// **'Dashboard'**
  String get dashboard;

  /// No comments empty state title
  ///
  /// In en, this message translates to:
  /// **'No Comments'**
  String get no_comments;

  /// Empty comments message
  ///
  /// In en, this message translates to:
  /// **'Be the first to add a comment'**
  String get be_first_to_comment;

  /// No comments in category
  ///
  /// In en, this message translates to:
  /// **'No comments in {category} category'**
  String no_comments_in_category(String category);

  /// Error loading comments title
  ///
  /// In en, this message translates to:
  /// **'Error Loading Comments'**
  String get error_loading_comments;

  /// Add comment button
  ///
  /// In en, this message translates to:
  /// **'Add Comment'**
  String get add_comment;

  /// Delete comment dialog title
  ///
  /// In en, this message translates to:
  /// **'Delete Comment'**
  String get delete_comment;

  /// Delete comment confirmation
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete this comment? This action cannot be undone.'**
  String get delete_comment_confirmation;

  /// Delete comment error
  ///
  /// In en, this message translates to:
  /// **'Failed to delete comment'**
  String get failed_to_delete_comment;

  /// Comment deleted success
  ///
  /// In en, this message translates to:
  /// **'Comment deleted'**
  String get comment_deleted;

  /// Load comments error
  ///
  /// In en, this message translates to:
  /// **'Failed to load comments'**
  String get failed_to_load_comments;

  /// No comments yet message
  ///
  /// In en, this message translates to:
  /// **'No comments yet'**
  String get no_comments_yet;

  /// View all comments link
  ///
  /// In en, this message translates to:
  /// **'View all {count} comments'**
  String view_all_comments(int count);

  /// Access denied title
  ///
  /// In en, this message translates to:
  /// **'Access Denied'**
  String get access_denied;

  /// Admin required message
  ///
  /// In en, this message translates to:
  /// **'Admin privileges are required to access comments.'**
  String get admin_required_for_comments;

  /// Dismantling page title
  ///
  /// In en, this message translates to:
  /// **'Dismantling'**
  String get dismantling;

  /// Dismantling banner title
  ///
  /// In en, this message translates to:
  /// **'Dismantling in Progress'**
  String get dismantling_in_progress;

  /// Dismantling banner subtitle
  ///
  /// In en, this message translates to:
  /// **'Follow each step carefully to ensure safe removal'**
  String get dismantling_follow_steps;

  /// Dismantling complete dialog title
  ///
  /// In en, this message translates to:
  /// **'Dismantling Complete'**
  String get dismantling_complete;

  /// Dismantling complete message
  ///
  /// In en, this message translates to:
  /// **'All dismantling steps have been completed. This will reset the installation status.'**
  String get dismantling_complete_message;

  /// Not yet button
  ///
  /// In en, this message translates to:
  /// **'Not Yet'**
  String get not_yet;

  /// Complete dismantling button
  ///
  /// In en, this message translates to:
  /// **'Complete Dismantling'**
  String get complete_dismantling;

  /// Select item dialog title
  ///
  /// In en, this message translates to:
  /// **'Select Item to Scan'**
  String get select_item_to_scan;

  /// Scan item dialog title
  ///
  /// In en, this message translates to:
  /// **'Scan {item}'**
  String scan_item(String item);

  /// Image source dialog message
  ///
  /// In en, this message translates to:
  /// **'Choose image source:'**
  String get choose_image_source;

  /// Camera option
  ///
  /// In en, this message translates to:
  /// **'Camera'**
  String get camera;

  /// Gallery option
  ///
  /// In en, this message translates to:
  /// **'Gallery'**
  String get gallery;

  /// Analyzing image message
  ///
  /// In en, this message translates to:
  /// **'Analyzing image...'**
  String get analyzing_image;

  /// Item verified title
  ///
  /// In en, this message translates to:
  /// **'Item Verified!'**
  String get item_verified;

  /// Item not found title
  ///
  /// In en, this message translates to:
  /// **'Item Not Found'**
  String get item_not_found;

  /// Item verified message
  ///
  /// In en, this message translates to:
  /// **'The item has been successfully verified and matched with the packing list.'**
  String get item_verified_message;

  /// Item not found message
  ///
  /// In en, this message translates to:
  /// **'The item could not be verified. Please try again or check manually.'**
  String get item_not_found_message;

  /// Auto check message
  ///
  /// In en, this message translates to:
  /// **'This item will be automatically checked off.'**
  String get item_auto_checked;

  /// Check item button
  ///
  /// In en, this message translates to:
  /// **'Check Item'**
  String get check_item;

  /// Packing list page title
  ///
  /// In en, this message translates to:
  /// **'IDTM Packing List'**
  String get idtm_packing_list;

  /// Equipment checklist card title
  ///
  /// In en, this message translates to:
  /// **'Equipment Checklist'**
  String get equipment_checklist;

  /// Verify items subtitle
  ///
  /// In en, this message translates to:
  /// **'Verify all items before installation'**
  String get verify_all_items;

  /// Total weight display
  ///
  /// In en, this message translates to:
  /// **'Total Weight: {weight} kg'**
  String total_weight(String weight);

  /// Scanning button state
  ///
  /// In en, this message translates to:
  /// **'Scanning...'**
  String get scanning;

  /// Scan with camera button
  ///
  /// In en, this message translates to:
  /// **'Scan with Camera'**
  String get scan_with_camera;

  /// Reset checklist dialog title
  ///
  /// In en, this message translates to:
  /// **'Reset Checklist'**
  String get reset_checklist;

  /// Reset checklist confirmation
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to reset all checkboxes? This cannot be undone.'**
  String get reset_checklist_confirmation;

  /// Reset button
  ///
  /// In en, this message translates to:
  /// **'Reset'**
  String get reset;

  /// Checklist reset success message
  ///
  /// In en, this message translates to:
  /// **'Checklist reset successfully'**
  String get checklist_reset_success;

  /// Maintenance mode page title
  ///
  /// In en, this message translates to:
  /// **'Maintenance Mode'**
  String get maintenance_mode;

  /// System operational card title
  ///
  /// In en, this message translates to:
  /// **'System Operational'**
  String get system_operational;

  /// Installation success subtitle
  ///
  /// In en, this message translates to:
  /// **'Installation completed successfully'**
  String get installation_completed_successfully;

  /// Maintenance tasks section
  ///
  /// In en, this message translates to:
  /// **'Maintenance Tasks'**
  String get maintenance_tasks;

  /// View maintenance guide card title
  ///
  /// In en, this message translates to:
  /// **'View Maintenance Guide'**
  String get view_maintenance_guide;

  /// Maintenance guide description
  ///
  /// In en, this message translates to:
  /// **'Complete maintenance instructions and procedures'**
  String get maintenance_guide_description;

  /// Daily inspection card title
  ///
  /// In en, this message translates to:
  /// **'Daily Inspection'**
  String get daily_inspection;

  /// Daily inspection description
  ///
  /// In en, this message translates to:
  /// **'Check system status and connections'**
  String get daily_inspection_description;

  /// Weekly maintenance card title
  ///
  /// In en, this message translates to:
  /// **'Weekly Maintenance'**
  String get weekly_maintenance;

  /// Weekly maintenance description
  ///
  /// In en, this message translates to:
  /// **'Perform routine maintenance checks'**
  String get weekly_maintenance_description;

  /// Monthly review card title
  ///
  /// In en, this message translates to:
  /// **'Monthly Review'**
  String get monthly_review;

  /// Monthly review description
  ///
  /// In en, this message translates to:
  /// **'Complete monthly system review'**
  String get monthly_review_description;

  /// Maintenance notes section
  ///
  /// In en, this message translates to:
  /// **'Maintenance Notes'**
  String get maintenance_notes;

  /// Quick actions section
  ///
  /// In en, this message translates to:
  /// **'Quick Actions'**
  String get quick_actions;

  /// View documentation button
  ///
  /// In en, this message translates to:
  /// **'View Documentation'**
  String get view_documentation;

  /// Export maintenance log button
  ///
  /// In en, this message translates to:
  /// **'Export Maintenance Log'**
  String get export_maintenance_log;

  /// Maintenance alerts card title
  ///
  /// In en, this message translates to:
  /// **'Maintenance Alerts Active'**
  String get maintenance_alerts_active;

  /// Scheduled reminders count
  ///
  /// In en, this message translates to:
  /// **'{count} scheduled reminder{count, plural, =1{} other{s}}'**
  String scheduled_reminders_count(int count);

  /// Maintenance notifications info
  ///
  /// In en, this message translates to:
  /// **'You will receive periodic notifications for maintenance tasks'**
  String get maintenance_notifications_info;

  /// Scheduled reminders dialog title
  ///
  /// In en, this message translates to:
  /// **'Scheduled Reminders'**
  String get scheduled_reminders;

  /// Facility use guide page title
  ///
  /// In en, this message translates to:
  /// **'Facility Use Guide'**
  String get facility_use_guide;

  /// IDTM facility use header title
  ///
  /// In en, this message translates to:
  /// **'IDTM Facility Use & Functioning'**
  String get idtm_facility_use_title;

  /// Facility use guide description
  ///
  /// In en, this message translates to:
  /// **'Browse sections for operational guidance, safety warnings, and site selection requirements.'**
  String get facility_use_description;

  /// Installation guide page title
  ///
  /// In en, this message translates to:
  /// **'Installation Guide'**
  String get installation_guide;

  /// Maintenance guide page title
  ///
  /// In en, this message translates to:
  /// **'Maintenance Guide'**
  String get maintenance_guide;

  /// Overall progress label
  ///
  /// In en, this message translates to:
  /// **'Overall Progress'**
  String get overall_progress;

  /// Steps completed progress text
  ///
  /// In en, this message translates to:
  /// **'{completed} of {total} steps completed'**
  String steps_completed(int completed, int total);

  /// Error with message
  ///
  /// In en, this message translates to:
  /// **'Error: {error}'**
  String error_with_message(String error);

  /// Ready status description
  ///
  /// In en, this message translates to:
  /// **'Ready to begin installation process'**
  String get ready_to_begin_installation;

  /// Installing status description
  ///
  /// In en, this message translates to:
  /// **'Installation in progress'**
  String get installation_in_progress;

  /// Installed status description
  ///
  /// In en, this message translates to:
  /// **'System installed and operational'**
  String get system_installed_operational;

  /// Dismantling status description
  ///
  /// In en, this message translates to:
  /// **'Dismantling in progress'**
  String get dismantling_in_progress_status;

  /// Completed status description
  ///
  /// In en, this message translates to:
  /// **'Installation completed'**
  String get installation_completed;

  /// Start installation button
  ///
  /// In en, this message translates to:
  /// **'Start Installation'**
  String get start_installation;

  /// Continue installation button
  ///
  /// In en, this message translates to:
  /// **'Continue Installation'**
  String get continue_installation;

  /// Start dismantling button
  ///
  /// In en, this message translates to:
  /// **'Start Dismantling'**
  String get start_dismantling;

  /// Continue dismantling button
  ///
  /// In en, this message translates to:
  /// **'Continue Dismantling'**
  String get continue_dismantling;

  /// Start new installation button
  ///
  /// In en, this message translates to:
  /// **'Start New Installation'**
  String get start_new_installation;

  /// System reset success message
  ///
  /// In en, this message translates to:
  /// **'System reset. Ready for new installation.'**
  String get system_reset_ready;

  /// Show packing list button
  ///
  /// In en, this message translates to:
  /// **'Show Packing List'**
  String get show_packing_list;

  /// Start dismantling confirmation title
  ///
  /// In en, this message translates to:
  /// **'Start Dismantling?'**
  String get start_dismantling_question;

  /// Dismantling confirmation message
  ///
  /// In en, this message translates to:
  /// **'You are about to start the dismantling process. This will:'**
  String get dismantling_confirmation_message;

  /// Exit maintenance mode action
  ///
  /// In en, this message translates to:
  /// **'Exit maintenance mode'**
  String get exit_maintenance_mode;

  /// Begin dismantling phase action
  ///
  /// In en, this message translates to:
  /// **'Begin dismantling phase'**
  String get begin_dismantling_phase;

  /// Open dismantling guide action
  ///
  /// In en, this message translates to:
  /// **'Open dismantling guide'**
  String get open_dismantling_guide;

  /// Maintenance complete warning
  ///
  /// In en, this message translates to:
  /// **'Make sure all maintenance tasks are completed before proceeding.'**
  String get maintenance_complete_before_dismantling;

  /// Dismantling started message
  ///
  /// In en, this message translates to:
  /// **'Dismantling phase started. Opening dismantling guide.'**
  String get dismantling_started_message;

  /// Installation guide progress card title
  ///
  /// In en, this message translates to:
  /// **'Installation Guide Progress'**
  String get installation_guide_progress;

  /// Installation complete title
  ///
  /// In en, this message translates to:
  /// **'Installation Complete!'**
  String get installation_complete_title;

  /// Installation complete message
  ///
  /// In en, this message translates to:
  /// **'Installation completed! Opening maintenance mode.'**
  String get installation_complete_maintenance;

  /// Finish and go to maintenance button
  ///
  /// In en, this message translates to:
  /// **'Finish & Go to Maintenance'**
  String get finish_go_to_maintenance;

  /// Dismantling guide progress card title
  ///
  /// In en, this message translates to:
  /// **'Dismantling Guide Progress'**
  String get dismantling_guide_progress;

  /// Dismantling complete title
  ///
  /// In en, this message translates to:
  /// **'Dismantling Complete!'**
  String get dismantling_complete_title;

  /// Dismantling lifecycle complete message
  ///
  /// In en, this message translates to:
  /// **'Dismantling completed! IDTM lifecycle finished.'**
  String get dismantling_lifecycle_complete;

  /// IDTM lifecycle completed title
  ///
  /// In en, this message translates to:
  /// **'IDTM Lifecycle Completed!'**
  String get idtm_lifecycle_completed;

  /// Lifecycle completed description
  ///
  /// In en, this message translates to:
  /// **'Installation, maintenance, and dismantling phases have been successfully completed.'**
  String get lifecycle_completed_description;

  /// Installed badge label
  ///
  /// In en, this message translates to:
  /// **'Installed'**
  String get installed;

  /// Maintained badge label
  ///
  /// In en, this message translates to:
  /// **'Maintained'**
  String get maintained;

  /// Dismantled badge label
  ///
  /// In en, this message translates to:
  /// **'Dismantled'**
  String get dismantled;

  /// IDTM installation card title
  ///
  /// In en, this message translates to:
  /// **'IDTM Installation'**
  String get idtm_installation;

  /// What is IDTM page title
  ///
  /// In en, this message translates to:
  /// **'What is IDTM'**
  String get what_is_idtm;

  /// IDTM overview card title
  ///
  /// In en, this message translates to:
  /// **'IDTM Overview'**
  String get idtm_overview;

  /// Page indicator
  ///
  /// In en, this message translates to:
  /// **'Page {current} of {total}'**
  String page_indicator(int current, int total);

  /// Failed to load PDF error
  ///
  /// In en, this message translates to:
  /// **'Failed to load PDF: {error}'**
  String failed_to_load_pdf(String error);

  /// 404 not found text
  ///
  /// In en, this message translates to:
  /// **'404 Not Found'**
  String get not_found_404;

  /// Address label
  ///
  /// In en, this message translates to:
  /// **'Address: {address}'**
  String address_label(String address);

  /// Alert templates page title
  ///
  /// In en, this message translates to:
  /// **'Alert Templates'**
  String get alert_templates;

  /// Initialize alerts tooltip
  ///
  /// In en, this message translates to:
  /// **'Initialize Maintenance Alerts'**
  String get initialize_maintenance_alerts;

  /// All facilities menu item
  ///
  /// In en, this message translates to:
  /// **'All Facilities'**
  String get all_facilities;

  /// No alert templates empty state
  ///
  /// In en, this message translates to:
  /// **'No Alert Templates'**
  String get no_alert_templates;

  /// No alert templates message
  ///
  /// In en, this message translates to:
  /// **'Tap the + button to create your first alert template for facility maintenance'**
  String get no_alert_templates_message;

  /// Error loading templates title
  ///
  /// In en, this message translates to:
  /// **'Error Loading Templates'**
  String get error_loading_templates;

  /// Super admin required for templates
  ///
  /// In en, this message translates to:
  /// **'Super Admin privileges are required to manage alert templates.'**
  String get super_admin_required_templates;

  /// Go to dashboard button
  ///
  /// In en, this message translates to:
  /// **'Go to Dashboard'**
  String get go_to_dashboard;

  /// Add template FAB label
  ///
  /// In en, this message translates to:
  /// **'Add Template'**
  String get add_template;

  /// Delete template dialog title
  ///
  /// In en, this message translates to:
  /// **'Delete Template'**
  String get delete_template;

  /// Delete template confirmation
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete \"{title}\"? This action cannot be undone.'**
  String delete_template_confirmation(String title);

  /// Admin management page title
  ///
  /// In en, this message translates to:
  /// **'Admin Management'**
  String get admin_management;

  /// Manage alert templates tooltip
  ///
  /// In en, this message translates to:
  /// **'Manage Alert Templates'**
  String get manage_alert_templates;

  /// No admin users empty state
  ///
  /// In en, this message translates to:
  /// **'No Admin Users'**
  String get no_admin_users;

  /// No admin users message
  ///
  /// In en, this message translates to:
  /// **'Tap the + button to add your first admin user'**
  String get no_admin_users_message;

  /// Error loading admins title
  ///
  /// In en, this message translates to:
  /// **'Error Loading Admins'**
  String get error_loading_admins;

  /// Super admin required for page
  ///
  /// In en, this message translates to:
  /// **'Super Admin privileges are required to access this page.'**
  String get super_admin_required_page;

  /// Add admin FAB label
  ///
  /// In en, this message translates to:
  /// **'Add Admin'**
  String get add_admin;

  /// Login removed placeholder
  ///
  /// In en, this message translates to:
  /// **'Login functionality has been removed'**
  String get login_removed;

  /// Address collection dialog title
  ///
  /// In en, this message translates to:
  /// **'Address Collection'**
  String get address_collection;

  /// Address collection removed message
  ///
  /// In en, this message translates to:
  /// **'Address collection functionality has been removed'**
  String get address_collection_removed;

  /// Feedback available message
  ///
  /// In en, this message translates to:
  /// **'Feedback feature available in main button'**
  String get feedback_available;

  /// Installation notes section title
  ///
  /// In en, this message translates to:
  /// **'Installation Notes'**
  String get installation_notes;

  /// Error scanning item message
  ///
  /// In en, this message translates to:
  /// **'Error scanning item: {error}'**
  String error_scanning_item(String error);

  /// Item verified and checked message
  ///
  /// In en, this message translates to:
  /// **'✓ {item} verified and checked!'**
  String item_verified_checked(String item);

  /// Quantity label
  ///
  /// In en, this message translates to:
  /// **'Qty: {quantity}'**
  String qty_label(int quantity);

  /// Quantity and dimensions
  ///
  /// In en, this message translates to:
  /// **'Qty: {quantity} • {dimensions}'**
  String qty_dimensions(int quantity, String dimensions);

  /// Weight label
  ///
  /// In en, this message translates to:
  /// **'Weight: {weight}'**
  String weight_label(String weight);

  /// Dismantling notes section title
  ///
  /// In en, this message translates to:
  /// **'Dismantling Notes'**
  String get dismantling_notes;

  /// Europallet 1 name
  ///
  /// In en, this message translates to:
  /// **'EUROPALLET 1'**
  String get packing_europallet_1;

  /// Europallet 1 description
  ///
  /// In en, this message translates to:
  /// **'First europallet containing main tent and accessories'**
  String get packing_europallet_1_desc;

  /// Europallet 2 name
  ///
  /// In en, this message translates to:
  /// **'EUROPALLET 2'**
  String get packing_europallet_2;

  /// Europallet 2 description
  ///
  /// In en, this message translates to:
  /// **'Second europallet containing main tent and sun net'**
  String get packing_europallet_2_desc;

  /// Europallet 3 name
  ///
  /// In en, this message translates to:
  /// **'EUROPALLET 3'**
  String get packing_europallet_3;

  /// Europallet 3 description
  ///
  /// In en, this message translates to:
  /// **'Third europallet containing main tent and sun net'**
  String get packing_europallet_3_desc;

  /// Main tent structure name
  ///
  /// In en, this message translates to:
  /// **'AZF4 27 WFP'**
  String get packing_azf4_27_wfp;

  /// Main tent structure description
  ///
  /// In en, this message translates to:
  /// **'Main tent structure'**
  String get packing_azf4_27_wfp_desc;

  /// Bag for inner cabins name
  ///
  /// In en, this message translates to:
  /// **'BAG FOR INNER CABINS'**
  String get packing_bag_inner_cabins;

  /// Bag for inner cabins description
  ///
  /// In en, this message translates to:
  /// **'Inner cabin partitions'**
  String get packing_bag_inner_cabins_desc;

  /// Bag for sun shadowing net name
  ///
  /// In en, this message translates to:
  /// **'BAG FOR SUN SHADOWING NET'**
  String get packing_bag_sun_net;

  /// Bag for sun shadowing net description
  ///
  /// In en, this message translates to:
  /// **'Sun protection net'**
  String get packing_bag_sun_net_desc;

  /// Logistic box 1 name
  ///
  /// In en, this message translates to:
  /// **'LOGISTIC BOX 1'**
  String get packing_logistic_box_1;

  /// Logistic box 1 description
  ///
  /// In en, this message translates to:
  /// **'Logistics box with sun shadowing net'**
  String get packing_logistic_box_1_desc;

  /// Sun shadowing net name
  ///
  /// In en, this message translates to:
  /// **'SUN SHADOWING NET'**
  String get packing_sun_shadowing_net;

  /// Sun shadowing net description
  ///
  /// In en, this message translates to:
  /// **'Additional sun protection net'**
  String get packing_sun_shadowing_net_desc;

  /// Logistic box 2 name
  ///
  /// In en, this message translates to:
  /// **'LOGISTIC BOX 2'**
  String get packing_logistic_box_2;

  /// Logistic box 2 description
  ///
  /// In en, this message translates to:
  /// **'Logistics box with mid and inner liners'**
  String get packing_logistic_box_2_desc;

  /// Mid liner name
  ///
  /// In en, this message translates to:
  /// **'MID LINER'**
  String get packing_mid_liner;

  /// Mid liner description
  ///
  /// In en, this message translates to:
  /// **'Mid layer insulation liner'**
  String get packing_mid_liner_desc;

  /// Inner liner name
  ///
  /// In en, this message translates to:
  /// **'INNER LINER'**
  String get packing_inner_liner;

  /// Inner liner description
  ///
  /// In en, this message translates to:
  /// **'Inner insulation liner'**
  String get packing_inner_liner_desc;

  /// Logistic box 3 name
  ///
  /// In en, this message translates to:
  /// **'LOGISTIC BOX 3'**
  String get packing_logistic_box_3;

  /// Logistic box 3 description
  ///
  /// In en, this message translates to:
  /// **'Logistics box with vestibules'**
  String get packing_logistic_box_3_desc;

  /// Vestibule name
  ///
  /// In en, this message translates to:
  /// **'VESTIBULE'**
  String get packing_vestibule;

  /// Vestibule description
  ///
  /// In en, this message translates to:
  /// **'Entry vestibules'**
  String get packing_vestibule_desc;

  /// Logistic box 4 name
  ///
  /// In en, this message translates to:
  /// **'LOGISTIC BOX 4'**
  String get packing_logistic_box_4;

  /// Logistic box 4 description
  ///
  /// In en, this message translates to:
  /// **'Logistics box with staking kit, inflator, and repair kit'**
  String get packing_logistic_box_4_desc;

  /// Staking kit name
  ///
  /// In en, this message translates to:
  /// **'AZF4 27 & VESTIBULE STAKING KIT'**
  String get packing_staking_kit;

  /// Staking kit description
  ///
  /// In en, this message translates to:
  /// **'Ground anchoring stakes and ropes'**
  String get packing_staking_kit_desc;

  /// Manual inflator name
  ///
  /// In en, this message translates to:
  /// **'MANUAL INFLATOR'**
  String get packing_manual_inflator;

  /// Manual inflator description
  ///
  /// In en, this message translates to:
  /// **'Manual pump for tent inflation'**
  String get packing_manual_inflator_desc;

  /// Repair kit name
  ///
  /// In en, this message translates to:
  /// **'REPAIR KIT'**
  String get packing_repair_kit;

  /// Repair kit description
  ///
  /// In en, this message translates to:
  /// **'Emergency repair materials and tools'**
  String get packing_repair_kit_desc;

  /// Logistic box 5 name
  ///
  /// In en, this message translates to:
  /// **'LOGISTIC BOX 5'**
  String get packing_logistic_box_5;

  /// Logistic box 5 description
  ///
  /// In en, this message translates to:
  /// **'Additional logistics box'**
  String get packing_logistic_box_5_desc;

  /// Logistic box 6 name
  ///
  /// In en, this message translates to:
  /// **'LOGISTIC BOX 6'**
  String get packing_logistic_box_6;

  /// Logistic box 6 description
  ///
  /// In en, this message translates to:
  /// **'Additional logistics box'**
  String get packing_logistic_box_6_desc;

  /// Logistic box 7 name
  ///
  /// In en, this message translates to:
  /// **'LOGISTIC BOX 7'**
  String get packing_logistic_box_7;

  /// Logistic box 7 description
  ///
  /// In en, this message translates to:
  /// **'Additional logistics box'**
  String get packing_logistic_box_7_desc;

  /// Logistic box 8 name
  ///
  /// In en, this message translates to:
  /// **'LOGISTIC BOX 8'**
  String get packing_logistic_box_8;

  /// Logistic box 8 description
  ///
  /// In en, this message translates to:
  /// **'Additional logistics box'**
  String get packing_logistic_box_8_desc;

  /// Logistic box 9 name
  ///
  /// In en, this message translates to:
  /// **'LOGISTIC BOX 9'**
  String get packing_logistic_box_9;

  /// Logistic box 9 description
  ///
  /// In en, this message translates to:
  /// **'Additional logistics box'**
  String get packing_logistic_box_9_desc;

  /// Tiles pallet name
  ///
  /// In en, this message translates to:
  /// **'TILES PALLET'**
  String get packing_tiles_pallet;

  /// Tiles pallet description
  ///
  /// In en, this message translates to:
  /// **'Hard flooring tiles for tent base'**
  String get packing_tiles_pallet_desc;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'it'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'it':
      return AppLocalizationsIt();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
