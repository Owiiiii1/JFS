// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Ukrainian (`uk`).
class AppLocalizationsUk extends AppLocalizations {
  AppLocalizationsUk([String locale = 'uk']) : super(locale);

  @override
  String get signIn => 'Увійти';

  @override
  String get signUp => 'Реєстрація';

  @override
  String get email => 'Email';

  @override
  String get password => 'Пароль';

  @override
  String get emailRequired => 'Введіть email';

  @override
  String get enterValidEmail => 'Введіть коректний email';

  @override
  String get passwordRequired => 'Введіть пароль';

  @override
  String get hidePassword => 'Приховати пароль';

  @override
  String get showPassword => 'Показати пароль';

  @override
  String signInFailed(String error) {
    return 'Помилка входу: $error';
  }

  @override
  String get createAccount => 'Створити обліковий запис';

  @override
  String get name => 'Ім\'я';

  @override
  String get nameRequired => 'Введіть ім\'я';

  @override
  String get phone => 'Телефон';

  @override
  String get phoneRequired => 'Введіть телефон';

  @override
  String get phoneMustStartWithPlus => 'Телефон повинен починатися з +';

  @override
  String get enterValidPhone => 'Введіть коректний номер телефону';

  @override
  String get confirmPassword => 'Підтвердіть пароль';

  @override
  String get passwordsDoNotMatch => 'Паролі не збігаються';

  @override
  String get passwordMinLength => 'Пароль не менше 8 символів';

  @override
  String get atLeast8Chars => 'Не менше 8 символів';

  @override
  String get backToSignIn => 'Повернутися до входу';

  @override
  String registrationFailed(String error) {
    return 'Помилка реєстрації: $error';
  }

  @override
  String get account => 'Обліковий запис';

  @override
  String get editInfo => 'РЕДАГУВАТИ';

  @override
  String get fullName => 'Повне ім\'я';

  @override
  String get retry => 'Повторити';

  @override
  String get accountSettings => 'Налаштування облікового запису';

  @override
  String get editProfile => 'Редагувати профіль';

  @override
  String get save => 'Зберегти';

  @override
  String get edit => 'Редагувати';

  @override
  String get role => 'Роль';

  @override
  String get myChildren => 'Мої діти';

  @override
  String get addChild => 'Додати дитину';

  @override
  String get noChildrenAddedYet => 'Дітей поки не додано';

  @override
  String get ageLabel => 'Вік';

  @override
  String get settings => 'Налаштування';

  @override
  String get appLanguage => 'Мова застосунку';

  @override
  String get unitsOfMeasurement => 'Одиниці виміру';

  @override
  String get metricUnits => 'Метричні (см, кг)';

  @override
  String get imperialUnits => 'Американські (in, lb)';

  @override
  String get systemLanguage => 'Системна';

  @override
  String get languageRussian => 'Русский';

  @override
  String get languageEnglish => 'English';

  @override
  String get languageUkrainian => 'Українська';

  @override
  String get languageSpanishUS => 'Іспанська (США)';

  @override
  String get addChildTitle => 'Додати дитину';

  @override
  String get firstName => 'Ім\'я';

  @override
  String get lastName => 'Прізвище';

  @override
  String get birthdate => 'Дата народження';

  @override
  String get chooseDate => 'Оберіть дату';

  @override
  String get create => 'Створити';

  @override
  String get enterFirstName => 'Введіть ім\'я';

  @override
  String get mainPhoto => 'Основне фото';

  @override
  String get changePhoto => 'Змінити';

  @override
  String get deletePhoto => 'Видалити';

  @override
  String get addPhoto => 'Додати фото';

  @override
  String get photoSaved => 'Фото збережено';

  @override
  String get photoDeleted => 'Фото видалено';

  @override
  String get photoAdded => 'Фото додано';

  @override
  String get extraPhotos => 'Додаткові фото';

  @override
  String get cancel => 'Скасувати';

  @override
  String get clear => 'Очистити';

  @override
  String get height => 'Зріст';

  @override
  String get weight => 'Вага';

  @override
  String get shoulders => 'Плечі';

  @override
  String get chest => 'Груди';

  @override
  String get waist => 'Талія';

  @override
  String get hips => 'Стегна';

  @override
  String get currentParticipation => 'Поточна участь';

  @override
  String get unknownError => 'Невідома помилка';

  @override
  String model(String name) {
    return 'Модель: $name';
  }

  @override
  String get active => 'АКТИВНО';

  @override
  String get journeyProgress => 'ПРОГРЕС';

  @override
  String stepOf(int completed, int total) {
    return 'Крок $completed з $total';
  }

  @override
  String next(String text) {
    return 'Далі: $text';
  }

  @override
  String get viewProgress => 'ПЕРЕГЛЯНУТИ ПРОГРЕС';

  @override
  String get noActiveEvents => 'Немає активних подій';

  @override
  String get becomeModelTitle => 'Почніть модельну кар\'єру дитини сьогодні';

  @override
  String get becomeAModel => 'СТАТИ МОДЕЛЛЮ';

  @override
  String get latestHighlights => 'Останні події';

  @override
  String get viewAll => 'ВСІ';

  @override
  String get quickActions => 'Швидкі дії';

  @override
  String get upcomingShows => 'Найближчі\nпокази';

  @override
  String get manageKids => 'Мої\nдіти';

  @override
  String get navHome => 'Головна';

  @override
  String get navEvents => 'Події';

  @override
  String get navProfile => 'Профіль';

  @override
  String get navInfo => 'Інфо';

  @override
  String get continueButton => 'Продовжити';

  @override
  String get loading => 'Завантаження...';

  @override
  String get signOut => 'Вийти';

  @override
  String get tokenValidNext => 'Токен дійсний. Далі: головна.';

  @override
  String get homePageTitle => 'Головна';

  @override
  String youAreSignedIn(String name) {
    return 'Ви увійшли$name.';
  }

  @override
  String yourRole(String role) {
    return 'Ваша роль: $role';
  }

  @override
  String get phoneHint => '+380501234567';

  @override
  String get enterValidEmailShort => 'Введіть коректний email';

  @override
  String get phoneMustStartWithPlusShort => 'Телефон повинен починатися з +';

  @override
  String get comingSoon => 'Незабаром';

  @override
  String get hello => 'Привіт';

  @override
  String helloName(String name) {
    return 'Привіт, $name';
  }

  @override
  String get noRolesAssigned =>
      'Вам поки не призначено жодної ролі. Зверніться до адміністрації.';

  @override
  String signedInAs(String name) {
    return 'Ви увійшли як $name';
  }

  @override
  String get staff => 'Співробітник';

  @override
  String get birthdateDialogTitle => 'Дата народження';

  @override
  String get nextShowsTitle => 'Найближчі покази';

  @override
  String get nextShowsSeason => 'Сезон 2026';

  @override
  String get details => 'Деталі';

  @override
  String get contact => 'Зв\'язатися';

  @override
  String get registrationOpen => 'Реєстрація відкрита';
}
