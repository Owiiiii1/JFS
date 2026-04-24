import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_es.dart';
import 'app_localizations_ru.dart';
import 'app_localizations_uk.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'gen_l10n/app_localizations.dart';
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
    Locale('es'),
    Locale('es', 'US'),
    Locale('ru'),
    Locale('uk'),
  ];

  /// No description provided for @signIn.
  ///
  /// In en, this message translates to:
  /// **'Sign in'**
  String get signIn;

  /// No description provided for @signUp.
  ///
  /// In en, this message translates to:
  /// **'Sign up'**
  String get signUp;

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

  /// No description provided for @emailRequired.
  ///
  /// In en, this message translates to:
  /// **'Email is required'**
  String get emailRequired;

  /// No description provided for @enterValidEmail.
  ///
  /// In en, this message translates to:
  /// **'Enter a valid email'**
  String get enterValidEmail;

  /// No description provided for @passwordRequired.
  ///
  /// In en, this message translates to:
  /// **'Password is required'**
  String get passwordRequired;

  /// No description provided for @hidePassword.
  ///
  /// In en, this message translates to:
  /// **'Hide password'**
  String get hidePassword;

  /// No description provided for @showPassword.
  ///
  /// In en, this message translates to:
  /// **'Show password'**
  String get showPassword;

  /// No description provided for @signInFailed.
  ///
  /// In en, this message translates to:
  /// **'Sign in failed: {error}'**
  String signInFailed(String error);

  /// No description provided for @apiEndpointNotFoundHint.
  ///
  /// In en, this message translates to:
  /// **'The server could not find the API (404). Set API_BASE_URL to your site root without a trailing /api — the app calls /api/app/login itself. If Laravel is in a subfolder, include the path to the public directory (e.g. https://example.com/myapp/public).'**
  String get apiEndpointNotFoundHint;

  /// No description provided for @notificationsTitle.
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get notificationsTitle;

  /// No description provided for @notificationsLoadFailed.
  ///
  /// In en, this message translates to:
  /// **'Could not load notifications. Try again.'**
  String get notificationsLoadFailed;

  /// No description provided for @notificationsEmpty.
  ///
  /// In en, this message translates to:
  /// **'No notifications yet.'**
  String get notificationsEmpty;

  /// No description provided for @notificationsNewMark.
  ///
  /// In en, this message translates to:
  /// **'New'**
  String get notificationsNewMark;

  /// No description provided for @notificationDetailsTitle.
  ///
  /// In en, this message translates to:
  /// **'Notification'**
  String get notificationDetailsTitle;

  /// No description provided for @createAccount.
  ///
  /// In en, this message translates to:
  /// **'Create account'**
  String get createAccount;

  /// No description provided for @name.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get name;

  /// No description provided for @registerNameLabel.
  ///
  /// In en, this message translates to:
  /// **'Enter first and last name'**
  String get registerNameLabel;

  /// No description provided for @nameRequired.
  ///
  /// In en, this message translates to:
  /// **'Name is required'**
  String get nameRequired;

  /// No description provided for @phone.
  ///
  /// In en, this message translates to:
  /// **'Phone'**
  String get phone;

  /// No description provided for @phoneRequired.
  ///
  /// In en, this message translates to:
  /// **'Phone is required'**
  String get phoneRequired;

  /// No description provided for @phoneMustStartWithPlus.
  ///
  /// In en, this message translates to:
  /// **'Phone must start with +'**
  String get phoneMustStartWithPlus;

  /// No description provided for @enterValidPhone.
  ///
  /// In en, this message translates to:
  /// **'Enter a valid phone number'**
  String get enterValidPhone;

  /// No description provided for @confirmPassword.
  ///
  /// In en, this message translates to:
  /// **'Confirm password'**
  String get confirmPassword;

  /// No description provided for @passwordsDoNotMatch.
  ///
  /// In en, this message translates to:
  /// **'Passwords do not match'**
  String get passwordsDoNotMatch;

  /// No description provided for @passwordMinLength.
  ///
  /// In en, this message translates to:
  /// **'Password must be at least 8 characters'**
  String get passwordMinLength;

  /// No description provided for @atLeast8Chars.
  ///
  /// In en, this message translates to:
  /// **'At least 8 characters'**
  String get atLeast8Chars;

  /// No description provided for @backToSignIn.
  ///
  /// In en, this message translates to:
  /// **'Back to sign in'**
  String get backToSignIn;

  /// No description provided for @registrationFailed.
  ///
  /// In en, this message translates to:
  /// **'Registration failed: {error}'**
  String registrationFailed(String error);

  /// No description provided for @loginPasswordOptionalHint.
  ///
  /// In en, this message translates to:
  /// **'If your profile was created by admin/import, leave password empty and continue.'**
  String get loginPasswordOptionalHint;

  /// No description provided for @setPasswordTitle.
  ///
  /// In en, this message translates to:
  /// **'Set password'**
  String get setPasswordTitle;

  /// No description provided for @setPasswordSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Create a password for {email}'**
  String setPasswordSubtitle(String email);

  /// No description provided for @passwordSetupMinLength.
  ///
  /// In en, this message translates to:
  /// **'Password must be at least 6 characters'**
  String get passwordSetupMinLength;

  /// No description provided for @savePasswordAndContinue.
  ///
  /// In en, this message translates to:
  /// **'Save password and continue'**
  String get savePasswordAndContinue;

  /// No description provided for @passwordSetupFailed.
  ///
  /// In en, this message translates to:
  /// **'Password setup failed: {error}'**
  String passwordSetupFailed(String error);

  /// No description provided for @account.
  ///
  /// In en, this message translates to:
  /// **'Account'**
  String get account;

  /// No description provided for @editInfo.
  ///
  /// In en, this message translates to:
  /// **'EDIT INFO'**
  String get editInfo;

  /// No description provided for @fullName.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get fullName;

  /// No description provided for @retry.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get retry;

  /// No description provided for @accountSettings.
  ///
  /// In en, this message translates to:
  /// **'Account settings'**
  String get accountSettings;

  /// No description provided for @editProfile.
  ///
  /// In en, this message translates to:
  /// **'Edit profile'**
  String get editProfile;

  /// No description provided for @deleteAccount.
  ///
  /// In en, this message translates to:
  /// **'Delete account'**
  String get deleteAccount;

  /// No description provided for @deleteAccountConfirmTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete account?'**
  String get deleteAccountConfirmTitle;

  /// No description provided for @deleteAccountConfirmMessage.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to permanently delete your account? This cannot be undone.'**
  String get deleteAccountConfirmMessage;

  /// No description provided for @deleteAccountSecondTitle.
  ///
  /// In en, this message translates to:
  /// **'What will be deleted'**
  String get deleteAccountSecondTitle;

  /// No description provided for @deleteAccountSecondMessage.
  ///
  /// In en, this message translates to:
  /// **'The following will be permanently removed from our systems:\n\n• Your account and profile\n• All children linked to your account\n• All event assignments, stage progress, tickets, and meal selections\n• Photos and other data stored for your children\n• Your membership in event chats and in-app notifications\n\nSome payment or accounting records may be kept where required by law.'**
  String get deleteAccountSecondMessage;

  /// No description provided for @deleteAccountContinue.
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get deleteAccountContinue;

  /// No description provided for @deleteAccountConfirmAction.
  ///
  /// In en, this message translates to:
  /// **'Delete permanently'**
  String get deleteAccountConfirmAction;

  /// No description provided for @deleteAccountWorking.
  ///
  /// In en, this message translates to:
  /// **'Deleting account…'**
  String get deleteAccountWorking;

  /// No description provided for @save.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// No description provided for @edit.
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get edit;

  /// No description provided for @role.
  ///
  /// In en, this message translates to:
  /// **'Role'**
  String get role;

  /// No description provided for @myChildren.
  ///
  /// In en, this message translates to:
  /// **'My Children'**
  String get myChildren;

  /// No description provided for @addChild.
  ///
  /// In en, this message translates to:
  /// **'Add Child'**
  String get addChild;

  /// No description provided for @noChildrenAddedYet.
  ///
  /// In en, this message translates to:
  /// **'No children added yet'**
  String get noChildrenAddedYet;

  /// No description provided for @ageLabel.
  ///
  /// In en, this message translates to:
  /// **'Age'**
  String get ageLabel;

  /// No description provided for @settings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// No description provided for @aboutTheApp.
  ///
  /// In en, this message translates to:
  /// **'About the app'**
  String get aboutTheApp;

  /// No description provided for @aboutAppDisplayName.
  ///
  /// In en, this message translates to:
  /// **'YoungFashionShow'**
  String get aboutAppDisplayName;

  /// No description provided for @aboutPublisherLine.
  ///
  /// In en, this message translates to:
  /// **'YOUNGFASHIONSHOW'**
  String get aboutPublisherLine;

  /// No description provided for @aboutVersionLabel.
  ///
  /// In en, this message translates to:
  /// **'VERSION'**
  String get aboutVersionLabel;

  /// No description provided for @aboutReleaseDateLabel.
  ///
  /// In en, this message translates to:
  /// **'RELEASE DATE'**
  String get aboutReleaseDateLabel;

  /// No description provided for @aboutDevelopedByPrefix.
  ///
  /// In en, this message translates to:
  /// **'Developed by:'**
  String get aboutDevelopedByPrefix;

  /// No description provided for @aboutDeveloperBrand.
  ///
  /// In en, this message translates to:
  /// **'OWLSOLUTIONS'**
  String get aboutDeveloperBrand;

  /// No description provided for @aboutLinkCouldNotOpen.
  ///
  /// In en, this message translates to:
  /// **'Could not open the link.'**
  String get aboutLinkCouldNotOpen;

  /// No description provided for @appLanguage.
  ///
  /// In en, this message translates to:
  /// **'App language'**
  String get appLanguage;

  /// No description provided for @unitsOfMeasurement.
  ///
  /// In en, this message translates to:
  /// **'Units of measurement'**
  String get unitsOfMeasurement;

  /// No description provided for @timeDisplayFormat.
  ///
  /// In en, this message translates to:
  /// **'Time display format'**
  String get timeDisplayFormat;

  /// No description provided for @timeFormat24Hour.
  ///
  /// In en, this message translates to:
  /// **'24-hour'**
  String get timeFormat24Hour;

  /// No description provided for @timeFormat12Hour.
  ///
  /// In en, this message translates to:
  /// **'12-hour (AM/PM)'**
  String get timeFormat12Hour;

  /// No description provided for @metricUnits.
  ///
  /// In en, this message translates to:
  /// **'Metric (cm, kg)'**
  String get metricUnits;

  /// No description provided for @imperialUnits.
  ///
  /// In en, this message translates to:
  /// **'American (in, lb)'**
  String get imperialUnits;

  /// No description provided for @systemLanguage.
  ///
  /// In en, this message translates to:
  /// **'System'**
  String get systemLanguage;

  /// No description provided for @languageRussian.
  ///
  /// In en, this message translates to:
  /// **'Russian'**
  String get languageRussian;

  /// No description provided for @languageEnglish.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get languageEnglish;

  /// No description provided for @languageUkrainian.
  ///
  /// In en, this message translates to:
  /// **'Ukrainian'**
  String get languageUkrainian;

  /// No description provided for @languageSpanishUS.
  ///
  /// In en, this message translates to:
  /// **'Spanish (U.S.)'**
  String get languageSpanishUS;

  /// No description provided for @addChildTitle.
  ///
  /// In en, this message translates to:
  /// **'Add child'**
  String get addChildTitle;

  /// No description provided for @firstName.
  ///
  /// In en, this message translates to:
  /// **'First name'**
  String get firstName;

  /// No description provided for @gender.
  ///
  /// In en, this message translates to:
  /// **'Gender'**
  String get gender;

  /// No description provided for @genderBoy.
  ///
  /// In en, this message translates to:
  /// **'Boy'**
  String get genderBoy;

  /// No description provided for @genderGirl.
  ///
  /// In en, this message translates to:
  /// **'Girl'**
  String get genderGirl;

  /// No description provided for @lastName.
  ///
  /// In en, this message translates to:
  /// **'Last name'**
  String get lastName;

  /// No description provided for @birthdate.
  ///
  /// In en, this message translates to:
  /// **'Birthdate'**
  String get birthdate;

  /// No description provided for @chooseDate.
  ///
  /// In en, this message translates to:
  /// **'Choose date'**
  String get chooseDate;

  /// No description provided for @create.
  ///
  /// In en, this message translates to:
  /// **'Create'**
  String get create;

  /// No description provided for @enterFirstName.
  ///
  /// In en, this message translates to:
  /// **'Enter first name'**
  String get enterFirstName;

  /// No description provided for @mainPhoto.
  ///
  /// In en, this message translates to:
  /// **'Main photo'**
  String get mainPhoto;

  /// No description provided for @changePhoto.
  ///
  /// In en, this message translates to:
  /// **'Change'**
  String get changePhoto;

  /// No description provided for @deletePhoto.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get deletePhoto;

  /// No description provided for @addPhoto.
  ///
  /// In en, this message translates to:
  /// **'Add photo'**
  String get addPhoto;

  /// No description provided for @photoSaved.
  ///
  /// In en, this message translates to:
  /// **'Photo saved'**
  String get photoSaved;

  /// No description provided for @photoDeleted.
  ///
  /// In en, this message translates to:
  /// **'Photo deleted'**
  String get photoDeleted;

  /// No description provided for @photoAdded.
  ///
  /// In en, this message translates to:
  /// **'Photo added'**
  String get photoAdded;

  /// No description provided for @extraPhotos.
  ///
  /// In en, this message translates to:
  /// **'Extra photos'**
  String get extraPhotos;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @clear.
  ///
  /// In en, this message translates to:
  /// **'Clear'**
  String get clear;

  /// No description provided for @height.
  ///
  /// In en, this message translates to:
  /// **'Height'**
  String get height;

  /// No description provided for @weight.
  ///
  /// In en, this message translates to:
  /// **'Weight'**
  String get weight;

  /// No description provided for @shoulders.
  ///
  /// In en, this message translates to:
  /// **'Shoulders'**
  String get shoulders;

  /// No description provided for @chest.
  ///
  /// In en, this message translates to:
  /// **'Chest'**
  String get chest;

  /// No description provided for @waist.
  ///
  /// In en, this message translates to:
  /// **'Waist'**
  String get waist;

  /// No description provided for @hips.
  ///
  /// In en, this message translates to:
  /// **'Hips'**
  String get hips;

  /// No description provided for @measurementLengthUnitCm.
  ///
  /// In en, this message translates to:
  /// **'cm'**
  String get measurementLengthUnitCm;

  /// No description provided for @measurementLengthUnitIn.
  ///
  /// In en, this message translates to:
  /// **'in'**
  String get measurementLengthUnitIn;

  /// No description provided for @currentParticipation.
  ///
  /// In en, this message translates to:
  /// **'Current Participation'**
  String get currentParticipation;

  /// No description provided for @childSubscribedBrands.
  ///
  /// In en, this message translates to:
  /// **'Brands: {brands}'**
  String childSubscribedBrands(String brands);

  /// No description provided for @unknownError.
  ///
  /// In en, this message translates to:
  /// **'Unknown error'**
  String get unknownError;

  /// No description provided for @model.
  ///
  /// In en, this message translates to:
  /// **'Model: {name}'**
  String model(String name);

  /// No description provided for @active.
  ///
  /// In en, this message translates to:
  /// **'ACTIVE'**
  String get active;

  /// No description provided for @familyLabel.
  ///
  /// In en, this message translates to:
  /// **'FAMILY'**
  String get familyLabel;

  /// No description provided for @familyJoinButton.
  ///
  /// In en, this message translates to:
  /// **'JOIN FAMILY'**
  String get familyJoinButton;

  /// No description provided for @familyJoinDialogHint.
  ///
  /// In en, this message translates to:
  /// **'Enter the 6-digit family code.'**
  String get familyJoinDialogHint;

  /// No description provided for @familyJoinAction.
  ///
  /// In en, this message translates to:
  /// **'Join'**
  String get familyJoinAction;

  /// No description provided for @familyJoinInvalidCode.
  ///
  /// In en, this message translates to:
  /// **'Enter a valid 6-digit code.'**
  String get familyJoinInvalidCode;

  /// No description provided for @familyJoinSuccess.
  ///
  /// In en, this message translates to:
  /// **'Family subscription connected.'**
  String get familyJoinSuccess;

  /// No description provided for @contractWarningTitle.
  ///
  /// In en, this message translates to:
  /// **'Warning'**
  String get contractWarningTitle;

  /// No description provided for @contractWarningFallbackText.
  ///
  /// In en, this message translates to:
  /// **'Before purchasing tickets, please review and sign the contract.'**
  String get contractWarningFallbackText;

  /// No description provided for @contractViewButton.
  ///
  /// In en, this message translates to:
  /// **'View'**
  String get contractViewButton;

  /// No description provided for @contractPreviewTitle.
  ///
  /// In en, this message translates to:
  /// **'Contract text'**
  String get contractPreviewTitle;

  /// No description provided for @contractSignButton.
  ///
  /// In en, this message translates to:
  /// **'Sign'**
  String get contractSignButton;

  /// No description provided for @contractSignatureTitle.
  ///
  /// In en, this message translates to:
  /// **'Add signature'**
  String get contractSignatureTitle;

  /// No description provided for @contractSignedSuccess.
  ///
  /// In en, this message translates to:
  /// **'Contract signed successfully.'**
  String get contractSignedSuccess;

  /// No description provided for @journeyProgress.
  ///
  /// In en, this message translates to:
  /// **'JOURNEY PROGRESS'**
  String get journeyProgress;

  /// No description provided for @journeyPreparationPhase.
  ///
  /// In en, this message translates to:
  /// **'PREPARATION PHASE'**
  String get journeyPreparationPhase;

  /// No description provided for @journeyMainEventTitle.
  ///
  /// In en, this message translates to:
  /// **'THE MAIN EVENT'**
  String get journeyMainEventTitle;

  /// No description provided for @journeyMainEventSubtitle.
  ///
  /// In en, this message translates to:
  /// **'RUNWAY EXCLUSIVE'**
  String get journeyMainEventSubtitle;

  /// No description provided for @stepOf.
  ///
  /// In en, this message translates to:
  /// **'Step {completed} of {total}'**
  String stepOf(int completed, int total);

  /// No description provided for @next.
  ///
  /// In en, this message translates to:
  /// **'Next: {text}'**
  String next(String text);

  /// No description provided for @viewProgress.
  ///
  /// In en, this message translates to:
  /// **'VIEW PROGRESS'**
  String get viewProgress;

  /// No description provided for @eventSettings.
  ///
  /// In en, this message translates to:
  /// **'EVENT SETTINGS'**
  String get eventSettings;

  /// No description provided for @homeEventCardMyEvent.
  ///
  /// In en, this message translates to:
  /// **'MY EVENT'**
  String get homeEventCardMyEvent;

  /// No description provided for @homeEventCardRunwayJourney.
  ///
  /// In en, this message translates to:
  /// **'RUNWAY JOURNEY'**
  String get homeEventCardRunwayJourney;

  /// No description provided for @eventSettingsPlaceholder.
  ///
  /// In en, this message translates to:
  /// **'Event settings will appear here soon.'**
  String get eventSettingsPlaceholder;

  /// No description provided for @eventSettingsConfigurationPortal.
  ///
  /// In en, this message translates to:
  /// **'CONFIGURATION PORTAL'**
  String get eventSettingsConfigurationPortal;

  /// No description provided for @eventSettingsMainHeadline.
  ///
  /// In en, this message translates to:
  /// **'Event Settings'**
  String get eventSettingsMainHeadline;

  /// No description provided for @eventSettingsFamilyButton.
  ///
  /// In en, this message translates to:
  /// **'Family'**
  String get eventSettingsFamilyButton;

  /// No description provided for @familyManageTitle.
  ///
  /// In en, this message translates to:
  /// **'Family'**
  String get familyManageTitle;

  /// No description provided for @familyManageEnabled.
  ///
  /// In en, this message translates to:
  /// **'Enable family connections'**
  String get familyManageEnabled;

  /// No description provided for @familyManageCodeLabel.
  ///
  /// In en, this message translates to:
  /// **'Family code'**
  String get familyManageCodeLabel;

  /// No description provided for @familyManageRegenerateCode.
  ///
  /// In en, this message translates to:
  /// **'Regenerate code'**
  String get familyManageRegenerateCode;

  /// No description provided for @familyManageConnectionsTitle.
  ///
  /// In en, this message translates to:
  /// **'Active family connections'**
  String get familyManageConnectionsTitle;

  /// No description provided for @familyManageNoConnections.
  ///
  /// In en, this message translates to:
  /// **'No active family connections yet.'**
  String get familyManageNoConnections;

  /// No description provided for @familyManageUnknownUser.
  ///
  /// In en, this message translates to:
  /// **'Unknown user'**
  String get familyManageUnknownUser;

  /// No description provided for @eventSettingsLeaveFamilyButton.
  ///
  /// In en, this message translates to:
  /// **'Disconnect from family'**
  String get eventSettingsLeaveFamilyButton;

  /// No description provided for @eventSettingsLeaveFamilyConfirmTitle.
  ///
  /// In en, this message translates to:
  /// **'Disconnect family access?'**
  String get eventSettingsLeaveFamilyConfirmTitle;

  /// No description provided for @eventSettingsLeaveFamilyConfirmText.
  ///
  /// In en, this message translates to:
  /// **'You will lose family event access until you join again by code.'**
  String get eventSettingsLeaveFamilyConfirmText;

  /// No description provided for @eventSettingsLeaveFamilySuccess.
  ///
  /// In en, this message translates to:
  /// **'Family access has been disconnected.'**
  String get eventSettingsLeaveFamilySuccess;

  /// No description provided for @eventSettingsMealTitle.
  ///
  /// In en, this message translates to:
  /// **'Meal Selection'**
  String get eventSettingsMealTitle;

  /// No description provided for @eventSettingsMealSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Choose a meal for the current event'**
  String get eventSettingsMealSubtitle;

  /// No description provided for @eventSettingsMealCta.
  ///
  /// In en, this message translates to:
  /// **'MANAGE MENU'**
  String get eventSettingsMealCta;

  /// No description provided for @eventSettingsMealOrderedPcs.
  ///
  /// In en, this message translates to:
  /// **'Ordered: {count} pc'**
  String eventSettingsMealOrderedPcs(int count);

  /// No description provided for @eventSettingsMealPurchasesListHeading.
  ///
  /// In en, this message translates to:
  /// **'Placed orders'**
  String get eventSettingsMealPurchasesListHeading;

  /// No description provided for @eventSettingsMealPurchaseChildLine.
  ///
  /// In en, this message translates to:
  /// **'Child: {name}'**
  String eventSettingsMealPurchaseChildLine(String name);

  /// No description provided for @mealPurchaseIssued.
  ///
  /// In en, this message translates to:
  /// **'Issued'**
  String get mealPurchaseIssued;

  /// No description provided for @mealPurchaseNotIssued.
  ///
  /// In en, this message translates to:
  /// **'Not handed out yet'**
  String get mealPurchaseNotIssued;

  /// No description provided for @eventSettingsRehearsalTitle.
  ///
  /// In en, this message translates to:
  /// **'Rehearsal Booking'**
  String get eventSettingsRehearsalTitle;

  /// No description provided for @eventSettingsRehearsalSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Book your spot for rehearsal'**
  String get eventSettingsRehearsalSubtitle;

  /// No description provided for @eventSettingsRehearsalCta.
  ///
  /// In en, this message translates to:
  /// **'BOOK NOW'**
  String get eventSettingsRehearsalCta;

  /// No description provided for @eventSettingsBrandRehearsalsHeading.
  ///
  /// In en, this message translates to:
  /// **'Your brand rehearsals'**
  String get eventSettingsBrandRehearsalsHeading;

  /// No description provided for @rehearsalModalTitle.
  ///
  /// In en, this message translates to:
  /// **'Rehearsal booking'**
  String get rehearsalModalTitle;

  /// No description provided for @rehearsalSelectDate.
  ///
  /// In en, this message translates to:
  /// **'Select date'**
  String get rehearsalSelectDate;

  /// No description provided for @rehearsalAvailableSlots.
  ///
  /// In en, this message translates to:
  /// **'Available slots'**
  String get rehearsalAvailableSlots;

  /// No description provided for @rehearsalFreeLabel.
  ///
  /// In en, this message translates to:
  /// **'Available:'**
  String get rehearsalFreeLabel;

  /// No description provided for @rehearsalNoSlotsConfigured.
  ///
  /// In en, this message translates to:
  /// **'No rehearsal slots for this event yet.'**
  String get rehearsalNoSlotsConfigured;

  /// No description provided for @rehearsalLoadError.
  ///
  /// In en, this message translates to:
  /// **'Could not load slots. Try again.'**
  String get rehearsalLoadError;

  /// No description provided for @rehearsalBrandNotAssigned.
  ///
  /// In en, this message translates to:
  /// **'Brand is not assigned for this child. Rehearsal booking is unavailable.'**
  String get rehearsalBrandNotAssigned;

  /// No description provided for @rehearsalFull.
  ///
  /// In en, this message translates to:
  /// **'Full'**
  String get rehearsalFull;

  /// No description provided for @rehearsalConfirmBooking.
  ///
  /// In en, this message translates to:
  /// **'Confirm booking'**
  String get rehearsalConfirmBooking;

  /// No description provided for @rehearsalBookingFooterNote.
  ///
  /// In en, this message translates to:
  /// **'Changes must be made 24 hours before the session when possible.'**
  String get rehearsalBookingFooterNote;

  /// No description provided for @rehearsalBookedTitle.
  ///
  /// In en, this message translates to:
  /// **'Your rehearsal is booked'**
  String get rehearsalBookedTitle;

  /// No description provided for @rehearsalChangeBooking.
  ///
  /// In en, this message translates to:
  /// **'Change booking'**
  String get rehearsalChangeBooking;

  /// No description provided for @rehearsalProgramLabel.
  ///
  /// In en, this message translates to:
  /// **'Details'**
  String get rehearsalProgramLabel;

  /// No description provided for @rehearsalArriveEarly.
  ///
  /// In en, this message translates to:
  /// **'Please arrive 15 minutes early.'**
  String get rehearsalArriveEarly;

  /// No description provided for @rehearsalBookingSaved.
  ///
  /// In en, this message translates to:
  /// **'Booking saved'**
  String get rehearsalBookingSaved;

  /// No description provided for @rehearsalBookingError.
  ///
  /// In en, this message translates to:
  /// **'Could not complete booking.'**
  String get rehearsalBookingError;

  /// No description provided for @rehearsalSelectChild.
  ///
  /// In en, this message translates to:
  /// **'Child'**
  String get rehearsalSelectChild;

  /// No description provided for @rehearsalUpdateBooking.
  ///
  /// In en, this message translates to:
  /// **'Add and update booking'**
  String get rehearsalUpdateBooking;

  /// No description provided for @rehearsalCancelChange.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get rehearsalCancelChange;

  /// No description provided for @rehearsalChangeBookingLockedHint.
  ///
  /// In en, this message translates to:
  /// **'The organizer has closed booking changes. Contact support if you need help.'**
  String get rehearsalChangeBookingLockedHint;

  /// No description provided for @rehearsalMilestoneTitle.
  ///
  /// In en, this message translates to:
  /// **'General rehearsal'**
  String get rehearsalMilestoneTitle;

  /// No description provided for @rehearsalBrandMilestoneTitle.
  ///
  /// In en, this message translates to:
  /// **'Brand rehearsal: {brandName}'**
  String rehearsalBrandMilestoneTitle(String brandName);

  /// No description provided for @rehearsalBrandMilestoneShort.
  ///
  /// In en, this message translates to:
  /// **'Brand rehearsal'**
  String get rehearsalBrandMilestoneShort;

  /// No description provided for @rehearsalNextBookHint.
  ///
  /// In en, this message translates to:
  /// **'Book your rehearsal slot in Event settings.'**
  String get rehearsalNextBookHint;

  /// No description provided for @eventSettingsPackingTitle.
  ///
  /// In en, this message translates to:
  /// **'Don\'t Forget List'**
  String get eventSettingsPackingTitle;

  /// No description provided for @eventSettingsPackingSubtitle.
  ///
  /// In en, this message translates to:
  /// **''**
  String get eventSettingsPackingSubtitle;

  /// No description provided for @eventSettingsPackingCta.
  ///
  /// In en, this message translates to:
  /// **'VIEW LIST'**
  String get eventSettingsPackingCta;

  /// No description provided for @eventPackingLoadFailed.
  ///
  /// In en, this message translates to:
  /// **'Could not load packing info. Try again.'**
  String get eventPackingLoadFailed;

  /// No description provided for @eventPackingEmpty.
  ///
  /// In en, this message translates to:
  /// **'Packing information has not been added for this event yet.'**
  String get eventPackingEmpty;

  /// No description provided for @eventDescriptionTitle.
  ///
  /// In en, this message translates to:
  /// **'Event info'**
  String get eventDescriptionTitle;

  /// No description provided for @eventProgressShowGallery.
  ///
  /// In en, this message translates to:
  /// **'Show gallery'**
  String get eventProgressShowGallery;

  /// No description provided for @eventProgressCheckin.
  ///
  /// In en, this message translates to:
  /// **'Check-in'**
  String get eventProgressCheckin;

  /// No description provided for @eventProgressCheckinPrompt.
  ///
  /// In en, this message translates to:
  /// **'Scan to start the event'**
  String get eventProgressCheckinPrompt;

  /// No description provided for @eventProgressCheckinUnavailable.
  ///
  /// In en, this message translates to:
  /// **'Check-in code is not available yet.'**
  String get eventProgressCheckinUnavailable;

  /// No description provided for @eventDescriptionLoadFailed.
  ///
  /// In en, this message translates to:
  /// **'Could not load event description. Try again.'**
  String get eventDescriptionLoadFailed;

  /// No description provided for @eventDescriptionEmpty.
  ///
  /// In en, this message translates to:
  /// **'No description has been added for this event yet.'**
  String get eventDescriptionEmpty;

  /// No description provided for @eventSettingsBrandTitle.
  ///
  /// In en, this message translates to:
  /// **'Shoes & socks'**
  String get eventSettingsBrandTitle;

  /// No description provided for @eventSettingsBrandSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Read the brand\'s recommendations for taking part in the event'**
  String get eventSettingsBrandSubtitle;

  /// No description provided for @eventSettingsBrandCta.
  ///
  /// In en, this message translates to:
  /// **'VIEW GUIDELINES'**
  String get eventSettingsBrandCta;

  /// No description provided for @brandRequirementsLoadFailed.
  ///
  /// In en, this message translates to:
  /// **'Could not load brand requirements. Try again.'**
  String get brandRequirementsLoadFailed;

  /// No description provided for @brandRequirementsEmpty.
  ///
  /// In en, this message translates to:
  /// **'No brand requirements have been added for this event yet.'**
  String get brandRequirementsEmpty;

  /// No description provided for @brandRequirementsEmptyItem.
  ///
  /// In en, this message translates to:
  /// **'No requirements text has been added for this brand yet.'**
  String get brandRequirementsEmptyItem;

  /// No description provided for @brandRequirementsPickBrandTitle.
  ///
  /// In en, this message translates to:
  /// **'Choose a brand'**
  String get brandRequirementsPickBrandTitle;

  /// No description provided for @brandRequirementsBrandNumber.
  ///
  /// In en, this message translates to:
  /// **'Brand {brandId}'**
  String brandRequirementsBrandNumber(int brandId);

  /// No description provided for @eventSettingsParkingTitle.
  ///
  /// In en, this message translates to:
  /// **'Valet Parking'**
  String get eventSettingsParkingTitle;

  /// No description provided for @eventSettingsParkingSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Open your valet parking pass and arrival status'**
  String get eventSettingsParkingSubtitle;

  /// No description provided for @eventSettingsParkingCta.
  ///
  /// In en, this message translates to:
  /// **'OPEN VALET PARKING'**
  String get eventSettingsParkingCta;

  /// No description provided for @parkingChooseModeTitle.
  ///
  /// In en, this message translates to:
  /// **'Valet parking mode'**
  String get parkingChooseModeTitle;

  /// No description provided for @parkingChooseModeHint.
  ///
  /// In en, this message translates to:
  /// **'Choose screen state for visual testing.'**
  String get parkingChooseModeHint;

  /// No description provided for @parkingModeInactive.
  ///
  /// In en, this message translates to:
  /// **'INACTIVE'**
  String get parkingModeInactive;

  /// No description provided for @parkingModeActive.
  ///
  /// In en, this message translates to:
  /// **'ACTIVE'**
  String get parkingModeActive;

  /// No description provided for @parkingInactiveHeadline.
  ///
  /// In en, this message translates to:
  /// **'NO ACTIVE VALET PARKING'**
  String get parkingInactiveHeadline;

  /// No description provided for @parkingInactiveBody.
  ///
  /// In en, this message translates to:
  /// **'VALET PARKING WILL APPEAR HERE AFTER TICKET PURCHASE.'**
  String get parkingInactiveBody;

  /// No description provided for @parkingInactiveBuyCta.
  ///
  /// In en, this message translates to:
  /// **'BUY'**
  String get parkingInactiveBuyCta;

  /// No description provided for @parkingInactiveVipBody.
  ///
  /// In en, this message translates to:
  /// **'FOR VIP VALET PARKING — RESERVE A SPOT FOR YOUR CAR.'**
  String get parkingInactiveVipBody;

  /// No description provided for @parkingInactiveVipBookCta.
  ///
  /// In en, this message translates to:
  /// **'BOOK VALET PARKING'**
  String get parkingInactiveVipBookCta;

  /// No description provided for @parkingPayForParkingCta.
  ///
  /// In en, this message translates to:
  /// **'PAY FOR VALET PARKING'**
  String get parkingPayForParkingCta;

  /// No description provided for @parkingVipQuotaNextPaymentBody.
  ///
  /// In en, this message translates to:
  /// **'YOUR COMPLIMENTARY VALET TICKETS FOR THIS EVENT ARE USED UP. YOU CAN STILL ADD A SPOT AT THE REGULAR PRICE.'**
  String get parkingVipQuotaNextPaymentBody;

  /// No description provided for @parkingFreeTicketsQuotaLine.
  ///
  /// In en, this message translates to:
  /// **'Complimentary valet: {used} of {quota} used ({remaining} left)'**
  String parkingFreeTicketsQuotaLine(int used, int quota, int remaining);

  /// No description provided for @parkingActiveTicketLabel.
  ///
  /// In en, this message translates to:
  /// **'TICKET'**
  String get parkingActiveTicketLabel;

  /// No description provided for @parkingTicketMock1.
  ///
  /// In en, this message translates to:
  /// **'TICKET A1 · MODEL'**
  String get parkingTicketMock1;

  /// No description provided for @parkingTicketMock2.
  ///
  /// In en, this message translates to:
  /// **'TICKET B7 · GUEST'**
  String get parkingTicketMock2;

  /// No description provided for @parkingActiveValetLabel.
  ///
  /// In en, this message translates to:
  /// **'VALET SERVICE'**
  String get parkingActiveValetLabel;

  /// No description provided for @parkingActiveStatusLine.
  ///
  /// In en, this message translates to:
  /// **'VALET PARKING ACTIVE'**
  String get parkingActiveStatusLine;

  /// No description provided for @parkingActiveShowEntryPointCta.
  ///
  /// In en, this message translates to:
  /// **'SHOW ENTRY POINT'**
  String get parkingActiveShowEntryPointCta;

  /// No description provided for @parkingActiveCarLabel.
  ///
  /// In en, this message translates to:
  /// **'CAR'**
  String get parkingActiveCarLabel;

  /// No description provided for @parkingActiveRegistrationNumberLabel.
  ///
  /// In en, this message translates to:
  /// **'PLATE NUMBER'**
  String get parkingActiveRegistrationNumberLabel;

  /// No description provided for @parkingCreateTicketTitle.
  ///
  /// In en, this message translates to:
  /// **'Create Ticket'**
  String get parkingCreateTicketTitle;

  /// No description provided for @parkingCreateEventLabel.
  ///
  /// In en, this message translates to:
  /// **'Event'**
  String get parkingCreateEventLabel;

  /// No description provided for @parkingCreateAccountNameLabel.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get parkingCreateAccountNameLabel;

  /// No description provided for @parkingCreateCarModelLabel.
  ///
  /// In en, this message translates to:
  /// **'MAKE AND MODEL'**
  String get parkingCreateCarModelLabel;

  /// No description provided for @parkingCreateCarModelHint.
  ///
  /// In en, this message translates to:
  /// **'For example: Ford Mustang'**
  String get parkingCreateCarModelHint;

  /// No description provided for @parkingCreatePlateNumberLabel.
  ///
  /// In en, this message translates to:
  /// **'PLATE NUMBER'**
  String get parkingCreatePlateNumberLabel;

  /// No description provided for @parkingCreatePlateNumberHint.
  ///
  /// In en, this message translates to:
  /// **'For example: CA 7JXK921'**
  String get parkingCreatePlateNumberHint;

  /// No description provided for @parkingCreateRepeatPlateNumberLabel.
  ///
  /// In en, this message translates to:
  /// **'REPEAT PLATE NUMBER'**
  String get parkingCreateRepeatPlateNumberLabel;

  /// No description provided for @parkingCreateRepeatPlateNumberHint.
  ///
  /// In en, this message translates to:
  /// **'Re-enter plate number'**
  String get parkingCreateRepeatPlateNumberHint;

  /// No description provided for @parkingCreatePlateNumberMismatch.
  ///
  /// In en, this message translates to:
  /// **'Plate numbers do not match'**
  String get parkingCreatePlateNumberMismatch;

  /// No description provided for @parkingCreateBuyCta.
  ///
  /// In en, this message translates to:
  /// **'BUY'**
  String get parkingCreateBuyCta;

  /// No description provided for @parkingCreateBookCta.
  ///
  /// In en, this message translates to:
  /// **'BOOK VALET PARKING'**
  String get parkingCreateBookCta;

  /// No description provided for @parkingCheckoutInBrowser.
  ///
  /// In en, this message translates to:
  /// **'Complete payment in your browser.'**
  String get parkingCheckoutInBrowser;

  /// No description provided for @parkingPurchasedWithoutPayment.
  ///
  /// In en, this message translates to:
  /// **'Ticket purchased successfully.'**
  String get parkingPurchasedWithoutPayment;

  /// No description provided for @parkingVipBooked.
  ///
  /// In en, this message translates to:
  /// **'VIP valet parking booked successfully.'**
  String get parkingVipBooked;

  /// No description provided for @parkingCheckoutError.
  ///
  /// In en, this message translates to:
  /// **'Could not start valet parking payment. Try again.'**
  String get parkingCheckoutError;

  /// No description provided for @clientTicketServiceUnavailableTitle.
  ///
  /// In en, this message translates to:
  /// **'Service unavailable'**
  String get clientTicketServiceUnavailableTitle;

  /// No description provided for @clientTicketServiceUnavailableBody.
  ///
  /// In en, this message translates to:
  /// **'This ticket service is not active right now.'**
  String get clientTicketServiceUnavailableBody;

  /// No description provided for @parkingActivePassLabel.
  ///
  /// In en, this message translates to:
  /// **'PASS CODE'**
  String get parkingActivePassLabel;

  /// No description provided for @eventSettingsChatTitle.
  ///
  /// In en, this message translates to:
  /// **'Group Chat'**
  String get eventSettingsChatTitle;

  /// No description provided for @eventSettingsChatSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Group chat with group participants and managers'**
  String get eventSettingsChatSubtitle;

  /// No description provided for @eventSettingsChatCta.
  ///
  /// In en, this message translates to:
  /// **'OPEN CHAT'**
  String get eventSettingsChatCta;

  /// No description provided for @chatRoomsLoadFailed.
  ///
  /// In en, this message translates to:
  /// **'Could not load chat rooms. Try again.'**
  String get chatRoomsLoadFailed;

  /// No description provided for @chatNoRooms.
  ///
  /// In en, this message translates to:
  /// **'No chat rooms are available for your brands in this event yet.'**
  String get chatNoRooms;

  /// No description provided for @chatNoMessagesYet.
  ///
  /// In en, this message translates to:
  /// **'No messages yet'**
  String get chatNoMessagesYet;

  /// No description provided for @chatLoadFailed.
  ///
  /// In en, this message translates to:
  /// **'Could not load chat messages. Try again.'**
  String get chatLoadFailed;

  /// No description provided for @chatSendFailed.
  ///
  /// In en, this message translates to:
  /// **'Could not send message. Try again.'**
  String get chatSendFailed;

  /// No description provided for @chatMessagePlaceholder.
  ///
  /// In en, this message translates to:
  /// **'Message group...'**
  String get chatMessagePlaceholder;

  /// No description provided for @chatReply.
  ///
  /// In en, this message translates to:
  /// **'Reply'**
  String get chatReply;

  /// No description provided for @chatReplyCancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get chatReplyCancel;

  /// No description provided for @chatReplyingTo.
  ///
  /// In en, this message translates to:
  /// **'Replying to {name}'**
  String chatReplyingTo(String name);

  /// No description provided for @chatReplyPreviewPhoto.
  ///
  /// In en, this message translates to:
  /// **'Photo'**
  String get chatReplyPreviewPhoto;

  /// No description provided for @chatEdit.
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get chatEdit;

  /// No description provided for @chatDelete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get chatDelete;

  /// No description provided for @chatDeleteTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete message?'**
  String get chatDeleteTitle;

  /// No description provided for @chatDeleteMessageConfirm.
  ///
  /// In en, this message translates to:
  /// **'This action cannot be undone.'**
  String get chatDeleteMessageConfirm;

  /// No description provided for @chatDeleteFailed.
  ///
  /// In en, this message translates to:
  /// **'Could not delete message. Try again.'**
  String get chatDeleteFailed;

  /// No description provided for @chatEditFailed.
  ///
  /// In en, this message translates to:
  /// **'Could not edit message. Try again.'**
  String get chatEditFailed;

  /// No description provided for @chatEditingLabel.
  ///
  /// In en, this message translates to:
  /// **'Editing message'**
  String get chatEditingLabel;

  /// No description provided for @chatCancelEdit.
  ///
  /// In en, this message translates to:
  /// **'Cancel edit'**
  String get chatCancelEdit;

  /// No description provided for @eventSettingsChatMoreParticipants.
  ///
  /// In en, this message translates to:
  /// **'+{count}'**
  String eventSettingsChatMoreParticipants(int count);

  /// No description provided for @mealChoiceTitle.
  ///
  /// In en, this message translates to:
  /// **'Choose lunch'**
  String get mealChoiceTitle;

  /// No description provided for @mealSelectChildLabel.
  ///
  /// In en, this message translates to:
  /// **'Child'**
  String get mealSelectChildLabel;

  /// No description provided for @mealSelectDishLabel.
  ///
  /// In en, this message translates to:
  /// **'Dish'**
  String get mealSelectDishLabel;

  /// No description provided for @mealSave.
  ///
  /// In en, this message translates to:
  /// **'ORDER'**
  String get mealSave;

  /// No description provided for @mealNoMealsConfigured.
  ///
  /// In en, this message translates to:
  /// **'No dishes have been added for this event yet.'**
  String get mealNoMealsConfigured;

  /// No description provided for @mealSaved.
  ///
  /// In en, this message translates to:
  /// **'Saved'**
  String get mealSaved;

  /// No description provided for @mealSaveError.
  ///
  /// In en, this message translates to:
  /// **'Could not save. Try again.'**
  String get mealSaveError;

  /// No description provided for @mealOrdersClosed.
  ///
  /// In en, this message translates to:
  /// **'Order acceptance is closed'**
  String get mealOrdersClosed;

  /// No description provided for @mealPaid.
  ///
  /// In en, this message translates to:
  /// **'Paid'**
  String get mealPaid;

  /// No description provided for @mealPaidDetail.
  ///
  /// In en, this message translates to:
  /// **'Lunch for this event is paid.'**
  String get mealPaidDetail;

  /// No description provided for @mealPayInBrowser.
  ///
  /// In en, this message translates to:
  /// **'Complete payment in the browser, then return to the app.'**
  String get mealPayInBrowser;

  /// No description provided for @mealCheckoutError.
  ///
  /// In en, this message translates to:
  /// **'Could not start payment. Try again.'**
  String get mealCheckoutError;

  /// No description provided for @mealAwaitingPayment.
  ///
  /// In en, this message translates to:
  /// **'Order placed — awaiting payment'**
  String get mealAwaitingPayment;

  /// No description provided for @mealAwaitingPaymentDetail.
  ///
  /// In en, this message translates to:
  /// **'Your dish is saved. Finish payment in the browser; status will update after Stripe confirms it.'**
  String get mealAwaitingPaymentDetail;

  /// No description provided for @mealPaymentContinue.
  ///
  /// In en, this message translates to:
  /// **'Continue payment'**
  String get mealPaymentContinue;

  /// No description provided for @mealPaymentCancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel payment'**
  String get mealPaymentCancel;

  /// No description provided for @mealPaymentStartAgain.
  ///
  /// In en, this message translates to:
  /// **'Start payment again'**
  String get mealPaymentStartAgain;

  /// No description provided for @mealPaymentCanceled.
  ///
  /// In en, this message translates to:
  /// **'Payment canceled. You can start again when ready.'**
  String get mealPaymentCanceled;

  /// No description provided for @mealPaymentStatusLoadError.
  ///
  /// In en, this message translates to:
  /// **'Could not load payment status. Try again.'**
  String get mealPaymentStatusLoadError;

  /// No description provided for @noActiveEvents.
  ///
  /// In en, this message translates to:
  /// **'No active events'**
  String get noActiveEvents;

  /// No description provided for @becomeModelTitle.
  ///
  /// In en, this message translates to:
  /// **'Start your child\'s modeling journey today'**
  String get becomeModelTitle;

  /// No description provided for @becomeAModel.
  ///
  /// In en, this message translates to:
  /// **'BECOME A MODEL'**
  String get becomeAModel;

  /// No description provided for @latestHighlights.
  ///
  /// In en, this message translates to:
  /// **'Latest Highlights'**
  String get latestHighlights;

  /// No description provided for @viewAll.
  ///
  /// In en, this message translates to:
  /// **'VIEW ALL'**
  String get viewAll;

  /// No description provided for @quickActions.
  ///
  /// In en, this message translates to:
  /// **'Quick Actions'**
  String get quickActions;

  /// No description provided for @fillOutApplication.
  ///
  /// In en, this message translates to:
  /// **'Fill Out\nApplication'**
  String get fillOutApplication;

  /// No description provided for @upcomingShows.
  ///
  /// In en, this message translates to:
  /// **'Upcoming\nShows'**
  String get upcomingShows;

  /// No description provided for @manageKids.
  ///
  /// In en, this message translates to:
  /// **'Manage\nKids'**
  String get manageKids;

  /// No description provided for @navHome.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get navHome;

  /// No description provided for @navEvents.
  ///
  /// In en, this message translates to:
  /// **'Events'**
  String get navEvents;

  /// No description provided for @eventsYoutubeLiveButton.
  ///
  /// In en, this message translates to:
  /// **'YouTube live'**
  String get eventsYoutubeLiveButton;

  /// No description provided for @eventsYoutubeLiveInvalidUrl.
  ///
  /// In en, this message translates to:
  /// **'Could not open this YouTube link.'**
  String get eventsYoutubeLiveInvalidUrl;

  /// No description provided for @eventsYoutubeLiveOpenExternally.
  ///
  /// In en, this message translates to:
  /// **'Open in YouTube'**
  String get eventsYoutubeLiveOpenExternally;

  /// No description provided for @navProfile.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get navProfile;

  /// No description provided for @navInfo.
  ///
  /// In en, this message translates to:
  /// **'Info'**
  String get navInfo;

  /// No description provided for @continueButton.
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get continueButton;

  /// No description provided for @loading.
  ///
  /// In en, this message translates to:
  /// **'Loading...'**
  String get loading;

  /// No description provided for @signOut.
  ///
  /// In en, this message translates to:
  /// **'Sign out'**
  String get signOut;

  /// No description provided for @tokenValidNext.
  ///
  /// In en, this message translates to:
  /// **'Token valid. Next: Home page.'**
  String get tokenValidNext;

  /// No description provided for @homePageTitle.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get homePageTitle;

  /// No description provided for @youAreSignedIn.
  ///
  /// In en, this message translates to:
  /// **'You are signed in{name}.'**
  String youAreSignedIn(String name);

  /// No description provided for @yourRole.
  ///
  /// In en, this message translates to:
  /// **'Your role: {role}'**
  String yourRole(String role);

  /// No description provided for @phoneHint.
  ///
  /// In en, this message translates to:
  /// **'+1234567890'**
  String get phoneHint;

  /// No description provided for @enterValidEmailShort.
  ///
  /// In en, this message translates to:
  /// **'Enter a valid email'**
  String get enterValidEmailShort;

  /// No description provided for @phoneMustStartWithPlusShort.
  ///
  /// In en, this message translates to:
  /// **'Phone must start with +'**
  String get phoneMustStartWithPlusShort;

  /// No description provided for @comingSoon.
  ///
  /// In en, this message translates to:
  /// **'Coming soon'**
  String get comingSoon;

  /// No description provided for @hello.
  ///
  /// In en, this message translates to:
  /// **'Hello'**
  String get hello;

  /// No description provided for @helloName.
  ///
  /// In en, this message translates to:
  /// **'Hello, {name}'**
  String helloName(String name);

  /// No description provided for @noRolesAssigned.
  ///
  /// In en, this message translates to:
  /// **'You have not been assigned any roles yet. Please contact the administration.'**
  String get noRolesAssigned;

  /// No description provided for @signedInAs.
  ///
  /// In en, this message translates to:
  /// **'Signed in as {name}'**
  String signedInAs(String name);

  /// No description provided for @staff.
  ///
  /// In en, this message translates to:
  /// **'Staff'**
  String get staff;

  /// No description provided for @birthdateDialogTitle.
  ///
  /// In en, this message translates to:
  /// **'Birthdate'**
  String get birthdateDialogTitle;

  /// No description provided for @nextShowsTitle.
  ///
  /// In en, this message translates to:
  /// **'Next Shows'**
  String get nextShowsTitle;

  /// No description provided for @nextShowsSeason.
  ///
  /// In en, this message translates to:
  /// **'2026 Season'**
  String get nextShowsSeason;

  /// No description provided for @details.
  ///
  /// In en, this message translates to:
  /// **'Details'**
  String get details;

  /// No description provided for @contact.
  ///
  /// In en, this message translates to:
  /// **'Contact'**
  String get contact;

  /// No description provided for @registrationOpen.
  ///
  /// In en, this message translates to:
  /// **'Registration Open'**
  String get registrationOpen;

  /// No description provided for @myTicketsButton.
  ///
  /// In en, this message translates to:
  /// **'MY TICKETS'**
  String get myTicketsButton;

  /// No description provided for @myTicketsTitle.
  ///
  /// In en, this message translates to:
  /// **'My tickets'**
  String get myTicketsTitle;

  /// No description provided for @selectEventForTickets.
  ///
  /// In en, this message translates to:
  /// **'Select event'**
  String get selectEventForTickets;

  /// No description provided for @ticketsMomName.
  ///
  /// In en, this message translates to:
  /// **'Parent name'**
  String get ticketsMomName;

  /// No description provided for @ticketsEventDate.
  ///
  /// In en, this message translates to:
  /// **'Date'**
  String get ticketsEventDate;

  /// No description provided for @ticketsOpenPdf.
  ///
  /// In en, this message translates to:
  /// **'OPEN'**
  String get ticketsOpenPdf;

  /// No description provided for @ticketsPdfUnavailable.
  ///
  /// In en, this message translates to:
  /// **'PDF not available yet'**
  String get ticketsPdfUnavailable;

  /// No description provided for @ticketsBuy.
  ///
  /// In en, this message translates to:
  /// **'BUY TICKET'**
  String get ticketsBuy;

  /// No description provided for @ticketsBuyNoLink.
  ///
  /// In en, this message translates to:
  /// **'No purchase link is set. Add a ticket store URL for this event in the admin, or a website URL in Info.'**
  String get ticketsBuyNoLink;

  /// No description provided for @ticketsBuyCouldNotOpen.
  ///
  /// In en, this message translates to:
  /// **'Could not open the link.'**
  String get ticketsBuyCouldNotOpen;

  /// No description provided for @ticketsBuySubtitle.
  ///
  /// In en, this message translates to:
  /// **'VIP and standard seats available'**
  String get ticketsBuySubtitle;

  /// No description provided for @ticketsBuyEmailHint.
  ///
  /// In en, this message translates to:
  /// **'Your tickets will be sent to the email address provided during purchase.'**
  String get ticketsBuyEmailHint;

  /// No description provided for @extraTicketButton.
  ///
  /// In en, this message translates to:
  /// **'OPEN BAR'**
  String get extraTicketButton;

  /// No description provided for @extraTicketSelectEventFirst.
  ///
  /// In en, this message translates to:
  /// **'Select an event first.'**
  String get extraTicketSelectEventFirst;

  /// No description provided for @extraTicketNoActiveHeadline.
  ///
  /// In en, this message translates to:
  /// **'NO ACTIVE BEVERAGE PACKAGES'**
  String get extraTicketNoActiveHeadline;

  /// No description provided for @extraTicketBuyCta.
  ///
  /// In en, this message translates to:
  /// **'BUY'**
  String get extraTicketBuyCta;

  /// No description provided for @extraTicketAccessOpen.
  ///
  /// In en, this message translates to:
  /// **'ACCESS TO BEVERAGE PACKAGE IS OPEN'**
  String get extraTicketAccessOpen;

  /// No description provided for @extraTicketCheckoutInBrowser.
  ///
  /// In en, this message translates to:
  /// **'Complete payment in your browser.'**
  String get extraTicketCheckoutInBrowser;

  /// No description provided for @extraTicketCheckoutError.
  ///
  /// In en, this message translates to:
  /// **'Could not start beverage package payment. Try again.'**
  String get extraTicketCheckoutError;

  /// No description provided for @backstageTicketButton.
  ///
  /// In en, this message translates to:
  /// **'BACKSTAGE PASS'**
  String get backstageTicketButton;

  /// No description provided for @backstageTicketSelectEventFirst.
  ///
  /// In en, this message translates to:
  /// **'Select an event first.'**
  String get backstageTicketSelectEventFirst;

  /// No description provided for @backstageTicketNoActiveHeadline.
  ///
  /// In en, this message translates to:
  /// **'NO ACTIVE BACKSTAGE PASSES'**
  String get backstageTicketNoActiveHeadline;

  /// No description provided for @backstageTicketBuyCta.
  ///
  /// In en, this message translates to:
  /// **'BUY'**
  String get backstageTicketBuyCta;

  /// No description provided for @backstageTicketAccessOpen.
  ///
  /// In en, this message translates to:
  /// **'ACCESS TO BACKSTAGE PASS IS OPEN'**
  String get backstageTicketAccessOpen;

  /// No description provided for @backstageTicketCheckoutInBrowser.
  ///
  /// In en, this message translates to:
  /// **'Complete payment in your browser.'**
  String get backstageTicketCheckoutInBrowser;

  /// No description provided for @backstageTicketCheckoutError.
  ///
  /// In en, this message translates to:
  /// **'Could not start backstage pass payment. Try again.'**
  String get backstageTicketCheckoutError;

  /// No description provided for @ticketsNoEvents.
  ///
  /// In en, this message translates to:
  /// **'No events with tickets yet'**
  String get ticketsNoEvents;

  /// No description provided for @ticketsNoneForEvent.
  ///
  /// In en, this message translates to:
  /// **'No tickets for this event'**
  String get ticketsNoneForEvent;

  /// No description provided for @ticketsLoadError.
  ///
  /// In en, this message translates to:
  /// **'Could not load tickets'**
  String get ticketsLoadError;

  /// No description provided for @ticketsEventsLoadError.
  ///
  /// In en, this message translates to:
  /// **'Could not load events'**
  String get ticketsEventsLoadError;

  /// No description provided for @faqBrandCatalogTitle.
  ///
  /// In en, this message translates to:
  /// **'Clothing brands'**
  String get faqBrandCatalogTitle;

  /// No description provided for @pdfViewerTitle.
  ///
  /// In en, this message translates to:
  /// **'Ticket'**
  String get pdfViewerTitle;

  /// No description provided for @contactFormLinkMissing.
  ///
  /// In en, this message translates to:
  /// **'No form link is set. Add В«Contact / signup form URLВ» in Application settings in the admin.'**
  String get contactFormLinkMissing;

  /// No description provided for @infoHubTitle.
  ///
  /// In en, this message translates to:
  /// **'Information Hub'**
  String get infoHubTitle;

  /// No description provided for @infoMenuAboutYfs.
  ///
  /// In en, this message translates to:
  /// **'About YFS'**
  String get infoMenuAboutYfs;

  /// No description provided for @infoMenuGeneralFaq.
  ///
  /// In en, this message translates to:
  /// **'General FAQ'**
  String get infoMenuGeneralFaq;

  /// No description provided for @infoMenuContactManager.
  ///
  /// In en, this message translates to:
  /// **'Contact Manager'**
  String get infoMenuContactManager;

  /// No description provided for @infoFooterBrand.
  ///
  /// In en, this message translates to:
  /// **'YFS'**
  String get infoFooterBrand;

  /// No description provided for @infoFooterCopyright.
  ///
  /// In en, this message translates to:
  /// **'В© 2024 Young Fashion Series. All rights reserved.'**
  String get infoFooterCopyright;

  /// No description provided for @parentProgressLabel.
  ///
  /// In en, this message translates to:
  /// **'Parent progress: {completed}/{total}'**
  String parentProgressLabel(int completed, int total);

  /// No description provided for @appUpdateRequiredMessage.
  ///
  /// In en, this message translates to:
  /// **'Please update the app to continue.'**
  String get appUpdateRequiredMessage;

  /// No description provided for @appUpdateButton.
  ///
  /// In en, this message translates to:
  /// **'Update app'**
  String get appUpdateButton;

  /// No description provided for @showAll.
  ///
  /// In en, this message translates to:
  /// **'Show all'**
  String get showAll;

  /// No description provided for @staffNoneSelected.
  ///
  /// In en, this message translates to:
  /// **'-- None --'**
  String get staffNoneSelected;

  /// No description provided for @staffRoleInactive.
  ///
  /// In en, this message translates to:
  /// **'INACTIVE'**
  String get staffRoleInactive;

  /// No description provided for @staffWorkerStatusRefreshFailed.
  ///
  /// In en, this message translates to:
  /// **'Could not update role status. Check your connection.'**
  String get staffWorkerStatusRefreshFailed;

  /// No description provided for @staffScanRoleInactive.
  ///
  /// In en, this message translates to:
  /// **'This role has been deactivated in the admin panel. Scanning is not available.'**
  String get staffScanRoleInactive;

  /// No description provided for @staffScanFailed.
  ///
  /// In en, this message translates to:
  /// **'Scan failed: {error}'**
  String staffScanFailed(String error);

  /// No description provided for @staffScanSelectEventStageFirst.
  ///
  /// In en, this message translates to:
  /// **'Select active event and stage in Staff Settings before scanning.'**
  String get staffScanSelectEventStageFirst;

  /// No description provided for @staffScanProcessed.
  ///
  /// In en, this message translates to:
  /// **'Scan processed'**
  String get staffScanProcessed;

  /// No description provided for @chatCouldNotPickPhoto.
  ///
  /// In en, this message translates to:
  /// **'Could not pick photo'**
  String get chatCouldNotPickPhoto;

  /// No description provided for @staffChildProfileTitle.
  ///
  /// In en, this message translates to:
  /// **'Child Profile'**
  String get staffChildProfileTitle;

  /// No description provided for @staffEventTimelineButton.
  ///
  /// In en, this message translates to:
  /// **'TIMELINE'**
  String get staffEventTimelineButton;

  /// No description provided for @staffEventTimelineTitle.
  ///
  /// In en, this message translates to:
  /// **'Event timeline'**
  String get staffEventTimelineTitle;

  /// No description provided for @staffParentTimelineButton1.
  ///
  /// In en, this message translates to:
  /// **'PARENT 1 TIMELINE'**
  String get staffParentTimelineButton1;

  /// No description provided for @staffParentTimelineButton2.
  ///
  /// In en, this message translates to:
  /// **'PARENT 2 TIMELINE'**
  String get staffParentTimelineButton2;

  /// No description provided for @staffParentTimelineTitle1.
  ///
  /// In en, this message translates to:
  /// **'Parent 1 timeline'**
  String get staffParentTimelineTitle1;

  /// No description provided for @staffParentTimelineTitle2.
  ///
  /// In en, this message translates to:
  /// **'Parent 2 timeline'**
  String get staffParentTimelineTitle2;

  /// No description provided for @staffCurrentStage.
  ///
  /// In en, this message translates to:
  /// **'CURRENT STAGE'**
  String get staffCurrentStage;

  /// No description provided for @staffProgressPercentComplete.
  ///
  /// In en, this message translates to:
  /// **'{percent}% Complete'**
  String staffProgressPercentComplete(int percent);

  /// No description provided for @staffChildDetailEmpty.
  ///
  /// In en, this message translates to:
  /// **'No child details in DB'**
  String get staffChildDetailEmpty;

  /// No description provided for @staffLoadFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed to load'**
  String get staffLoadFailed;

  /// No description provided for @staffGuardianLiaison.
  ///
  /// In en, this message translates to:
  /// **'GUARDIAN LIAISON'**
  String get staffGuardianLiaison;

  /// No description provided for @staffAssignedBrand.
  ///
  /// In en, this message translates to:
  /// **'ASSIGNED BRAND'**
  String get staffAssignedBrand;

  /// No description provided for @staffAssignedPackage.
  ///
  /// In en, this message translates to:
  /// **'PACKAGE'**
  String get staffAssignedPackage;

  /// No description provided for @staffSupervisor.
  ///
  /// In en, this message translates to:
  /// **'SUPERVISOR'**
  String get staffSupervisor;

  /// No description provided for @staffSectionCoreDetails.
  ///
  /// In en, this message translates to:
  /// **'Core Details'**
  String get staffSectionCoreDetails;

  /// No description provided for @staffSectionParentContact.
  ///
  /// In en, this message translates to:
  /// **'Parent Contact'**
  String get staffSectionParentContact;

  /// No description provided for @staffPhaseWithName.
  ///
  /// In en, this message translates to:
  /// **'Phase: {stageName}'**
  String staffPhaseWithName(String stageName);

  /// No description provided for @staffNoCurrentStage.
  ///
  /// In en, this message translates to:
  /// **'No current stage'**
  String get staffNoCurrentStage;

  /// No description provided for @staffAgeYearsOld.
  ///
  /// In en, this message translates to:
  /// **'{age} years old'**
  String staffAgeYearsOld(int age);

  /// No description provided for @staffNotesLabel.
  ///
  /// In en, this message translates to:
  /// **'Notes'**
  String get staffNotesLabel;

  /// No description provided for @staffParentRoleDefault.
  ///
  /// In en, this message translates to:
  /// **'Parent'**
  String get staffParentRoleDefault;

  /// No description provided for @contactManagerIntro.
  ///
  /// In en, this message translates to:
  /// **'You can leave a message about any question. We will get back to you as soon as possible.'**
  String get contactManagerIntro;

  /// No description provided for @contactManagerMessageLabel.
  ///
  /// In en, this message translates to:
  /// **'Your message'**
  String get contactManagerMessageLabel;

  /// No description provided for @contactManagerMessageRequired.
  ///
  /// In en, this message translates to:
  /// **'Please enter your message'**
  String get contactManagerMessageRequired;

  /// No description provided for @contactManagerSend.
  ///
  /// In en, this message translates to:
  /// **'Send'**
  String get contactManagerSend;

  /// No description provided for @contactManagerSent.
  ///
  /// In en, this message translates to:
  /// **'Your message has been sent. We will contact you soon.'**
  String get contactManagerSent;

  /// No description provided for @contactManagerSendFailed.
  ///
  /// In en, this message translates to:
  /// **'Could not send. Try again later.'**
  String get contactManagerSendFailed;

  /// No description provided for @contactManagerServiceUnavailable.
  ///
  /// In en, this message translates to:
  /// **'Contact is temporarily unavailable. Please try again later.'**
  String get contactManagerServiceUnavailable;

  /// No description provided for @close.
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get close;

  /// No description provided for @staffPortalTitle.
  ///
  /// In en, this message translates to:
  /// **'Staff Portal'**
  String get staffPortalTitle;

  /// No description provided for @staffActiveEvent.
  ///
  /// In en, this message translates to:
  /// **'Active event'**
  String get staffActiveEvent;

  /// No description provided for @staffActiveStage.
  ///
  /// In en, this message translates to:
  /// **'Active stage'**
  String get staffActiveStage;

  /// No description provided for @staffSelectEvent.
  ///
  /// In en, this message translates to:
  /// **'Select event'**
  String get staffSelectEvent;

  /// No description provided for @staffSelectEventInSettings.
  ///
  /// In en, this message translates to:
  /// **'Select an event in Staff Settings'**
  String get staffSelectEventInSettings;

  /// No description provided for @staffSelectStage.
  ///
  /// In en, this message translates to:
  /// **'Select stage'**
  String get staffSelectStage;

  /// No description provided for @staffPreparatoryStageLabel.
  ///
  /// In en, this message translates to:
  /// **'Prep: {stageName}'**
  String staffPreparatoryStageLabel(String stageName);

  /// No description provided for @staffScanButton.
  ///
  /// In en, this message translates to:
  /// **'SCAN'**
  String get staffScanButton;

  /// No description provided for @staffQrCheckButton.
  ///
  /// In en, this message translates to:
  /// **'QR CHECK'**
  String get staffQrCheckButton;

  /// No description provided for @staffParkingButton.
  ///
  /// In en, this message translates to:
  /// **'VALET PARKING'**
  String get staffParkingButton;

  /// No description provided for @staffExtraZoneButton.
  ///
  /// In en, this message translates to:
  /// **'BEVERAGE PACKAGE'**
  String get staffExtraZoneButton;

  /// No description provided for @staffBackstageButton.
  ///
  /// In en, this message translates to:
  /// **'BACKSTAGE PASS'**
  String get staffBackstageButton;

  /// No description provided for @staffRehearsalCheckinButton.
  ///
  /// In en, this message translates to:
  /// **'REHEARSAL CHECK-IN'**
  String get staffRehearsalCheckinButton;

  /// No description provided for @staffTapToScanModelLanyard.
  ///
  /// In en, this message translates to:
  /// **'TAP TO SCAN MODEL LANYARD'**
  String get staffTapToScanModelLanyard;

  /// No description provided for @staffTapToScanParkingQr.
  ///
  /// In en, this message translates to:
  /// **'TAP TO SCAN VALET PARKING QR'**
  String get staffTapToScanParkingQr;

  /// No description provided for @staffTapToScanExtraZoneQr.
  ///
  /// In en, this message translates to:
  /// **'TAP TO SCAN BEVERAGE PACKAGE QR'**
  String get staffTapToScanExtraZoneQr;

  /// No description provided for @staffTapToScanBackstageQr.
  ///
  /// In en, this message translates to:
  /// **'TAP TO SCAN BACKSTAGE PASS QR'**
  String get staffTapToScanBackstageQr;

  /// No description provided for @staffTapToScanRehearsalCheckinQr.
  ///
  /// In en, this message translates to:
  /// **'TAP TO SCAN REHEARSAL CHECK-IN QR'**
  String get staffTapToScanRehearsalCheckinQr;

  /// No description provided for @staffMealHandoutButton.
  ///
  /// In en, this message translates to:
  /// **'LUNCH'**
  String get staffMealHandoutButton;

  /// No description provided for @staffTapToScanMealBadge.
  ///
  /// In en, this message translates to:
  /// **'TAP TO SCAN A CHILD OR PARENT BADGE'**
  String get staffTapToScanMealBadge;

  /// No description provided for @staffMealIssueTitle.
  ///
  /// In en, this message translates to:
  /// **'Lunch handout'**
  String get staffMealIssueTitle;

  /// No description provided for @staffMealIssueNoMeals.
  ///
  /// In en, this message translates to:
  /// **'No lunch orders for this pass.'**
  String get staffMealIssueNoMeals;

  /// No description provided for @staffMealIssueHandOut.
  ///
  /// In en, this message translates to:
  /// **'Hand out'**
  String get staffMealIssueHandOut;

  /// No description provided for @staffMealIssueSuccess.
  ///
  /// In en, this message translates to:
  /// **'Marked as handed out.'**
  String get staffMealIssueSuccess;

  /// No description provided for @staffMealIssueFailure.
  ///
  /// In en, this message translates to:
  /// **'Could not update: {error}'**
  String staffMealIssueFailure(String error);

  /// No description provided for @staffMealIssueAlreadyIssued.
  ///
  /// In en, this message translates to:
  /// **'already handed out'**
  String get staffMealIssueAlreadyIssued;

  /// No description provided for @staffTapToScanQrCheck.
  ///
  /// In en, this message translates to:
  /// **'TAP TO SCAN BADGE — STAGE & CHILD CARD'**
  String get staffTapToScanQrCheck;

  /// No description provided for @staffCurrentTask.
  ///
  /// In en, this message translates to:
  /// **'Current Task'**
  String get staffCurrentTask;

  /// No description provided for @staffUtilitiesAndTools.
  ///
  /// In en, this message translates to:
  /// **'UTILITIES & TOOLS'**
  String get staffUtilitiesAndTools;

  /// No description provided for @staffScanForInfoTitle.
  ///
  /// In en, this message translates to:
  /// **'Scan for Info'**
  String get staffScanForInfoTitle;

  /// No description provided for @staffScanForInfoSubtitle.
  ///
  /// In en, this message translates to:
  /// **'General purpose assets & ID scanner'**
  String get staffScanForInfoSubtitle;

  /// No description provided for @staffToiletRequest.
  ///
  /// In en, this message translates to:
  /// **'Toilet Request'**
  String get staffToiletRequest;

  /// No description provided for @staffRestroomLog.
  ///
  /// In en, this message translates to:
  /// **'RESTROOM LOG'**
  String get staffRestroomLog;

  /// No description provided for @staffSettingsCardTitle.
  ///
  /// In en, this message translates to:
  /// **'Staff Settings'**
  String get staffSettingsCardTitle;

  /// No description provided for @staffPreferences.
  ///
  /// In en, this message translates to:
  /// **'PREFERENCES'**
  String get staffPreferences;

  /// No description provided for @staffSupervisorRoleTitle.
  ///
  /// In en, this message translates to:
  /// **'Supervisor Role'**
  String get staffSupervisorRoleTitle;

  /// No description provided for @staffSupervisorRoleDescription.
  ///
  /// In en, this message translates to:
  /// **'Manage event flow, oversee photographers, and ensure all children are captured effectively. Track progress in real-time.'**
  String get staffSupervisorRoleDescription;

  /// No description provided for @staffCurrentStageLabel.
  ///
  /// In en, this message translates to:
  /// **'Current stage'**
  String get staffCurrentStageLabel;

  /// No description provided for @staffNoMainStagesAvailable.
  ///
  /// In en, this message translates to:
  /// **'No main stages available for this event.'**
  String get staffNoMainStagesAvailable;

  /// No description provided for @staffChildRegistry.
  ///
  /// In en, this message translates to:
  /// **'Child Registry'**
  String get staffChildRegistry;

  /// No description provided for @staffChildrenListed.
  ///
  /// In en, this message translates to:
  /// **'{count} Children Listed'**
  String staffChildrenListed(int count);

  /// No description provided for @staffSelectActiveEventForRegistry.
  ///
  /// In en, this message translates to:
  /// **'Select an active event in Settings to see the child registry.'**
  String get staffSelectActiveEventForRegistry;

  /// No description provided for @staffNoChildrenAssigned.
  ///
  /// In en, this message translates to:
  /// **'No children assigned for this event.'**
  String get staffNoChildrenAssigned;

  /// No description provided for @staffRehearsalAdminSlotsTitle.
  ///
  /// In en, this message translates to:
  /// **'Rehearsal Slots'**
  String get staffRehearsalAdminSlotsTitle;

  /// No description provided for @staffRehearsalCheckinActiveSlot.
  ///
  /// In en, this message translates to:
  /// **'Active rehearsal slot'**
  String get staffRehearsalCheckinActiveSlot;

  /// No description provided for @staffRehearsalAdminSelectSlot.
  ///
  /// In en, this message translates to:
  /// **'Select rehearsal slot'**
  String get staffRehearsalAdminSelectSlot;

  /// No description provided for @staffRehearsalCheckinSelectSlotFirst.
  ///
  /// In en, this message translates to:
  /// **'Select rehearsal slot first'**
  String get staffRehearsalCheckinSelectSlotFirst;

  /// No description provided for @staffRehearsalAdminBookedChildrenTitle.
  ///
  /// In en, this message translates to:
  /// **'Booked Children'**
  String get staffRehearsalAdminBookedChildrenTitle;

  /// No description provided for @staffRehearsalAdminNoSlots.
  ///
  /// In en, this message translates to:
  /// **'No rehearsal slots created for this event.'**
  String get staffRehearsalAdminNoSlots;

  /// No description provided for @staffRehearsalAdminNoChildrenForSlot.
  ///
  /// In en, this message translates to:
  /// **'No children booked for this slot.'**
  String get staffRehearsalAdminNoChildrenForSlot;

  /// No description provided for @staffGiftControlButton.
  ///
  /// In en, this message translates to:
  /// **'CONTROL'**
  String get staffGiftControlButton;

  /// No description provided for @staffGiftControlTitle.
  ///
  /// In en, this message translates to:
  /// **'Gift Issue Control'**
  String get staffGiftControlTitle;

  /// No description provided for @staffGiftControlSelectStage.
  ///
  /// In en, this message translates to:
  /// **'Select report stage'**
  String get staffGiftControlSelectStage;

  /// No description provided for @staffGiftControlFilterAll.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get staffGiftControlFilterAll;

  /// No description provided for @staffGiftControlFilterPassed.
  ///
  /// In en, this message translates to:
  /// **'Passed'**
  String get staffGiftControlFilterPassed;

  /// No description provided for @staffGiftControlFilterNotPassed.
  ///
  /// In en, this message translates to:
  /// **'Not passed'**
  String get staffGiftControlFilterNotPassed;

  /// No description provided for @staffGiftControlNoChildren.
  ///
  /// In en, this message translates to:
  /// **'No children for selected filters.'**
  String get staffGiftControlNoChildren;

  /// No description provided for @staffTableProfile.
  ///
  /// In en, this message translates to:
  /// **'PROFILE'**
  String get staffTableProfile;

  /// No description provided for @staffTableName.
  ///
  /// In en, this message translates to:
  /// **'NAME'**
  String get staffTableName;

  /// No description provided for @staffTableStatus.
  ///
  /// In en, this message translates to:
  /// **'STATUS'**
  String get staffTableStatus;

  /// No description provided for @staffTableAction.
  ///
  /// In en, this message translates to:
  /// **'ACTION'**
  String get staffTableAction;

  /// No description provided for @staffYes.
  ///
  /// In en, this message translates to:
  /// **'Yes'**
  String get staffYes;

  /// No description provided for @staffNo.
  ///
  /// In en, this message translates to:
  /// **'No'**
  String get staffNo;

  /// No description provided for @staffRoleHostessTitle.
  ///
  /// In en, this message translates to:
  /// **'Role: hostess'**
  String get staffRoleHostessTitle;

  /// No description provided for @staffRoleHostessPlaceholder.
  ///
  /// In en, this message translates to:
  /// **'The hostess role screen will be added later.'**
  String get staffRoleHostessPlaceholder;

  /// No description provided for @staffRoleInterviewTitle.
  ///
  /// In en, this message translates to:
  /// **'Role: interview'**
  String get staffRoleInterviewTitle;

  /// No description provided for @staffRoleInterviewPlaceholder.
  ///
  /// In en, this message translates to:
  /// **'The interview role screen will be added later.'**
  String get staffRoleInterviewPlaceholder;

  /// No description provided for @staffRoleLunchesTitle.
  ///
  /// In en, this message translates to:
  /// **'Role: lunches'**
  String get staffRoleLunchesTitle;

  /// No description provided for @staffRoleLunchesPlaceholder.
  ///
  /// In en, this message translates to:
  /// **'The lunches role screen will be added later.'**
  String get staffRoleLunchesPlaceholder;

  /// No description provided for @staffRoleSuperadminTitle.
  ///
  /// In en, this message translates to:
  /// **'Role: superadmin'**
  String get staffRoleSuperadminTitle;

  /// No description provided for @staffRoleSuperadminPlaceholder.
  ///
  /// In en, this message translates to:
  /// **'The superadmin role screen will be added later.'**
  String get staffRoleSuperadminPlaceholder;

  /// No description provided for @staffRoleRehearsalAdminTitle.
  ///
  /// In en, this message translates to:
  /// **'Role: rehearsal admin'**
  String get staffRoleRehearsalAdminTitle;

  /// No description provided for @staffRoleRehearsalAdminPlaceholder.
  ///
  /// In en, this message translates to:
  /// **'The rehearsal admin role screen will be added later.'**
  String get staffRoleRehearsalAdminPlaceholder;

  /// No description provided for @staffNavHome.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get staffNavHome;

  /// No description provided for @staffNavEvent.
  ///
  /// In en, this message translates to:
  /// **'Event'**
  String get staffNavEvent;

  /// No description provided for @staffNavMore.
  ///
  /// In en, this message translates to:
  /// **'More'**
  String get staffNavMore;

  /// No description provided for @staffAccessBadge.
  ///
  /// In en, this message translates to:
  /// **'STAFF ACCESS'**
  String get staffAccessBadge;

  /// No description provided for @staffVenueAndContact.
  ///
  /// In en, this message translates to:
  /// **'Venue & Contact'**
  String get staffVenueAndContact;

  /// No description provided for @staffMainOffice.
  ///
  /// In en, this message translates to:
  /// **'Main Office'**
  String get staffMainOffice;

  /// No description provided for @staffSecurity.
  ///
  /// In en, this message translates to:
  /// **'Security'**
  String get staffSecurity;

  /// No description provided for @staffScanHeaderParking.
  ///
  /// In en, this message translates to:
  /// **'Valet Parking Scan'**
  String get staffScanHeaderParking;

  /// No description provided for @staffScanHeaderExtraZone.
  ///
  /// In en, this message translates to:
  /// **'Beverage package entry'**
  String get staffScanHeaderExtraZone;

  /// No description provided for @staffScanHeaderBackstage.
  ///
  /// In en, this message translates to:
  /// **'Backstage pass entry'**
  String get staffScanHeaderBackstage;

  /// No description provided for @staffScanHeaderRehearsalCheckin.
  ///
  /// In en, this message translates to:
  /// **'Rehearsal Check-in'**
  String get staffScanHeaderRehearsalCheckin;

  /// No description provided for @staffScanHeaderInfo.
  ///
  /// In en, this message translates to:
  /// **'Scan for Info'**
  String get staffScanHeaderInfo;

  /// No description provided for @staffScanHeaderQr.
  ///
  /// In en, this message translates to:
  /// **'Scan QR Code'**
  String get staffScanHeaderQr;

  /// No description provided for @staffScanHintParking.
  ///
  /// In en, this message translates to:
  /// **'Scan valet parking QR code to show ticket details'**
  String get staffScanHintParking;

  /// No description provided for @staffScanHintExtraZone.
  ///
  /// In en, this message translates to:
  /// **'Scan beverage package QR code to allow entry'**
  String get staffScanHintExtraZone;

  /// No description provided for @staffScanHintBackstage.
  ///
  /// In en, this message translates to:
  /// **'Scan backstage pass QR code to allow entry'**
  String get staffScanHintBackstage;

  /// No description provided for @staffScanHintRehearsalCheckin.
  ///
  /// In en, this message translates to:
  /// **'Scan child check-in QR to close rehearsal check-in'**
  String get staffScanHintRehearsalCheckin;

  /// No description provided for @staffScanHintInfo.
  ///
  /// In en, this message translates to:
  /// **'Scan child or parent badge to view profile'**
  String get staffScanHintInfo;

  /// No description provided for @staffScanHintQr.
  ///
  /// In en, this message translates to:
  /// **'Align QR code within the frame'**
  String get staffScanHintQr;

  /// No description provided for @staffScanHeaderQrCheck.
  ///
  /// In en, this message translates to:
  /// **'QR check'**
  String get staffScanHeaderQrCheck;

  /// No description provided for @staffScanHintQrCheck.
  ///
  /// In en, this message translates to:
  /// **'Scan the child badge to mark the selected stage complete, then open the child card'**
  String get staffScanHintQrCheck;

  /// No description provided for @staffQrCheckSuccessTitle.
  ///
  /// In en, this message translates to:
  /// **'Stage marked complete'**
  String get staffQrCheckSuccessTitle;

  /// No description provided for @staffQrCheckSuccessContinue.
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get staffQrCheckSuccessContinue;

  /// No description provided for @staffScanErrorTitle.
  ///
  /// In en, this message translates to:
  /// **'Scan Error'**
  String get staffScanErrorTitle;

  /// No description provided for @staffScanErrorUnknown.
  ///
  /// In en, this message translates to:
  /// **'Unknown scan error.'**
  String get staffScanErrorUnknown;

  /// No description provided for @staffParkingTicketTitle.
  ///
  /// In en, this message translates to:
  /// **'Valet Parking Ticket'**
  String get staffParkingTicketTitle;

  /// No description provided for @staffExtraZonePassTitle.
  ///
  /// In en, this message translates to:
  /// **'Beverage package pass'**
  String get staffExtraZonePassTitle;

  /// No description provided for @staffExtraZoneScanResultTitle.
  ///
  /// In en, this message translates to:
  /// **'Scan Result'**
  String get staffExtraZoneScanResultTitle;

  /// No description provided for @staffExtraZoneResultNotFound.
  ///
  /// In en, this message translates to:
  /// **'CODE NOT FOUND IN DATABASE'**
  String get staffExtraZoneResultNotFound;

  /// No description provided for @staffExtraZoneResultAccessGranted.
  ///
  /// In en, this message translates to:
  /// **'CODE ACCEPTED, ACCESS GRANTED'**
  String get staffExtraZoneResultAccessGranted;

  /// No description provided for @staffExtraZoneResultAccessClosed.
  ///
  /// In en, this message translates to:
  /// **'CODE ACCEPTED, BUT ACCESS CLOSED'**
  String get staffExtraZoneResultAccessClosed;

  /// No description provided for @staffBackstageScanResultTitle.
  ///
  /// In en, this message translates to:
  /// **'Scan Result'**
  String get staffBackstageScanResultTitle;

  /// No description provided for @staffBackstageResultNotFound.
  ///
  /// In en, this message translates to:
  /// **'CODE NOT FOUND IN DATABASE'**
  String get staffBackstageResultNotFound;

  /// No description provided for @staffBackstageResultAccessGranted.
  ///
  /// In en, this message translates to:
  /// **'CODE ACCEPTED, ACCESS GRANTED'**
  String get staffBackstageResultAccessGranted;

  /// No description provided for @staffBackstageResultAccessClosed.
  ///
  /// In en, this message translates to:
  /// **'CODE ACCEPTED, BUT ACCESS CLOSED'**
  String get staffBackstageResultAccessClosed;

  /// No description provided for @staffRehearsalCheckinScanResultTitle.
  ///
  /// In en, this message translates to:
  /// **'Scan Result'**
  String get staffRehearsalCheckinScanResultTitle;

  /// No description provided for @staffRehearsalCheckinResultNotFound.
  ///
  /// In en, this message translates to:
  /// **'CHECK-IN CODE NOT FOUND'**
  String get staffRehearsalCheckinResultNotFound;

  /// No description provided for @staffRehearsalCheckinResultWrongSlot.
  ///
  /// In en, this message translates to:
  /// **'CHILD IS NOT IN THE SELECTED SLOT'**
  String get staffRehearsalCheckinResultWrongSlot;

  /// No description provided for @staffRehearsalCheckinResultAlreadyClosed.
  ///
  /// In en, this message translates to:
  /// **'REHEARSAL CHECK-IN ALREADY CLOSED'**
  String get staffRehearsalCheckinResultAlreadyClosed;

  /// No description provided for @staffRehearsalCheckinResultClosedNow.
  ///
  /// In en, this message translates to:
  /// **'REHEARSAL CHECK-IN CLOSED'**
  String get staffRehearsalCheckinResultClosedNow;

  /// No description provided for @staffRehearsalCheckinFieldChild.
  ///
  /// In en, this message translates to:
  /// **'Child'**
  String get staffRehearsalCheckinFieldChild;

  /// No description provided for @staffRehearsalCheckinFieldSlot.
  ///
  /// In en, this message translates to:
  /// **'Slot'**
  String get staffRehearsalCheckinFieldSlot;

  /// No description provided for @staffParkingFieldEvent.
  ///
  /// In en, this message translates to:
  /// **'Event'**
  String get staffParkingFieldEvent;

  /// No description provided for @staffParkingFieldClient.
  ///
  /// In en, this message translates to:
  /// **'Client'**
  String get staffParkingFieldClient;

  /// No description provided for @staffParkingFieldCar.
  ///
  /// In en, this message translates to:
  /// **'Car'**
  String get staffParkingFieldCar;

  /// No description provided for @staffParkingFieldPlateNumber.
  ///
  /// In en, this message translates to:
  /// **'Plate number'**
  String get staffParkingFieldPlateNumber;

  /// No description provided for @staffParkingFieldVipClient.
  ///
  /// In en, this message translates to:
  /// **'VIP client'**
  String get staffParkingFieldVipClient;

  /// No description provided for @staffShowProgressTitle.
  ///
  /// In en, this message translates to:
  /// **'Show Progress'**
  String get staffShowProgressTitle;

  /// No description provided for @staffCouldNotOpenDialer.
  ///
  /// In en, this message translates to:
  /// **'Could not open the phone dialer'**
  String get staffCouldNotOpenDialer;

  /// No description provided for @staffRealtimeTracking.
  ///
  /// In en, this message translates to:
  /// **'REAL-TIME TRACKING'**
  String get staffRealtimeTracking;

  /// No description provided for @staffEstimatedCompletion.
  ///
  /// In en, this message translates to:
  /// **'EST. COMPLETION'**
  String get staffEstimatedCompletion;

  /// No description provided for @staffNoMainStagesInPlan.
  ///
  /// In en, this message translates to:
  /// **'No main stages in plan yet.'**
  String get staffNoMainStagesInPlan;

  /// No description provided for @staffStatusDone.
  ///
  /// In en, this message translates to:
  /// **'DONE'**
  String get staffStatusDone;

  /// No description provided for @staffStatusInProgress.
  ///
  /// In en, this message translates to:
  /// **'IN PROGRESS'**
  String get staffStatusInProgress;

  /// No description provided for @staffStatusPending.
  ///
  /// In en, this message translates to:
  /// **'PENDING'**
  String get staffStatusPending;

  /// No description provided for @staffContactDetails.
  ///
  /// In en, this message translates to:
  /// **'Contact Details'**
  String get staffContactDetails;

  /// No description provided for @staffPrimaryParent.
  ///
  /// In en, this message translates to:
  /// **'PRIMARY PARENT'**
  String get staffPrimaryParent;

  /// No description provided for @staffIdLabel.
  ///
  /// In en, this message translates to:
  /// **'Staff ID: {id}'**
  String staffIdLabel(String id);

  /// No description provided for @staffSwitchRole.
  ///
  /// In en, this message translates to:
  /// **'Switch Role'**
  String get staffSwitchRole;

  /// No description provided for @staffCurrentRoleLabel.
  ///
  /// In en, this message translates to:
  /// **'CURRENT: {role}'**
  String staffCurrentRoleLabel(String role);

  /// No description provided for @staffRoleSubtitleScan.
  ///
  /// In en, this message translates to:
  /// **'QR scan & stage flow'**
  String get staffRoleSubtitleScan;

  /// No description provided for @staffRoleSubtitleQrCheck.
  ///
  /// In en, this message translates to:
  /// **'Mark stage by badge, then child details'**
  String get staffRoleSubtitleQrCheck;

  /// No description provided for @staffRoleSubtitleSupervisor.
  ///
  /// In en, this message translates to:
  /// **'Full access & management'**
  String get staffRoleSubtitleSupervisor;

  /// No description provided for @staffRoleSubtitleHostess.
  ///
  /// In en, this message translates to:
  /// **'Guest & zone support'**
  String get staffRoleSubtitleHostess;

  /// No description provided for @staffRoleSubtitleParking.
  ///
  /// In en, this message translates to:
  /// **'Valet parking flow & access'**
  String get staffRoleSubtitleParking;

  /// No description provided for @staffRoleSubtitleExtraZone.
  ///
  /// In en, this message translates to:
  /// **'Beverage package access'**
  String get staffRoleSubtitleExtraZone;

  /// No description provided for @staffRoleSubtitleBackstage.
  ///
  /// In en, this message translates to:
  /// **'Backstage pass access'**
  String get staffRoleSubtitleBackstage;

  /// No description provided for @staffRoleSubtitleRehearsalAdmin.
  ///
  /// In en, this message translates to:
  /// **'Rehearsal administration'**
  String get staffRoleSubtitleRehearsalAdmin;

  /// No description provided for @staffRoleSubtitleRehearsalCheckin.
  ///
  /// In en, this message translates to:
  /// **'Rehearsal slot check-in scan'**
  String get staffRoleSubtitleRehearsalCheckin;

  /// No description provided for @staffRoleSubtitleGiftIssue.
  ///
  /// In en, this message translates to:
  /// **'Gift issue control'**
  String get staffRoleSubtitleGiftIssue;

  /// No description provided for @staffRoleSubtitleInterview.
  ///
  /// In en, this message translates to:
  /// **'Interview flow'**
  String get staffRoleSubtitleInterview;

  /// No description provided for @staffRoleSubtitleLunches.
  ///
  /// In en, this message translates to:
  /// **'Meals & lunches'**
  String get staffRoleSubtitleLunches;

  /// No description provided for @staffRoleSubtitleSuperadmin.
  ///
  /// In en, this message translates to:
  /// **'Super admin tools'**
  String get staffRoleSubtitleSuperadmin;

  /// No description provided for @staffRoleSubtitlePhotographer.
  ///
  /// In en, this message translates to:
  /// **'Media capture & uploads'**
  String get staffRoleSubtitlePhotographer;

  /// No description provided for @staffRoleSubtitleStylist.
  ///
  /// In en, this message translates to:
  /// **'Wardrobe & makeup logs'**
  String get staffRoleSubtitleStylist;

  /// No description provided for @staffHostessEntryMode.
  ///
  /// In en, this message translates to:
  /// **'ENTRY'**
  String get staffHostessEntryMode;

  /// No description provided for @staffHostessExitMode.
  ///
  /// In en, this message translates to:
  /// **'EXIT'**
  String get staffHostessExitMode;

  /// No description provided for @staffHostessEntryHint.
  ///
  /// In en, this message translates to:
  /// **'Scan child badge to close selected stage and sync Family Look parents'**
  String get staffHostessEntryHint;

  /// No description provided for @staffHostessExitHint.
  ///
  /// In en, this message translates to:
  /// **'Scan child or parent badge, review progress and close event stage'**
  String get staffHostessExitHint;

  /// No description provided for @staffHostessEntryResultTitle.
  ///
  /// In en, this message translates to:
  /// **'Entry scan result'**
  String get staffHostessEntryResultTitle;

  /// No description provided for @staffHostessExitResultTitle.
  ///
  /// In en, this message translates to:
  /// **'Exit scan result'**
  String get staffHostessExitResultTitle;

  /// No description provided for @staffHostessFieldChildName.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get staffHostessFieldChildName;

  /// No description provided for @staffHostessFieldParent.
  ///
  /// In en, this message translates to:
  /// **'Parent'**
  String get staffHostessFieldParent;

  /// No description provided for @staffHostessFieldBrandsAndSupervisors.
  ///
  /// In en, this message translates to:
  /// **'Brands and supervisors'**
  String get staffHostessFieldBrandsAndSupervisors;

  /// No description provided for @staffHostessFieldFamilyLook.
  ///
  /// In en, this message translates to:
  /// **'Family Look'**
  String get staffHostessFieldFamilyLook;

  /// No description provided for @staffHostessFamilyLookEnabled.
  ///
  /// In en, this message translates to:
  /// **'Family Look is enabled'**
  String get staffHostessFamilyLookEnabled;

  /// No description provided for @staffHostessFieldStages.
  ///
  /// In en, this message translates to:
  /// **'Stages'**
  String get staffHostessFieldStages;

  /// No description provided for @staffHostessCloseEventAction.
  ///
  /// In en, this message translates to:
  /// **'Close Event'**
  String get staffHostessCloseEventAction;

  /// No description provided for @staffHostessStageAlreadySelectedOtherMode.
  ///
  /// In en, this message translates to:
  /// **'This stage is already selected for the other hostess mode.'**
  String get staffHostessStageAlreadySelectedOtherMode;

  /// No description provided for @staffHostessRequiredProgress.
  ///
  /// In en, this message translates to:
  /// **'Required stages completed: {completed}/{total}'**
  String staffHostessRequiredProgress(int completed, int total);
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
      <String>['en', 'es', 'ru', 'uk'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when language+country codes are specified.
  switch (locale.languageCode) {
    case 'es':
      {
        switch (locale.countryCode) {
          case 'US':
            return AppLocalizationsEsUs();
        }
        break;
      }
  }

  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'es':
      return AppLocalizationsEs();
    case 'ru':
      return AppLocalizationsRu();
    case 'uk':
      return AppLocalizationsUk();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
