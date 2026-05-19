// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Russian (`ru`).
class AppLocalizationsRu extends AppLocalizations {
  AppLocalizationsRu([String locale = 'ru']) : super(locale);

  @override
  String get signIn => 'Р’РѕР№С‚Рё';

  @override
  String get signUp => 'Р РµРіРёСЃС‚СЂР°С†РёСЏ';

  @override
  String get email => 'Р­Р»РµРєС‚СЂРѕРЅРЅР°СЏ РїРѕС‡С‚Р°';

  @override
  String get password => 'РџР°СЂРѕР»СЊ';

  @override
  String get emailRequired => 'Р’РІРµРґРёС‚Рµ email';

  @override
  String get enterValidEmail => 'Р’РІРµРґРёС‚Рµ РєРѕСЂСЂРµРєС‚РЅС‹Р№ email';

  @override
  String get passwordRequired => 'Р’РІРµРґРёС‚Рµ РїР°СЂРѕР»СЊ';

  @override
  String get hidePassword => 'РЎРєСЂС‹С‚СЊ РїР°СЂРѕР»СЊ';

  @override
  String get showPassword => 'РџРѕРєР°Р·Р°С‚СЊ РїР°СЂРѕР»СЊ';

  @override
  String signInFailed(String error) {
    return 'РћС€РёР±РєР° РІС…РѕРґР°: $error';
  }

  @override
  String get apiEndpointNotFoundHint =>
      'РЎРµСЂРІРµСЂ РЅРµ РЅР°С€С‘Р» API (404). РЈРєР°Р¶РёС‚Рµ РІ СЃР±РѕСЂРєРµ РєРѕСЂРµРЅСЊ СЃР°Р№С‚Р° Р±РµР· В«/apiВ» РІ РєРѕРЅС†Рµ вЂ” РїСЂРёР»РѕР¶РµРЅРёРµ СЃР°РјРѕ РѕР±СЂР°С‰Р°РµС‚СЃСЏ Рє /api/app/login. Р•СЃР»Рё Laravel РІ РїРѕРґРїР°РїРєРµ, РґРѕР±Р°РІСЊС‚Рµ РїСѓС‚СЊ РґРѕ РєР°С‚Р°Р»РѕРіР° public (РЅР°РїСЂРёРјРµСЂ https://example.com/myapp/public).';

  @override
  String get notificationsTitle => 'РЈРІРµРґРѕРјР»РµРЅРёСЏ';

  @override
  String get notificationsLoadFailed =>
      'РќРµ СѓРґР°Р»РѕСЃСЊ Р·Р°РіСЂСѓР·РёС‚СЊ СѓРІРµРґРѕРјР»РµРЅРёСЏ. РџРѕРїСЂРѕР±СѓР№С‚Рµ СЃРЅРѕРІР°.';

  @override
  String get notificationsEmpty => 'РџРѕРєР° РЅРµС‚ СѓРІРµРґРѕРјР»РµРЅРёР№.';

  @override
  String get notificationsNewMark => 'РќРѕРІРѕРµ';

  @override
  String get notificationDetailsTitle => 'РЈРІРµРґРѕРјР»РµРЅРёРµ';

  @override
  String get createAccount => 'РЎРѕР·РґР°С‚СЊ Р°РєРєР°СѓРЅС‚';

  @override
  String get name => 'РРјСЏ';

  @override
  String get registerNameLabel => 'Р’РІРµРґРёС‚Рµ РёРјСЏ Рё С„Р°РјРёР»РёСЋ';

  @override
  String get nameRequired => 'Р’РІРµРґРёС‚Рµ РёРјСЏ';

  @override
  String get phone => 'РўРµР»РµС„РѕРЅ';

  @override
  String get phoneRequired => 'Р’РІРµРґРёС‚Рµ С‚РµР»РµС„РѕРЅ';

  @override
  String get phoneMustStartWithPlus =>
      'РўРµР»РµС„РѕРЅ РґРѕР»Р¶РµРЅ РЅР°С‡РёРЅР°С‚СЊСЃСЏ СЃ +';

  @override
  String get enterValidPhone =>
      'Р’РІРµРґРёС‚Рµ РєРѕСЂСЂРµРєС‚РЅС‹Р№ РЅРѕРјРµСЂ С‚РµР»РµС„РѕРЅР°';

  @override
  String get confirmPassword => 'РџРѕРґС‚РІРµСЂРґРёС‚Рµ РїР°СЂРѕР»СЊ';

  @override
  String get passwordsDoNotMatch => 'РџР°СЂРѕР»Рё РЅРµ СЃРѕРІРїР°РґР°СЋС‚';

  @override
  String get passwordMinLength =>
      'РџР°СЂРѕР»СЊ РЅРµ РјРµРЅРµРµ 8 СЃРёРјРІРѕР»РѕРІ';

  @override
  String get atLeast8Chars => 'РќРµ РјРµРЅРµРµ 8 СЃРёРјРІРѕР»РѕРІ';

  @override
  String get backToSignIn => 'Р’РµСЂРЅСѓС‚СЊСЃСЏ Рє РІС…РѕРґСѓ';

  @override
  String registrationFailed(String error) {
    return 'РћС€РёР±РєР° СЂРµРіРёСЃС‚СЂР°С†РёРё: $error';
  }

  @override
  String get loginPasswordOptionalHint =>
      'Р•СЃР»Рё РїСЂРѕС„РёР»СЊ СЃРѕР·РґР°Р» Р°РґРјРёРЅ РёР»Рё РёРјРїРѕСЂС‚, РѕСЃС‚Р°РІСЊС‚Рµ РїР°СЂРѕР»СЊ РїСѓСЃС‚С‹Рј Рё РїСЂРѕРґРѕР»Р¶Р°Р№С‚Рµ.';

  @override
  String get setPasswordTitle => 'РЎРѕР·РґР°РЅРёРµ РїР°СЂРѕР»СЏ';

  @override
  String setPasswordSubtitle(String email) {
    return 'РЎРѕР·РґР°Р№С‚Рµ РїР°СЂРѕР»СЊ РґР»СЏ $email';
  }

  @override
  String get passwordSetupMinLength =>
      'РџР°СЂРѕР»СЊ РґРѕР»Р¶РµРЅ Р±С‹С‚СЊ РЅРµ РјРµРЅРµРµ 6 СЃРёРјРІРѕР»РѕРІ';

  @override
  String get savePasswordAndContinue =>
      'РЎРѕС…СЂР°РЅРёС‚СЊ РїР°СЂРѕР»СЊ Рё РїСЂРѕРґРѕР»Р¶РёС‚СЊ';

  @override
  String passwordSetupFailed(String error) {
    return 'РќРµ СѓРґР°Р»РѕСЃСЊ СЃРѕР·РґР°С‚СЊ РїР°СЂРѕР»СЊ: $error';
  }

  @override
  String get account => 'РђРєРєР°СѓРЅС‚';

  @override
  String get editInfo => 'Р Р•Р”РђРљРўРР РћР’РђРўР¬';

  @override
  String get fullName => 'РРјСЏ';

  @override
  String get retry => 'РџРѕРІС‚РѕСЂРёС‚СЊ';

  @override
  String get accountSettings => 'РќР°СЃС‚СЂРѕР№РєРё Р°РєРєР°СѓРЅС‚Р°';

  @override
  String get editProfile => 'Р РµРґР°РєС‚РёСЂРѕРІР°С‚СЊ РїСЂРѕС„РёР»СЊ';

  @override
  String get deleteAccount => 'РЈРґР°Р»РёС‚СЊ Р°РєРєР°СѓРЅС‚';

  @override
  String get deleteAccountConfirmTitle => 'РЈРґР°Р»РёС‚СЊ Р°РєРєР°СѓРЅС‚?';

  @override
  String get deleteAccountConfirmMessage =>
      'Р’С‹ СѓРІРµСЂРµРЅС‹, С‡С‚Рѕ С…РѕС‚РёС‚Рµ РЅР°РІСЃРµРіРґР° СѓРґР°Р»РёС‚СЊ Р°РєРєР°СѓРЅС‚? Р­С‚Рѕ РґРµР№СЃС‚РІРёРµ РЅРµР»СЊР·СЏ РѕС‚РјРµРЅРёС‚СЊ.';

  @override
  String get deleteAccountSecondTitle => 'Р§С‚Рѕ Р±СѓРґРµС‚ СѓРґР°Р»РµРЅРѕ';

  @override
  String get deleteAccountSecondMessage =>
      'Р‘СѓРґРµС‚ Р±РµР·РІРѕР·РІСЂР°С‚РЅРѕ СѓРґР°Р»РµРЅРѕ РёР· РЅР°С€РёС… СЃРёСЃС‚РµРј:\n\nвЂў РІР°С€ Р°РєРєР°СѓРЅС‚ Рё РїСЂРѕС„РёР»СЊ;\nвЂў РІСЃРµ РґРµС‚Рё, РїСЂРёРІСЏР·Р°РЅРЅС‹Рµ Рє Р°РєРєР°СѓРЅС‚Сѓ;\nвЂў РІСЃРµ РЅР°Р·РЅР°С‡РµРЅРёСЏ РЅР° РјРµСЂРѕРїСЂРёСЏС‚РёСЏ, РїСЂРѕРіСЂРµСЃСЃ РїРѕ СЌС‚Р°РїР°Рј, Р±РёР»РµС‚С‹ Рё РІС‹Р±РѕСЂ РѕР±РµРґРѕРІ;\nвЂў С„РѕС‚РѕРіСЂР°С„РёРё Рё РґСЂСѓРіРёРµ РґР°РЅРЅС‹Рµ РґРµС‚РµР№;\nвЂў СѓС‡Р°СЃС‚РёРµ РІ С‡Р°С‚Р°С… РјРµСЂРѕРїСЂРёСЏС‚РёР№ Рё СѓРІРµРґРѕРјР»РµРЅРёСЏ РІ РїСЂРёР»РѕР¶РµРЅРёРё.\n\nРќРµРєРѕС‚РѕСЂС‹Рµ РїР»Р°С‚С‘Р¶РЅС‹Рµ РёР»Рё Р±СѓС…РіР°Р»С‚РµСЂСЃРєРёРµ Р·Р°РїРёСЃРё РјРѕРіСѓС‚ СЃРѕС…СЂР°РЅСЏС‚СЊСЃСЏ, РµСЃР»Рё СЌС‚РѕРіРѕ С‚СЂРµР±СѓРµС‚ Р·Р°РєРѕРЅ.';

  @override
  String get deleteAccountContinue => 'РџСЂРѕРґРѕР»Р¶РёС‚СЊ';

  @override
  String get deleteAccountConfirmAction => 'РЈРґР°Р»РёС‚СЊ РЅР°РІСЃРµРіРґР°';

  @override
  String get deleteAccountWorking => 'РЈРґР°Р»РµРЅРёРµ Р°РєРєР°СѓРЅС‚Р°вЂ¦';

  @override
  String get save => 'РЎРѕС…СЂР°РЅРёС‚СЊ';

  @override
  String get edit => 'Р РµРґР°РєС‚РёСЂРѕРІР°С‚СЊ';

  @override
  String get role => 'Р РѕР»СЊ';

  @override
  String get myChildren => 'РњРѕРё РґРµС‚Рё';

  @override
  String get addChild => 'Р”РѕР±Р°РІРёС‚СЊ СЂРµР±С‘РЅРєР°';

  @override
  String get noChildrenAddedYet => 'Р”РµС‚Рё РїРѕРєР° РЅРµ РґРѕР±Р°РІР»РµРЅС‹';

  @override
  String get ageLabel => 'Р’РѕР·СЂР°СЃС‚';

  @override
  String get settings => 'РќР°СЃС‚СЂРѕР№РєРё';

  @override
  String get aboutTheApp => 'Рћ РїСЂРёР»РѕР¶РµРЅРёРё';

  @override
  String get aboutAppDisplayName => 'YoungFashionShow';

  @override
  String get aboutPublisherLine => 'YOUNGFASHIONSHOW';

  @override
  String get aboutVersionLabel => 'Р’Р•Р РЎРРЇ';

  @override
  String get aboutReleaseDateLabel => 'Р”РђРўРђ Р’Р«РџРЈРЎРљРђ';

  @override
  String get aboutDevelopedByPrefix => 'Р РђР—Р РђР‘РћРўРђРќРћ:';

  @override
  String get aboutDeveloperBrand => 'OWLSOLUTIONS';

  @override
  String get aboutLinkCouldNotOpen =>
      'РќРµ СѓРґР°Р»РѕСЃСЊ РѕС‚РєСЂС‹С‚СЊ СЃСЃС‹Р»РєСѓ.';

  @override
  String get appLanguage => 'РЇР·С‹Рє РїСЂРёР»РѕР¶РµРЅРёСЏ';

  @override
  String get unitsOfMeasurement => 'Р•РґРёРЅРёС†С‹ РёР·РјРµСЂРµРЅРёСЏ';

  @override
  String get timeDisplayFormat => 'Р¤РѕСЂРјР°С‚ РІСЂРµРјРµРЅРё';

  @override
  String get timeFormat24Hour => '24-С‡Р°СЃРѕРІРѕР№';

  @override
  String get timeFormat12Hour => '12-С‡Р°СЃРѕРІРѕР№ (AM/PM)';

  @override
  String get metricUnits => 'РњРµС‚СЂРёС‡РµСЃРєРёРµ (СЃРј, РєРі)';

  @override
  String get imperialUnits => 'РђРјРµСЂРёРєР°РЅСЃРєРёРµ (in, lb)';

  @override
  String get systemLanguage => 'РЎРёСЃС‚РµРјРЅС‹Р№';

  @override
  String get languageRussian => 'Р СѓСЃСЃРєРёР№';

  @override
  String get languageEnglish => 'РђРЅРіР»РёР№СЃРєРёР№';

  @override
  String get languageUkrainian => 'РЈРєСЂР°С—РЅСЃСЊРєР°';

  @override
  String get languageSpanishUS => 'РСЃРїР°РЅСЃРєРёР№ (РЎРЁРђ)';

  @override
  String get addChildTitle => 'Р”РѕР±Р°РІРёС‚СЊ СЂРµР±С‘РЅРєР°';

  @override
  String get firstName => 'РРјСЏ';

  @override
  String get gender => 'РџРѕР»';

  @override
  String get genderBoy => 'РњР°Р»СЊС‡РёРє';

  @override
  String get genderGirl => 'Р”РµРІРѕС‡РєР°';

  @override
  String get lastName => 'Р¤Р°РјРёР»РёСЏ';

  @override
  String get birthdate => 'Р”Р°С‚Р° СЂРѕР¶РґРµРЅРёСЏ';

  @override
  String get chooseDate => 'Р’С‹Р±РµСЂРёС‚Рµ РґР°С‚Сѓ';

  @override
  String get create => 'РЎРѕР·РґР°С‚СЊ';

  @override
  String get enterFirstName => 'Р’РІРµРґРёС‚Рµ РёРјСЏ';

  @override
  String get mainPhoto => 'РћСЃРЅРѕРІРЅРѕРµ С„РѕС‚Рѕ';

  @override
  String get changePhoto => 'РР·РјРµРЅРёС‚СЊ';

  @override
  String get deletePhoto => 'РЈРґР°Р»РёС‚СЊ';

  @override
  String get addPhoto => 'Р”РѕР±Р°РІРёС‚СЊ С„РѕС‚Рѕ';

  @override
  String get photoSaved => 'Р¤РѕС‚Рѕ СЃРѕС…СЂР°РЅРµРЅРѕ';

  @override
  String get photoDeleted => 'Р¤РѕС‚Рѕ СѓРґР°Р»РµРЅРѕ';

  @override
  String get photoAdded => 'Р¤РѕС‚Рѕ РґРѕР±Р°РІР»РµРЅРѕ';

  @override
  String get extraPhotos => 'Р”РѕРїРѕР»РЅРёС‚РµР»СЊРЅС‹Рµ С„РѕС‚Рѕ';

  @override
  String get cancel => 'РћС‚РјРµРЅР°';

  @override
  String get clear => 'РћС‡РёСЃС‚РёС‚СЊ';

  @override
  String get height => 'Р РѕСЃС‚';

  @override
  String get weight => 'Р’РµСЃ';

  @override
  String get shoulders => 'РџР»РµС‡Рё';

  @override
  String get chest => 'Р“СЂСѓРґСЊ';

  @override
  String get waist => 'РўР°Р»РёСЏ';

  @override
  String get hips => 'Р‘С‘РґСЂР°';

  @override
  String get measurementLengthUnitCm => 'СЃРј';

  @override
  String get measurementLengthUnitIn => 'РґСЋР№Рј';

  @override
  String get currentParticipation => 'РўРµРєСѓС‰РµРµ СѓС‡Р°СЃС‚РёРµ';

  @override
  String childSubscribedBrands(String brands) {
    return 'Р‘СЂРµРЅРґС‹: $brands';
  }

  @override
  String get unknownError => 'РќРµРёР·РІРµСЃС‚РЅР°СЏ РѕС€РёР±РєР°';

  @override
  String model(String name) {
    return 'РњРѕРґРµР»СЊ: $name';
  }

  @override
  String get active => 'РђРљРўРР’РќРћ';

  @override
  String get familyLabel => 'FAMILY';

  @override
  String get familyJoinButton => 'РџР РРЎРћР•Р”РРќРРўР¬РЎРЇ Рљ РЎР•РњР¬Р•';

  @override
  String get familyJoinDialogHint =>
      'Р’РІРµРґРёС‚Рµ 6-Р·РЅР°С‡РЅС‹Р№ СЃРµРјРµР№РЅС‹Р№ РєРѕРґ.';

  @override
  String get familyJoinAction => 'РџРѕРґРєР»СЋС‡РёС‚СЊСЃСЏ';

  @override
  String get familyJoinInvalidCode =>
      'Р’РІРµРґРёС‚Рµ РєРѕСЂСЂРµРєС‚РЅС‹Р№ 6-Р·РЅР°С‡РЅС‹Р№ РєРѕРґ.';

  @override
  String get familyJoinSuccess =>
      'РЎРµРјРµР№РЅР°СЏ РїРѕРґРїРёСЃРєР° РїРѕРґРєР»СЋС‡РµРЅР°.';

  @override
  String get contractWarningTitle => 'РџСЂРµРґСѓРїСЂРµР¶РґРµРЅРёРµ';

  @override
  String get contractWarningFallbackText =>
      'РџРµСЂРµРґ РїРѕРєСѓРїРєРѕР№ Р±РёР»РµС‚РѕРІ РѕР·РЅР°РєРѕРјСЊС‚РµСЃСЊ Рё РїРѕРґРїРёС€РёС‚Рµ РґРѕРіРѕРІРѕСЂ.';

  @override
  String get contractViewButton => 'РџСЂРѕСЃРјРѕС‚СЂРµС‚СЊ';

  @override
  String get contractPreviewTitle => 'РўРµРєСЃС‚ РґРѕРіРѕРІРѕСЂР°';

  @override
  String get contractSignButton => 'РџРѕРґРїРёСЃР°С‚СЊ';

  @override
  String get contractSignatureTitle => 'РџРѕСЃС‚Р°РІСЊС‚Рµ РїРѕРґРїРёСЃСЊ';

  @override
  String get contractSignedSuccess =>
      'Р”РѕРіРѕРІРѕСЂ СѓСЃРїРµС€РЅРѕ РїРѕРґРїРёСЃР°РЅ.';

  @override
  String get journeyProgress => 'РџР РћР“Р Р•РЎРЎ';

  @override
  String get journeyPreparationPhase => 'РџРћР”Р“РћРўРћР’РљРђ';

  @override
  String get journeyMainEventTitle => 'РћРЎРќРћР’РќРћР™ РР’Р•РќРў';

  @override
  String get journeyMainEventSubtitle => 'Р“Р›РђР’РќРћР• РЁРћРЈ';

  @override
  String stepOf(int completed, int total) {
    return 'РЁР°Рі $completed РёР· $total';
  }

  @override
  String next(String text) {
    return 'Р”Р°Р»РµРµ: $text';
  }

  @override
  String get viewProgress => 'РЎРњРћРўР Р•РўР¬ РџР РћР“Р Р•РЎРЎ';

  @override
  String get eventSettings => 'РќРђРЎРўР РћР™РљР РР’Р•РќРўРђ';

  @override
  String get homeEventCardMyEvent => 'РњРћР™ РР’Р•РќРў';

  @override
  String get homeEventCardRunwayJourney => 'РџРЈРўР¬ РќРђ РџРћР”РРЈРњ';

  @override
  String get eventSettingsPlaceholder =>
      'Р—РґРµСЃСЊ СЃРєРѕСЂРѕ РїРѕСЏРІСЏС‚СЃСЏ РЅР°СЃС‚СЂРѕР№РєРё РёРІРµРЅС‚Р°.';

  @override
  String get eventSettingsConfigurationPortal =>
      'РџРћР РўРђР› РќРђРЎРўР РћР•Рљ';

  @override
  String get eventSettingsMainHeadline => 'РќР°СЃС‚СЂРѕР№РєРё РёРІРµРЅС‚Р°';

  @override
  String get eventSettingsFamilyButton => 'РЎРµРјСЊСЏ';

  @override
  String get familyManageTitle => 'РЎРµРјСЊСЏ';

  @override
  String get familyManageEnabled =>
      'РђРєС‚РёРІРёСЂРѕРІР°С‚СЊ СЃРµРјРµР№РЅС‹Рµ РїРѕРґРєР»СЋС‡РµРЅРёСЏ';

  @override
  String get familyManageCodeLabel => 'РЎРµРјРµР№РЅС‹Р№ РєРѕРґ';

  @override
  String get familyManageRegenerateCode => 'РР·РјРµРЅРёС‚СЊ РєРѕРґ';

  @override
  String get familyManageConnectionsTitle =>
      'РђРєС‚РёРІРЅС‹Рµ СЃРµРјРµР№РЅС‹Рµ РїРѕРґРєР»СЋС‡РµРЅРёСЏ';

  @override
  String get familyManageNoConnections =>
      'РђРєС‚РёРІРЅС‹С… СЃРµРјРµР№РЅС‹С… РїРѕРґРєР»СЋС‡РµРЅРёР№ РїРѕРєР° РЅРµС‚.';

  @override
  String get familyManageUnknownUser =>
      'РќРµРёР·РІРµСЃС‚РЅС‹Р№ РїРѕР»СЊР·РѕРІР°С‚РµР»СЊ';

  @override
  String get eventSettingsLeaveFamilyButton =>
      'РћС‚РєР»СЋС‡РёС‚СЊСЃСЏ РѕС‚ СЃРµРјСЊРё';

  @override
  String get eventSettingsLeaveFamilyConfirmTitle =>
      'РћС‚РєР»СЋС‡РёС‚СЊ СЃРµРјРµР№РЅС‹Р№ РґРѕСЃС‚СѓРї?';

  @override
  String get eventSettingsLeaveFamilyConfirmText =>
      'Р’С‹ РїРѕС‚РµСЂСЏРµС‚Рµ СЃРµРјРµР№РЅС‹Р№ РґРѕСЃС‚СѓРї Рє РёРІРµРЅС‚Сѓ, РїРѕРєР° РЅРµ РїРѕРґРєР»СЋС‡РёС‚РµСЃСЊ СЃРЅРѕРІР° РїРѕ РєРѕРґСѓ.';

  @override
  String get eventSettingsLeaveFamilySuccess =>
      'РЎРµРјРµР№РЅРѕРµ РїРѕРґРєР»СЋС‡РµРЅРёРµ РѕС‚РєР»СЋС‡РµРЅРѕ.';

  @override
  String get eventSettingsMealTitle => 'Р’С‹Р±РѕСЂ РїРёС‚Р°РЅРёСЏ';

  @override
  String get eventSettingsMealSubtitle =>
      'Р’С‹Р±РµСЂРёС‚Рµ Р±Р»СЋРґРѕ РЅР° С‚РµРєСѓС‰РёР№ РёРІРµРЅС‚';

  @override
  String get eventSettingsMealCta => 'РњР•РќР®';

  @override
  String eventSettingsMealOrderedPcs(int count) {
    return 'Р—Р°РєР°Р·Р°РЅРѕ: $count С€С‚.';
  }

  @override
  String get eventSettingsMealPurchasesListHeading =>
      'РћС„РѕСЂРјР»РµРЅРЅС‹Рµ Р·Р°РєР°Р·С‹';

  @override
  String eventSettingsMealPurchaseChildLine(String name) {
    return 'Р РµР±С‘РЅРѕРє: $name';
  }

  @override
  String get mealPurchaseIssued => 'Р’С‹РґР°РЅРѕ';

  @override
  String get mealPurchaseNotIssued => 'РќРµ РІС‹РґР°РЅ';

  @override
  String get eventSettingsRehearsalTitle =>
      'Р—Р°РїРёСЃСЊ РЅР° СЂРµРїРµС‚РёС†РёСЋ';

  @override
  String get eventSettingsRehearsalSubtitle =>
      'Р—Р°Р±СЂРѕРЅРёСЂСѓР№С‚Рµ РјРµСЃС‚Рѕ РЅР° СЂРµРїРµС‚РёС†РёСЋ';

  @override
  String get eventSettingsRehearsalCta => 'Р—РђРџРРЎРђРўР¬РЎРЇ';

  @override
  String get eventSettingsBrandRehearsalsHeading =>
      'Р’Р°С€Рё СЂРµРїРµС‚РёС†РёРё Р±СЂРµРЅРґРѕРІ';

  @override
  String get rehearsalModalTitle => 'Р—Р°РїРёСЃСЊ РЅР° СЂРµРїРµС‚РёС†РёСЋ';

  @override
  String get rehearsalSelectDate => 'Р’С‹Р±РµСЂРёС‚Рµ РґР°С‚Сѓ';

  @override
  String get rehearsalAvailableSlots => 'Р”РѕСЃС‚СѓРїРЅС‹Рµ СЃР»РѕС‚С‹';

  @override
  String get rehearsalFreeLabel => 'РЎРІРѕР±РѕРґРЅРѕ:';

  @override
  String get rehearsalNoSlotsConfigured =>
      'Р”Р»СЏ СЌС‚РѕРіРѕ РёРІРµРЅС‚Р° СЃР»РѕС‚РѕРІ СЂРµРїРµС‚РёС†РёР№ РїРѕРєР° РЅРµС‚.';

  @override
  String get rehearsalLoadError =>
      'РќРµ СѓРґР°Р»РѕСЃСЊ Р·Р°РіСЂСѓР·РёС‚СЊ СЃР»РѕС‚С‹. РџРѕРїСЂРѕР±СѓР№С‚Рµ СЃРЅРѕРІР°.';

  @override
  String get rehearsalBrandNotAssigned =>
      'Р РµР±РµРЅРєСѓ РЅРµ РЅР°Р·РЅР°С‡РµРЅ РїР°РєРµС‚. Р‘СЂРѕРЅРёСЂРѕРІР°РЅРёРµ СЂРµРїРµС‚РёС†РёР№ РЅРµРґРѕСЃС‚СѓРїРЅРѕ.';

  @override
  String get rehearsalFull => 'РњРµСЃС‚ РЅРµС‚';

  @override
  String get rehearsalConfirmBooking => 'РџРѕРґС‚РІРµСЂРґРёС‚СЊ Р·Р°РїРёСЃСЊ';

  @override
  String get rehearsalBookingFooterNote =>
      'РџРѕ РІРѕР·РјРѕР¶РЅРѕСЃС‚Рё РёР·РјРµРЅРµРЅРёСЏ РІРЅРѕСЃРёС‚Рµ Р·Р° 24 С‡Р°СЃР° РґРѕ СЃР»РѕС‚Р°.';

  @override
  String get rehearsalBookedTitle =>
      'Р РµРїРµС‚РёС†РёСЏ Р·Р°Р±СЂРѕРЅРёСЂРѕРІР°РЅР°';

  @override
  String get rehearsalChangeBooking =>
      'РР·РјРµРЅРёС‚СЊ Р±СЂРѕРЅРёСЂРѕРІР°РЅРёРµ';

  @override
  String get rehearsalProgramLabel => 'РћРїРёСЃР°РЅРёРµ';

  @override
  String get rehearsalArriveEarly =>
      'РџСЂРёС…РѕРґРёС‚Рµ Р·Р° 15 РјРёРЅСѓС‚ РґРѕ РЅР°С‡Р°Р»Р°.';

  @override
  String get rehearsalBookingSaved => 'Р—Р°РїРёСЃСЊ СЃРѕС…СЂР°РЅРµРЅР°';

  @override
  String get rehearsalBookingError =>
      'РќРµ СѓРґР°Р»РѕСЃСЊ РІС‹РїРѕР»РЅРёС‚СЊ Р·Р°РїРёСЃСЊ.';

  @override
  String get rehearsalSelectChild => 'Р РµР±С‘РЅРѕРє';

  @override
  String get rehearsalUpdateBooking =>
      'Р”РѕР±Р°РІРёС‚СЊ Рё РѕР±РЅРѕРІРёС‚СЊ Р±СЂРѕРЅРёСЂРѕРІР°РЅРёРµ';

  @override
  String get rehearsalCancelChange => 'РћС‚РјРµРЅР°';

  @override
  String get rehearsalChangeBookingLockedHint =>
      'РћСЂРіР°РЅРёР·Р°С‚РѕСЂ Р·Р°РєСЂС‹Р» СЃРјРµРЅСѓ Р·Р°РїРёСЃРё. РќР°РїРёС€РёС‚Рµ РІ РїРѕРґРґРµСЂР¶РєСѓ, РµСЃР»Рё РЅСѓР¶РЅР° РїРѕРјРѕС‰СЊ.';

  @override
  String get rehearsalMilestoneTitle => 'РћР±С‰Р°СЏ СЂРµРїРµС‚РёС†РёСЏ';

  @override
  String rehearsalBrandMilestoneTitle(String brandName) {
    return 'Р РµРїРµС‚РёС†РёСЏ Р±СЂРµРЅРґР°: $brandName';
  }

  @override
  String get rehearsalBrandMilestoneShort => 'Р РµРїРµС‚РёС†РёСЏ Р±СЂРµРЅРґР°';

  @override
  String get rehearsalNextBookHint =>
      'Р—Р°РїРёС€РёС‚РµСЃСЊ РЅР° СЂРµРїРµС‚РёС†РёСЋ РІ РЅР°СЃС‚СЂРѕР№РєР°С… РёРІРµРЅС‚Р°.';

  @override
  String get eventSettingsPackingTitle => 'РЎРїРёСЃРѕРє В«РќРµ Р·Р°Р±СѓРґСЊВ»';

  @override
  String get eventSettingsPackingSubtitle => '';

  @override
  String get eventSettingsPackingCta => 'РћРўРљР Р«РўР¬ РЎРџРРЎРћРљ';

  @override
  String get eventPackingLoadFailed =>
      'РќРµ СѓРґР°Р»РѕСЃСЊ Р·Р°РіСЂСѓР·РёС‚СЊ РёРЅС„РѕСЂРјР°С†РёСЋ. РџРѕРїСЂРѕР±СѓР№С‚Рµ СЃРЅРѕРІР°.';

  @override
  String get eventPackingEmpty =>
      'Р”Р»СЏ СЌС‚РѕРіРѕ РёРІРµРЅС‚Р° РёРЅС„РѕСЂРјР°С†РёСЏ РїРѕРєР° РЅРµ РґРѕР±Р°РІР»РµРЅР°.';

  @override
  String get eventDescriptionTitle => 'РћРїРёСЃР°РЅРёРµ РёРІРµРЅС‚Р°';

  @override
  String get eventProgressShowGallery => 'Р“Р°Р»РµСЂРµСЏ';

  @override
  String get eventProgressCheckin => 'Р§РµРєРёРЅ';

  @override
  String get eventProgressCheckinPrompt =>
      'РћС‚СЃРєР°РЅРёСЂСѓР№С‚Рµ РґР»СЏ СЃС‚Р°СЂС‚Р° РёРІРµРЅС‚Р°';

  @override
  String get eventProgressCheckinUnavailable =>
      'Р§РµРєРёРЅ-РєРѕРґ РїРѕРєР° РЅРµРґРѕСЃС‚СѓРїРµРЅ.';

  @override
  String get eventDescriptionLoadFailed =>
      'РќРµ СѓРґР°Р»РѕСЃСЊ Р·Р°РіСЂСѓР·РёС‚СЊ РѕРїРёСЃР°РЅРёРµ. РџРѕРїСЂРѕР±СѓР№С‚Рµ СЃРЅРѕРІР°.';

  @override
  String get eventDescriptionEmpty =>
      'Р”Р»СЏ СЌС‚РѕРіРѕ РёРІРµРЅС‚Р° РїРѕРєР° РЅРµ РґРѕР±Р°РІР»РµРЅРѕ С‚РµРєСЃС‚РѕРІРѕРµ РѕРїРёСЃР°РЅРёРµ.';

  @override
  String get eventSettingsBrandTitle => 'РћР±СѓРІСЊ Рё РЅРѕСЃРєРё';

  @override
  String get eventSettingsBrandSubtitle =>
      'РћР·РЅР°РєРѕРјСЊС‚РµСЃСЊ СЃ СЂРµРєРѕРјРµРЅРґР°С†РёСЏРјРё Р±СЂРµРЅРґР° РґР»СЏ СѓС‡Р°СЃС‚РёСЏ РІ РёРІРµРЅС‚Рµ';

  @override
  String get eventSettingsBrandCta => 'Р РЈРљРћР’РћР”РЎРўР’Рћ';

  @override
  String get brandRequirementsLoadFailed =>
      'РќРµ СѓРґР°Р»РѕСЃСЊ Р·Р°РіСЂСѓР·РёС‚СЊ С‚СЂРµР±РѕРІР°РЅРёСЏ Р±СЂРµРЅРґР°. РџРѕРїСЂРѕР±СѓР№С‚Рµ СЃРЅРѕРІР°.';

  @override
  String get brandRequirementsEmpty =>
      'Р”Р»СЏ СЌС‚РѕРіРѕ РёРІРµРЅС‚Р° С‚СЂРµР±РѕРІР°РЅРёСЏ Р±СЂРµРЅРґРѕРІ РїРѕРєР° РЅРµ РґРѕР±Р°РІР»РµРЅС‹.';

  @override
  String get brandRequirementsEmptyItem =>
      'Р”Р»СЏ СЌС‚РѕРіРѕ Р±СЂРµРЅРґР° С‚СЂРµР±РѕРІР°РЅРёСЏ РїРѕРєР° РЅРµ Р·Р°РїРѕР»РЅРµРЅС‹.';

  @override
  String get brandRequirementsPickBrandTitle => 'Р’С‹Р±РµСЂРёС‚Рµ Р±СЂРµРЅРґ';

  @override
  String brandRequirementsBrandNumber(int brandId) {
    return 'Р‘СЂРµРЅРґ $brandId';
  }

  @override
  String get eventSettingsParkingTitle => 'Р’Р°Р»РµС‚-РїР°СЂРєРѕРІРєР°';

  @override
  String get eventSettingsParkingSubtitle =>
      'РћС‚РєСЂРѕР№С‚Рµ РїСЂРѕРїСѓСЃРє РЅР° РІР°Р»РµС‚-РїР°СЂРєРѕРІРєСѓ Рё СЃС‚Р°С‚СѓСЃ РїСЂРёР±С‹С‚РёСЏ';

  @override
  String get eventSettingsParkingCta =>
      'РћРўРљР Р«РўР¬ Р’РђР›Р•Рў-РџРђР РљРћР’РљРЈ';

  @override
  String get parkingChooseModeTitle => 'Р РµР¶РёРј РІР°Р»РµС‚-РїР°СЂРєРѕРІРєРё';

  @override
  String get parkingChooseModeHint =>
      'Р’С‹Р±РµСЂРёС‚Рµ СЃРѕСЃС‚РѕСЏРЅРёРµ СЌРєСЂР°РЅР° РґР»СЏ С‚РµСЃС‚Р° РІРёР·СѓР°Р»Р°.';

  @override
  String get parkingModeInactive => 'РќР• РђРљРўРР’РќРћ';

  @override
  String get parkingModeActive => 'РђРљРўРР’РќРћ';

  @override
  String get parkingInactiveHeadline =>
      'Р’РђР›Р•Рў-РџРђР РљРћР’РљРђ РќР• РђРљРўРР’РќРђ';

  @override
  String get parkingInactiveBody =>
      'Р’РђР›Р•Рў-РџРђР РљРћР’РљРђ РџРћРЇР’РРўРЎРЇ Р—Р”Р•РЎР¬ РџРћРЎР›Р• РџРћРљРЈРџРљР Р‘РР›Р•РўРђ.';

  @override
  String get parkingInactiveBuyCta => 'РљРЈРџРРўР¬';

  @override
  String get parkingInactiveVipBody =>
      'Р”Р›РЇ VIP Р’РђР›Р•Рў-РџРђР РљРћР’РљР вЂ” Р—РђР‘Р РћРќРР РЈР™РўР• РњР•РЎРўРћ Р”Р›РЇ Р’РђРЁР•Р“Рћ РђР’РўРћРњРћР‘РР›РЇ.';

  @override
  String get parkingInactiveVipBookCta =>
      'Р—РђРљРђР—РђРўР¬ Р’РђР›Р•Рў-РџРђР РљРћР’РљРЈ';

  @override
  String get parkingPayForParkingCta =>
      'РћРџР›РђРўРРўР¬ Р’РђР›Р•Рў-РџРђР РљРћР’РљРЈ';

  @override
  String get parkingVipQuotaNextPaymentBody =>
      'Р‘Р•РЎРџР›РђРўРќР«Р• Р’РђР›Р•Рў-Р‘РР›Р•РўР« РќРђ Р­РўРћРў РР’Р•РќРў РРЎР§Р•Р РџРђРќР«. РњРћР–РќРћ РћР¤РћР РњРРўР¬ Р•Р©РЃ РњР•РЎРўРћ РџРћ РћР‘Р«Р§РќРћР™ Р¦Р•РќР•.';

  @override
  String parkingFreeTicketsQuotaLine(int used, int quota, int remaining) {
    return 'Р‘РµСЃРїР»Р°С‚РЅС‹Р№ РІР°Р»РµС‚: РёСЃРїРѕР»СЊР·РѕРІР°РЅРѕ $used РёР· $quota (РѕСЃС‚Р°Р»РѕСЃСЊ $remaining)';
  }

  @override
  String get parkingActiveTicketLabel => 'Р‘РР›Р•Рў';

  @override
  String get parkingTicketMock1 => 'Р‘РР›Р•Рў A1 В· РњРћР”Р•Р›Р¬';

  @override
  String get parkingTicketMock2 => 'Р‘РР›Р•Рў B7 В· Р“РћРЎРўР¬';

  @override
  String get parkingActiveValetLabel => 'VALET SERVICE';

  @override
  String get parkingActiveStatusLine =>
      'Р’РђР›Р•Рў-РџРђР РљРћР’РљРђ РђРљРўРР’РќРђ';

  @override
  String get parkingActiveShowEntryPointCta =>
      'РџРћРљРђР—РђРўР¬ РўРћР§РљРЈ Р’РЄР•Р—Р”Рђ';

  @override
  String get parkingActiveCarLabel => 'РђР’РўРћРњРћР‘РР›Р¬';

  @override
  String get parkingActiveRegistrationNumberLabel =>
      'РќРћРњР•Р РќРћР™ Р—РќРђРљ';

  @override
  String get parkingCreateTicketTitle => 'РЎРѕР·РґР°С‚СЊ Р±РёР»РµС‚';

  @override
  String get parkingCreateEventLabel => 'РРІРµРЅС‚';

  @override
  String get parkingCreateAccountNameLabel => 'РРјСЏ';

  @override
  String get parkingCreateCarModelLabel => 'РњРђР РљРђ Р РњРћР”Р•Р›Р¬';

  @override
  String get parkingCreateCarModelHint => 'РќР°РїСЂРёРјРµСЂ: Ford Mustang';

  @override
  String get parkingCreatePlateNumberLabel => 'РќРћРњР•Р РќРћР™ Р—РќРђРљ';

  @override
  String get parkingCreatePlateNumberHint => 'РќР°РїСЂРёРјРµСЂ: CA 7JXK921';

  @override
  String get parkingCreateRepeatPlateNumberLabel =>
      'РџРћР’РўРћР РРўР• РќРћРњР•Р РќРћР™ Р—РќРђРљ';

  @override
  String get parkingCreateRepeatPlateNumberHint =>
      'РџРѕРІС‚РѕСЂРЅРѕ РІРІРµРґРёС‚Рµ РЅРѕРјРµСЂРЅРѕР№ Р·РЅР°Рє';

  @override
  String get parkingCreatePlateNumberMismatch =>
      'РќРѕРјРµСЂРЅС‹Рµ Р·РЅР°РєРё РЅРµ СЃРѕРІРїР°РґР°СЋС‚';

  @override
  String get parkingCreateBuyCta => 'РљРЈРџРРўР¬';

  @override
  String get parkingCreateBookCta =>
      'Р—РђРљРђР—РђРўР¬ Р’РђР›Р•Рў-РџРђР РљРћР’РљРЈ';

  @override
  String get parkingCheckoutInBrowser =>
      'Р—Р°РІРµСЂС€РёС‚Рµ РѕРїР»Р°С‚Сѓ РІ Р±СЂР°СѓР·РµСЂРµ.';

  @override
  String get parkingPurchasedWithoutPayment =>
      'Р‘РёР»РµС‚ СѓСЃРїРµС€РЅРѕ РєСѓРїР»РµРЅ.';

  @override
  String get parkingVipBooked =>
      'VIP РІР°Р»РµС‚-РїР°СЂРєРѕРІРєР° СѓСЃРїРµС€РЅРѕ Р·Р°Р±СЂРѕРЅРёСЂРѕРІР°РЅР°.';

  @override
  String get parkingCheckoutError =>
      'РќРµ СѓРґР°Р»РѕСЃСЊ РЅР°С‡Р°С‚СЊ РѕРїР»Р°С‚Сѓ РІР°Р»РµС‚-РїР°СЂРєРѕРІРєРё. РџРѕРїСЂРѕР±СѓР№С‚Рµ СЃРЅРѕРІР°.';

  @override
  String get clientTicketServiceUnavailableTitle =>
      'РЎРµСЂРІРёСЃ РЅРµРґРѕСЃС‚СѓРїРµРЅ';

  @override
  String get clientTicketServiceUnavailableBody =>
      'Р­С‚РѕС‚ СЃРµСЂРІРёСЃ Р±РёР»РµС‚РѕРІ СЃРµР№С‡Р°СЃ РЅРµ Р°РєС‚РёРІРµРЅ.';

  @override
  String get parkingActivePassLabel => 'РљРћР” РџР РћРџРЈРЎРљРђ';

  @override
  String get eventSettingsChatTitle => 'РћР±С‰РёР№ С‡Р°С‚';

  @override
  String get eventSettingsChatSubtitle =>
      'РћР±С‰РёР№ С‡Р°С‚ СЃ СѓС‡Р°СЃС‚РЅРёРєР°РјРё РіСЂСѓРїРїС‹ Рё РјРµРЅРµРґР¶РµСЂР°РјРё';

  @override
  String get eventSettingsChatCta => 'РћРўРљР Р«РўР¬ Р§РђРў';

  @override
  String get chatRoomsLoadFailed =>
      'РќРµ СѓРґР°Р»РѕСЃСЊ Р·Р°РіСЂСѓР·РёС‚СЊ РєРѕРјРЅР°С‚С‹ С‡Р°С‚Р°. РџРѕРїСЂРѕР±СѓР№С‚Рµ СЃРЅРѕРІР°.';

  @override
  String get chatNoRooms =>
      'Р”Р»СЏ РІР°С€РёС… Р±СЂРµРЅРґРѕРІ РІ СЌС‚РѕРј РёРІРµРЅС‚Рµ РїРѕРєР° РЅРµС‚ С‡Р°С‚-РєРѕРјРЅР°С‚.';

  @override
  String get chatNoMessagesYet => 'РЎРѕРѕР±С‰РµРЅРёР№ РїРѕРєР° РЅРµС‚';

  @override
  String get chatLoadFailed =>
      'РќРµ СѓРґР°Р»РѕСЃСЊ Р·Р°РіСЂСѓР·РёС‚СЊ СЃРѕРѕР±С‰РµРЅРёСЏ. РџРѕРїСЂРѕР±СѓР№С‚Рµ СЃРЅРѕРІР°.';

  @override
  String get chatSendFailed =>
      'РќРµ СѓРґР°Р»РѕСЃСЊ РѕС‚РїСЂР°РІРёС‚СЊ СЃРѕРѕР±С‰РµРЅРёРµ. РџРѕРїСЂРѕР±СѓР№С‚Рµ СЃРЅРѕРІР°.';

  @override
  String get chatMessagePlaceholder => 'РЎРѕРѕР±С‰РµРЅРёРµ РІ С‡Р°С‚...';

  @override
  String get chatReply => 'РћС‚РІРµС‚РёС‚СЊ';

  @override
  String get chatReplyCancel => 'РћС‚РјРµРЅР°';

  @override
  String chatReplyingTo(String name) {
    return 'РћС‚РІРµС‚ РґР»СЏ $name';
  }

  @override
  String get chatReplyPreviewPhoto => 'Р¤РѕС‚Рѕ';

  @override
  String get chatEdit => 'РР·РјРµРЅРёС‚СЊ';

  @override
  String get chatDelete => 'РЈРґР°Р»РёС‚СЊ';

  @override
  String get chatDeleteTitle => 'РЈРґР°Р»РёС‚СЊ СЃРѕРѕР±С‰РµРЅРёРµ?';

  @override
  String get chatDeleteMessageConfirm =>
      'Р­С‚Рѕ РґРµР№СЃС‚РІРёРµ РЅРµР»СЊР·СЏ РѕС‚РјРµРЅРёС‚СЊ.';

  @override
  String get chatDeleteFailed =>
      'РќРµ СѓРґР°Р»РѕСЃСЊ СѓРґР°Р»РёС‚СЊ СЃРѕРѕР±С‰РµРЅРёРµ. РџРѕРїСЂРѕР±СѓР№С‚Рµ СЃРЅРѕРІР°.';

  @override
  String get chatEditFailed =>
      'РќРµ СѓРґР°Р»РѕСЃСЊ РёР·РјРµРЅРёС‚СЊ СЃРѕРѕР±С‰РµРЅРёРµ. РџРѕРїСЂРѕР±СѓР№С‚Рµ СЃРЅРѕРІР°.';

  @override
  String get chatEditingLabel =>
      'Р РµРґР°РєС‚РёСЂРѕРІР°РЅРёРµ СЃРѕРѕР±С‰РµРЅРёСЏ';

  @override
  String get chatCancelEdit => 'РћС‚РјРµРЅРёС‚СЊ СЂРµРґР°РєС‚РёСЂРѕРІР°РЅРёРµ';

  @override
  String eventSettingsChatMoreParticipants(int count) {
    return '+$count';
  }

  @override
  String get mealChoiceTitle => 'Р’С‹Р±РѕСЂ РѕР±РµРґР°';

  @override
  String get mealSelectChildLabel => 'Р РµР±С‘РЅРѕРє';

  @override
  String get mealSelectDishLabel => 'Р‘Р»СЋРґРѕ';

  @override
  String get mealSave => 'Р—РђРљРђР—РђРўР¬';

  @override
  String get mealNoMealsConfigured =>
      'Р”Р»СЏ СЌС‚РѕРіРѕ РёРІРµРЅС‚Р° РїРѕРєР° РЅРµ РґРѕР±Р°РІР»РµРЅС‹ Р±Р»СЋРґР°.';

  @override
  String get mealSaved => 'РЎРѕС…СЂР°РЅРµРЅРѕ';

  @override
  String get mealSaveError =>
      'РќРµ СѓРґР°Р»РѕСЃСЊ СЃРѕС…СЂР°РЅРёС‚СЊ. РџРѕРїСЂРѕР±СѓР№С‚Рµ СЃРЅРѕРІР°.';

  @override
  String get mealOrdersClosed => 'РџСЂРёС‘Рј Р·Р°РєР°Р·РѕРІ Р·Р°РєСЂС‹С‚';

  @override
  String get mealPaid => 'РћРїР»Р°С‡РµРЅРѕ';

  @override
  String get mealPaidDetail =>
      'РћР±РµРґ РїРѕ СЌС‚РѕРјСѓ РёРІРµРЅС‚Сѓ РѕРїР»Р°С‡РµРЅ.';

  @override
  String get mealPayInBrowser =>
      'Р—Р°РІРµСЂС€РёС‚Рµ РѕРїР»Р°С‚Сѓ РІ Р±СЂР°СѓР·РµСЂРµ Рё РІРµСЂРЅРёС‚РµСЃСЊ РІ РїСЂРёР»РѕР¶РµРЅРёРµ.';

  @override
  String get mealCheckoutError =>
      'РќРµ СѓРґР°Р»РѕСЃСЊ РЅР°С‡Р°С‚СЊ РѕРїР»Р°С‚Сѓ. РџРѕРїСЂРѕР±СѓР№С‚Рµ СЃРЅРѕРІР°.';

  @override
  String get mealAwaitingPayment =>
      'Р—Р°РєР°Р· РѕС„РѕСЂРјР»РµРЅ вЂ” РѕР¶РёРґР°РµС‚ РѕРїР»Р°С‚С‹';

  @override
  String get mealAwaitingPaymentDetail =>
      'Р‘Р»СЋРґРѕ СЃРѕС…СЂР°РЅРµРЅРѕ. Р—Р°РІРµСЂС€РёС‚Рµ РѕРїР»Р°С‚Сѓ РІ Р±СЂР°СѓР·РµСЂРµ; СЃС‚Р°С‚СѓСЃ РѕР±РЅРѕРІРёС‚СЃСЏ РїРѕСЃР»Рµ РїРѕРґС‚РІРµСЂР¶РґРµРЅРёСЏ Stripe.';

  @override
  String get mealPaymentContinue => 'РџСЂРѕРґРѕР»Р¶РёС‚СЊ РѕРїР»Р°С‚Сѓ';

  @override
  String get mealPaymentCancel => 'РћС‚РјРµРЅРёС‚СЊ РѕРїР»Р°С‚Сѓ';

  @override
  String get mealPaymentStartAgain => 'РќР°С‡Р°С‚СЊ РѕРїР»Р°С‚Сѓ СЃРЅРѕРІР°';

  @override
  String get mealPaymentCanceled =>
      'РћРїР»Р°С‚Р° РѕС‚РјРµРЅРµРЅР°. РњРѕР¶РЅРѕ РЅР°С‡Р°С‚СЊ Р·Р°РЅРѕРІРѕ.';

  @override
  String get mealPaymentStatusLoadError =>
      'РќРµ СѓРґР°Р»РѕСЃСЊ Р·Р°РіСЂСѓР·РёС‚СЊ СЃС‚Р°С‚СѓСЃ РѕРїР»Р°С‚С‹. РџРѕРїСЂРѕР±СѓР№С‚Рµ СЃРЅРѕРІР°.';

  @override
  String get noActiveEvents => 'РќРµС‚ Р°РєС‚РёРІРЅС‹С… СЃРѕР±С‹С‚РёР№';

  @override
  String get becomeModelTitle =>
      'РќР°С‡РЅРёС‚Рµ РјРѕРґРµР»СЊРЅСѓСЋ РєР°СЂСЊРµСЂСѓ СЂРµР±С‘РЅРєР° СЃРµРіРѕРґРЅСЏ';

  @override
  String get becomeAModel => 'РЎРўРђРўР¬ РњРћР”Р•Р›Р¬Р®';

  @override
  String get latestHighlights => 'РџРѕСЃР»РµРґРЅРёРµ СЃРѕР±С‹С‚РёСЏ';

  @override
  String get viewAll => 'Р’РЎР•';

  @override
  String get quickActions => 'Р‘С‹СЃС‚СЂС‹Рµ РґРµР№СЃС‚РІРёСЏ';

  @override
  String get fillOutApplication => 'Р—Р°РїРѕР»РЅРёС‚СЊ\nР·Р°СЏРІРєСѓ';

  @override
  String get upcomingShows => 'Р‘Р»РёР¶Р°Р№С€РёРµ\nРїРѕРєР°Р·С‹';

  @override
  String get manageKids => 'РњРѕРё\nРґРµС‚Рё';

  @override
  String get navHome => 'Р“Р»Р°РІРЅР°СЏ';

  @override
  String get navEvents => 'РЎРѕР±С‹С‚РёСЏ';

  @override
  String get eventsYoutubeLiveButton => 'YouTube С‚СЂР°РЅСЃР»СЏС†РёСЏ';

  @override
  String get eventsYoutubeLiveInvalidUrl =>
      'РќРµ СѓРґР°Р»РѕСЃСЊ РѕС‚РєСЂС‹С‚СЊ СЌС‚Сѓ СЃСЃС‹Р»РєСѓ YouTube.';

  @override
  String get eventsYoutubeLiveOpenExternally => 'РћС‚РєСЂС‹С‚СЊ РІ YouTube';

  @override
  String get navProfile => 'РџСЂРѕС„РёР»СЊ';

  @override
  String get navInfo => 'РРЅС„Рѕ';

  @override
  String get continueButton => 'РџСЂРѕРґРѕР»Р¶РёС‚СЊ';

  @override
  String get loading => 'Р—Р°РіСЂСѓР·РєР°...';

  @override
  String get signOut => 'Р’С‹Р№С‚Рё';

  @override
  String get tokenValidNext =>
      'РўРѕРєРµРЅ РґРµР№СЃС‚РІРёС‚РµР»РµРЅ. Р”Р°Р»СЊС€Рµ: РіР»Р°РІРЅР°СЏ.';

  @override
  String get homePageTitle => 'Р“Р»Р°РІРЅР°СЏ';

  @override
  String youAreSignedIn(String name) {
    return 'Р’С‹ РІРѕС€Р»Рё$name.';
  }

  @override
  String yourRole(String role) {
    return 'Р’Р°С€Р° СЂРѕР»СЊ: $role';
  }

  @override
  String get phoneHint => '+79001234567';

  @override
  String get enterValidEmailShort =>
      'Р’РІРµРґРёС‚Рµ РєРѕСЂСЂРµРєС‚РЅС‹Р№ email';

  @override
  String get phoneMustStartWithPlusShort =>
      'РўРµР»РµС„РѕРЅ РґРѕР»Р¶РµРЅ РЅР°С‡РёРЅР°С‚СЊСЃСЏ СЃ +';

  @override
  String get comingSoon => 'РЎРєРѕСЂРѕ';

  @override
  String get hello => 'РџСЂРёРІРµС‚';

  @override
  String helloName(String name) {
    return 'РџСЂРёРІРµС‚, $name';
  }

  @override
  String get noRolesAssigned =>
      'Р’Р°Рј РїРѕРєР° РЅРµ РЅР°Р·РЅР°С‡РµРЅС‹ СЂРѕР»Рё. РћР±СЂР°С‚РёС‚РµСЃСЊ Рє Р°РґРјРёРЅРёСЃС‚СЂР°С†РёРё.';

  @override
  String signedInAs(String name) {
    return 'Р’С‹ РІРѕС€Р»Рё РєР°Рє $name';
  }

  @override
  String get birthdateDialogTitle => 'Р”Р°С‚Р° СЂРѕР¶РґРµРЅРёСЏ';

  @override
  String get nextShowsTitle => 'Р‘Р»РёР¶Р°Р№С€РёРµ РїРѕРєР°Р·С‹';

  @override
  String get nextShowsSeason => 'РЎРµР·РѕРЅ 2026';

  @override
  String get details => 'РџРѕРґСЂРѕР±РЅРµРµ';

  @override
  String get contact => 'РЎРІСЏР·Р°С‚СЊСЃСЏ';

  @override
  String get registrationOpen => 'Р РµРіРёСЃС‚СЂР°С†РёСЏ РѕС‚РєСЂС‹С‚Р°';

  @override
  String get myTicketsButton => 'РњРћР Р‘РР›Р•РўР«';

  @override
  String get myTicketsTitle => 'РњРѕРё Р±РёР»РµС‚С‹';

  @override
  String get selectEventForTickets => 'Р’С‹Р±РµСЂРёС‚Рµ РјРµСЂРѕРїСЂРёСЏС‚РёРµ';

  @override
  String get ticketsMomName => 'РРјСЏ СЂРѕРґРёС‚РµР»СЏ';

  @override
  String get ticketsEventDate => 'Р”Р°С‚Р°';

  @override
  String get ticketsOpenPdf => 'РћРўРљР Р«РўР¬';

  @override
  String get ticketsPdfUnavailable => 'PDF РїРѕРєР° РЅРµРґРѕСЃС‚СѓРїРµРЅ';

  @override
  String get ticketsBuy => 'РљРЈРџРРўР¬ Р‘РР›Р•Рў';

  @override
  String get ticketsBuyNoLink =>
      'РЎСЃС‹Р»РєР° РЅР° РїРѕРєСѓРїРєСѓ РЅРµ Р·Р°РґР°РЅР°. РЈРєР°Р¶РёС‚Рµ РІ Р°РґРјРёРЅРєРµ СЃСЃС‹Р»РєСѓ РЅР° РјР°РіР°Р·РёРЅ Р±РёР»РµС‚РѕРІ РґР»СЏ РёРІРµРЅС‚Р° РёР»Рё СЃР°Р№С‚ РІ СЂР°Р·РґРµР»Рµ Info.';

  @override
  String get ticketsBuyCouldNotOpen =>
      'РќРµ СѓРґР°Р»РѕСЃСЊ РѕС‚РєСЂС‹С‚СЊ СЃСЃС‹Р»РєСѓ.';

  @override
  String get ticketsBuySubtitle =>
      'Р”РѕСЃС‚СѓРїРЅС‹ VIP Рё СЃС‚Р°РЅРґР°СЂС‚РЅС‹Рµ РјРµСЃС‚Р°';

  @override
  String get ticketsBuyEmailHint =>
      'Р’Р°С€Рё Р±РёР»РµС‚С‹ РїСЂРёРґСѓС‚ РЅР° СЌР»РµРєС‚СЂРѕРЅРЅСѓСЋ РїРѕС‡С‚Сѓ, СѓРєР°Р·Р°РЅРЅСѓСЋ РїСЂРё РїРѕРєСѓРїРєРµ Р±РёР»РµС‚Р°.';

  @override
  String get extraTicketButton => 'OPEN BAR';

  @override
  String get extraTicketSelectEventFirst =>
      'РЎРЅР°С‡Р°Р»Р° РІС‹Р±РµСЂРёС‚Рµ РёРІРµРЅС‚.';

  @override
  String get extraTicketNoActiveHeadline =>
      'РќР•Рў РђРљРўРР’РќР«РҐ BEVERAGE PACKAGE';

  @override
  String get extraTicketBuyCta => 'РљРЈРџРРўР¬';

  @override
  String get extraTicketAccessOpen =>
      'Р”РћРЎРўРЈРџ Рљ BEVERAGE PACKAGE РћРўРљР Р«Рў';

  @override
  String get extraTicketCheckoutInBrowser =>
      'Р—Р°РІРµСЂС€РёС‚Рµ РѕРїР»Р°С‚Сѓ РІ Р±СЂР°СѓР·РµСЂРµ.';

  @override
  String get extraTicketCheckoutError =>
      'РќРµ СѓРґР°Р»РѕСЃСЊ Р·Р°РїСѓСЃС‚РёС‚СЊ РѕРїР»Р°С‚Сѓ BEVERAGE PACKAGE. РџРѕРїСЂРѕР±СѓР№С‚Рµ СЃРЅРѕРІР°.';

  @override
  String get backstageTicketButton => 'BACKSTAGE PASS';

  @override
  String get backstageTicketSelectEventFirst =>
      'РЎРЅР°С‡Р°Р»Р° РІС‹Р±РµСЂРёС‚Рµ РёРІРµРЅС‚.';

  @override
  String get backstageTicketNoActiveHeadline =>
      'РќР•Рў РђРљРўРР’РќР«РҐ BACKSTAGE PASS';

  @override
  String get backstageTicketBuyCta => 'РљРЈРџРРўР¬';

  @override
  String get backstageTicketAccessOpen =>
      'Р”РћРЎРўРЈРџ Рљ BACKSTAGE PASS РћРўРљР Р«Рў';

  @override
  String get backstageTicketCheckoutInBrowser =>
      'Р—Р°РІРµСЂС€РёС‚Рµ РѕРїР»Р°С‚Сѓ РІ Р±СЂР°СѓР·РµСЂРµ.';

  @override
  String get backstageTicketCheckoutError =>
      'РќРµ СѓРґР°Р»РѕСЃСЊ Р·Р°РїСѓСЃС‚РёС‚СЊ РѕРїР»Р°С‚Сѓ BACKSTAGE PASS. РџРѕРїСЂРѕР±СѓР№С‚Рµ СЃРЅРѕРІР°.';

  @override
  String get ticketsNoEvents =>
      'РџРѕРєР° РЅРµС‚ СЃРѕР±С‹С‚РёР№ СЃ Р±РёР»РµС‚Р°РјРё';

  @override
  String get ticketsNoneForEvent =>
      'РќРµС‚ Р±РёР»РµС‚РѕРІ РЅР° СЌС‚Рѕ СЃРѕР±С‹С‚РёРµ';

  @override
  String get ticketsLoadError =>
      'РќРµ СѓРґР°Р»РѕСЃСЊ Р·Р°РіСЂСѓР·РёС‚СЊ Р±РёР»РµС‚С‹';

  @override
  String get ticketsEventsLoadError =>
      'РќРµ СѓРґР°Р»РѕСЃСЊ Р·Р°РіСЂСѓР·РёС‚СЊ СЃРѕР±С‹С‚РёСЏ';

  @override
  String get faqBrandCatalogTitle => 'Р‘СЂРµРЅРґС‹ РѕРґРµР¶РґС‹';

  @override
  String get pdfViewerTitle => 'Р‘РёР»РµС‚';

  @override
  String get contactFormLinkMissing =>
      'РЎСЃС‹Р»РєР° РЅР° С„РѕСЂРјСѓ РЅРµ Р·Р°РґР°РЅР°. РЈРєР°Р¶РёС‚Рµ В«РЎСЃС‹Р»РєР° РЅР° С„РѕСЂРјСѓВ» РІ РѕР±С‰РёС… РЅР°СЃС‚СЂРѕР№РєР°С… РїСЂРёР»РѕР¶РµРЅРёСЏ РІ Р°РґРјРёРЅРєРµ.';

  @override
  String get infoHubTitle => 'РРЅС„РѕСЂРјР°С†РёРѕРЅРЅС‹Р№ С†РµРЅС‚СЂ';

  @override
  String get infoMenuAboutYfs => 'Рћ YFS';

  @override
  String get infoMenuGeneralFaq => 'РћР±С‰РёР№ FAQ';

  @override
  String get infoMenuContactManager =>
      'РЎРІСЏР·Р°С‚СЊСЃСЏ СЃ РјРµРЅРµРґР¶РµСЂРѕРј';

  @override
  String get infoFooterBrand => 'YFS';

  @override
  String get infoFooterCopyright =>
      'В© 2024 Young Fashion Series. Р’СЃРµ РїСЂР°РІР° Р·Р°С‰РёС‰РµРЅС‹.';

  @override
  String parentProgressLabel(int completed, int total) {
    return 'РџСЂРѕРіСЂРµСЃСЃ СЂРѕРґРёС‚РµР»СЏ: $completed/$total';
  }

  @override
  String get appUpdateRequiredMessage =>
      'РћР±РЅРѕРІРёС‚Рµ РїСЂРёР»РѕР¶РµРЅРёРµ, С‡С‚РѕР±С‹ РїСЂРѕРґРѕР»Р¶РёС‚СЊ.';

  @override
  String get appUpdateButton => 'РћР±РЅРѕРІРёС‚СЊ РїСЂРёР»РѕР¶РµРЅРёРµ';

  @override
  String get showAll => 'РџРѕРєР°Р·Р°С‚СЊ РІСЃРµ';

  @override
  String get chatCouldNotPickPhoto =>
      'РќРµ СѓРґР°Р»РѕСЃСЊ РІС‹Р±СЂР°С‚СЊ С„РѕС‚Рѕ';

  @override
  String get contactManagerIntro =>
      'Р’С‹ РјРѕР¶РµС‚Рµ РѕСЃС‚Р°РІРёС‚СЊ СЃРѕРѕР±С‰РµРЅРёРµ РїРѕ Р»СЋР±РѕРјСѓ РІРѕРїСЂРѕСЃСѓ вЂ” СЃ РІР°РјРё СЃРІСЏР¶СѓС‚СЃСЏ РІ Р±Р»РёР¶Р°Р№С€РµРµ РІСЂРµРјСЏ.';

  @override
  String get contactManagerMessageLabel => 'Р’Р°С€Рµ СЃРѕРѕР±С‰РµРЅРёРµ';

  @override
  String get contactManagerMessageRequired =>
      'Р’РІРµРґРёС‚Рµ С‚РµРєСЃС‚ СЃРѕРѕР±С‰РµРЅРёСЏ';

  @override
  String get contactManagerSend => 'РћС‚РїСЂР°РІРёС‚СЊ';

  @override
  String get contactManagerSent =>
      'РЎРѕРѕР±С‰РµРЅРёРµ РѕС‚РїСЂР°РІР»РµРЅРѕ. РњС‹ СЃРІСЏР¶РµРјСЃСЏ СЃ РІР°РјРё РІ Р±Р»РёР¶Р°Р№С€РµРµ РІСЂРµРјСЏ.';

  @override
  String get contactManagerSendFailed =>
      'РќРµ СѓРґР°Р»РѕСЃСЊ РѕС‚РїСЂР°РІРёС‚СЊ. РџРѕРїСЂРѕР±СѓР№С‚Рµ РїРѕР·Р¶Рµ.';

  @override
  String get contactManagerServiceUnavailable =>
      'РЎРІСЏР·СЊ РІСЂРµРјРµРЅРЅРѕ РЅРµРґРѕСЃС‚СѓРїРЅР°. РџРѕРїСЂРѕР±СѓР№С‚Рµ РїРѕР·Р¶Рµ.';

  @override
  String get close => 'Р—Р°РєСЂС‹С‚СЊ';
}
