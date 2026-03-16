// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get signIn => 'Sign in';

  @override
  String get signUp => 'Sign up';

  @override
  String get email => 'Email';

  @override
  String get password => 'Password';

  @override
  String get emailRequired => 'Email is required';

  @override
  String get enterValidEmail => 'Enter a valid email';

  @override
  String get passwordRequired => 'Password is required';

  @override
  String get hidePassword => 'Hide password';

  @override
  String get showPassword => 'Show password';

  @override
  String signInFailed(String error) {
    return 'Sign in failed: $error';
  }

  @override
  String get createAccount => 'Create account';

  @override
  String get name => 'Name';

  @override
  String get nameRequired => 'Name is required';

  @override
  String get phone => 'Phone';

  @override
  String get phoneRequired => 'Phone is required';

  @override
  String get phoneMustStartWithPlus => 'Phone must start with +';

  @override
  String get enterValidPhone => 'Enter a valid phone number';

  @override
  String get confirmPassword => 'Confirm password';

  @override
  String get passwordsDoNotMatch => 'Passwords do not match';

  @override
  String get passwordMinLength => 'Password must be at least 8 characters';

  @override
  String get atLeast8Chars => 'At least 8 characters';

  @override
  String get backToSignIn => 'Back to sign in';

  @override
  String registrationFailed(String error) {
    return 'Registration failed: $error';
  }

  @override
  String get account => 'Account';

  @override
  String get editInfo => 'EDIT INFO';

  @override
  String get fullName => 'Full Name';

  @override
  String get retry => 'Retry';

  @override
  String get accountSettings => 'Account settings';

  @override
  String get editProfile => 'Edit profile';

  @override
  String get save => 'Save';

  @override
  String get edit => 'Edit';

  @override
  String get role => 'Role';

  @override
  String get myChildren => 'My Children';

  @override
  String get addChild => 'Add Child';

  @override
  String get noChildrenAddedYet => 'No children added yet';

  @override
  String get ageLabel => 'Age';

  @override
  String get settings => 'Settings';

  @override
  String get appLanguage => 'App language';

  @override
  String get unitsOfMeasurement => 'Units of measurement';

  @override
  String get metricUnits => 'Metric (cm, kg)';

  @override
  String get imperialUnits => 'American (in, lb)';

  @override
  String get systemLanguage => 'System';

  @override
  String get languageRussian => 'Russian';

  @override
  String get languageEnglish => 'English';

  @override
  String get languageUkrainian => 'Ukrainian';

  @override
  String get languageSpanishUS => 'Spanish (U.S.)';

  @override
  String get addChildTitle => 'Add child';

  @override
  String get firstName => 'First name';

  @override
  String get lastName => 'Last name';

  @override
  String get birthdate => 'Birthdate';

  @override
  String get chooseDate => 'Choose date';

  @override
  String get create => 'Create';

  @override
  String get enterFirstName => 'Enter first name';

  @override
  String get mainPhoto => 'Main photo';

  @override
  String get changePhoto => 'Change';

  @override
  String get deletePhoto => 'Delete';

  @override
  String get addPhoto => 'Add photo';

  @override
  String get photoSaved => 'Photo saved';

  @override
  String get photoDeleted => 'Photo deleted';

  @override
  String get photoAdded => 'Photo added';

  @override
  String get extraPhotos => 'Extra photos';

  @override
  String get cancel => 'Cancel';

  @override
  String get clear => 'Clear';

  @override
  String get height => 'Height';

  @override
  String get weight => 'Weight';

  @override
  String get shoulders => 'Shoulders';

  @override
  String get chest => 'Chest';

  @override
  String get waist => 'Waist';

  @override
  String get hips => 'Hips';

  @override
  String get currentParticipation => 'Current Participation';

  @override
  String get unknownError => 'Unknown error';

  @override
  String model(String name) {
    return 'Model: $name';
  }

  @override
  String get active => 'ACTIVE';

  @override
  String get journeyProgress => 'JOURNEY PROGRESS';

  @override
  String stepOf(int completed, int total) {
    return 'Step $completed of $total';
  }

  @override
  String next(String text) {
    return 'Next: $text';
  }

  @override
  String get viewProgress => 'VIEW PROGRESS';

  @override
  String get noActiveEvents => 'No active events';

  @override
  String get becomeModelTitle => 'Start your child\'s modeling journey today';

  @override
  String get becomeAModel => 'BECOME A MODEL';

  @override
  String get latestHighlights => 'Latest Highlights';

  @override
  String get viewAll => 'VIEW ALL';

  @override
  String get quickActions => 'Quick Actions';

  @override
  String get upcomingShows => 'Upcoming\nShows';

  @override
  String get manageKids => 'Manage\nKids';

  @override
  String get navHome => 'Home';

  @override
  String get navEvents => 'Events';

  @override
  String get navProfile => 'Profile';

  @override
  String get navInfo => 'Info';

  @override
  String get continueButton => 'Continue';

  @override
  String get loading => 'Loading...';

  @override
  String get signOut => 'Sign out';

  @override
  String get tokenValidNext => 'Token valid. Next: Home page.';

  @override
  String get homePageTitle => 'Home';

  @override
  String youAreSignedIn(String name) {
    return 'You are signed in$name.';
  }

  @override
  String yourRole(String role) {
    return 'Your role: $role';
  }

  @override
  String get phoneHint => '+1234567890';

  @override
  String get enterValidEmailShort => 'Enter a valid email';

  @override
  String get phoneMustStartWithPlusShort => 'Phone must start with +';

  @override
  String get comingSoon => 'Coming soon';

  @override
  String get hello => 'Hello';

  @override
  String helloName(String name) {
    return 'Hello, $name';
  }

  @override
  String get noRolesAssigned =>
      'You have not been assigned any roles yet. Please contact the administration.';

  @override
  String signedInAs(String name) {
    return 'Signed in as $name';
  }

  @override
  String get staff => 'Staff';

  @override
  String get birthdateDialogTitle => 'Birthdate';

  @override
  String get nextShowsTitle => 'Next Shows';

  @override
  String get nextShowsSeason => '2026 Season';

  @override
  String get details => 'Details';

  @override
  String get contact => 'Contact';

  @override
  String get registrationOpen => 'Registration Open';
}
