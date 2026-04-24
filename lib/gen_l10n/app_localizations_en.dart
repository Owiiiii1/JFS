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
  String get apiEndpointNotFoundHint =>
      'The server could not find the API (404). Set API_BASE_URL to your site root without a trailing /api — the app calls /api/app/login itself. If Laravel is in a subfolder, include the path to the public directory (e.g. https://example.com/myapp/public).';

  @override
  String get notificationsTitle => 'Notifications';

  @override
  String get notificationsLoadFailed =>
      'Could not load notifications. Try again.';

  @override
  String get notificationsEmpty => 'No notifications yet.';

  @override
  String get notificationsNewMark => 'New';

  @override
  String get notificationDetailsTitle => 'Notification';

  @override
  String get createAccount => 'Create account';

  @override
  String get name => 'Name';

  @override
  String get registerNameLabel => 'Enter first and last name';

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
  String get loginPasswordOptionalHint =>
      'If your profile was created by admin/import, leave password empty and continue.';

  @override
  String get setPasswordTitle => 'Set password';

  @override
  String setPasswordSubtitle(String email) {
    return 'Create a password for $email';
  }

  @override
  String get passwordSetupMinLength => 'Password must be at least 6 characters';

  @override
  String get savePasswordAndContinue => 'Save password and continue';

  @override
  String passwordSetupFailed(String error) {
    return 'Password setup failed: $error';
  }

  @override
  String get account => 'Account';

  @override
  String get editInfo => 'EDIT INFO';

  @override
  String get fullName => 'Name';

  @override
  String get retry => 'Retry';

  @override
  String get accountSettings => 'Account settings';

  @override
  String get editProfile => 'Edit profile';

  @override
  String get deleteAccount => 'Delete account';

  @override
  String get deleteAccountConfirmTitle => 'Delete account?';

  @override
  String get deleteAccountConfirmMessage =>
      'Are you sure you want to permanently delete your account? This cannot be undone.';

  @override
  String get deleteAccountSecondTitle => 'What will be deleted';

  @override
  String get deleteAccountSecondMessage =>
      'The following will be permanently removed from our systems:\n\n• Your account and profile\n• All children linked to your account\n• All event assignments, stage progress, tickets, and meal selections\n• Photos and other data stored for your children\n• Your membership in event chats and in-app notifications\n\nSome payment or accounting records may be kept where required by law.';

  @override
  String get deleteAccountContinue => 'Continue';

  @override
  String get deleteAccountConfirmAction => 'Delete permanently';

  @override
  String get deleteAccountWorking => 'Deleting account…';

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
  String get aboutTheApp => 'About the app';

  @override
  String get aboutAppDisplayName => 'YoungFashionShow';

  @override
  String get aboutPublisherLine => 'YOUNGFASHIONSHOW';

  @override
  String get aboutVersionLabel => 'VERSION';

  @override
  String get aboutReleaseDateLabel => 'RELEASE DATE';

  @override
  String get aboutDevelopedByPrefix => 'Developed by:';

  @override
  String get aboutDeveloperBrand => 'OWLSOLUTIONS';

  @override
  String get aboutLinkCouldNotOpen => 'Could not open the link.';

  @override
  String get appLanguage => 'App language';

  @override
  String get unitsOfMeasurement => 'Units of measurement';

  @override
  String get timeDisplayFormat => 'Time display format';

  @override
  String get timeFormat24Hour => '24-hour';

  @override
  String get timeFormat12Hour => '12-hour (AM/PM)';

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
  String get gender => 'Gender';

  @override
  String get genderBoy => 'Boy';

  @override
  String get genderGirl => 'Girl';

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
  String get measurementLengthUnitCm => 'cm';

  @override
  String get measurementLengthUnitIn => 'in';

  @override
  String get currentParticipation => 'Current Participation';

  @override
  String childSubscribedBrands(String brands) {
    return 'Brands: $brands';
  }

  @override
  String get unknownError => 'Unknown error';

  @override
  String model(String name) {
    return 'Model: $name';
  }

  @override
  String get active => 'ACTIVE';

  @override
  String get familyLabel => 'FAMILY';

  @override
  String get familyJoinButton => 'JOIN FAMILY';

  @override
  String get familyJoinDialogHint => 'Enter the 6-digit family code.';

  @override
  String get familyJoinAction => 'Join';

  @override
  String get familyJoinInvalidCode => 'Enter a valid 6-digit code.';

  @override
  String get familyJoinSuccess => 'Family subscription connected.';

  @override
  String get contractWarningTitle => 'Warning';

  @override
  String get contractWarningFallbackText =>
      'Before purchasing tickets, please review and sign the contract.';

  @override
  String get contractViewButton => 'View';

  @override
  String get contractPreviewTitle => 'Contract text';

  @override
  String get contractSignButton => 'Sign';

  @override
  String get contractSignatureTitle => 'Add signature';

  @override
  String get contractSignedSuccess => 'Contract signed successfully.';

  @override
  String get journeyProgress => 'JOURNEY PROGRESS';

  @override
  String get journeyPreparationPhase => 'PREPARATION PHASE';

  @override
  String get journeyMainEventTitle => 'THE MAIN EVENT';

  @override
  String get journeyMainEventSubtitle => 'RUNWAY EXCLUSIVE';

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
  String get eventSettings => 'EVENT SETTINGS';

  @override
  String get homeEventCardMyEvent => 'MY EVENT';

  @override
  String get homeEventCardRunwayJourney => 'RUNWAY JOURNEY';

  @override
  String get eventSettingsPlaceholder =>
      'Event settings will appear here soon.';

  @override
  String get eventSettingsConfigurationPortal => 'CONFIGURATION PORTAL';

  @override
  String get eventSettingsMainHeadline => 'Event Settings';

  @override
  String get eventSettingsFamilyButton => 'Family';

  @override
  String get familyManageTitle => 'Family';

  @override
  String get familyManageEnabled => 'Enable family connections';

  @override
  String get familyManageCodeLabel => 'Family code';

  @override
  String get familyManageRegenerateCode => 'Regenerate code';

  @override
  String get familyManageConnectionsTitle => 'Active family connections';

  @override
  String get familyManageNoConnections => 'No active family connections yet.';

  @override
  String get familyManageUnknownUser => 'Unknown user';

  @override
  String get eventSettingsLeaveFamilyButton => 'Disconnect from family';

  @override
  String get eventSettingsLeaveFamilyConfirmTitle =>
      'Disconnect family access?';

  @override
  String get eventSettingsLeaveFamilyConfirmText =>
      'You will lose family event access until you join again by code.';

  @override
  String get eventSettingsLeaveFamilySuccess =>
      'Family access has been disconnected.';

  @override
  String get eventSettingsMealTitle => 'Meal Selection';

  @override
  String get eventSettingsMealSubtitle => 'Choose a meal for the current event';

  @override
  String get eventSettingsMealCta => 'MANAGE MENU';

  @override
  String eventSettingsMealOrderedPcs(int count) {
    return 'Ordered: $count pc';
  }

  @override
  String get eventSettingsMealPurchasesListHeading => 'Placed orders';

  @override
  String eventSettingsMealPurchaseChildLine(String name) {
    return 'Child: $name';
  }

  @override
  String get mealPurchaseIssued => 'Issued';

  @override
  String get mealPurchaseNotIssued => 'Not handed out yet';

  @override
  String get eventSettingsRehearsalTitle => 'Rehearsal Booking';

  @override
  String get eventSettingsRehearsalSubtitle => 'Book your spot for rehearsal';

  @override
  String get eventSettingsRehearsalCta => 'BOOK NOW';

  @override
  String get eventSettingsBrandRehearsalsHeading => 'Your brand rehearsals';

  @override
  String get rehearsalModalTitle => 'Rehearsal booking';

  @override
  String get rehearsalSelectDate => 'Select date';

  @override
  String get rehearsalAvailableSlots => 'Available slots';

  @override
  String get rehearsalFreeLabel => 'Available:';

  @override
  String get rehearsalNoSlotsConfigured =>
      'No rehearsal slots for this event yet.';

  @override
  String get rehearsalLoadError => 'Could not load slots. Try again.';

  @override
  String get rehearsalBrandNotAssigned =>
      'Brand is not assigned for this child. Rehearsal booking is unavailable.';

  @override
  String get rehearsalFull => 'Full';

  @override
  String get rehearsalConfirmBooking => 'Confirm booking';

  @override
  String get rehearsalBookingFooterNote =>
      'Changes must be made 24 hours before the session when possible.';

  @override
  String get rehearsalBookedTitle => 'Your rehearsal is booked';

  @override
  String get rehearsalChangeBooking => 'Change booking';

  @override
  String get rehearsalProgramLabel => 'Details';

  @override
  String get rehearsalArriveEarly => 'Please arrive 15 minutes early.';

  @override
  String get rehearsalBookingSaved => 'Booking saved';

  @override
  String get rehearsalBookingError => 'Could not complete booking.';

  @override
  String get rehearsalSelectChild => 'Child';

  @override
  String get rehearsalUpdateBooking => 'Add and update booking';

  @override
  String get rehearsalCancelChange => 'Cancel';

  @override
  String get rehearsalChangeBookingLockedHint =>
      'The organizer has closed booking changes. Contact support if you need help.';

  @override
  String get rehearsalMilestoneTitle => 'General rehearsal';

  @override
  String rehearsalBrandMilestoneTitle(String brandName) {
    return 'Brand rehearsal: $brandName';
  }

  @override
  String get rehearsalBrandMilestoneShort => 'Brand rehearsal';

  @override
  String get rehearsalNextBookHint =>
      'Book your rehearsal slot in Event settings.';

  @override
  String get eventSettingsPackingTitle => 'Don\'t Forget List';

  @override
  String get eventSettingsPackingSubtitle => '';

  @override
  String get eventSettingsPackingCta => 'VIEW LIST';

  @override
  String get eventPackingLoadFailed =>
      'Could not load packing info. Try again.';

  @override
  String get eventPackingEmpty =>
      'Packing information has not been added for this event yet.';

  @override
  String get eventDescriptionTitle => 'Event info';

  @override
  String get eventProgressShowGallery => 'Show gallery';

  @override
  String get eventProgressCheckin => 'Check-in';

  @override
  String get eventProgressCheckinPrompt => 'Scan to start the event';

  @override
  String get eventProgressCheckinUnavailable =>
      'Check-in code is not available yet.';

  @override
  String get eventDescriptionLoadFailed =>
      'Could not load event description. Try again.';

  @override
  String get eventDescriptionEmpty =>
      'No description has been added for this event yet.';

  @override
  String get eventSettingsBrandTitle => 'Shoes & socks';

  @override
  String get eventSettingsBrandSubtitle =>
      'Read the brand\'s recommendations for taking part in the event';

  @override
  String get eventSettingsBrandCta => 'VIEW GUIDELINES';

  @override
  String get brandRequirementsLoadFailed =>
      'Could not load brand requirements. Try again.';

  @override
  String get brandRequirementsEmpty =>
      'No brand requirements have been added for this event yet.';

  @override
  String get brandRequirementsEmptyItem =>
      'No requirements text has been added for this brand yet.';

  @override
  String get brandRequirementsPickBrandTitle => 'Choose a brand';

  @override
  String brandRequirementsBrandNumber(int brandId) {
    return 'Brand $brandId';
  }

  @override
  String get eventSettingsParkingTitle => 'Valet Parking';

  @override
  String get eventSettingsParkingSubtitle =>
      'Open your valet parking pass and arrival status';

  @override
  String get eventSettingsParkingCta => 'OPEN VALET PARKING';

  @override
  String get parkingChooseModeTitle => 'Valet parking mode';

  @override
  String get parkingChooseModeHint => 'Choose screen state for visual testing.';

  @override
  String get parkingModeInactive => 'INACTIVE';

  @override
  String get parkingModeActive => 'ACTIVE';

  @override
  String get parkingInactiveHeadline => 'NO ACTIVE VALET PARKING';

  @override
  String get parkingInactiveBody =>
      'VALET PARKING WILL APPEAR HERE AFTER TICKET PURCHASE.';

  @override
  String get parkingInactiveBuyCta => 'BUY';

  @override
  String get parkingInactiveVipBody =>
      'FOR VIP VALET PARKING — RESERVE A SPOT FOR YOUR CAR.';

  @override
  String get parkingInactiveVipBookCta => 'BOOK VALET PARKING';

  @override
  String get parkingPayForParkingCta => 'PAY FOR VALET PARKING';

  @override
  String get parkingVipQuotaNextPaymentBody =>
      'YOUR COMPLIMENTARY VALET TICKETS FOR THIS EVENT ARE USED UP. YOU CAN STILL ADD A SPOT AT THE REGULAR PRICE.';

  @override
  String parkingFreeTicketsQuotaLine(int used, int quota, int remaining) {
    return 'Complimentary valet: $used of $quota used ($remaining left)';
  }

  @override
  String get parkingActiveTicketLabel => 'TICKET';

  @override
  String get parkingTicketMock1 => 'TICKET A1 · MODEL';

  @override
  String get parkingTicketMock2 => 'TICKET B7 · GUEST';

  @override
  String get parkingActiveValetLabel => 'VALET SERVICE';

  @override
  String get parkingActiveStatusLine => 'VALET PARKING ACTIVE';

  @override
  String get parkingActiveShowEntryPointCta => 'SHOW ENTRY POINT';

  @override
  String get parkingActiveCarLabel => 'CAR';

  @override
  String get parkingActiveRegistrationNumberLabel => 'PLATE NUMBER';

  @override
  String get parkingCreateTicketTitle => 'Create Ticket';

  @override
  String get parkingCreateEventLabel => 'Event';

  @override
  String get parkingCreateAccountNameLabel => 'Name';

  @override
  String get parkingCreateCarModelLabel => 'MAKE AND MODEL';

  @override
  String get parkingCreateCarModelHint => 'For example: Ford Mustang';

  @override
  String get parkingCreatePlateNumberLabel => 'PLATE NUMBER';

  @override
  String get parkingCreatePlateNumberHint => 'For example: CA 7JXK921';

  @override
  String get parkingCreateRepeatPlateNumberLabel => 'REPEAT PLATE NUMBER';

  @override
  String get parkingCreateRepeatPlateNumberHint => 'Re-enter plate number';

  @override
  String get parkingCreatePlateNumberMismatch => 'Plate numbers do not match';

  @override
  String get parkingCreateBuyCta => 'BUY';

  @override
  String get parkingCreateBookCta => 'BOOK VALET PARKING';

  @override
  String get parkingCheckoutInBrowser => 'Complete payment in your browser.';

  @override
  String get parkingPurchasedWithoutPayment => 'Ticket purchased successfully.';

  @override
  String get parkingVipBooked => 'VIP valet parking booked successfully.';

  @override
  String get parkingCheckoutError =>
      'Could not start valet parking payment. Try again.';

  @override
  String get clientTicketServiceUnavailableTitle => 'Service unavailable';

  @override
  String get clientTicketServiceUnavailableBody =>
      'This ticket service is not active right now.';

  @override
  String get parkingActivePassLabel => 'PASS CODE';

  @override
  String get eventSettingsChatTitle => 'Group Chat';

  @override
  String get eventSettingsChatSubtitle =>
      'Group chat with group participants and managers';

  @override
  String get eventSettingsChatCta => 'OPEN CHAT';

  @override
  String get chatRoomsLoadFailed => 'Could not load chat rooms. Try again.';

  @override
  String get chatNoRooms =>
      'No chat rooms are available for your brands in this event yet.';

  @override
  String get chatNoMessagesYet => 'No messages yet';

  @override
  String get chatLoadFailed => 'Could not load chat messages. Try again.';

  @override
  String get chatSendFailed => 'Could not send message. Try again.';

  @override
  String get chatMessagePlaceholder => 'Message group...';

  @override
  String get chatReply => 'Reply';

  @override
  String get chatReplyCancel => 'Cancel';

  @override
  String chatReplyingTo(String name) {
    return 'Replying to $name';
  }

  @override
  String get chatReplyPreviewPhoto => 'Photo';

  @override
  String get chatEdit => 'Edit';

  @override
  String get chatDelete => 'Delete';

  @override
  String get chatDeleteTitle => 'Delete message?';

  @override
  String get chatDeleteMessageConfirm => 'This action cannot be undone.';

  @override
  String get chatDeleteFailed => 'Could not delete message. Try again.';

  @override
  String get chatEditFailed => 'Could not edit message. Try again.';

  @override
  String get chatEditingLabel => 'Editing message';

  @override
  String get chatCancelEdit => 'Cancel edit';

  @override
  String eventSettingsChatMoreParticipants(int count) {
    return '+$count';
  }

  @override
  String get mealChoiceTitle => 'Choose lunch';

  @override
  String get mealSelectChildLabel => 'Child';

  @override
  String get mealSelectDishLabel => 'Dish';

  @override
  String get mealSave => 'ORDER';

  @override
  String get mealNoMealsConfigured =>
      'No dishes have been added for this event yet.';

  @override
  String get mealSaved => 'Saved';

  @override
  String get mealSaveError => 'Could not save. Try again.';

  @override
  String get mealOrdersClosed => 'Order acceptance is closed';

  @override
  String get mealPaid => 'Paid';

  @override
  String get mealPaidDetail => 'Lunch for this event is paid.';

  @override
  String get mealPayInBrowser =>
      'Complete payment in the browser, then return to the app.';

  @override
  String get mealCheckoutError => 'Could not start payment. Try again.';

  @override
  String get mealAwaitingPayment => 'Order placed — awaiting payment';

  @override
  String get mealAwaitingPaymentDetail =>
      'Your dish is saved. Finish payment in the browser; status will update after Stripe confirms it.';

  @override
  String get mealPaymentContinue => 'Continue payment';

  @override
  String get mealPaymentCancel => 'Cancel payment';

  @override
  String get mealPaymentStartAgain => 'Start payment again';

  @override
  String get mealPaymentCanceled =>
      'Payment canceled. You can start again when ready.';

  @override
  String get mealPaymentStatusLoadError =>
      'Could not load payment status. Try again.';

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
  String get fillOutApplication => 'Fill Out\nApplication';

  @override
  String get upcomingShows => 'Upcoming\nShows';

  @override
  String get manageKids => 'Manage\nKids';

  @override
  String get navHome => 'Home';

  @override
  String get navEvents => 'Events';

  @override
  String get eventsYoutubeLiveButton => 'YouTube live';

  @override
  String get eventsYoutubeLiveInvalidUrl => 'Could not open this YouTube link.';

  @override
  String get eventsYoutubeLiveOpenExternally => 'Open in YouTube';

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

  @override
  String get myTicketsButton => 'MY TICKETS';

  @override
  String get myTicketsTitle => 'My tickets';

  @override
  String get selectEventForTickets => 'Select event';

  @override
  String get ticketsMomName => 'Parent name';

  @override
  String get ticketsEventDate => 'Date';

  @override
  String get ticketsOpenPdf => 'OPEN';

  @override
  String get ticketsPdfUnavailable => 'PDF not available yet';

  @override
  String get ticketsBuy => 'BUY TICKET';

  @override
  String get ticketsBuyNoLink =>
      'No purchase link is set. Add a ticket store URL for this event in the admin, or a website URL in Info.';

  @override
  String get ticketsBuyCouldNotOpen => 'Could not open the link.';

  @override
  String get ticketsBuySubtitle => 'VIP and standard seats available';

  @override
  String get ticketsBuyEmailHint =>
      'Your tickets will be sent to the email address provided during purchase.';

  @override
  String get extraTicketButton => 'OPEN BAR';

  @override
  String get extraTicketSelectEventFirst => 'Select an event first.';

  @override
  String get extraTicketNoActiveHeadline => 'NO ACTIVE BEVERAGE PACKAGES';

  @override
  String get extraTicketBuyCta => 'BUY';

  @override
  String get extraTicketAccessOpen => 'ACCESS TO BEVERAGE PACKAGE IS OPEN';

  @override
  String get extraTicketCheckoutInBrowser =>
      'Complete payment in your browser.';

  @override
  String get extraTicketCheckoutError =>
      'Could not start beverage package payment. Try again.';

  @override
  String get backstageTicketButton => 'BACKSTAGE PASS';

  @override
  String get backstageTicketSelectEventFirst => 'Select an event first.';

  @override
  String get backstageTicketNoActiveHeadline => 'NO ACTIVE BACKSTAGE PASSES';

  @override
  String get backstageTicketBuyCta => 'BUY';

  @override
  String get backstageTicketAccessOpen => 'ACCESS TO BACKSTAGE PASS IS OPEN';

  @override
  String get backstageTicketCheckoutInBrowser =>
      'Complete payment in your browser.';

  @override
  String get backstageTicketCheckoutError =>
      'Could not start backstage pass payment. Try again.';

  @override
  String get ticketsNoEvents => 'No events with tickets yet';

  @override
  String get ticketsNoneForEvent => 'No tickets for this event';

  @override
  String get ticketsLoadError => 'Could not load tickets';

  @override
  String get ticketsEventsLoadError => 'Could not load events';

  @override
  String get faqBrandCatalogTitle => 'Clothing brands';

  @override
  String get pdfViewerTitle => 'Ticket';

  @override
  String get contactFormLinkMissing =>
      'No form link is set. Add В«Contact / signup form URLВ» in Application settings in the admin.';

  @override
  String get infoHubTitle => 'Information Hub';

  @override
  String get infoMenuAboutYfs => 'About YFS';

  @override
  String get infoMenuGeneralFaq => 'General FAQ';

  @override
  String get infoMenuContactManager => 'Contact Manager';

  @override
  String get infoFooterBrand => 'YFS';

  @override
  String get infoFooterCopyright =>
      'В© 2024 Young Fashion Series. All rights reserved.';

  @override
  String parentProgressLabel(int completed, int total) {
    return 'Parent progress: $completed/$total';
  }

  @override
  String get appUpdateRequiredMessage => 'Please update the app to continue.';

  @override
  String get appUpdateButton => 'Update app';

  @override
  String get showAll => 'Show all';

  @override
  String get staffNoneSelected => '-- None --';

  @override
  String get staffRoleInactive => 'INACTIVE';

  @override
  String get staffWorkerStatusRefreshFailed =>
      'Could not update role status. Check your connection.';

  @override
  String get staffScanRoleInactive =>
      'This role has been deactivated in the admin panel. Scanning is not available.';

  @override
  String staffScanFailed(String error) {
    return 'Scan failed: $error';
  }

  @override
  String get staffScanSelectEventStageFirst =>
      'Select active event and stage in Staff Settings before scanning.';

  @override
  String get staffScanProcessed => 'Scan processed';

  @override
  String get chatCouldNotPickPhoto => 'Could not pick photo';

  @override
  String get staffChildProfileTitle => 'Child Profile';

  @override
  String get staffEventTimelineButton => 'TIMELINE';

  @override
  String get staffEventTimelineTitle => 'Event timeline';

  @override
  String get staffParentTimelineButton1 => 'PARENT 1 TIMELINE';

  @override
  String get staffParentTimelineButton2 => 'PARENT 2 TIMELINE';

  @override
  String get staffParentTimelineTitle1 => 'Parent 1 timeline';

  @override
  String get staffParentTimelineTitle2 => 'Parent 2 timeline';

  @override
  String get staffCurrentStage => 'CURRENT STAGE';

  @override
  String staffProgressPercentComplete(int percent) {
    return '$percent% Complete';
  }

  @override
  String get staffChildDetailEmpty => 'No child details in DB';

  @override
  String get staffLoadFailed => 'Failed to load';

  @override
  String get staffGuardianLiaison => 'GUARDIAN LIAISON';

  @override
  String get staffAssignedBrand => 'ASSIGNED BRAND';

  @override
  String get staffAssignedPackage => 'PACKAGE';

  @override
  String get staffSupervisor => 'SUPERVISOR';

  @override
  String get staffSectionCoreDetails => 'Core Details';

  @override
  String get staffSectionParentContact => 'Parent Contact';

  @override
  String staffPhaseWithName(String stageName) {
    return 'Phase: $stageName';
  }

  @override
  String get staffNoCurrentStage => 'No current stage';

  @override
  String staffAgeYearsOld(int age) {
    return '$age years old';
  }

  @override
  String get staffNotesLabel => 'Notes';

  @override
  String get staffParentRoleDefault => 'Parent';

  @override
  String get contactManagerIntro =>
      'You can leave a message about any question. We will get back to you as soon as possible.';

  @override
  String get contactManagerMessageLabel => 'Your message';

  @override
  String get contactManagerMessageRequired => 'Please enter your message';

  @override
  String get contactManagerSend => 'Send';

  @override
  String get contactManagerSent =>
      'Your message has been sent. We will contact you soon.';

  @override
  String get contactManagerSendFailed => 'Could not send. Try again later.';

  @override
  String get contactManagerServiceUnavailable =>
      'Contact is temporarily unavailable. Please try again later.';

  @override
  String get close => 'Close';

  @override
  String get staffPortalTitle => 'Staff Portal';

  @override
  String get staffActiveEvent => 'Active event';

  @override
  String get staffActiveStage => 'Active stage';

  @override
  String get staffSelectEvent => 'Select event';

  @override
  String get staffSelectEventInSettings => 'Select an event in Staff Settings';

  @override
  String get staffSelectStage => 'Select stage';

  @override
  String staffPreparatoryStageLabel(String stageName) {
    return 'Prep: $stageName';
  }

  @override
  String get staffScanButton => 'SCAN';

  @override
  String get staffQrCheckButton => 'QR CHECK';

  @override
  String get staffParkingButton => 'VALET PARKING';

  @override
  String get staffExtraZoneButton => 'BEVERAGE PACKAGE';

  @override
  String get staffBackstageButton => 'BACKSTAGE PASS';

  @override
  String get staffRehearsalCheckinButton => 'REHEARSAL CHECK-IN';

  @override
  String get staffTapToScanModelLanyard => 'TAP TO SCAN MODEL LANYARD';

  @override
  String get staffTapToScanParkingQr => 'TAP TO SCAN VALET PARKING QR';

  @override
  String get staffTapToScanExtraZoneQr => 'TAP TO SCAN BEVERAGE PACKAGE QR';

  @override
  String get staffTapToScanBackstageQr => 'TAP TO SCAN BACKSTAGE PASS QR';

  @override
  String get staffTapToScanRehearsalCheckinQr =>
      'TAP TO SCAN REHEARSAL CHECK-IN QR';

  @override
  String get staffMealHandoutButton => 'LUNCH';

  @override
  String get staffTapToScanMealBadge => 'TAP TO SCAN A CHILD OR PARENT BADGE';

  @override
  String get staffMealIssueTitle => 'Lunch handout';

  @override
  String get staffMealIssueNoMeals => 'No lunch orders for this pass.';

  @override
  String get staffMealIssueHandOut => 'Hand out';

  @override
  String get staffMealIssueSuccess => 'Marked as handed out.';

  @override
  String staffMealIssueFailure(String error) {
    return 'Could not update: $error';
  }

  @override
  String get staffMealIssueAlreadyIssued => 'already handed out';

  @override
  String get staffTapToScanQrCheck => 'TAP TO SCAN BADGE — STAGE & CHILD CARD';

  @override
  String get staffCurrentTask => 'Current Task';

  @override
  String get staffUtilitiesAndTools => 'UTILITIES & TOOLS';

  @override
  String get staffScanForInfoTitle => 'Scan for Info';

  @override
  String get staffScanForInfoSubtitle => 'General purpose assets & ID scanner';

  @override
  String get staffToiletRequest => 'Toilet Request';

  @override
  String get staffRestroomLog => 'RESTROOM LOG';

  @override
  String get staffSettingsCardTitle => 'Staff Settings';

  @override
  String get staffPreferences => 'PREFERENCES';

  @override
  String get staffSupervisorRoleTitle => 'Supervisor Role';

  @override
  String get staffSupervisorRoleDescription =>
      'Manage event flow, oversee photographers, and ensure all children are captured effectively. Track progress in real-time.';

  @override
  String get staffCurrentStageLabel => 'Current stage';

  @override
  String get staffNoMainStagesAvailable =>
      'No main stages available for this event.';

  @override
  String get staffChildRegistry => 'Child Registry';

  @override
  String staffChildrenListed(int count) {
    return '$count Children Listed';
  }

  @override
  String get staffSelectActiveEventForRegistry =>
      'Select an active event in Settings to see the child registry.';

  @override
  String get staffNoChildrenAssigned => 'No children assigned for this event.';

  @override
  String get staffRehearsalAdminSlotsTitle => 'Rehearsal Slots';

  @override
  String get staffRehearsalCheckinActiveSlot => 'Active rehearsal slot';

  @override
  String get staffRehearsalAdminSelectSlot => 'Select rehearsal slot';

  @override
  String get staffRehearsalCheckinSelectSlotFirst =>
      'Select rehearsal slot first';

  @override
  String get staffRehearsalAdminBookedChildrenTitle => 'Booked Children';

  @override
  String get staffRehearsalAdminNoSlots =>
      'No rehearsal slots created for this event.';

  @override
  String get staffRehearsalAdminNoChildrenForSlot =>
      'No children booked for this slot.';

  @override
  String get staffGiftControlButton => 'CONTROL';

  @override
  String get staffGiftControlTitle => 'Gift Issue Control';

  @override
  String get staffGiftControlSelectStage => 'Select report stage';

  @override
  String get staffGiftControlFilterAll => 'All';

  @override
  String get staffGiftControlFilterPassed => 'Passed';

  @override
  String get staffGiftControlFilterNotPassed => 'Not passed';

  @override
  String get staffGiftControlNoChildren => 'No children for selected filters.';

  @override
  String get staffTableProfile => 'PROFILE';

  @override
  String get staffTableName => 'NAME';

  @override
  String get staffTableStatus => 'STATUS';

  @override
  String get staffTableAction => 'ACTION';

  @override
  String get staffYes => 'Yes';

  @override
  String get staffNo => 'No';

  @override
  String get staffRoleHostessTitle => 'Role: hostess';

  @override
  String get staffRoleHostessPlaceholder =>
      'The hostess role screen will be added later.';

  @override
  String get staffRoleInterviewTitle => 'Role: interview';

  @override
  String get staffRoleInterviewPlaceholder =>
      'The interview role screen will be added later.';

  @override
  String get staffRoleLunchesTitle => 'Role: lunches';

  @override
  String get staffRoleLunchesPlaceholder =>
      'The lunches role screen will be added later.';

  @override
  String get staffRoleSuperadminTitle => 'Role: superadmin';

  @override
  String get staffRoleSuperadminPlaceholder =>
      'The superadmin role screen will be added later.';

  @override
  String get staffRoleRehearsalAdminTitle => 'Role: rehearsal admin';

  @override
  String get staffRoleRehearsalAdminPlaceholder =>
      'The rehearsal admin role screen will be added later.';

  @override
  String get staffNavHome => 'Home';

  @override
  String get staffNavEvent => 'Event';

  @override
  String get staffNavMore => 'More';

  @override
  String get staffAccessBadge => 'STAFF ACCESS';

  @override
  String get staffVenueAndContact => 'Venue & Contact';

  @override
  String get staffMainOffice => 'Main Office';

  @override
  String get staffSecurity => 'Security';

  @override
  String get staffScanHeaderParking => 'Valet Parking Scan';

  @override
  String get staffScanHeaderExtraZone => 'Beverage package entry';

  @override
  String get staffScanHeaderBackstage => 'Backstage pass entry';

  @override
  String get staffScanHeaderRehearsalCheckin => 'Rehearsal Check-in';

  @override
  String get staffScanHeaderInfo => 'Scan for Info';

  @override
  String get staffScanHeaderQr => 'Scan QR Code';

  @override
  String get staffScanHintParking =>
      'Scan valet parking QR code to show ticket details';

  @override
  String get staffScanHintExtraZone =>
      'Scan beverage package QR code to allow entry';

  @override
  String get staffScanHintBackstage =>
      'Scan backstage pass QR code to allow entry';

  @override
  String get staffScanHintRehearsalCheckin =>
      'Scan child check-in QR to close rehearsal check-in';

  @override
  String get staffScanHintInfo => 'Scan child or parent badge to view profile';

  @override
  String get staffScanHintQr => 'Align QR code within the frame';

  @override
  String get staffScanHeaderQrCheck => 'QR check';

  @override
  String get staffScanHintQrCheck =>
      'Scan the child badge to mark the selected stage complete, then open the child card';

  @override
  String get staffQrCheckSuccessTitle => 'Stage marked complete';

  @override
  String get staffQrCheckSuccessContinue => 'Continue';

  @override
  String get staffScanErrorTitle => 'Scan Error';

  @override
  String get staffScanErrorUnknown => 'Unknown scan error.';

  @override
  String get staffParkingTicketTitle => 'Valet Parking Ticket';

  @override
  String get staffExtraZonePassTitle => 'Beverage package pass';

  @override
  String get staffExtraZoneScanResultTitle => 'Scan Result';

  @override
  String get staffExtraZoneResultNotFound => 'CODE NOT FOUND IN DATABASE';

  @override
  String get staffExtraZoneResultAccessGranted =>
      'CODE ACCEPTED, ACCESS GRANTED';

  @override
  String get staffExtraZoneResultAccessClosed =>
      'CODE ACCEPTED, BUT ACCESS CLOSED';

  @override
  String get staffBackstageScanResultTitle => 'Scan Result';

  @override
  String get staffBackstageResultNotFound => 'CODE NOT FOUND IN DATABASE';

  @override
  String get staffBackstageResultAccessGranted =>
      'CODE ACCEPTED, ACCESS GRANTED';

  @override
  String get staffBackstageResultAccessClosed =>
      'CODE ACCEPTED, BUT ACCESS CLOSED';

  @override
  String get staffRehearsalCheckinScanResultTitle => 'Scan Result';

  @override
  String get staffRehearsalCheckinResultNotFound => 'CHECK-IN CODE NOT FOUND';

  @override
  String get staffRehearsalCheckinResultWrongSlot =>
      'CHILD IS NOT IN THE SELECTED SLOT';

  @override
  String get staffRehearsalCheckinResultAlreadyClosed =>
      'REHEARSAL CHECK-IN ALREADY CLOSED';

  @override
  String get staffRehearsalCheckinResultClosedNow =>
      'REHEARSAL CHECK-IN CLOSED';

  @override
  String get staffRehearsalCheckinFieldChild => 'Child';

  @override
  String get staffRehearsalCheckinFieldSlot => 'Slot';

  @override
  String get staffParkingFieldEvent => 'Event';

  @override
  String get staffParkingFieldClient => 'Client';

  @override
  String get staffParkingFieldCar => 'Car';

  @override
  String get staffParkingFieldPlateNumber => 'Plate number';

  @override
  String get staffParkingFieldVipClient => 'VIP client';

  @override
  String get staffShowProgressTitle => 'Show Progress';

  @override
  String get staffCouldNotOpenDialer => 'Could not open the phone dialer';

  @override
  String get staffRealtimeTracking => 'REAL-TIME TRACKING';

  @override
  String get staffEstimatedCompletion => 'EST. COMPLETION';

  @override
  String get staffNoMainStagesInPlan => 'No main stages in plan yet.';

  @override
  String get staffStatusDone => 'DONE';

  @override
  String get staffStatusInProgress => 'IN PROGRESS';

  @override
  String get staffStatusPending => 'PENDING';

  @override
  String get staffContactDetails => 'Contact Details';

  @override
  String get staffPrimaryParent => 'PRIMARY PARENT';

  @override
  String staffIdLabel(String id) {
    return 'Staff ID: $id';
  }

  @override
  String get staffSwitchRole => 'Switch Role';

  @override
  String staffCurrentRoleLabel(String role) {
    return 'CURRENT: $role';
  }

  @override
  String get staffRoleSubtitleScan => 'QR scan & stage flow';

  @override
  String get staffRoleSubtitleQrCheck =>
      'Mark stage by badge, then child details';

  @override
  String get staffRoleSubtitleSupervisor => 'Full access & management';

  @override
  String get staffRoleSubtitleHostess => 'Guest & zone support';

  @override
  String get staffRoleSubtitleParking => 'Valet parking flow & access';

  @override
  String get staffRoleSubtitleExtraZone => 'Beverage package access';

  @override
  String get staffRoleSubtitleBackstage => 'Backstage pass access';

  @override
  String get staffRoleSubtitleRehearsalAdmin => 'Rehearsal administration';

  @override
  String get staffRoleSubtitleRehearsalCheckin =>
      'Rehearsal slot check-in scan';

  @override
  String get staffRoleSubtitleGiftIssue => 'Gift issue control';

  @override
  String get staffRoleSubtitleInterview => 'Interview flow';

  @override
  String get staffRoleSubtitleLunches => 'Meals & lunches';

  @override
  String get staffRoleSubtitleSuperadmin => 'Super admin tools';

  @override
  String get staffRoleSubtitlePhotographer => 'Media capture & uploads';

  @override
  String get staffRoleSubtitleStylist => 'Wardrobe & makeup logs';

  @override
  String get staffHostessEntryMode => 'ENTRY';

  @override
  String get staffHostessExitMode => 'EXIT';

  @override
  String get staffHostessEntryHint =>
      'Scan child badge to close selected stage and sync Family Look parents';

  @override
  String get staffHostessExitHint =>
      'Scan child or parent badge, review progress and close event stage';

  @override
  String get staffHostessEntryResultTitle => 'Entry scan result';

  @override
  String get staffHostessExitResultTitle => 'Exit scan result';

  @override
  String get staffHostessFieldChildName => 'Name';

  @override
  String get staffHostessFieldParent => 'Parent';

  @override
  String get staffHostessFieldBrandsAndSupervisors => 'Brands and supervisors';

  @override
  String get staffHostessFieldFamilyLook => 'Family Look';

  @override
  String get staffHostessFamilyLookEnabled => 'Family Look is enabled';

  @override
  String get staffHostessFieldStages => 'Stages';

  @override
  String get staffHostessCloseEventAction => 'Close Event';

  @override
  String get staffHostessStageAlreadySelectedOtherMode =>
      'This stage is already selected for the other hostess mode.';

  @override
  String staffHostessRequiredProgress(int completed, int total) {
    return 'Required stages completed: $completed/$total';
  }
}
