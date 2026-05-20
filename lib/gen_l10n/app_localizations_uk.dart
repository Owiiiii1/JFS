// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Ukrainian (`uk`).
class AppLocalizationsUk extends AppLocalizations {
  AppLocalizationsUk([String locale = 'uk']) : super(locale);

  @override
  String get signIn => 'РЈРІС–Р№С‚Рё';

  @override
  String get signUp => 'Р РµС”СЃС‚СЂР°С†С–СЏ';

  @override
  String get email => 'Р•Р»РµРєС‚СЂРѕРЅРЅР° РїРѕС€С‚Р°';

  @override
  String get password => 'РџР°СЂРѕР»СЊ';

  @override
  String get emailRequired => 'Р’РІРµРґС–С‚СЊ email';

  @override
  String get enterValidEmail => 'Р’РІРµРґС–С‚СЊ РєРѕСЂРµРєС‚РЅРёР№ email';

  @override
  String get passwordRequired => 'Р’РІРµРґС–С‚СЊ РїР°СЂРѕР»СЊ';

  @override
  String get hidePassword => 'РџСЂРёС…РѕРІР°С‚Рё РїР°СЂРѕР»СЊ';

  @override
  String get showPassword => 'РџРѕРєР°Р·Р°С‚Рё РїР°СЂРѕР»СЊ';

  @override
  String signInFailed(String error) {
    return 'РџРѕРјРёР»РєР° РІС…РѕРґСѓ: $error';
  }

  @override
  String get apiEndpointNotFoundHint =>
      'РЎРµСЂРІРµСЂ РЅРµ Р·РЅР°Р№С€РѕРІ API (404). РЈ Р·Р±С–СЂС†С– РІРєР°Р¶С–С‚СЊ РєРѕСЂС–РЅСЊ СЃР°Р№С‚Сѓ Р±РµР· В«/apiВ» РІ РєС–РЅС†С– вЂ” Р·Р°СЃС‚РѕСЃСѓРЅРѕРє СЃР°Рј Р·РІРµСЂС‚Р°С”С‚СЊСЃСЏ РґРѕ /api/app/login. РЇРєС‰Рѕ Laravel Сѓ РїС–РґРїР°РїС†С–, РґРѕРґР°Р№С‚Рµ С€Р»СЏС… РґРѕ РєР°С‚Р°Р»РѕРіСѓ public (РЅР°РїСЂРёРєР»Р°Рґ https://example.com/myapp/public).';

  @override
  String get notificationsTitle => 'РЎРїРѕРІС–С‰РµРЅРЅСЏ';

  @override
  String get notificationsLoadFailed =>
      'РќРµ РІРґР°Р»РѕСЃСЏ Р·Р°РІР°РЅС‚Р°Р¶РёС‚Рё СЃРїРѕРІС–С‰РµРЅРЅСЏ. РЎРїСЂРѕР±СѓР№С‚Рµ С‰Рµ СЂР°Р·.';

  @override
  String get notificationsEmpty => 'РџРѕРєРё РЅРµРјР°С” СЃРїРѕРІС–С‰РµРЅСЊ.';

  @override
  String get notificationsNewMark => 'РќРѕРІРµ';

  @override
  String get notificationDetailsTitle => 'РЎРїРѕРІС–С‰РµРЅРЅСЏ';

  @override
  String get createAccount => 'РЎС‚РІРѕСЂРёС‚Рё РѕР±Р»С–РєРѕРІРёР№ Р·Р°РїРёСЃ';

  @override
  String get name => 'Р†Рј\'СЏ';

  @override
  String get registerNameLabel =>
      'Р’РІРµРґС–С‚СЊ С–Рј\'СЏ С‚Р° РїСЂС–Р·РІРёС‰Рµ';

  @override
  String get nameRequired => 'Р’РІРµРґС–С‚СЊ С–Рј\'СЏ';

  @override
  String get phone => 'РўРµР»РµС„РѕРЅ';

  @override
  String get phoneRequired => 'Р’РІРµРґС–С‚СЊ С‚РµР»РµС„РѕРЅ';

  @override
  String get phoneMustStartWithPlus =>
      'РўРµР»РµС„РѕРЅ РїРѕРІРёРЅРµРЅ РїРѕС‡РёРЅР°С‚РёСЃСЏ Р· +';

  @override
  String get enterValidPhone =>
      'Р’РІРµРґС–С‚СЊ РєРѕСЂРµРєС‚РЅРёР№ РЅРѕРјРµСЂ С‚РµР»РµС„РѕРЅСѓ';

  @override
  String get confirmPassword => 'РџС–РґС‚РІРµСЂРґС–С‚СЊ РїР°СЂРѕР»СЊ';

  @override
  String get passwordsDoNotMatch => 'РџР°СЂРѕР»С– РЅРµ Р·Р±С–РіР°СЋС‚СЊСЃСЏ';

  @override
  String get passwordMinLength =>
      'РџР°СЂРѕР»СЊ РЅРµ РјРµРЅС€Рµ 8 СЃРёРјРІРѕР»С–РІ';

  @override
  String get atLeast8Chars => 'РќРµ РјРµРЅС€Рµ 8 СЃРёРјРІРѕР»С–РІ';

  @override
  String get backToSignIn => 'РџРѕРІРµСЂРЅСѓС‚РёСЃСЏ РґРѕ РІС…РѕРґСѓ';

  @override
  String registrationFailed(String error) {
    return 'РџРѕРјРёР»РєР° СЂРµС”СЃС‚СЂР°С†С–С—: $error';
  }

  @override
  String get loginPasswordOptionalHint =>
      'РЇРєС‰Рѕ РїСЂРѕС„С–Р»СЊ СЃС‚РІРѕСЂРёРІ Р°РґРјС–РЅ Р°Р±Рѕ С–РјРїРѕСЂС‚, Р·Р°Р»РёС€С‚Рµ РїР°СЂРѕР»СЊ РїРѕСЂРѕР¶РЅС–Рј С– РїСЂРѕРґРѕРІР¶СѓР№С‚Рµ.';

  @override
  String get setPasswordTitle => 'РЎС‚РІРѕСЂРµРЅРЅСЏ РїР°СЂРѕР»СЏ';

  @override
  String setPasswordSubtitle(String email) {
    return 'РЎС‚РІРѕСЂС–С‚СЊ РїР°СЂРѕР»СЊ РґР»СЏ $email';
  }

  @override
  String get passwordSetupMinLength =>
      'РџР°СЂРѕР»СЊ РјР°С” Р±СѓС‚Рё РЅРµ РјРµРЅС€Рµ 6 СЃРёРјРІРѕР»С–РІ';

  @override
  String get savePasswordAndContinue =>
      'Р—Р±РµСЂРµРіС‚Рё РїР°СЂРѕР»СЊ С– РїСЂРѕРґРѕРІР¶РёС‚Рё';

  @override
  String passwordSetupFailed(String error) {
    return 'РќРµ РІРґР°Р»РѕСЃСЏ СЃС‚РІРѕСЂРёС‚Рё РїР°СЂРѕР»СЊ: $error';
  }

  @override
  String get account => 'РћР±Р»С–РєРѕРІРёР№ Р·Р°РїРёСЃ';

  @override
  String get editInfo => 'Р Р•Р”РђР“РЈР’РђРўР';

  @override
  String get fullName => 'Р†Рј\'СЏ';

  @override
  String get retry => 'РџРѕРІС‚РѕСЂРёС‚Рё';

  @override
  String get accountSettings =>
      'РќР°Р»Р°С€С‚СѓРІР°РЅРЅСЏ РѕР±Р»С–РєРѕРІРѕРіРѕ Р·Р°РїРёСЃСѓ';

  @override
  String get editProfile => 'Р РµРґР°РіСѓРІР°С‚Рё РїСЂРѕС„С–Р»СЊ';

  @override
  String get deleteAccount => 'Р’РёРґР°Р»РёС‚Рё Р°РєР°СѓРЅС‚';

  @override
  String get deleteAccountConfirmTitle => 'Р’РёРґР°Р»РёС‚Рё Р°РєР°СѓРЅС‚?';

  @override
  String get deleteAccountConfirmMessage =>
      'Р’Рё РІРїРµРІРЅРµРЅС–, С‰Рѕ С…РѕС‡РµС‚Рµ РЅР°Р·Р°РІР¶РґРё РІРёРґР°Р»РёС‚Рё Р°РєР°СѓРЅС‚? Р¦СЋ РґС–СЋ РЅРµРјРѕР¶Р»РёРІРѕ СЃРєР°СЃСѓРІР°С‚Рё.';

  @override
  String get deleteAccountSecondTitle => 'Р©Рѕ Р±СѓРґРµ РІРёРґР°Р»РµРЅРѕ';

  @override
  String get deleteAccountSecondMessage =>
      'Р‘СѓРґРµ Р±РµР·РїРѕРІРѕСЂРѕС‚РЅРѕ РІРёРґР°Р»РµРЅРѕ Р· РЅР°С€РёС… СЃРёСЃС‚РµРј:\n\nвЂў РІР°С€ Р°РєР°СѓРЅС‚ С– РїСЂРѕС„С–Р»СЊ;\nвЂў СѓСЃС– РґС–С‚Рё, РїСЂРёРІвЂ™СЏР·Р°РЅС– РґРѕ Р°РєР°СѓРЅС‚Сѓ;\nвЂў СѓСЃС– РїСЂРёР·РЅР°С‡РµРЅРЅСЏ РЅР° Р·Р°С…РѕРґРё, РїСЂРѕРіСЂРµСЃ РїРѕ РµС‚Р°РїР°С…, РєРІРёС‚РєРё С‚Р° РІРёР±С–СЂ РѕР±С–РґС–РІ;\nвЂў С„РѕС‚РѕРіСЂР°С„С–С— С‚Р° С–РЅС€С– РґР°РЅС– РґС–С‚РµР№;\nвЂў СѓС‡Р°СЃС‚СЊ Сѓ С‡Р°С‚Р°С… Р·Р°С…РѕРґС–РІ С– СЃРїРѕРІС–С‰РµРЅРЅСЏ РІ Р·Р°СЃС‚РѕСЃСѓРЅРєСѓ.\n\nР”РµСЏРєС– РїР»Р°С‚С–Р¶РЅС– Р°Р±Рѕ Р±СѓС…РіР°Р»С‚РµСЂСЃСЊРєС– Р·Р°РїРёСЃРё РјРѕР¶СѓС‚СЊ Р·Р±РµСЂС–РіР°С‚РёСЃСЏ, СЏРєС‰Рѕ С†СЊРѕРіРѕ РІРёРјР°РіР°С” Р·Р°РєРѕРЅ.';

  @override
  String get deleteAccountContinue => 'Р”Р°Р»С–';

  @override
  String get deleteAccountConfirmAction => 'Р’РёРґР°Р»РёС‚Рё РЅР°Р·Р°РІР¶РґРё';

  @override
  String get deleteAccountWorking => 'Р’РёРґР°Р»РµРЅРЅСЏ Р°РєР°СѓРЅС‚Р°вЂ¦';

  @override
  String get save => 'Р—Р±РµСЂРµРіС‚Рё';

  @override
  String get edit => 'Р РµРґР°РіСѓРІР°С‚Рё';

  @override
  String get role => 'Р РѕР»СЊ';

  @override
  String get myChildren => 'РњРѕС— РґС–С‚Рё';

  @override
  String get addChild => 'Р”РѕРґР°С‚Рё РґРёС‚РёРЅСѓ';

  @override
  String get noChildrenAddedYet => 'Р”С–С‚РµР№ РїРѕРєРё РЅРµ РґРѕРґР°РЅРѕ';

  @override
  String get ageLabel => 'Р’С–Рє';

  @override
  String get settings => 'РќР°Р»Р°С€С‚СѓРІР°РЅРЅСЏ';

  @override
  String get aboutTheApp => 'РџСЂРѕ Р·Р°СЃС‚РѕСЃСѓРЅРѕРє';

  @override
  String get aboutAppDisplayName => 'YoungFashionShow';

  @override
  String get aboutPublisherLine => 'YOUNGFASHIONSHOW';

  @override
  String get aboutVersionLabel => 'Р’Р•Р РЎР†РЇ';

  @override
  String get aboutReleaseDateLabel => 'Р”РђРўРђ Р’РРџРЈРЎРљРЈ';

  @override
  String get aboutDevelopedByPrefix => 'Р РћР—Р РћР‘Р›Р•РќРћ:';

  @override
  String get aboutDeveloperBrand => 'OWLSOLUTIONS';

  @override
  String get aboutLinkCouldNotOpen =>
      'РќРµ РІРґР°Р»РѕСЃСЏ РІС–РґРєСЂРёС‚Рё РїРѕСЃРёР»Р°РЅРЅСЏ.';

  @override
  String get appLanguage => 'РњРѕРІР° Р·Р°СЃС‚РѕСЃСѓРЅРєСѓ';

  @override
  String get unitsOfMeasurement => 'РћРґРёРЅРёС†С– РІРёРјС–СЂСѓ';

  @override
  String get timeDisplayFormat => 'Р¤РѕСЂРјР°С‚ С‡Р°СЃСѓ';

  @override
  String get timeFormat24Hour => '24-РіРѕРґРёРЅРЅРёР№';

  @override
  String get timeFormat12Hour => '12-РіРѕРґРёРЅРЅРёР№ (AM/PM)';

  @override
  String get metricUnits => 'РњРµС‚СЂРёС‡РЅС– (СЃРј, РєРі)';

  @override
  String get imperialUnits => 'РђРјРµСЂРёРєР°РЅСЃСЊРєС– (in, lb)';

  @override
  String get systemLanguage => 'РЎРёСЃС‚РµРјРЅР°';

  @override
  String get languageRussian => 'Р СѓСЃСЃРєРёР№';

  @override
  String get languageEnglish => 'РђРЅРіР»С–Р№СЃСЊРєР°';

  @override
  String get languageUkrainian => 'РЈРєСЂР°С—РЅСЃСЊРєР°';

  @override
  String get languageSpanishUS => 'Р†СЃРїР°РЅСЃСЊРєР° (РЎРЁРђ)';

  @override
  String get addChildTitle => 'Р”РѕРґР°С‚Рё РґРёС‚РёРЅСѓ';

  @override
  String get firstName => 'Р†Рј\'СЏ';

  @override
  String get gender => 'РЎС‚Р°С‚СЊ';

  @override
  String get genderBoy => 'РҐР»РѕРїС‡РёРє';

  @override
  String get genderGirl => 'Р”С–РІС‡РёРЅРєР°';

  @override
  String get lastName => 'РџСЂС–Р·РІРёС‰Рµ';

  @override
  String get birthdate => 'Р”Р°С‚Р° РЅР°СЂРѕРґР¶РµРЅРЅСЏ';

  @override
  String get chooseDate => 'РћР±РµСЂС–С‚СЊ РґР°С‚Сѓ';

  @override
  String get create => 'РЎС‚РІРѕСЂРёС‚Рё';

  @override
  String get enterFirstName => 'Р’РІРµРґС–С‚СЊ С–Рј\'СЏ';

  @override
  String get mainPhoto => 'РћСЃРЅРѕРІРЅРµ С„РѕС‚Рѕ';

  @override
  String get changePhoto => 'Р—РјС–РЅРёС‚Рё';

  @override
  String get deletePhoto => 'Р’РёРґР°Р»РёС‚Рё';

  @override
  String get addPhoto => 'Р”РѕРґР°С‚Рё С„РѕС‚Рѕ';

  @override
  String get photoSaved => 'Р¤РѕС‚Рѕ Р·Р±РµСЂРµР¶РµРЅРѕ';

  @override
  String get photoDeleted => 'Р¤РѕС‚Рѕ РІРёРґР°Р»РµРЅРѕ';

  @override
  String get photoAdded => 'Р¤РѕС‚Рѕ РґРѕРґР°РЅРѕ';

  @override
  String get extraPhotos => 'Р”РѕРґР°С‚РєРѕРІС– С„РѕС‚Рѕ';

  @override
  String get cancel => 'РЎРєР°СЃСѓРІР°С‚Рё';

  @override
  String get clear => 'РћС‡РёСЃС‚РёС‚Рё';

  @override
  String get height => 'Р—СЂС–СЃС‚';

  @override
  String get weight => 'Р’Р°РіР°';

  @override
  String get shoulders => 'РџР»РµС‡С–';

  @override
  String get chest => 'Р“СЂСѓРґРё';

  @override
  String get waist => 'РўР°Р»С–СЏ';

  @override
  String get hips => 'РЎС‚РµРіРЅР°';

  @override
  String get measurementLengthUnitCm => 'СЃРј';

  @override
  String get measurementLengthUnitIn => 'РґСЋР№Рј';

  @override
  String get currentParticipation => 'РџРѕС‚РѕС‡РЅР° СѓС‡Р°СЃС‚СЊ';

  @override
  String childSubscribedBrands(String brands) {
    return 'Р‘СЂРµРЅРґРё: $brands';
  }

  @override
  String get unknownError => 'РќРµРІС–РґРѕРјР° РїРѕРјРёР»РєР°';

  @override
  String model(String name) {
    return 'РњРѕРґРµР»СЊ: $name';
  }

  @override
  String get active => 'РђРљРўРР’РќРћ';

  @override
  String get familyLabel => 'FAMILY';

  @override
  String get familyJoinButton => 'РџР РР„Р”РќРђРўРРЎРЇ Р”Рћ РЎР†РњКјР‡';

  @override
  String get familyJoinDialogHint =>
      'Р’РІРµРґС–С‚СЊ 6-Р·РЅР°С‡РЅРёР№ СЃС–РјРµР№РЅРёР№ РєРѕРґ.';

  @override
  String get familyJoinAction => 'РџС–РґРєР»СЋС‡РёС‚РёСЃСЏ';

  @override
  String get familyJoinInvalidCode =>
      'Р’РІРµРґС–С‚СЊ РєРѕСЂРµРєС‚РЅРёР№ 6-Р·РЅР°С‡РЅРёР№ РєРѕРґ.';

  @override
  String get familyJoinSuccess =>
      'РЎС–РјРµР№РЅСѓ РїС–РґРїРёСЃРєСѓ РїС–РґРєР»СЋС‡РµРЅРѕ.';

  @override
  String get contractWarningTitle => 'РџРѕРїРµСЂРµРґР¶РµРЅРЅСЏ';

  @override
  String get contractWarningFallbackText =>
      'РџРµСЂРµРґ РєСѓРїС–РІР»РµСЋ РєРІРёС‚РєС–РІ РѕР·РЅР°Р№РѕРјС‚РµСЃСЊ С– РїС–РґРїРёС€С–С‚СЊ РґРѕРіРѕРІС–СЂ.';

  @override
  String get contractViewButton => 'РџРµСЂРµРіР»СЏРЅСѓС‚Рё';

  @override
  String get contractPreviewTitle => 'РўРµРєСЃС‚ РґРѕРіРѕРІРѕСЂСѓ';

  @override
  String get contractSignButton => 'РџС–РґРїРёСЃР°С‚Рё';

  @override
  String get contractSignatureTitle => 'РџРѕСЃС‚Р°РІС‚Рµ РїС–РґРїРёСЃ';

  @override
  String get contractSignedSuccess =>
      'Р”РѕРіРѕРІС–СЂ СѓСЃРїС–С€РЅРѕ РїС–РґРїРёСЃР°РЅРѕ.';

  @override
  String get journeyProgress => 'РџР РћР“Р Р•РЎ';

  @override
  String get journeyPreparationPhase => 'РџР†Р”Р“РћРўРћР’РљРђ';

  @override
  String get journeyMainEventTitle => 'РћРЎРќРћР’РќРђ РџРћР”Р†РЇ';

  @override
  String get journeyMainEventSubtitle => 'Р“РћР›РћР’РќР• РЁРћРЈ';

  @override
  String stepOf(int completed, int total) {
    return 'РљСЂРѕРє $completed Р· $total';
  }

  @override
  String next(String text) {
    return 'Р”Р°Р»С–: $text';
  }

  @override
  String get viewProgress => 'РџР•Р Р•Р“Р›РЇРќРЈРўР РџР РћР“Р Р•РЎ';

  @override
  String get eventSettings => 'РќРђР›РђРЁРўРЈР’РђРќРќРЇ Р†Р’Р•РќРўРЈ';

  @override
  String get homeEventCardMyEvent => 'РњР†Р™ Р†Р’Р•РќРў';

  @override
  String get homeEventCardRunwayJourney => 'РЁР›РЇРҐ РќРђ РџРћР”Р†РЈРњ';

  @override
  String get eventSettingsPlaceholder =>
      'РўСѓС‚ РЅРµР·Р°Р±Р°СЂРѕРј Р·вЂ™СЏРІР»СЏС‚СЊСЃСЏ РЅР°Р»Р°С€С‚СѓРІР°РЅРЅСЏ С–РІРµРЅС‚Сѓ.';

  @override
  String get eventSettingsConfigurationPortal =>
      'РџРћР РўРђР› РќРђР›РђРЁРўРЈР’РђРќР¬';

  @override
  String get eventSettingsMainHeadline =>
      'РќР°Р»Р°С€С‚СѓРІР°РЅРЅСЏ С–РІРµРЅС‚Сѓ';

  @override
  String get eventSettingsFamilyButton => 'РЎС–РјКјСЏ';

  @override
  String get familyManageTitle => 'РЎС–РјКјСЏ';

  @override
  String get familyManageEnabled =>
      'РђРєС‚РёРІСѓРІР°С‚Рё СЃС–РјРµР№РЅС– РїС–РґРєР»СЋС‡РµРЅРЅСЏ';

  @override
  String get familyManageCodeLabel => 'РЎС–РјРµР№РЅРёР№ РєРѕРґ';

  @override
  String get familyManageRegenerateCode => 'Р—РјС–РЅРёС‚Рё РєРѕРґ';

  @override
  String get familyManageConnectionsTitle =>
      'РђРєС‚РёРІРЅС– СЃС–РјРµР№РЅС– РїС–РґРєР»СЋС‡РµРЅРЅСЏ';

  @override
  String get familyManageNoConnections =>
      'РђРєС‚РёРІРЅРёС… СЃС–РјРµР№РЅРёС… РїС–РґРєР»СЋС‡РµРЅСЊ РїРѕРєРё РЅРµРјР°С”.';

  @override
  String get familyManageUnknownUser =>
      'РќРµРІС–РґРѕРјРёР№ РєРѕСЂРёСЃС‚СѓРІР°С‡';

  @override
  String get eventSettingsLeaveFamilyButton =>
      'Р’С–РґРєР»СЋС‡РёС‚РёСЃСЏ РІС–Рґ СЃС–РјКјС—';

  @override
  String get eventSettingsLeaveFamilyConfirmTitle =>
      'Р’С–РґРєР»СЋС‡РёС‚Рё СЃС–РјРµР№РЅРёР№ РґРѕСЃС‚СѓРї?';

  @override
  String get eventSettingsLeaveFamilyConfirmText =>
      'Р’Рё РІС‚СЂР°С‚РёС‚Рµ СЃС–РјРµР№РЅРёР№ РґРѕСЃС‚СѓРї РґРѕ С–РІРµРЅС‚Сѓ, РґРѕРєРё РЅРµ РїС–РґРєР»СЋС‡РёС‚РµСЃСЊ Р·РЅРѕРІСѓ Р·Р° РєРѕРґРѕРј.';

  @override
  String get eventSettingsLeaveFamilySuccess =>
      'РЎС–РјРµР№РЅРµ РїС–РґРєР»СЋС‡РµРЅРЅСЏ РІС–РґРєР»СЋС‡РµРЅРѕ.';

  @override
  String get eventSettingsMealTitle => 'Р’РёР±С–СЂ С…Р°СЂС‡СѓРІР°РЅРЅСЏ';

  @override
  String get eventSettingsMealSubtitle =>
      'РћР±РµСЂС–С‚СЊ СЃС‚СЂР°РІСѓ РЅР° РїРѕС‚РѕС‡РЅРёР№ С–РІРµРЅС‚';

  @override
  String get eventSettingsMealCta => 'РњР•РќР®';

  @override
  String eventSettingsMealOrderedPcs(int count) {
    return 'Р—Р°РјРѕРІР»РµРЅРѕ: $count С€С‚.';
  }

  @override
  String get eventSettingsMealPurchasesListHeading =>
      'РћС„РѕСЂРјР»РµРЅС– Р·Р°РјРѕРІР»РµРЅРЅСЏ';

  @override
  String eventSettingsMealPurchaseChildLine(String name) {
    return 'Р”РёС‚РёРЅР°: $name';
  }

  @override
  String get mealPurchaseIssued => 'Р’РёРґР°РЅРѕ';

  @override
  String get mealPurchaseNotIssued => 'Р©Рµ РЅРµ РІРёРґР°РЅРѕ';

  @override
  String get eventSettingsRehearsalTitle =>
      'Р—Р°РїРёСЃ РЅР° СЂРµРїРµС‚РёС†С–СЋ';

  @override
  String get eventSettingsRehearsalSubtitle =>
      'Р—Р°Р±СЂРѕРЅСЋР№С‚Рµ РјС–СЃС†Рµ РЅР° СЂРµРїРµС‚РёС†С–СЋ';

  @override
  String get eventSettingsRehearsalCta => 'Р—РђРџРРЎРђРўРРЎРЇ';

  @override
  String get eventSettingsBrandRehearsalsHeading =>
      'Р’Р°С€С– СЂРµРїРµС‚РёС†С–С— Р±СЂРµРЅРґС–РІ';

  @override
  String get rehearsalModalTitle => 'Р—Р°РїРёСЃ РЅР° СЂРµРїРµС‚РёС†С–СЋ';

  @override
  String get rehearsalSelectDate => 'РћР±РµСЂС–С‚СЊ РґР°С‚Сѓ';

  @override
  String get rehearsalAvailableSlots => 'Р”РѕСЃС‚СѓРїРЅС– СЃР»РѕС‚Рё';

  @override
  String get rehearsalFreeLabel => 'Р’С–Р»СЊРЅРѕ:';

  @override
  String get rehearsalNoSlotsConfigured =>
      'Р”Р»СЏ С†СЊРѕРіРѕ С–РІРµРЅС‚Сѓ С‰Рµ РЅРµРјР°С” СЃР»РѕС‚С–РІ СЂРµРїРµС‚РёС†С–Р№.';

  @override
  String get rehearsalLoadError =>
      'РќРµ РІРґР°Р»РѕСЃСЏ Р·Р°РІР°РЅС‚Р°Р¶РёС‚Рё СЃР»РѕС‚Рё. РЎРїСЂРѕР±СѓР№С‚Рµ С‰Рµ СЂР°Р·.';

  @override
  String get rehearsalBrandNotAssigned =>
      'Р”Р»СЏ С†С–С”С— РґРёС‚РёРЅРё РЅРµ РїСЂРёР·РЅР°С‡РµРЅРѕ Р±СЂРµРЅРґ. Р‘СЂРѕРЅСЋРІР°РЅРЅСЏ СЂРµРїРµС‚РёС†С–Р№ РЅРµРґРѕСЃС‚СѓРїРЅРµ.';

  @override
  String get rehearsalFull => 'РњС–СЃС†СЊ РЅРµРјР°С”';

  @override
  String get rehearsalConfirmBooking => 'РџС–РґС‚РІРµСЂРґРёС‚Рё Р·Р°РїРёСЃ';

  @override
  String get rehearsalBookingFooterNote =>
      'Р—Р° РјРѕР¶Р»РёРІРѕСЃС‚С– Р·РјС–РЅРё РІРЅРѕСЃСЊС‚Рµ Р·Р° 24 РіРѕРґРёРЅРё РґРѕ СЃР»РѕС‚Сѓ.';

  @override
  String get rehearsalBookedTitle =>
      'Р РµРїРµС‚РёС†С–СЋ Р·Р°Р±СЂРѕРЅСЊРѕРІР°РЅРѕ';

  @override
  String get rehearsalChangeBooking => 'Р—РјС–РЅРёС‚Рё Р±СЂРѕРЅСЋРІР°РЅРЅСЏ';

  @override
  String get rehearsalProgramLabel => 'РћРїРёСЃ';

  @override
  String get rehearsalArriveEarly =>
      'РџСЂРёС…РѕРґСЊС‚Рµ Р·Р° 15 С…РІРёР»РёРЅ РґРѕ РїРѕС‡Р°С‚РєСѓ.';

  @override
  String get rehearsalBookingSaved => 'Р—Р°РїРёСЃ Р·Р±РµСЂРµР¶РµРЅРѕ';

  @override
  String get rehearsalBookingError =>
      'РќРµ РІРґР°Р»РѕСЃСЏ Р·Р°РІРµСЂС€РёС‚Рё Р·Р°РїРёСЃ.';

  @override
  String get rehearsalSelectChild => 'Р”РёС‚РёРЅР°';

  @override
  String get rehearsalUpdateBooking =>
      'Р”РѕРґР°С‚Рё Р№ РѕРЅРѕРІРёС‚Рё Р±СЂРѕРЅСЋРІР°РЅРЅСЏ';

  @override
  String get rehearsalCancelChange => 'РЎРєР°СЃСѓРІР°С‚Рё';

  @override
  String get rehearsalChangeBookingLockedHint =>
      'РћСЂРіР°РЅС–Р·Р°С‚РѕСЂ Р·Р°РєСЂРёРІ Р·РјС–РЅСѓ Р·Р°РїРёСЃСѓ. Р—РІРµСЂРЅС–С‚СЊСЃСЏ РІ РїС–РґС‚СЂРёРјРєСѓ, СЏРєС‰Рѕ РїРѕС‚СЂС–Р±РЅР° РґРѕРїРѕРјРѕРіР°.';

  @override
  String get rehearsalMilestoneTitle => 'Р—Р°РіР°Р»СЊРЅР° СЂРµРїРµС‚РёС†С–СЏ';

  @override
  String rehearsalBrandMilestoneTitle(String brandName) {
    return 'Р РµРїРµС‚РёС†С–СЏ Р±СЂРµРЅРґСѓ: $brandName';
  }

  @override
  String get rehearsalBrandMilestoneShort => 'Р РµРїРµС‚РёС†С–СЏ Р±СЂРµРЅРґСѓ';

  @override
  String get rehearsalNextBookHint =>
      'Р—Р°РїРёС€С–С‚СЊСЃСЏ РЅР° СЂРµРїРµС‚РёС†С–СЋ РІ РЅР°Р»Р°С€С‚СѓРІР°РЅРЅСЏС… С–РІРµРЅС‚Сѓ.';

  @override
  String get eventSettingsPackingTitle =>
      'РЎРїРёСЃРѕРє В«РќРµ Р·Р°Р±СѓРґСЊС‚РµВ»';

  @override
  String get eventSettingsPackingSubtitle => '';

  @override
  String get eventSettingsPackingCta => 'Р’Р†Р”РљР РРўР РЎРџРРЎРћРљ';

  @override
  String get eventPackingLoadFailed =>
      'РќРµ РІРґР°Р»РѕСЃСЏ Р·Р°РІР°РЅС‚Р°Р¶РёС‚Рё С–РЅС„РѕСЂРјР°С†С–СЋ. РЎРїСЂРѕР±СѓР№С‚Рµ С‰Рµ СЂР°Р·.';

  @override
  String get eventPackingEmpty =>
      'Р”Р»СЏ С†СЊРѕРіРѕ С–РІРµРЅС‚Сѓ С–РЅС„РѕСЂРјР°С†С–СЋ С‰Рµ РЅРµ РґРѕРґР°РЅРѕ.';

  @override
  String get eventDescriptionTitle => 'РћРїРёСЃ С–РІРµРЅС‚Сѓ';

  @override
  String get eventProgressShowGallery => 'Р“Р°Р»РµСЂРµСЏ';

  @override
  String get eventProgressCheckin => 'Р§РµРєС–РЅ';

  @override
  String get eventProgressCheckinPrompt =>
      'Р’С–РґСЃРєР°РЅСѓР№С‚Рµ РґР»СЏ СЃС‚Р°СЂС‚Сѓ С–РІРµРЅС‚Сѓ';

  @override
  String get eventProgressCheckinUnavailable =>
      'Р§РµРєС–РЅ-РєРѕРґ РїРѕРєРё РЅРµРґРѕСЃС‚СѓРїРЅРёР№.';

  @override
  String get eventDescriptionLoadFailed =>
      'РќРµ РІРґР°Р»РѕСЃСЏ Р·Р°РІР°РЅС‚Р°Р¶РёС‚Рё РѕРїРёСЃ. РЎРїСЂРѕР±СѓР№С‚Рµ С‰Рµ СЂР°Р·.';

  @override
  String get eventDescriptionEmpty =>
      'Р”Р»СЏ С†СЊРѕРіРѕ С–РІРµРЅС‚Сѓ С‰Рµ РЅРµ РґРѕРґР°РЅРѕ С‚РµРєСЃС‚РѕРІРѕРіРѕ РѕРїРёСЃСѓ.';

  @override
  String get eventSettingsBrandTitle => 'Р’Р·СѓС‚С‚СЏ С‚Р° С€РєР°СЂРїРµС‚РєРё';

  @override
  String get eventSettingsBrandSubtitle =>
      'РћР·РЅР°Р№РѕРјС‚РµСЃСЏ Р· СЂРµРєРѕРјРµРЅРґР°С†С–СЏРјРё Р±СЂРµРЅРґСѓ РґР»СЏ СѓС‡Р°СЃС‚С– РІ С–РІРµРЅС‚С–';

  @override
  String get eventSettingsBrandCta => 'РљР•Р Р†Р’РќРР¦РўР’Рћ';

  @override
  String get brandRequirementsLoadFailed =>
      'РќРµ РІРґР°Р»РѕСЃСЏ Р·Р°РІР°РЅС‚Р°Р¶РёС‚Рё РІРёРјРѕРіРё Р±СЂРµРЅРґСѓ. РЎРїСЂРѕР±СѓР№С‚Рµ С‰Рµ СЂР°Р·.';

  @override
  String get brandRequirementsEmpty =>
      'Р”Р»СЏ С†СЊРѕРіРѕ С–РІРµРЅС‚Сѓ РІРёРјРѕРіРё Р±СЂРµРЅРґС–РІ С‰Рµ РЅРµ РґРѕРґР°РЅС–.';

  @override
  String get brandRequirementsEmptyItem =>
      'Р”Р»СЏ С†СЊРѕРіРѕ Р±СЂРµРЅРґСѓ РІРёРјРѕРіРё С‰Рµ РЅРµ Р·Р°РїРѕРІРЅРµРЅС–.';

  @override
  String get brandRequirementsPickBrandTitle => 'РћР±РµСЂС–С‚СЊ Р±СЂРµРЅРґ';

  @override
  String brandRequirementsBrandNumber(int brandId) {
    return 'Р‘СЂРµРЅРґ $brandId';
  }

  @override
  String get eventSettingsParkingTitle => 'Р’Р°Р»РµС‚-РїР°СЂРєСѓРІР°РЅРЅСЏ';

  @override
  String get eventSettingsParkingSubtitle =>
      'Р’С–РґРєСЂРёР№С‚Рµ РїСЂРѕРїСѓСЃРє РЅР° РІР°Р»РµС‚-РїР°СЂРєСѓРІР°РЅРЅСЏ Р№ СЃС‚Р°С‚СѓСЃ РїСЂРёР±СѓС‚С‚СЏ';

  @override
  String get eventSettingsParkingCta =>
      'Р’Р†Р”РљР РРўР Р’РђР›Р•Рў-РџРђР РљРЈР’РђРќРќРЇ';

  @override
  String get parkingChooseModeTitle =>
      'Р РµР¶РёРј РІР°Р»РµС‚-РїР°СЂРєСѓРІР°РЅРЅСЏ';

  @override
  String get parkingChooseModeHint =>
      'РћР±РµСЂС–С‚СЊ СЃС‚Р°РЅ РµРєСЂР°РЅР° РґР»СЏ С‚РµСЃС‚Сѓ РІС–Р·СѓР°Р»Сѓ.';

  @override
  String get parkingModeInactive => 'РќР• РђРљРўРР’РќРћ';

  @override
  String get parkingModeActive => 'РђРљРўРР’РќРћ';

  @override
  String get parkingInactiveHeadline =>
      'Р’РђР›Р•Рў-РџРђР РљРЈР’РђРќРќРЇ РќР• РђРљРўРР’РќР•';

  @override
  String get parkingInactiveBody =>
      'Р’РђР›Р•Рў-РџРђР РљРЈР’РђРќРќРЇ Р—\'РЇР’РРўР¬РЎРЇ РўРЈРў РџР†РЎР›РЇ РљРЈРџР†Р’Р›Р† РљР’РРўРљРђ.';

  @override
  String get parkingInactiveBuyCta => 'РљРЈРџРРўР';

  @override
  String get parkingInactiveVipBody =>
      'Р”Р›РЇ VIP Р’РђР›Р•Рў-РџРђР РљРЈР’РђРќРќРЇ вЂ” Р—РђР‘Р РћРќР®Р™РўР• РњР†РЎР¦Р• Р”Р›РЇ Р’РђРЁРћР“Рћ РђР’РўРћРњРћР‘Р†Р›РЇ.';

  @override
  String get parkingInactiveVipBookCta =>
      'Р—РђРњРћР’РРўР Р’РђР›Р•Рў-РџРђР РљРЈР’РђРќРќРЇ';

  @override
  String get parkingPayForParkingCta =>
      'РЎРџР›РђРўРРўР Р’РђР›Р•Рў-РџРђР РљРЈР’РђРќРќРЇ';

  @override
  String get parkingVipQuotaNextPaymentBody =>
      'Р‘Р•Р—РљРћРЁРўРћР’РќР† Р’РђР›Р•Рў-РљР’РРўРљР РќРђ Р¦Р® РџРћР”Р†Р® Р’РРљРћР РРЎРўРђРќРћ. РњРћР–РќРђ Р”РћР”РђРўР РњР†РЎР¦Р• Р—Рђ Р—Р’РР§РђР™РќРћР® Р¦Р†РќРћР®.';

  @override
  String parkingFreeTicketsQuotaLine(int used, int quota, int remaining) {
    return 'Р‘РµР·РєРѕС€С‚РѕРІРЅРёР№ РІР°Р»РµС‚: РІРёРєРѕСЂРёСЃС‚Р°РЅРѕ $used Р· $quota (Р·Р°Р»РёС€РёР»РѕСЃСЊ $remaining)';
  }

  @override
  String get parkingActiveTicketLabel => 'РљР’РРўРћРљ';

  @override
  String get parkingTicketMock1 => 'РљР’РРўРћРљ A1 В· РњРћР”Р•Р›Р¬';

  @override
  String get parkingTicketMock2 => 'РљР’РРўРћРљ B7 В· Р“РћРЎРўР¬';

  @override
  String get parkingActiveValetLabel => 'VALET SERVICE';

  @override
  String get parkingActiveStatusLine =>
      'Р’РђР›Р•Рў-РџРђР РљРЈР’РђРќРќРЇ РђРљРўРР’РќР•';

  @override
  String get parkingActiveShowEntryPointCta =>
      'РџРћРљРђР—РђРўР РўРћР§РљРЈ Р’\'Р‡Р—Р”РЈ';

  @override
  String get parkingActiveCarLabel => 'РђР’РўРћРњРћР‘Р†Р›Р¬';

  @override
  String get parkingActiveRegistrationNumberLabel =>
      'РќРћРњР•Р РќРР™ Р—РќРђРљ';

  @override
  String get parkingCreateTicketTitle => 'РЎС‚РІРѕСЂРёС‚Рё РєРІРёС‚РѕРє';

  @override
  String get parkingCreateEventLabel => 'Р†РІРµРЅС‚';

  @override
  String get parkingCreateAccountNameLabel => 'Р†Рј\'СЏ';

  @override
  String get parkingCreateCarModelLabel => 'РњРђР РљРђ РўРђ РњРћР”Р•Р›Р¬';

  @override
  String get parkingCreateCarModelHint => 'РќР°РїСЂРёРєР»Р°Рґ: Ford Mustang';

  @override
  String get parkingCreatePlateNumberLabel => 'РќРћРњР•Р РќРР™ Р—РќРђРљ';

  @override
  String get parkingCreatePlateNumberHint => 'РќР°РїСЂРёРєР»Р°Рґ: CA 7JXK921';

  @override
  String get parkingCreateRepeatPlateNumberLabel =>
      'РџРћР’РўРћР Р†РўР¬ РќРћРњР•Р РќРР™ Р—РќРђРљ';

  @override
  String get parkingCreateRepeatPlateNumberHint =>
      'РџРѕРІС‚РѕСЂРЅРѕ РІРІРµРґС–С‚СЊ РЅРѕРјРµСЂРЅРёР№ Р·РЅР°Рє';

  @override
  String get parkingCreatePlateNumberMismatch =>
      'РќРѕРјРµСЂРЅС– Р·РЅР°РєРё РЅРµ Р·Р±С–РіР°СЋС‚СЊСЃСЏ';

  @override
  String get parkingCreateBuyCta => 'РљРЈРџРРўР';

  @override
  String get parkingCreateBookCta =>
      'Р—РђРњРћР’РРўР Р’РђР›Р•Рў-РџРђР РљРЈР’РђРќРќРЇ';

  @override
  String get parkingCheckoutInBrowser =>
      'Р—Р°РІРµСЂС€С–С‚СЊ РѕРїР»Р°С‚Сѓ Сѓ Р±СЂР°СѓР·РµСЂС–.';

  @override
  String get parkingPurchasedWithoutPayment =>
      'РљРІРёС‚РѕРє СѓСЃРїС–С€РЅРѕ РєСѓРїР»РµРЅРѕ.';

  @override
  String get parkingVipBooked =>
      'VIP РІР°Р»РµС‚-РїР°СЂРєСѓРІР°РЅРЅСЏ СѓСЃРїС–С€РЅРѕ Р·Р°Р±СЂРѕРЅСЊРѕРІР°РЅРѕ.';

  @override
  String get parkingCheckoutError =>
      'РќРµ РІРґР°Р»РѕСЃСЏ РїРѕС‡Р°С‚Рё РѕРїР»Р°С‚Сѓ РІР°Р»РµС‚-РїР°СЂРєСѓРІР°РЅРЅСЏ. РЎРїСЂРѕР±СѓР№С‚Рµ С‰Рµ СЂР°Р·.';

  @override
  String get clientTicketServiceUnavailableTitle =>
      'РЎРµСЂРІС–СЃ РЅРµРґРѕСЃС‚СѓРїРЅРёР№';

  @override
  String get clientTicketServiceUnavailableBody =>
      'Р¦РµР№ СЃРµСЂРІС–СЃ РєРІРёС‚РєС–РІ Р·Р°СЂР°Р· РЅРµ Р°РєС‚РёРІРЅРёР№.';

  @override
  String get parkingActivePassLabel => 'РљРћР” РџР РћРџРЈРЎРљРЈ';

  @override
  String get eventSettingsChatTitle => 'РЎРїС–Р»СЊРЅРёР№ С‡Р°С‚';

  @override
  String get eventSettingsChatSubtitle =>
      'РЎРїС–Р»СЊРЅРёР№ С‡Р°С‚ Р· СѓС‡Р°СЃРЅРёРєР°РјРё РіСЂСѓРїРё С‚Р° РјРµРЅРµРґР¶РµСЂР°РјРё';

  @override
  String get eventSettingsChatCta => 'Р’Р†Р”РљР РРўР Р§РђРў';

  @override
  String get chatRoomsLoadFailed =>
      'РќРµ РІРґР°Р»РѕСЃСЏ Р·Р°РІР°РЅС‚Р°Р¶РёС‚Рё РєС–РјРЅР°С‚Рё С‡Р°С‚Сѓ. РЎРїСЂРѕР±СѓР№С‚Рµ С‰Рµ СЂР°Р·.';

  @override
  String get chatNoRooms =>
      'Р”Р»СЏ РІР°С€РёС… Р±СЂРµРЅРґС–РІ Сѓ С†СЊРѕРјСѓ С–РІРµРЅС‚С– С‰Рµ РЅРµРјР°С” С‡Р°С‚-РєС–РјРЅР°С‚.';

  @override
  String get chatNoMessagesYet => 'РџРѕРІС–РґРѕРјР»РµРЅСЊ С‰Рµ РЅРµРјР°С”';

  @override
  String get chatLoadFailed =>
      'РќРµ РІРґР°Р»РѕСЃСЏ Р·Р°РІР°РЅС‚Р°Р¶РёС‚Рё РїРѕРІС–РґРѕРјР»РµРЅРЅСЏ. РЎРїСЂРѕР±СѓР№С‚Рµ С‰Рµ СЂР°Р·.';

  @override
  String get chatSendFailed =>
      'РќРµ РІРґР°Р»РѕСЃСЏ РЅР°РґС–СЃР»Р°С‚Рё РїРѕРІС–РґРѕРјР»РµРЅРЅСЏ. РЎРїСЂРѕР±СѓР№С‚Рµ С‰Рµ СЂР°Р·.';

  @override
  String get chatMessagePlaceholder => 'РџРѕРІС–РґРѕРјР»РµРЅРЅСЏ РІ С‡Р°С‚...';

  @override
  String get chatReply => 'Р’С–РґРїРѕРІС–СЃС‚Рё';

  @override
  String get chatReplyCancel => 'РЎРєР°СЃСѓРІР°С‚Рё';

  @override
  String chatReplyingTo(String name) {
    return 'Р’С–РґРїРѕРІС–РґСЊ РґР»СЏ $name';
  }

  @override
  String get chatReplyPreviewPhoto => 'Р¤РѕС‚Рѕ';

  @override
  String get chatEdit => 'Р—РјС–РЅРёС‚Рё';

  @override
  String get chatDelete => 'Р’РёРґР°Р»РёС‚Рё';

  @override
  String get chatDeleteTitle => 'Р’РёРґР°Р»РёС‚Рё РїРѕРІС–РґРѕРјР»РµРЅРЅСЏ?';

  @override
  String get chatDeleteMessageConfirm =>
      'Р¦СЋ РґС–СЋ РЅРµРјРѕР¶Р»РёРІРѕ СЃРєР°СЃСѓРІР°С‚Рё.';

  @override
  String get chatDeleteFailed =>
      'РќРµ РІРґР°Р»РѕСЃСЏ РІРёРґР°Р»РёС‚Рё РїРѕРІС–РґРѕРјР»РµРЅРЅСЏ. РЎРїСЂРѕР±СѓР№С‚Рµ С‰Рµ СЂР°Р·.';

  @override
  String get chatEditFailed =>
      'РќРµ РІРґР°Р»РѕСЃСЏ Р·РјС–РЅРёС‚Рё РїРѕРІС–РґРѕРјР»РµРЅРЅСЏ. РЎРїСЂРѕР±СѓР№С‚Рµ С‰Рµ СЂР°Р·.';

  @override
  String get chatEditingLabel =>
      'Р РµРґР°РіСѓРІР°РЅРЅСЏ РїРѕРІС–РґРѕРјР»РµРЅРЅСЏ';

  @override
  String get chatCancelEdit => 'РЎРєР°СЃСѓРІР°С‚Рё СЂРµРґР°РіСѓРІР°РЅРЅСЏ';

  @override
  String eventSettingsChatMoreParticipants(int count) {
    return '+$count';
  }

  @override
  String get mealChoiceTitle => 'Р’РёР±С–СЂ РѕР±С–РґСѓ';

  @override
  String get mealSelectChildLabel => 'Р”РёС‚РёРЅР°';

  @override
  String get mealSelectDishLabel => 'РЎС‚СЂР°РІР°';

  @override
  String get mealSave => 'Р—РђРњРћР’РРўР';

  @override
  String get mealNoMealsConfigured =>
      'Р”Р»СЏ С†СЊРѕРіРѕ С–РІРµРЅС‚Сѓ С‰Рµ РЅРµ РґРѕРґР°РЅРѕ СЃС‚СЂР°РІ.';

  @override
  String get mealSaved => 'Р—Р±РµСЂРµР¶РµРЅРѕ';

  @override
  String get mealSaveError =>
      'РќРµ РІРґР°Р»РѕСЃСЏ Р·Р±РµСЂРµРіС‚Рё. РЎРїСЂРѕР±СѓР№С‚Рµ С‰Рµ СЂР°Р·.';

  @override
  String get mealOrdersClosed =>
      'РџСЂРёР№РѕРј Р·Р°РјРѕРІР»РµРЅСЊ Р·Р°РєСЂРёС‚РёР№';

  @override
  String get mealPaid => 'РћРїР»Р°С‡РµРЅРѕ';

  @override
  String get mealPaidDetail =>
      'РћР±С–Рґ РґР»СЏ С†СЊРѕРіРѕ С–РІРµРЅС‚Сѓ РѕРїР»Р°С‡РµРЅРѕ.';

  @override
  String get mealPayInBrowser =>
      'Р—Р°РІРµСЂС€С–С‚СЊ РѕРїР»Р°С‚Сѓ РІ Р±СЂР°СѓР·РµСЂС– С‚Р° РїРѕРІРµСЂРЅС–С‚СЊСЃСЏ РІ Р·Р°СЃС‚РѕСЃСѓРЅРѕРє.';

  @override
  String get mealCheckoutError =>
      'РќРµ РІРґР°Р»РѕСЃСЏ РїРѕС‡Р°С‚Рё РѕРїР»Р°С‚Сѓ. РЎРїСЂРѕР±СѓР№С‚Рµ С‰Рµ СЂР°Р·.';

  @override
  String get mealAwaitingPayment =>
      'Р—Р°РјРѕРІР»РµРЅРЅСЏ РѕС„РѕСЂРјР»РµРЅРѕ вЂ” РѕС‡С–РєСѓС” РѕРїР»Р°С‚Рё';

  @override
  String get mealAwaitingPaymentDetail =>
      'РЎС‚СЂР°РІСѓ Р·Р±РµСЂРµР¶РµРЅРѕ. Р—Р°РІРµСЂС€С–С‚СЊ РѕРїР»Р°С‚Сѓ РІ Р±СЂР°СѓР·РµСЂС–; СЃС‚Р°С‚СѓСЃ РѕРЅРѕРІРёС‚СЊСЃСЏ РїС–СЃР»СЏ РїС–РґС‚РІРµСЂРґР¶РµРЅРЅСЏ Stripe.';

  @override
  String get mealPaymentContinue => 'РџСЂРѕРґРѕРІР¶РёС‚Рё РѕРїР»Р°С‚Сѓ';

  @override
  String get mealPaymentCancel => 'РЎРєР°СЃСѓРІР°С‚Рё РѕРїР»Р°С‚Сѓ';

  @override
  String get mealPaymentStartAgain => 'РџРѕС‡Р°С‚Рё РѕРїР»Р°С‚Сѓ Р·РЅРѕРІСѓ';

  @override
  String get mealPaymentCanceled =>
      'РћРїР»Р°С‚Сѓ СЃРєР°СЃРѕРІР°РЅРѕ. РњРѕР¶РЅР° РїРѕС‡Р°С‚Рё Р·РЅРѕРІСѓ.';

  @override
  String get mealPaymentStatusLoadError =>
      'РќРµ РІРґР°Р»РѕСЃСЏ Р·Р°РІР°РЅС‚Р°Р¶РёС‚Рё СЃС‚Р°С‚СѓСЃ РѕРїР»Р°С‚Рё. РЎРїСЂРѕР±СѓР№С‚Рµ С‰Рµ СЂР°Р·.';

  @override
  String get noActiveEvents => 'РќРµРјР°С” Р°РєС‚РёРІРЅРёС… РїРѕРґС–Р№';

  @override
  String get becomeModelTitle =>
      'РџРѕС‡РЅС–С‚СЊ РјРѕРґРµР»СЊРЅСѓ РєР°СЂ\'С”СЂСѓ РґРёС‚РёРЅРё СЃСЊРѕРіРѕРґРЅС–';

  @override
  String get becomeAModel => 'РЎРўРђРўР РњРћР”Р•Р›Р›Р®';

  @override
  String get latestHighlights => 'РћСЃС‚Р°РЅРЅС– РїРѕРґС–С—';

  @override
  String get viewAll => 'Р’РЎР†';

  @override
  String get quickActions => 'РЁРІРёРґРєС– РґС–С—';

  @override
  String get fillOutApplication => 'Р—Р°РїРѕРІРЅРёС‚Рё\nР·Р°СЏРІРєСѓ';

  @override
  String get upcomingShows => 'РќР°Р№Р±Р»РёР¶С‡С–\nРїРѕРєР°Р·Рё';

  @override
  String get manageKids => 'РњРѕС—\nРґС–С‚Рё';

  @override
  String get navHome => 'Р“РѕР»РѕРІРЅР°';

  @override
  String get navEvents => 'РџРѕРґС–С—';

  @override
  String get eventsYoutubeLiveButton => 'YouTube С‚СЂР°РЅСЃР»СЏС†С–СЏ';

  @override
  String get eventsYoutubeLiveInvalidUrl =>
      'РќРµ РІРґР°Р»РѕСЃСЏ РІС–РґРєСЂРёС‚Рё С†Рµ РїРѕСЃРёР»Р°РЅРЅСЏ YouTube.';

  @override
  String get eventsYoutubeLiveOpenExternally => 'Р’С–РґРєСЂРёС‚Рё РІ YouTube';

  @override
  String get navProfile => 'РџСЂРѕС„С–Р»СЊ';

  @override
  String get navInfo => 'Р†РЅС„Рѕ';

  @override
  String get continueButton => 'РџСЂРѕРґРѕРІР¶РёС‚Рё';

  @override
  String get loading => 'Р—Р°РІР°РЅС‚Р°Р¶РµРЅРЅСЏ...';

  @override
  String get signOut => 'Р’РёР№С‚Рё';

  @override
  String get tokenValidNext =>
      'РўРѕРєРµРЅ РґС–Р№СЃРЅРёР№. Р”Р°Р»С–: РіРѕР»РѕРІРЅР°.';

  @override
  String get homePageTitle => 'Р“РѕР»РѕРІРЅР°';

  @override
  String youAreSignedIn(String name) {
    return 'Р’Рё СѓРІС–Р№С€Р»Рё$name.';
  }

  @override
  String yourRole(String role) {
    return 'Р’Р°С€Р° СЂРѕР»СЊ: $role';
  }

  @override
  String get phoneHint => '+380501234567';

  @override
  String get enterValidEmailShort => 'Р’РІРµРґС–С‚СЊ РєРѕСЂРµРєС‚РЅРёР№ email';

  @override
  String get phoneMustStartWithPlusShort =>
      'РўРµР»РµС„РѕРЅ РїРѕРІРёРЅРµРЅ РїРѕС‡РёРЅР°С‚РёСЃСЏ Р· +';

  @override
  String get comingSoon => 'РќРµР·Р°Р±Р°СЂРѕРј';

  @override
  String get hello => 'РџСЂРёРІС–С‚';

  @override
  String helloName(String name) {
    return 'РџСЂРёРІС–С‚, $name';
  }

  @override
  String get noRolesAssigned =>
      'Р’Р°Рј РїРѕРєРё РЅРµ РїСЂРёР·РЅР°С‡РµРЅРѕ Р¶РѕРґРЅРѕС— СЂРѕР»С–. Р—РІРµСЂРЅС–С‚СЊСЃСЏ РґРѕ Р°РґРјС–РЅС–СЃС‚СЂР°С†С–С—.';

  @override
  String signedInAs(String name) {
    return 'Р’Рё СѓРІС–Р№С€Р»Рё СЏРє $name';
  }

  @override
  String get birthdateDialogTitle => 'Р”Р°С‚Р° РЅР°СЂРѕРґР¶РµРЅРЅСЏ';

  @override
  String get nextShowsTitle => 'РќР°Р№Р±Р»РёР¶С‡С– РїРѕРєР°Р·Рё';

  @override
  String get nextShowsSeason => 'РЎРµР·РѕРЅ 2026';

  @override
  String get details => 'Р”РµС‚Р°Р»С–';

  @override
  String get contact => 'Р—РІ\'СЏР·Р°С‚РёСЃСЏ';

  @override
  String get registrationOpen => 'Р РµС”СЃС‚СЂР°С†С–СЏ РІС–РґРєСЂРёС‚Р°';

  @override
  String get myTicketsButton => 'РњРћР‡ РљР’РРўРљР';

  @override
  String get myTicketsTitle => 'РњРѕС— РєРІРёС‚РєРё';

  @override
  String get selectEventForTickets => 'РћР±РµСЂС–С‚СЊ Р·Р°С…С–Рґ';

  @override
  String get ticketsMomName => 'Р†Рј\'СЏ Р±Р°С‚СЊРєР°/РјР°С‚РµСЂС–';

  @override
  String get ticketsEventDate => 'Р”Р°С‚Р°';

  @override
  String get ticketsOpenPdf => 'Р’Р†Р”РљР РРўР';

  @override
  String get ticketsPdfUnavailable => 'PDF С‰Рµ РЅРµРґРѕСЃС‚СѓРїРЅРёР№';

  @override
  String get ticketsBuy => 'РљРЈРџРРўР РљР’РРўРћРљ';

  @override
  String get ticketsBuyNoLink =>
      'РџРѕСЃРёР»Р°РЅРЅСЏ РЅР° РїРѕРєСѓРїРєСѓ РЅРµ Р·Р°РґР°РЅРµ. Р”РѕРґР°Р№С‚Рµ РІ Р°РґРјС–РЅС†С– РїРѕСЃРёР»Р°РЅРЅСЏ РЅР° РјР°РіР°Р·РёРЅ РєРІРёС‚РєС–РІ РґР»СЏ С–РІРµРЅС‚Р° Р°Р±Рѕ СЃР°Р№С‚ Сѓ СЂРѕР·РґС–Р»С– Info.';

  @override
  String get ticketsBuyCouldNotOpen =>
      'РќРµ РІРґР°Р»РѕСЃСЏ РІС–РґРєСЂРёС‚Рё РїРѕСЃРёР»Р°РЅРЅСЏ.';

  @override
  String get ticketsBuySubtitle =>
      'Р”РѕСЃС‚СѓРїРЅС– VIP С– СЃС‚Р°РЅРґР°СЂС‚РЅС– РјС–СЃС†СЏ';

  @override
  String get ticketsBuyEmailHint =>
      'Р’Р°С€С– РєРІРёС‚РєРё РїСЂРёР№РґСѓС‚СЊ РЅР° РµР»РµРєС‚СЂРѕРЅРЅСѓ РїРѕС€С‚Сѓ, РІРєР°Р·Р°РЅСѓ РїС–Рґ С‡Р°СЃ РїРѕРєСѓРїРєРё РєРІРёС‚РєР°.';

  @override
  String get extraTicketButton => 'OPEN BAR';

  @override
  String get extraTicketSelectEventFirst =>
      'РЎРїРѕС‡Р°С‚РєСѓ РѕР±РµСЂС–С‚СЊ С–РІРµРЅС‚.';

  @override
  String get extraTicketNoActiveHeadline =>
      'РќР•РњРђР„ РђРљРўРР’РќРРҐ BEVERAGE PACKAGE';

  @override
  String get extraTicketBuyCta => 'РљРЈРџРРўР';

  @override
  String get extraTicketAccessOpen =>
      'Р”РћРЎРўРЈРџ Р”Рћ BEVERAGE PACKAGE Р’Р†Р”РљР РРўРћ';

  @override
  String get extraTicketCheckoutInBrowser =>
      'Р—Р°РІРµСЂС€С–С‚СЊ РѕРїР»Р°С‚Сѓ Сѓ Р±СЂР°СѓР·РµСЂС–.';

  @override
  String get extraTicketCheckoutError =>
      'РќРµ РІРґР°Р»РѕСЃСЏ Р·Р°РїСѓСЃС‚РёС‚Рё РѕРїР»Р°С‚Сѓ BEVERAGE PACKAGE. РЎРїСЂРѕР±СѓР№С‚Рµ С‰Рµ СЂР°Р·.';

  @override
  String get backstageTicketButton => 'BACKSTAGE PASS';

  @override
  String get backstageTicketSelectEventFirst =>
      'РЎРїРѕС‡Р°С‚РєСѓ РѕР±РµСЂС–С‚СЊ С–РІРµРЅС‚.';

  @override
  String get backstageTicketNoActiveHeadline =>
      'РќР•РњРђР„ РђРљРўРР’РќРРҐ BACKSTAGE PASS';

  @override
  String get backstageTicketBuyCta => 'РљРЈРџРРўР';

  @override
  String get backstageTicketAccessOpen =>
      'Р”РћРЎРўРЈРџ Р”Рћ BACKSTAGE PASS Р’Р†Р”РљР РРўРћ';

  @override
  String get backstageTicketCheckoutInBrowser =>
      'Р—Р°РІРµСЂС€С–С‚СЊ РѕРїР»Р°С‚Сѓ Сѓ Р±СЂР°СѓР·РµСЂС–.';

  @override
  String get backstageTicketCheckoutError =>
      'РќРµ РІРґР°Р»РѕСЃСЏ Р·Р°РїСѓСЃС‚РёС‚Рё РѕРїР»Р°С‚Сѓ BACKSTAGE PASS. РЎРїСЂРѕР±СѓР№С‚Рµ С‰Рµ СЂР°Р·.';

  @override
  String get ticketsNoEvents =>
      'РџРѕРєРё РЅРµРјР°С” Р·Р°С…РѕРґС–РІ С–Р· РєРІРёС‚РєР°РјРё';

  @override
  String get ticketsNoneForEvent =>
      'РќРµРјР°С” РєРІРёС‚РєС–РІ РЅР° С†РµР№ Р·Р°С…С–Рґ';

  @override
  String get ticketsLoadError =>
      'РќРµ РІРґР°Р»РѕСЃСЏ Р·Р°РІР°РЅС‚Р°Р¶РёС‚Рё РєРІРёС‚РєРё';

  @override
  String get ticketsEventsLoadError =>
      'РќРµ РІРґР°Р»РѕСЃСЏ Р·Р°РІР°РЅС‚Р°Р¶РёС‚Рё Р·Р°С…РѕРґРё';

  @override
  String get faqBrandCatalogTitle => 'Р‘СЂРµРЅРґРё РѕРґСЏРіСѓ';

  @override
  String get pdfViewerTitle => 'РљРІРёС‚РѕРє';

  @override
  String get contactFormLinkMissing =>
      'РџРѕСЃРёР»Р°РЅРЅСЏ РЅР° С„РѕСЂРјСѓ РЅРµ РЅР°Р»Р°С€С‚РѕРІР°РЅРѕ. Р”РѕРґР°Р№С‚Рµ В«РџРѕСЃРёР»Р°РЅРЅСЏ РЅР° С„РѕСЂРјСѓВ» Сѓ Р·Р°РіР°Р»СЊРЅРёС… РЅР°Р»Р°С€С‚СѓРІР°РЅРЅСЏС… Р·Р°СЃС‚РѕСЃСѓРЅРєСѓ РІ Р°РґРјС–РЅС†С–.';

  @override
  String get infoHubTitle => 'Р†РЅС„РѕСЂРјР°С†С–Р№РЅРёР№ С†РµРЅС‚СЂ';

  @override
  String get infoMenuAboutYfs => 'РџСЂРѕ YFS';

  @override
  String get infoMenuGeneralFaq => 'Р—Р°РіР°Р»СЊРЅС– FAQ';

  @override
  String get infoMenuContactManager =>
      'Р—РІ\'СЏР·РѕРє С–Р· РјРµРЅРµРґР¶РµСЂРѕРј';

  @override
  String get infoFooterBrand => 'YFS';

  @override
  String get infoFooterCopyright =>
      'В© 2024 Young Fashion Series. РЈСЃС– РїСЂР°РІР° Р·Р°С…РёС‰РµРЅРѕ.';

  @override
  String parentProgressLabel(int completed, int total) {
    return 'РџСЂРѕРіСЂРµСЃ Р±Р°С‚СЊРєР°/РјР°С‚РµСЂС–: $completed/$total';
  }

  @override
  String get appUpdateRequiredMessage =>
      'РћРЅРѕРІС–С‚СЊ Р·Р°СЃС‚РѕСЃСѓРЅРѕРє, С‰РѕР± РїСЂРѕРґРѕРІР¶РёС‚Рё.';

  @override
  String get appUpdateButton => 'РћРЅРѕРІРёС‚Рё Р·Р°СЃС‚РѕСЃСѓРЅРѕРє';

  @override
  String get showAll => 'РџРѕРєР°Р·Р°С‚Рё РІСЃРµ';

  @override
  String get chatCouldNotPickPhoto =>
      'РќРµ РІРґР°Р»РѕСЃСЏ РІРёР±СЂР°С‚Рё С„РѕС‚Рѕ';

  @override
  String get contactManagerIntro =>
      'Р’Рё РјРѕР¶РµС‚Рµ Р·Р°Р»РёС€РёС‚Рё РїРѕРІС–РґРѕРјР»РµРЅРЅСЏ Р· Р±СѓРґСЊ-СЏРєРѕРіРѕ РїРёС‚Р°РЅРЅСЏ вЂ” Р· РІР°РјРё Р·РІвЂ™СЏР¶СѓС‚СЊСЃСЏ РЅР°Р№Р±Р»РёР¶С‡РёРј С‡Р°СЃРѕРј.';

  @override
  String get contactManagerMessageLabel => 'Р’Р°С€Рµ РїРѕРІС–РґРѕРјР»РµРЅРЅСЏ';

  @override
  String get contactManagerMessageRequired =>
      'Р’РІРµРґС–С‚СЊ С‚РµРєСЃС‚ РїРѕРІС–РґРѕРјР»РµРЅРЅСЏ';

  @override
  String get contactManagerSend => 'РќР°РґС–СЃР»Р°С‚Рё';

  @override
  String get contactManagerSent =>
      'РџРѕРІС–РґРѕРјР»РµРЅРЅСЏ РЅР°РґС–СЃР»Р°РЅРѕ. РњРё Р·РІвЂ™СЏР¶РµРјРѕСЃСЏ Р· РІР°РјРё РЅР°Р№Р±Р»РёР¶С‡РёРј С‡Р°СЃРѕРј.';

  @override
  String get contactManagerSendFailed =>
      'РќРµ РІРґР°Р»РѕСЃСЏ РЅР°РґС–СЃР»Р°С‚Рё. РЎРїСЂРѕР±СѓР№С‚Рµ РїС–Р·РЅС–С€Рµ.';

  @override
  String get contactManagerServiceUnavailable =>
      'Р—РІвЂ™СЏР·РѕРє С‚РёРјС‡Р°СЃРѕРІРѕ РЅРµРґРѕСЃС‚СѓРїРЅРёР№. РЎРїСЂРѕР±СѓР№С‚Рµ РїС–Р·РЅС–С€Рµ.';

  @override
  String get close => 'Закрити';

  @override
  String get pastShowPhotosButtonTitle => 'Фото & відео';

  @override
  String get pastShowPhotosButtonSubtitle => 'з минулих показів';

  @override
  String get pastShowPhotosTitle => 'Фото & відео';

  @override
  String get pastShowPhotosNotParticipatedMessage =>
      'Ви ще не брали участі в жодному показі. Фото і відео будуть додані після проходження показу.';

  @override
  String get pastShowPhotosPendingMessage =>
      'Фото і відео будуть додані після проходження показу.';

  @override
  String get pastShowPhotosChooseEventTitle => 'Оберіть показ';

  @override
  String get pastShowPhotosChooseChildTitle => 'Фото & відео';

  @override
  String get pastShowPhotosOpenPhoto => 'Фото';

  @override
  String get pastShowPhotosOpenVideo => 'Відео';

  @override
  String get pastShowPhotosLinkCouldNotOpen => 'Не вдалося відкрити посилання.';
}
