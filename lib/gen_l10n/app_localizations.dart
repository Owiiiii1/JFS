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

  /// No description provided for @currentParticipation.
  ///
  /// In en, this message translates to:
  /// **'Current Participation'**
  String get currentParticipation;

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
  /// **'Update booking'**
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
  /// **'Rehearsal'**
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
  /// **'What to bring?'**
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

  /// No description provided for @eventSettingsBrandTitle.
  ///
  /// In en, this message translates to:
  /// **'Brand Requirements'**
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

  /// No description provided for @pdfViewerTitle.
  ///
  /// In en, this message translates to:
  /// **'Ticket'**
  String get pdfViewerTitle;

  /// No description provided for @contactFormLinkMissing.
  ///
  /// In en, this message translates to:
  /// **'No form link is set. Add «Contact / signup form URL» in Application settings in the admin.'**
  String get contactFormLinkMissing;
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
