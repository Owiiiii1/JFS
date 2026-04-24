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
  String get email => 'Электронная почта';

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
  String get registerNameLabel => 'Введите имя и фамилию';

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
  String get loginPasswordOptionalHint =>
      'Если профиль создал админ или импорт, оставьте пароль пустым и продолжайте.';

  @override
  String get setPasswordTitle => 'Создание пароля';

  @override
  String setPasswordSubtitle(String email) {
    return 'Создайте пароль для $email';
  }

  @override
  String get passwordSetupMinLength => 'Пароль должен быть не менее 6 символов';

  @override
  String get savePasswordAndContinue => 'Сохранить пароль и продолжить';

  @override
  String passwordSetupFailed(String error) {
    return 'Не удалось создать пароль: $error';
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
  String get timeDisplayFormat => 'Формат времени';

  @override
  String get timeFormat24Hour => '24-часовой';

  @override
  String get timeFormat12Hour => '12-часовой (AM/PM)';

  @override
  String get metricUnits => 'Метрические (см, кг)';

  @override
  String get imperialUnits => 'Американские (in, lb)';

  @override
  String get systemLanguage => 'Системный';

  @override
  String get languageRussian => 'Русский';

  @override
  String get languageEnglish => 'Английский';

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
  String childSubscribedBrands(String brands) {
    return 'Бренды: $brands';
  }

  @override
  String get unknownError => 'Неизвестная ошибка';

  @override
  String model(String name) {
    return 'Модель: $name';
  }

  @override
  String get active => 'АКТИВНО';

  @override
  String get familyLabel => 'FAMILY';

  @override
  String get familyJoinButton => 'ПРИСОЕДИНИТЬСЯ К СЕМЬЕ';

  @override
  String get familyJoinDialogHint => 'Введите 6-значный семейный код.';

  @override
  String get familyJoinAction => 'Подключиться';

  @override
  String get familyJoinInvalidCode => 'Введите корректный 6-значный код.';

  @override
  String get familyJoinSuccess => 'Семейная подписка подключена.';

  @override
  String get contractWarningTitle => 'Предупреждение';

  @override
  String get contractWarningFallbackText =>
      'Перед покупкой билетов ознакомьтесь и подпишите договор.';

  @override
  String get contractViewButton => 'Просмотреть';

  @override
  String get contractPreviewTitle => 'Текст договора';

  @override
  String get contractSignButton => 'Подписать';

  @override
  String get contractSignatureTitle => 'Поставьте подпись';

  @override
  String get contractSignedSuccess => 'Договор успешно подписан.';

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
  String get eventSettingsFamilyButton => 'Семья';

  @override
  String get familyManageTitle => 'Семья';

  @override
  String get familyManageEnabled => 'Активировать семейные подключения';

  @override
  String get familyManageCodeLabel => 'Семейный код';

  @override
  String get familyManageRegenerateCode => 'Изменить код';

  @override
  String get familyManageConnectionsTitle => 'Активные семейные подключения';

  @override
  String get familyManageNoConnections =>
      'Активных семейных подключений пока нет.';

  @override
  String get familyManageUnknownUser => 'Неизвестный пользователь';

  @override
  String get eventSettingsLeaveFamilyButton => 'Отключиться от семьи';

  @override
  String get eventSettingsLeaveFamilyConfirmTitle =>
      'Отключить семейный доступ?';

  @override
  String get eventSettingsLeaveFamilyConfirmText =>
      'Вы потеряете семейный доступ к ивенту, пока не подключитесь снова по коду.';

  @override
  String get eventSettingsLeaveFamilySuccess =>
      'Семейное подключение отключено.';

  @override
  String get eventSettingsMealTitle => 'Выбор питания';

  @override
  String get eventSettingsMealSubtitle => 'Выберите блюдо на текущий ивент';

  @override
  String get eventSettingsMealCta => 'МЕНЮ';

  @override
  String eventSettingsMealOrderedPcs(int count) {
    return 'Заказано: $count шт.';
  }

  @override
  String get eventSettingsMealPurchasesListHeading => 'Оформленные заказы';

  @override
  String eventSettingsMealPurchaseChildLine(String name) {
    return 'Ребёнок: $name';
  }

  @override
  String get mealPurchaseIssued => 'Выдано';

  @override
  String get mealPurchaseNotIssued => 'Не выдан';

  @override
  String get eventSettingsRehearsalTitle => 'Запись на репетицию';

  @override
  String get eventSettingsRehearsalSubtitle =>
      'Забронируйте место на репетицию';

  @override
  String get eventSettingsRehearsalCta => 'ЗАПИСАТЬСЯ';

  @override
  String get eventSettingsBrandRehearsalsHeading => 'Ваши репетиции брендов';

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
  String get rehearsalUpdateBooking => 'Добавить и обновить бронирование';

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
  String get eventProgressCheckin => 'Чекин';

  @override
  String get eventProgressCheckinPrompt => 'Отсканируйте для старта ивента';

  @override
  String get eventProgressCheckinUnavailable => 'Чекин-код пока недоступен.';

  @override
  String get eventDescriptionLoadFailed =>
      'Не удалось загрузить описание. Попробуйте снова.';

  @override
  String get eventDescriptionEmpty =>
      'Для этого ивента пока не добавлено текстовое описание.';

  @override
  String get eventSettingsBrandTitle => 'Обувь и носки';

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
  String get eventSettingsParkingTitle => 'Валет-парковка';

  @override
  String get eventSettingsParkingSubtitle =>
      'Откройте пропуск на валет-парковку и статус прибытия';

  @override
  String get eventSettingsParkingCta => 'ОТКРЫТЬ ВАЛЕТ-ПАРКОВКУ';

  @override
  String get parkingChooseModeTitle => 'Режим валет-парковки';

  @override
  String get parkingChooseModeHint =>
      'Выберите состояние экрана для теста визуала.';

  @override
  String get parkingModeInactive => 'НЕ АКТИВНО';

  @override
  String get parkingModeActive => 'АКТИВНО';

  @override
  String get parkingInactiveHeadline => 'ВАЛЕТ-ПАРКОВКА НЕ АКТИВНА';

  @override
  String get parkingInactiveBody =>
      'ВАЛЕТ-ПАРКОВКА ПОЯВИТСЯ ЗДЕСЬ ПОСЛЕ ПОКУПКИ БИЛЕТА.';

  @override
  String get parkingInactiveBuyCta => 'КУПИТЬ';

  @override
  String get parkingInactiveVipBody =>
      'ДЛЯ VIP ВАЛЕТ-ПАРКОВКИ — ЗАБРОНИРУЙТЕ МЕСТО ДЛЯ ВАШЕГО АВТОМОБИЛЯ.';

  @override
  String get parkingInactiveVipBookCta => 'ЗАКАЗАТЬ ВАЛЕТ-ПАРКОВКУ';

  @override
  String get parkingPayForParkingCta => 'ОПЛАТИТЬ ВАЛЕТ-ПАРКОВКУ';

  @override
  String get parkingVipQuotaNextPaymentBody =>
      'БЕСПЛАТНЫЕ ВАЛЕТ-БИЛЕТЫ НА ЭТОТ ИВЕНТ ИСЧЕРПАНЫ. МОЖНО ОФОРМИТЬ ЕЩЁ МЕСТО ПО ОБЫЧНОЙ ЦЕНЕ.';

  @override
  String parkingFreeTicketsQuotaLine(int used, int quota, int remaining) {
    return 'Бесплатный валет: использовано $used из $quota (осталось $remaining)';
  }

  @override
  String get parkingActiveTicketLabel => 'БИЛЕТ';

  @override
  String get parkingTicketMock1 => 'БИЛЕТ A1 · МОДЕЛЬ';

  @override
  String get parkingTicketMock2 => 'БИЛЕТ B7 · ГОСТЬ';

  @override
  String get parkingActiveValetLabel => 'VALET SERVICE';

  @override
  String get parkingActiveStatusLine => 'ВАЛЕТ-ПАРКОВКА АКТИВНА';

  @override
  String get parkingActiveShowEntryPointCta => 'ПОКАЗАТЬ ТОЧКУ ВЪЕЗДА';

  @override
  String get parkingActiveCarLabel => 'АВТОМОБИЛЬ';

  @override
  String get parkingActiveRegistrationNumberLabel => 'НОМЕРНОЙ ЗНАК';

  @override
  String get parkingCreateTicketTitle => 'Создать билет';

  @override
  String get parkingCreateEventLabel => 'Ивент';

  @override
  String get parkingCreateAccountNameLabel => 'Имя';

  @override
  String get parkingCreateCarModelLabel => 'МАРКА И МОДЕЛЬ';

  @override
  String get parkingCreateCarModelHint => 'Например: Ford Mustang';

  @override
  String get parkingCreatePlateNumberLabel => 'НОМЕРНОЙ ЗНАК';

  @override
  String get parkingCreatePlateNumberHint => 'Например: CA 7JXK921';

  @override
  String get parkingCreateRepeatPlateNumberLabel => 'ПОВТОРИТЕ НОМЕРНОЙ ЗНАК';

  @override
  String get parkingCreateRepeatPlateNumberHint =>
      'Повторно введите номерной знак';

  @override
  String get parkingCreatePlateNumberMismatch => 'Номерные знаки не совпадают';

  @override
  String get parkingCreateBuyCta => 'КУПИТЬ';

  @override
  String get parkingCreateBookCta => 'ЗАКАЗАТЬ ВАЛЕТ-ПАРКОВКУ';

  @override
  String get parkingCheckoutInBrowser => 'Завершите оплату в браузере.';

  @override
  String get parkingPurchasedWithoutPayment => 'Билет успешно куплен.';

  @override
  String get parkingVipBooked => 'VIP валет-парковка успешно забронирована.';

  @override
  String get parkingCheckoutError =>
      'Не удалось начать оплату валет-парковки. Попробуйте снова.';

  @override
  String get clientTicketServiceUnavailableTitle => 'Сервис недоступен';

  @override
  String get clientTicketServiceUnavailableBody =>
      'Этот сервис билетов сейчас не активен.';

  @override
  String get parkingActivePassLabel => 'КОД ПРОПУСКА';

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
  String get chatEdit => 'Изменить';

  @override
  String get chatDelete => 'Удалить';

  @override
  String get chatDeleteTitle => 'Удалить сообщение?';

  @override
  String get chatDeleteMessageConfirm => 'Это действие нельзя отменить.';

  @override
  String get chatDeleteFailed =>
      'Не удалось удалить сообщение. Попробуйте снова.';

  @override
  String get chatEditFailed =>
      'Не удалось изменить сообщение. Попробуйте снова.';

  @override
  String get chatEditingLabel => 'Редактирование сообщения';

  @override
  String get chatCancelEdit => 'Отменить редактирование';

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
  String get mealPaymentContinue => 'Продолжить оплату';

  @override
  String get mealPaymentCancel => 'Отменить оплату';

  @override
  String get mealPaymentStartAgain => 'Начать оплату снова';

  @override
  String get mealPaymentCanceled => 'Оплата отменена. Можно начать заново.';

  @override
  String get mealPaymentStatusLoadError =>
      'Не удалось загрузить статус оплаты. Попробуйте снова.';

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
  String get eventsYoutubeLiveButton => 'YouTube трансляция';

  @override
  String get eventsYoutubeLiveInvalidUrl =>
      'Не удалось открыть эту ссылку YouTube.';

  @override
  String get eventsYoutubeLiveOpenExternally => 'Открыть в YouTube';

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
  String get ticketsBuyEmailHint =>
      'Ваши билеты придут на электронную почту, указанную при покупке билета.';

  @override
  String get extraTicketButton => 'OPEN BAR';

  @override
  String get extraTicketSelectEventFirst => 'Сначала выберите ивент.';

  @override
  String get extraTicketNoActiveHeadline => 'НЕТ АКТИВНЫХ BEVERAGE PACKAGE';

  @override
  String get extraTicketBuyCta => 'КУПИТЬ';

  @override
  String get extraTicketAccessOpen => 'ДОСТУП К BEVERAGE PACKAGE ОТКРЫТ';

  @override
  String get extraTicketCheckoutInBrowser => 'Завершите оплату в браузере.';

  @override
  String get extraTicketCheckoutError =>
      'Не удалось запустить оплату BEVERAGE PACKAGE. Попробуйте снова.';

  @override
  String get backstageTicketButton => 'BACKSTAGE PASS';

  @override
  String get backstageTicketSelectEventFirst => 'Сначала выберите ивент.';

  @override
  String get backstageTicketNoActiveHeadline => 'НЕТ АКТИВНЫХ BACKSTAGE PASS';

  @override
  String get backstageTicketBuyCta => 'КУПИТЬ';

  @override
  String get backstageTicketAccessOpen => 'ДОСТУП К BACKSTAGE PASS ОТКРЫТ';

  @override
  String get backstageTicketCheckoutInBrowser => 'Завершите оплату в браузере.';

  @override
  String get backstageTicketCheckoutError =>
      'Не удалось запустить оплату BACKSTAGE PASS. Попробуйте снова.';

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
  String get staffRoleInactive => 'НЕАКТИВНА';

  @override
  String get staffWorkerStatusRefreshFailed =>
      'Не удалось обновить статус роли. Проверьте соединение.';

  @override
  String get staffScanRoleInactive =>
      'Эта роль отключена в админке. Сканирование недоступно.';

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
  String get staffEventTimelineButton => 'ТАЙМЛАЙН';

  @override
  String get staffEventTimelineTitle => 'Таймлайн ивента';

  @override
  String get staffParentTimelineButton1 => 'ТАЙМЛАЙН РОДИТЕЛЯ 1';

  @override
  String get staffParentTimelineButton2 => 'ТАЙМЛАЙН РОДИТЕЛЯ 2';

  @override
  String get staffParentTimelineTitle1 => 'Таймлайн родителя 1';

  @override
  String get staffParentTimelineTitle2 => 'Таймлайн родителя 2';

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
  String get staffAssignedPackage => 'ПАКЕТ';

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

  @override
  String get close => 'Закрыть';

  @override
  String get staffPortalTitle => 'Портал сотрудников';

  @override
  String get staffActiveEvent => 'Активное событие';

  @override
  String get staffActiveStage => 'Активный этап';

  @override
  String get staffSelectEvent => 'Выберите событие';

  @override
  String get staffSelectEventInSettings =>
      'Выберите событие в настройках сотрудника';

  @override
  String get staffSelectStage => 'Выберите этап';

  @override
  String staffPreparatoryStageLabel(String stageName) {
    return 'Подготовка: $stageName';
  }

  @override
  String get staffScanButton => 'СКАН';

  @override
  String get staffQrCheckButton => 'QR-ПРОВЕРКА';

  @override
  String get staffParkingButton => 'ВАЛЕТ-ПАРКОВКА';

  @override
  String get staffExtraZoneButton => 'BEVERAGE PACKAGE';

  @override
  String get staffBackstageButton => 'BACKSTAGE PASS';

  @override
  String get staffRehearsalCheckinButton => 'ЧЕК-ИН РЕПЕТИЦИЙ';

  @override
  String get staffTapToScanModelLanyard =>
      'НАЖМИТЕ, ЧТОБЫ СКАНИРОВАТЬ БЕЙДЖ МОДЕЛИ';

  @override
  String get staffTapToScanParkingQr =>
      'НАЖМИТЕ, ЧТОБЫ СКАНИРОВАТЬ QR ВАЛЕТ-ПАРКОВКИ';

  @override
  String get staffTapToScanExtraZoneQr =>
      'НАЖМИТЕ, ЧТОБЫ СКАНИРОВАТЬ QR BEVERAGE PACKAGE';

  @override
  String get staffTapToScanBackstageQr =>
      'НАЖМИТЕ, ЧТОБЫ СКАНИРОВАТЬ QR BACKSTAGE PASS';

  @override
  String get staffTapToScanRehearsalCheckinQr =>
      'НАЖМИТЕ, ЧТОБЫ СКАНИРОВАТЬ QR ЧЕК-ИНА РЕПЕТИЦИЙ';

  @override
  String get staffMealHandoutButton => 'ОБЕД';

  @override
  String get staffTapToScanMealBadge => 'СКАН БЕЙДЖА РЕБЁНКА ИЛИ РОДИТЕЛЯ';

  @override
  String get staffMealIssueTitle => 'Выдача обедов';

  @override
  String get staffMealIssueNoMeals => 'По этому бейджу нет заказанных обедов.';

  @override
  String get staffMealIssueHandOut => 'Выдать';

  @override
  String get staffMealIssueSuccess => 'Отмечено как выдано.';

  @override
  String staffMealIssueFailure(String error) {
    return 'Не удалось: $error';
  }

  @override
  String get staffMealIssueAlreadyIssued => 'уже выдано';

  @override
  String get staffTapToScanQrCheck =>
      'НАЖМИТЕ ДЛЯ СКАНА БЕЙДЖА — ЭТАП И КАРТОЧКА';

  @override
  String get staffCurrentTask => 'Текущая задача';

  @override
  String get staffUtilitiesAndTools => 'ИНСТРУМЕНТЫ';

  @override
  String get staffScanForInfoTitle => 'Скан для информации';

  @override
  String get staffScanForInfoSubtitle => 'Сканер бейджей и служебных QR';

  @override
  String get staffToiletRequest => 'Запрос в туалет';

  @override
  String get staffRestroomLog => 'ЖУРНАЛ ТУАЛЕТА';

  @override
  String get staffSettingsCardTitle => 'Настройки сотрудника';

  @override
  String get staffPreferences => 'ПРЕДПОЧТЕНИЯ';

  @override
  String get staffSupervisorRoleTitle => 'Роль супервайзера';

  @override
  String get staffSupervisorRoleDescription =>
      'Управляйте потоком события, контролируйте фотографов и следите, чтобы все дети были охвачены. Отслеживайте прогресс в реальном времени.';

  @override
  String get staffCurrentStageLabel => 'Текущий этап';

  @override
  String get staffNoMainStagesAvailable =>
      'Для этого события нет основных этапов.';

  @override
  String get staffChildRegistry => 'Реестр детей';

  @override
  String staffChildrenListed(int count) {
    return 'Детей в списке: $count';
  }

  @override
  String get staffSelectActiveEventForRegistry =>
      'Выберите активное событие в настройках, чтобы увидеть реестр детей.';

  @override
  String get staffNoChildrenAssigned =>
      'Для этого события нет назначенных детей.';

  @override
  String get staffRehearsalAdminSlotsTitle => 'Слоты репетиций';

  @override
  String get staffRehearsalCheckinActiveSlot => 'Активный слот репетиции';

  @override
  String get staffRehearsalAdminSelectSlot => 'Выберите слот репетиции';

  @override
  String get staffRehearsalCheckinSelectSlotFirst =>
      'Сначала выберите слот репетиции';

  @override
  String get staffRehearsalAdminBookedChildrenTitle => 'Записанные дети';

  @override
  String get staffRehearsalAdminNoSlots =>
      'Для этого события нет созданных слотов репетиций.';

  @override
  String get staffRehearsalAdminNoChildrenForSlot =>
      'На этот слот пока никто не записан.';

  @override
  String get staffGiftControlButton => 'КОНТРОЛЬ';

  @override
  String get staffGiftControlTitle => 'Контроль выдачи подарков';

  @override
  String get staffGiftControlSelectStage => 'Выберите этап отчета';

  @override
  String get staffGiftControlFilterAll => 'Все';

  @override
  String get staffGiftControlFilterPassed => 'Пройдено';

  @override
  String get staffGiftControlFilterNotPassed => 'Не пройдено';

  @override
  String get staffGiftControlNoChildren => 'Нет детей по выбранным фильтрам.';

  @override
  String get staffTableProfile => 'ПРОФИЛЬ';

  @override
  String get staffTableName => 'ИМЯ';

  @override
  String get staffTableStatus => 'СТАТУС';

  @override
  String get staffTableAction => 'ДЕЙСТВИЕ';

  @override
  String get staffYes => 'Да';

  @override
  String get staffNo => 'Нет';

  @override
  String get staffRoleHostessTitle => 'Роль: хостесс';

  @override
  String get staffRoleHostessPlaceholder =>
      'Экран роли хостесс будет добавлен позже.';

  @override
  String get staffRoleInterviewTitle => 'Роль: интервью';

  @override
  String get staffRoleInterviewPlaceholder =>
      'Экран роли интервью будет добавлен позже.';

  @override
  String get staffRoleLunchesTitle => 'Роль: обеды';

  @override
  String get staffRoleLunchesPlaceholder =>
      'Экран роли обедов будет добавлен позже.';

  @override
  String get staffRoleSuperadminTitle => 'Роль: суперадмин';

  @override
  String get staffRoleSuperadminPlaceholder =>
      'Экран роли суперадмина будет добавлен позже.';

  @override
  String get staffRoleRehearsalAdminTitle => 'Роль: админ репетиций';

  @override
  String get staffRoleRehearsalAdminPlaceholder =>
      'Экран роли админа репетиций будет добавлен позже.';

  @override
  String get staffNavHome => 'Главная';

  @override
  String get staffNavEvent => 'Событие';

  @override
  String get staffNavMore => 'Еще';

  @override
  String get staffAccessBadge => 'ДОСТУП СОТРУДНИКА';

  @override
  String get staffVenueAndContact => 'Локация и контакты';

  @override
  String get staffMainOffice => 'Главный офис';

  @override
  String get staffSecurity => 'Охрана';

  @override
  String get staffScanHeaderParking => 'Скан валет-парковки';

  @override
  String get staffScanHeaderExtraZone => 'Вход: BEVERAGE PACKAGE';

  @override
  String get staffScanHeaderBackstage => 'Вход: BACKSTAGE PASS';

  @override
  String get staffScanHeaderRehearsalCheckin => 'Чекин репетиций';

  @override
  String get staffScanHeaderInfo => 'Скан для информации';

  @override
  String get staffScanHeaderQr => 'Скан QR кода';

  @override
  String get staffScanHintParking =>
      'Сканируйте QR валет-парковки, чтобы показать данные талона';

  @override
  String get staffScanHintExtraZone =>
      'Сканируйте QR BEVERAGE PACKAGE для входа';

  @override
  String get staffScanHintBackstage => 'Сканируйте QR BACKSTAGE PASS для входа';

  @override
  String get staffScanHintRehearsalCheckin =>
      'Сканируйте check-in QR ребенка, чтобы закрыть прохождение репетиции';

  @override
  String get staffScanHintInfo =>
      'Сканируйте бейдж ребенка или родителя, чтобы открыть профиль';

  @override
  String get staffScanHintQr => 'Поместите QR-код в рамку';

  @override
  String get staffScanHeaderQrCheck => 'QR-проверка';

  @override
  String get staffScanHintQrCheck =>
      'Сканируйте бейдж ребёнка, чтобы отметить выбранный этап, затем откроется карточка';

  @override
  String get staffQrCheckSuccessTitle => 'Этап отмечен';

  @override
  String get staffQrCheckSuccessContinue => 'Далее';

  @override
  String get staffScanErrorTitle => 'Ошибка сканирования';

  @override
  String get staffScanErrorUnknown => 'Неизвестная ошибка сканирования.';

  @override
  String get staffParkingTicketTitle => 'Талон валет-парковки';

  @override
  String get staffExtraZonePassTitle => 'Пропуск BEVERAGE PACKAGE';

  @override
  String get staffExtraZoneScanResultTitle => 'Результат сканирования';

  @override
  String get staffExtraZoneResultNotFound => 'КОД ОТСУТСТВУЕТ В БАЗЕ';

  @override
  String get staffExtraZoneResultAccessGranted => 'КОД ПРИНЯТ, ПРОХОД РАЗРЕШЕН';

  @override
  String get staffExtraZoneResultAccessClosed => 'КОД ПРИНЯТ, НО ДОСТУП ЗАКРЫТ';

  @override
  String get staffBackstageScanResultTitle => 'Результат сканирования';

  @override
  String get staffBackstageResultNotFound => 'КОД ОТСУТСТВУЕТ В БАЗЕ';

  @override
  String get staffBackstageResultAccessGranted => 'КОД ПРИНЯТ, ПРОХОД РАЗРЕШЕН';

  @override
  String get staffBackstageResultAccessClosed => 'КОД ПРИНЯТ, НО ДОСТУП ЗАКРЫТ';

  @override
  String get staffRehearsalCheckinScanResultTitle => 'Результат сканирования';

  @override
  String get staffRehearsalCheckinResultNotFound => 'CHECK-IN КОД НЕ НАЙДЕН';

  @override
  String get staffRehearsalCheckinResultWrongSlot =>
      'РЕБЕНОК НЕ ЗАПИСАН НА ЭТОТ СЛОТ';

  @override
  String get staffRehearsalCheckinResultAlreadyClosed =>
      'ЧЕК-ИН РЕПЕТИЦИИ УЖЕ ЗАКРЫТ';

  @override
  String get staffRehearsalCheckinResultClosedNow => 'ЧЕК-ИН РЕПЕТИЦИИ ЗАКРЫТ';

  @override
  String get staffRehearsalCheckinFieldChild => 'Ребенок';

  @override
  String get staffRehearsalCheckinFieldSlot => 'Слот';

  @override
  String get staffParkingFieldEvent => 'Событие';

  @override
  String get staffParkingFieldClient => 'Клиент';

  @override
  String get staffParkingFieldCar => 'Автомобиль';

  @override
  String get staffParkingFieldPlateNumber => 'Госномер';

  @override
  String get staffParkingFieldVipClient => 'VIP клиент';

  @override
  String get staffShowProgressTitle => 'Прогресс шоу';

  @override
  String get staffCouldNotOpenDialer => 'Не удалось открыть набор номера';

  @override
  String get staffRealtimeTracking => 'ОТСЛЕЖИВАНИЕ В РЕАЛЬНОМ ВРЕМЕНИ';

  @override
  String get staffEstimatedCompletion => 'ПРИМЕРНОЕ ЗАВЕРШЕНИЕ';

  @override
  String get staffNoMainStagesInPlan => 'В плане пока нет основных этапов.';

  @override
  String get staffStatusDone => 'ГОТОВО';

  @override
  String get staffStatusInProgress => 'В ПРОЦЕССЕ';

  @override
  String get staffStatusPending => 'ОЖИДАНИЕ';

  @override
  String get staffContactDetails => 'Контактные данные';

  @override
  String get staffPrimaryParent => 'ОСНОВНОЙ РОДИТЕЛЬ';

  @override
  String staffIdLabel(String id) {
    return 'ID сотрудника: $id';
  }

  @override
  String get staffSwitchRole => 'Сменить роль';

  @override
  String staffCurrentRoleLabel(String role) {
    return 'ТЕКУЩАЯ: $role';
  }

  @override
  String get staffRoleSubtitleScan => 'Скан QR и этапы';

  @override
  String get staffRoleSubtitleQrCheck =>
      'Отметка этапа по бейджу, затем карточка ребёнка';

  @override
  String get staffRoleSubtitleSupervisor => 'Полный доступ и управление';

  @override
  String get staffRoleSubtitleHostess => 'Поддержка гостей и зон';

  @override
  String get staffRoleSubtitleParking => 'Валет-парковка и доступ';

  @override
  String get staffRoleSubtitleExtraZone => 'Доступ к BEVERAGE PACKAGE';

  @override
  String get staffRoleSubtitleBackstage => 'Доступ к BACKSTAGE PASS';

  @override
  String get staffRoleSubtitleRehearsalAdmin => 'Управление репетициями';

  @override
  String get staffRoleSubtitleRehearsalCheckin =>
      'Скан check-in по слотам репетиций';

  @override
  String get staffRoleSubtitleGiftIssue => 'Контроль выдачи подарков';

  @override
  String get staffRoleSubtitleInterview => 'Поток интервью';

  @override
  String get staffRoleSubtitleLunches => 'Питание и обеды';

  @override
  String get staffRoleSubtitleSuperadmin => 'Инструменты суперадмина';

  @override
  String get staffRoleSubtitlePhotographer => 'Съемка и загрузка медиа';

  @override
  String get staffRoleSubtitleStylist => 'Гардероб и макияж';

  @override
  String get staffHostessEntryMode => 'ВХОД';

  @override
  String get staffHostessExitMode => 'ВЫХОД';

  @override
  String get staffHostessEntryHint =>
      'Сканируйте бейдж ребенка, чтобы закрыть выбранный этап и синхронизировать родителей Family Look';

  @override
  String get staffHostessExitHint =>
      'Сканируйте бейдж ребенка или родителя, проверьте прогресс и закройте этап выхода';

  @override
  String get staffHostessEntryResultTitle => 'Результат сканирования входа';

  @override
  String get staffHostessExitResultTitle => 'Результат сканирования выхода';

  @override
  String get staffHostessFieldChildName => 'Имя';

  @override
  String get staffHostessFieldParent => 'Родитель';

  @override
  String get staffHostessFieldBrandsAndSupervisors => 'Бренды и супервайзеры';

  @override
  String get staffHostessFieldFamilyLook => 'Family Look';

  @override
  String get staffHostessFamilyLookEnabled => 'Family Look активирован';

  @override
  String get staffHostessFieldStages => 'Этапы';

  @override
  String get staffHostessCloseEventAction => 'Закрыть ивент';

  @override
  String get staffHostessStageAlreadySelectedOtherMode =>
      'Этот этап уже выбран для другого режима хостесс.';

  @override
  String staffHostessRequiredProgress(int completed, int total) {
    return 'Обязательные этапы: $completed/$total';
  }
}
