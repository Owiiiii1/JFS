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
  String get apiEndpointNotFoundHint =>
      'Сервер не нашёл API (404). Укажите в сборке корень сайта без «/api» в конце — приложение само обращается к /api/app/login. Если Laravel в подпапке, добавьте путь до каталога public (например https://example.com/myapp/public).';

  @override
  String get notificationsTitle => 'Уведомления';

  @override
  String get notificationsLoadFailed =>
      'Не удалось загрузить уведомления. Попробуйте снова.';

  @override
  String get notificationsEmpty => 'Пока нет уведомлений.';

  @override
  String get notificationsNewMark => 'Новое';

  @override
  String get notificationDetailsTitle => 'Уведомление';

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
  String get fullName => 'Имя';

  @override
  String get retry => 'Повторить';

  @override
  String get accountSettings => 'Настройки аккаунта';

  @override
  String get editProfile => 'Редактировать профиль';

  @override
  String get deleteAccount => 'Удалить аккаунт';

  @override
  String get deleteAccountConfirmTitle => 'Удалить аккаунт?';

  @override
  String get deleteAccountConfirmMessage =>
      'Вы уверены, что хотите навсегда удалить аккаунт? Это действие нельзя отменить.';

  @override
  String get deleteAccountSecondTitle => 'Что будет удалено';

  @override
  String get deleteAccountSecondMessage =>
      'Будет безвозвратно удалено из наших систем:\n\n• ваш аккаунт и профиль;\n• все дети, привязанные к аккаунту;\n• все назначения на мероприятия, прогресс по этапам, билеты и выбор обедов;\n• фотографии и другие данные детей;\n• участие в чатах мероприятий и уведомления в приложении.\n\nНекоторые платёжные или бухгалтерские записи могут сохраняться, если этого требует закон.';

  @override
  String get deleteAccountContinue => 'Продолжить';

  @override
  String get deleteAccountConfirmAction => 'Удалить навсегда';

  @override
  String get deleteAccountWorking => 'Удаление аккаунта…';

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
  String get aboutTheApp => 'О приложении';

  @override
  String get aboutAppDisplayName => 'YoungFashionShow';

  @override
  String get aboutPublisherLine => 'YOUNGFASHIONSHOW';

  @override
  String get aboutVersionLabel => 'ВЕРСИЯ';

  @override
  String get aboutReleaseDateLabel => 'ДАТА ВЫПУСКА';

  @override
  String get aboutDevelopedByPrefix => 'РАЗРАБОТАНО:';

  @override
  String get aboutDeveloperBrand => 'OWLSOLUTIONS';

  @override
  String get aboutLinkCouldNotOpen => 'Не удалось открыть ссылку.';

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
  String get gender => 'Пол';

  @override
  String get genderBoy => 'Мальчик';

  @override
  String get genderGirl => 'Девочка';

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
  String get measurementLengthUnitCm => 'см';

  @override
  String get measurementLengthUnitIn => 'дюйм';

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
  String get journeyPreparationPhase => 'ПОДГОТОВКА';

  @override
  String get journeyMainEventTitle => 'ОСНОВНОЙ ИВЕНТ';

  @override
  String get journeyMainEventSubtitle => 'ГЛАВНОЕ ШОУ';

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
  String get eventSettings => 'НАСТРОЙКИ ИВЕНТА';

  @override
  String get homeEventCardMyEvent => 'МОЙ ИВЕНТ';

  @override
  String get homeEventCardRunwayJourney => 'ПУТЬ НА ПОДИУМ';

  @override
  String get eventSettingsPlaceholder =>
      'Здесь скоро появятся настройки ивента.';

  @override
  String get eventSettingsConfigurationPortal => 'ПОРТАЛ НАСТРОЕК';

  @override
  String get eventSettingsMainHeadline => 'Настройки ивента';

  @override
  String get eventSettingsMealTitle => 'Выбор питания';

  @override
  String get eventSettingsMealSubtitle => 'Выберите блюдо на текущий ивент';

  @override
  String get eventSettingsMealCta => 'МЕНЮ';

  @override
  String get eventSettingsRehearsalTitle => 'Запись на репетицию';

  @override
  String get eventSettingsRehearsalSubtitle =>
      'Забронируйте место на репетицию';

  @override
  String get eventSettingsRehearsalCta => 'ЗАПИСАТЬСЯ';

  @override
  String get rehearsalModalTitle => 'Запись на репетицию';

  @override
  String get rehearsalSelectDate => 'Выберите дату';

  @override
  String get rehearsalAvailableSlots => 'Доступные слоты';

  @override
  String get rehearsalFreeLabel => 'Свободно:';

  @override
  String get rehearsalNoSlotsConfigured =>
      'Для этого ивента слотов репетиций пока нет.';

  @override
  String get rehearsalLoadError =>
      'Не удалось загрузить слоты. Попробуйте снова.';

  @override
  String get rehearsalBrandNotAssigned =>
      'Ребенку не назначен пакет. Бронирование репетиций недоступно.';

  @override
  String get rehearsalFull => 'Мест нет';

  @override
  String get rehearsalConfirmBooking => 'Подтвердить запись';

  @override
  String get rehearsalBookingFooterNote =>
      'По возможности изменения вносите за 24 часа до слота.';

  @override
  String get rehearsalBookedTitle => 'Репетиция забронирована';

  @override
  String get rehearsalChangeBooking => 'Изменить бронирование';

  @override
  String get rehearsalProgramLabel => 'Описание';

  @override
  String get rehearsalArriveEarly => 'Приходите за 15 минут до начала.';

  @override
  String get rehearsalBookingSaved => 'Запись сохранена';

  @override
  String get rehearsalBookingError => 'Не удалось выполнить запись.';

  @override
  String get rehearsalSelectChild => 'Ребёнок';

  @override
  String get rehearsalUpdateBooking => 'Изменить запись';

  @override
  String get rehearsalCancelChange => 'Отмена';

  @override
  String get rehearsalChangeBookingLockedHint =>
      'Организатор закрыл смену записи. Напишите в поддержку, если нужна помощь.';

  @override
  String get rehearsalMilestoneTitle => 'Общая репетиция';

  @override
  String rehearsalBrandMilestoneTitle(String brandName) {
    return 'Репетиция бренда: $brandName';
  }

  @override
  String get rehearsalBrandMilestoneShort => 'Репетиция бренда';

  @override
  String get rehearsalNextBookHint =>
      'Запишитесь на репетицию в настройках ивента.';

  @override
  String get eventSettingsPackingTitle => 'Список «Не забудь»';

  @override
  String get eventSettingsPackingSubtitle => '';

  @override
  String get eventSettingsPackingCta => 'ОТКРЫТЬ СПИСОК';

  @override
  String get eventPackingLoadFailed =>
      'Не удалось загрузить информацию. Попробуйте снова.';

  @override
  String get eventPackingEmpty =>
      'Для этого ивента информация пока не добавлена.';

  @override
  String get eventDescriptionTitle => 'Описание ивента';

  @override
  String get eventProgressShowGallery => 'Галерея';

  @override
  String get eventDescriptionLoadFailed =>
      'Не удалось загрузить описание. Попробуйте снова.';

  @override
  String get eventDescriptionEmpty =>
      'Для этого ивента пока не добавлено текстовое описание.';

  @override
  String get eventSettingsBrandTitle => 'Требования бренда';

  @override
  String get eventSettingsBrandSubtitle =>
      'Ознакомьтесь с рекомендациями бренда для участия в ивенте';

  @override
  String get eventSettingsBrandCta => 'РУКОВОДСТВО';

  @override
  String get brandRequirementsLoadFailed =>
      'Не удалось загрузить требования бренда. Попробуйте снова.';

  @override
  String get brandRequirementsEmpty =>
      'Для этого ивента требования брендов пока не добавлены.';

  @override
  String get brandRequirementsEmptyItem =>
      'Для этого бренда требования пока не заполнены.';

  @override
  String get brandRequirementsPickBrandTitle => 'Выберите бренд';

  @override
  String brandRequirementsBrandNumber(int brandId) {
    return 'Бренд $brandId';
  }

  @override
  String get eventSettingsChatTitle => 'Общий чат';

  @override
  String get eventSettingsChatSubtitle =>
      'Общий чат с участниками группы и менеджерами';

  @override
  String get eventSettingsChatCta => 'ОТКРЫТЬ ЧАТ';

  @override
  String get chatRoomsLoadFailed =>
      'Не удалось загрузить комнаты чата. Попробуйте снова.';

  @override
  String get chatNoRooms =>
      'Для ваших брендов в этом ивенте пока нет чат-комнат.';

  @override
  String get chatNoMessagesYet => 'Сообщений пока нет';

  @override
  String get chatLoadFailed =>
      'Не удалось загрузить сообщения. Попробуйте снова.';

  @override
  String get chatSendFailed =>
      'Не удалось отправить сообщение. Попробуйте снова.';

  @override
  String get chatMessagePlaceholder => 'Сообщение в чат...';

  @override
  String get chatReply => 'Ответить';

  @override
  String get chatReplyCancel => 'Отмена';

  @override
  String chatReplyingTo(String name) {
    return 'Ответ для $name';
  }

  @override
  String get chatReplyPreviewPhoto => 'Фото';

  @override
  String eventSettingsChatMoreParticipants(int count) {
    return '+$count';
  }

  @override
  String get mealChoiceTitle => 'Выбор обеда';

  @override
  String get mealSelectChildLabel => 'Ребёнок';

  @override
  String get mealSelectDishLabel => 'Блюдо';

  @override
  String get mealSave => 'ЗАКАЗАТЬ';

  @override
  String get mealNoMealsConfigured =>
      'Для этого ивента пока не добавлены блюда.';

  @override
  String get mealSaved => 'Сохранено';

  @override
  String get mealSaveError => 'Не удалось сохранить. Попробуйте снова.';

  @override
  String get mealOrdersClosed => 'Приём заказов закрыт';

  @override
  String get mealPaid => 'Оплачено';

  @override
  String get mealPaidDetail => 'Обед по этому ивенту оплачен.';

  @override
  String get mealPayInBrowser =>
      'Завершите оплату в браузере и вернитесь в приложение.';

  @override
  String get mealCheckoutError => 'Не удалось начать оплату. Попробуйте снова.';

  @override
  String get mealAwaitingPayment => 'Заказ оформлен — ожидает оплаты';

  @override
  String get mealAwaitingPaymentDetail =>
      'Блюдо сохранено. Завершите оплату в браузере; статус обновится после подтверждения Stripe.';

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
  String get fillOutApplication => 'Заполнить\nзаявку';

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

  @override
  String get myTicketsButton => 'МОИ БИЛЕТЫ';

  @override
  String get myTicketsTitle => 'Мои билеты';

  @override
  String get selectEventForTickets => 'Выберите мероприятие';

  @override
  String get ticketsMomName => 'Имя родителя';

  @override
  String get ticketsEventDate => 'Дата';

  @override
  String get ticketsOpenPdf => 'ОТКРЫТЬ';

  @override
  String get ticketsPdfUnavailable => 'PDF пока недоступен';

  @override
  String get ticketsBuy => 'КУПИТЬ БИЛЕТ';

  @override
  String get ticketsBuyNoLink =>
      'Ссылка на покупку не задана. Укажите в админке ссылку на магазин билетов для ивента или сайт в разделе Info.';

  @override
  String get ticketsBuyCouldNotOpen => 'Не удалось открыть ссылку.';

  @override
  String get ticketsBuySubtitle => 'Доступны VIP и стандартные места';

  @override
  String get ticketsNoEvents => 'Пока нет событий с билетами';

  @override
  String get ticketsNoneForEvent => 'Нет билетов на это событие';

  @override
  String get ticketsLoadError => 'Не удалось загрузить билеты';

  @override
  String get ticketsEventsLoadError => 'Не удалось загрузить события';

  @override
  String get faqBrandCatalogTitle => 'Бренды одежды';

  @override
  String get pdfViewerTitle => 'Билет';

  @override
  String get contactFormLinkMissing =>
      'Ссылка на форму не задана. Укажите «Ссылка на форму» в общих настройках приложения в админке.';

  @override
  String get infoHubTitle => 'Информационный центр';

  @override
  String get infoMenuAboutYfs => 'О YFS';

  @override
  String get infoMenuGeneralFaq => 'Общий FAQ';

  @override
  String get infoMenuContactManager => 'Связаться с менеджером';

  @override
  String get infoFooterBrand => 'YFS';

  @override
  String get infoFooterCopyright =>
      '© 2024 Young Fashion Series. Все права защищены.';

  @override
  String parentProgressLabel(int completed, int total) {
    return 'Прогресс родителя: $completed/$total';
  }

  @override
  String get appUpdateRequiredMessage =>
      'Обновите приложение, чтобы продолжить.';

  @override
  String get appUpdateButton => 'Обновить приложение';

  @override
  String get showAll => 'Показать все';

  @override
  String get staffNoneSelected => '— Нет —';

  @override
  String staffScanFailed(String error) {
    return 'Ошибка сканирования: $error';
  }

  @override
  String get staffScanSelectEventStageFirst =>
      'Выберите активное событие и этап в настройках персонала перед сканированием.';

  @override
  String get staffScanProcessed => 'Сканирование выполнено';

  @override
  String get chatCouldNotPickPhoto => 'Не удалось выбрать фото';

  @override
  String get staffChildProfileTitle => 'Профиль ребёнка';

  @override
  String get staffCurrentStage => 'ТЕКУЩИЙ ЭТАП';

  @override
  String staffProgressPercentComplete(int percent) {
    return '$percent% завершено';
  }

  @override
  String get staffChildDetailEmpty => 'Нет данных о ребёнке в БД';

  @override
  String get staffLoadFailed => 'Не удалось загрузить';

  @override
  String get staffGuardianLiaison => 'КУРАТОР';

  @override
  String get staffAssignedBrand => 'НАЗНАЧЕННЫЙ БРЕНД';

  @override
  String get staffSupervisor => 'СУПЕРВАЙЗЕР';

  @override
  String get staffSectionCoreDetails => 'Основные данные';

  @override
  String get staffSectionParentContact => 'Контакт родителя';

  @override
  String staffPhaseWithName(String stageName) {
    return 'Фаза: $stageName';
  }

  @override
  String get staffNoCurrentStage => 'Нет текущего этапа';

  @override
  String staffAgeYearsOld(int age) {
    return '$age лет';
  }

  @override
  String get staffNotesLabel => 'Заметки';

  @override
  String get staffParentRoleDefault => 'Родитель';

  @override
  String get contactManagerIntro =>
      'Вы можете оставить сообщение по любому вопросу — с вами свяжутся в ближайшее время.';

  @override
  String get contactManagerMessageLabel => 'Ваше сообщение';

  @override
  String get contactManagerMessageRequired => 'Введите текст сообщения';

  @override
  String get contactManagerSend => 'Отправить';

  @override
  String get contactManagerSent =>
      'Сообщение отправлено. Мы свяжемся с вами в ближайшее время.';

  @override
  String get contactManagerSendFailed =>
      'Не удалось отправить. Попробуйте позже.';

  @override
  String get contactManagerServiceUnavailable =>
      'Связь временно недоступна. Попробуйте позже.';
}
