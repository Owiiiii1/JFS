// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Russian (`ru`).
class AppLocalizationsRu extends AppLocalizations {
  AppLocalizationsRu([String locale = 'ru']) : super(locale);

  @override
  String get signIn => 'Войти';

  @override
  String get signUp => 'Регистрация';

  @override
  String get email => 'Email';

  @override
  String get password => 'Пароль';

  @override
  String get emailRequired => 'Введите email';

  @override
  String get enterValidEmail => 'Введите корректный email';

  @override
  String get passwordRequired => 'Введите пароль';

  @override
  String get hidePassword => 'Скрыть пароль';

  @override
  String get showPassword => 'Показать пароль';

  @override
  String signInFailed(String error) {
    return 'Ошибка входа: $error';
  }

  @override
  String get createAccount => 'Создать аккаунт';

  @override
  String get name => 'Имя';

  @override
  String get nameRequired => 'Введите имя';

  @override
  String get phone => 'Телефон';

  @override
  String get phoneRequired => 'Введите телефон';

  @override
  String get phoneMustStartWithPlus => 'Телефон должен начинаться с +';

  @override
  String get enterValidPhone => 'Введите корректный номер телефона';

  @override
  String get confirmPassword => 'Подтвердите пароль';

  @override
  String get passwordsDoNotMatch => 'Пароли не совпадают';

  @override
  String get passwordMinLength => 'Пароль не менее 8 символов';

  @override
  String get atLeast8Chars => 'Не менее 8 символов';

  @override
  String get backToSignIn => 'Вернуться к входу';

  @override
  String registrationFailed(String error) {
    return 'Ошибка регистрации: $error';
  }

  @override
  String get account => 'Аккаунт';

  @override
  String get editInfo => 'РЕДАКТИРОВАТЬ';

  @override
  String get fullName => 'Полное имя';

  @override
  String get retry => 'Повторить';

  @override
  String get accountSettings => 'Настройки аккаунта';

  @override
  String get editProfile => 'Редактировать профиль';

  @override
  String get save => 'Сохранить';

  @override
  String get edit => 'Редактировать';

  @override
  String get role => 'Роль';

  @override
  String get myChildren => 'Мои дети';

  @override
  String get addChild => 'Добавить ребёнка';

  @override
  String get noChildrenAddedYet => 'Дети пока не добавлены';

  @override
  String get ageLabel => 'Возраст';

  @override
  String get settings => 'Настройки';

  @override
  String get appLanguage => 'Язык приложения';

  @override
  String get unitsOfMeasurement => 'Единицы измерения';

  @override
  String get metricUnits => 'Метрические (см, кг)';

  @override
  String get imperialUnits => 'Американские (in, lb)';

  @override
  String get systemLanguage => 'Системный';

  @override
  String get languageRussian => 'Русский';

  @override
  String get languageEnglish => 'English';

  @override
  String get languageUkrainian => 'Українська';

  @override
  String get languageSpanishUS => 'Испанский (США)';

  @override
  String get addChildTitle => 'Добавить ребёнка';

  @override
  String get firstName => 'Имя';

  @override
  String get lastName => 'Фамилия';

  @override
  String get birthdate => 'Дата рождения';

  @override
  String get chooseDate => 'Выберите дату';

  @override
  String get create => 'Создать';

  @override
  String get enterFirstName => 'Введите имя';

  @override
  String get mainPhoto => 'Основное фото';

  @override
  String get changePhoto => 'Изменить';

  @override
  String get deletePhoto => 'Удалить';

  @override
  String get addPhoto => 'Добавить фото';

  @override
  String get photoSaved => 'Фото сохранено';

  @override
  String get photoDeleted => 'Фото удалено';

  @override
  String get photoAdded => 'Фото добавлено';

  @override
  String get extraPhotos => 'Дополнительные фото';

  @override
  String get cancel => 'Отмена';

  @override
  String get clear => 'Очистить';

  @override
  String get height => 'Рост';

  @override
  String get weight => 'Вес';

  @override
  String get shoulders => 'Плечи';

  @override
  String get chest => 'Грудь';

  @override
  String get waist => 'Талия';

  @override
  String get hips => 'Бёдра';

  @override
  String get currentParticipation => 'Текущее участие';

  @override
  String get unknownError => 'Неизвестная ошибка';

  @override
  String model(String name) {
    return 'Модель: $name';
  }

  @override
  String get active => 'АКТИВНО';

  @override
  String get journeyProgress => 'ПРОГРЕСС';

  @override
  String stepOf(int completed, int total) {
    return 'Шаг $completed из $total';
  }

  @override
  String next(String text) {
    return 'Далее: $text';
  }

  @override
  String get viewProgress => 'СМОТРЕТЬ ПРОГРЕСС';

  @override
  String get noActiveEvents => 'Нет активных событий';

  @override
  String get becomeModelTitle => 'Начните модельную карьеру ребёнка сегодня';

  @override
  String get becomeAModel => 'СТАТЬ МОДЕЛЬЮ';

  @override
  String get latestHighlights => 'Последние события';

  @override
  String get viewAll => 'ВСЕ';

  @override
  String get quickActions => 'Быстрые действия';

  @override
  String get upcomingShows => 'Ближайшие\nпоказы';

  @override
  String get manageKids => 'Мои\nдети';

  @override
  String get navHome => 'Главная';

  @override
  String get navEvents => 'События';

  @override
  String get navProfile => 'Профиль';

  @override
  String get navInfo => 'Инфо';

  @override
  String get continueButton => 'Продолжить';

  @override
  String get loading => 'Загрузка...';

  @override
  String get signOut => 'Выйти';

  @override
  String get tokenValidNext => 'Токен действителен. Дальше: главная.';

  @override
  String get homePageTitle => 'Главная';

  @override
  String youAreSignedIn(String name) {
    return 'Вы вошли$name.';
  }

  @override
  String yourRole(String role) {
    return 'Ваша роль: $role';
  }

  @override
  String get phoneHint => '+79001234567';

  @override
  String get enterValidEmailShort => 'Введите корректный email';

  @override
  String get phoneMustStartWithPlusShort => 'Телефон должен начинаться с +';

  @override
  String get comingSoon => 'Скоро';

  @override
  String get hello => 'Привет';

  @override
  String helloName(String name) {
    return 'Привет, $name';
  }

  @override
  String get noRolesAssigned =>
      'Вам пока не назначены роли. Обратитесь к администрации.';

  @override
  String signedInAs(String name) {
    return 'Вы вошли как $name';
  }

  @override
  String get staff => 'Сотрудник';

  @override
  String get birthdateDialogTitle => 'Дата рождения';

  @override
  String get nextShowsTitle => 'Ближайшие показы';

  @override
  String get nextShowsSeason => 'Сезон 2026';

  @override
  String get details => 'Подробнее';

  @override
  String get contact => 'Связаться';

  @override
  String get registrationOpen => 'Регистрация открыта';
}
