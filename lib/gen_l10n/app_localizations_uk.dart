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
  String get email => 'Електронна пошта';

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
  String get apiEndpointNotFoundHint =>
      'Сервер не знайшов API (404). У збірці вкажіть корінь сайту без «/api» в кінці — застосунок сам звертається до /api/app/login. Якщо Laravel у підпапці, додайте шлях до каталогу public (наприклад https://example.com/myapp/public).';

  @override
  String get notificationsTitle => 'Сповіщення';

  @override
  String get notificationsLoadFailed =>
      'Не вдалося завантажити сповіщення. Спробуйте ще раз.';

  @override
  String get notificationsEmpty => 'Поки немає сповіщень.';

  @override
  String get notificationsNewMark => 'Нове';

  @override
  String get notificationDetailsTitle => 'Сповіщення';

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
  String get loginPasswordOptionalHint =>
      'Якщо профіль створив адмін або імпорт, залиште пароль порожнім і продовжуйте.';

  @override
  String get setPasswordTitle => 'Створення пароля';

  @override
  String setPasswordSubtitle(String email) {
    return 'Створіть пароль для $email';
  }

  @override
  String get passwordSetupMinLength => 'Пароль має бути не менше 6 символів';

  @override
  String get savePasswordAndContinue => 'Зберегти пароль і продовжити';

  @override
  String passwordSetupFailed(String error) {
    return 'Не вдалося створити пароль: $error';
  }

  @override
  String get account => 'Обліковий запис';

  @override
  String get editInfo => 'РЕДАГУВАТИ';

  @override
  String get fullName => 'Ім\'я';

  @override
  String get retry => 'Повторити';

  @override
  String get accountSettings => 'Налаштування облікового запису';

  @override
  String get editProfile => 'Редагувати профіль';

  @override
  String get deleteAccount => 'Видалити акаунт';

  @override
  String get deleteAccountConfirmTitle => 'Видалити акаунт?';

  @override
  String get deleteAccountConfirmMessage =>
      'Ви впевнені, що хочете назавжди видалити акаунт? Цю дію неможливо скасувати.';

  @override
  String get deleteAccountSecondTitle => 'Що буде видалено';

  @override
  String get deleteAccountSecondMessage =>
      'Буде безповоротно видалено з наших систем:\n\n• ваш акаунт і профіль;\n• усі діти, прив’язані до акаунту;\n• усі призначення на заходи, прогрес по етапах, квитки та вибір обідів;\n• фотографії та інші дані дітей;\n• участь у чатах заходів і сповіщення в застосунку.\n\nДеякі платіжні або бухгалтерські записи можуть зберігатися, якщо цього вимагає закон.';

  @override
  String get deleteAccountContinue => 'Далі';

  @override
  String get deleteAccountConfirmAction => 'Видалити назавжди';

  @override
  String get deleteAccountWorking => 'Видалення акаунта…';

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
  String get aboutTheApp => 'Про застосунок';

  @override
  String get aboutAppDisplayName => 'YoungFashionShow';

  @override
  String get aboutPublisherLine => 'YOUNGFASHIONSHOW';

  @override
  String get aboutVersionLabel => 'ВЕРСІЯ';

  @override
  String get aboutReleaseDateLabel => 'ДАТА ВИПУСКУ';

  @override
  String get aboutDevelopedByPrefix => 'РОЗРОБЛЕНО:';

  @override
  String get aboutDeveloperBrand => 'OWLSOLUTIONS';

  @override
  String get aboutLinkCouldNotOpen => 'Не вдалося відкрити посилання.';

  @override
  String get appLanguage => 'Мова застосунку';

  @override
  String get unitsOfMeasurement => 'Одиниці виміру';

  @override
  String get timeDisplayFormat => 'Формат часу';

  @override
  String get timeFormat24Hour => '24-годинний';

  @override
  String get timeFormat12Hour => '12-годинний (AM/PM)';

  @override
  String get metricUnits => 'Метричні (см, кг)';

  @override
  String get imperialUnits => 'Американські (in, lb)';

  @override
  String get systemLanguage => 'Системна';

  @override
  String get languageRussian => 'Русский';

  @override
  String get languageEnglish => 'Англійська';

  @override
  String get languageUkrainian => 'Українська';

  @override
  String get languageSpanishUS => 'Іспанська (США)';

  @override
  String get addChildTitle => 'Додати дитину';

  @override
  String get firstName => 'Ім\'я';

  @override
  String get gender => 'Стать';

  @override
  String get genderBoy => 'Хлопчик';

  @override
  String get genderGirl => 'Дівчинка';

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
  String get measurementLengthUnitCm => 'см';

  @override
  String get measurementLengthUnitIn => 'дюйм';

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
  String get journeyPreparationPhase => 'ПІДГОТОВКА';

  @override
  String get journeyMainEventTitle => 'ОСНОВНА ПОДІЯ';

  @override
  String get journeyMainEventSubtitle => 'ГОЛОВНЕ ШОУ';

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
  String get eventSettings => 'НАЛАШТУВАННЯ ІВЕНТУ';

  @override
  String get homeEventCardMyEvent => 'МІЙ ІВЕНТ';

  @override
  String get homeEventCardRunwayJourney => 'ШЛЯХ НА ПОДІУМ';

  @override
  String get eventSettingsPlaceholder =>
      'Тут незабаром з’являться налаштування івенту.';

  @override
  String get eventSettingsConfigurationPortal => 'ПОРТАЛ НАЛАШТУВАНЬ';

  @override
  String get eventSettingsMainHeadline => 'Налаштування івенту';

  @override
  String get eventSettingsMealTitle => 'Вибір харчування';

  @override
  String get eventSettingsMealSubtitle => 'Оберіть страву на поточний івент';

  @override
  String get eventSettingsMealCta => 'МЕНЮ';

  @override
  String get eventSettingsRehearsalTitle => 'Запис на репетицію';

  @override
  String get eventSettingsRehearsalSubtitle => 'Забронюйте місце на репетицію';

  @override
  String get eventSettingsRehearsalCta => 'ЗАПИСАТИСЯ';

  @override
  String get rehearsalModalTitle => 'Запис на репетицію';

  @override
  String get rehearsalSelectDate => 'Оберіть дату';

  @override
  String get rehearsalAvailableSlots => 'Доступні слоти';

  @override
  String get rehearsalFreeLabel => 'Вільно:';

  @override
  String get rehearsalNoSlotsConfigured =>
      'Для цього івенту ще немає слотів репетицій.';

  @override
  String get rehearsalLoadError =>
      'Не вдалося завантажити слоти. Спробуйте ще раз.';

  @override
  String get rehearsalBrandNotAssigned =>
      'Для цієї дитини не призначено бренд. Бронювання репетицій недоступне.';

  @override
  String get rehearsalFull => 'Місць немає';

  @override
  String get rehearsalConfirmBooking => 'Підтвердити запис';

  @override
  String get rehearsalBookingFooterNote =>
      'За можливості зміни вносьте за 24 години до слоту.';

  @override
  String get rehearsalBookedTitle => 'Репетицію заброньовано';

  @override
  String get rehearsalChangeBooking => 'Змінити бронювання';

  @override
  String get rehearsalProgramLabel => 'Опис';

  @override
  String get rehearsalArriveEarly => 'Приходьте за 15 хвилин до початку.';

  @override
  String get rehearsalBookingSaved => 'Запис збережено';

  @override
  String get rehearsalBookingError => 'Не вдалося завершити запис.';

  @override
  String get rehearsalSelectChild => 'Дитина';

  @override
  String get rehearsalUpdateBooking => 'Змінити запис';

  @override
  String get rehearsalCancelChange => 'Скасувати';

  @override
  String get rehearsalChangeBookingLockedHint =>
      'Організатор закрив зміну запису. Зверніться в підтримку, якщо потрібна допомога.';

  @override
  String get rehearsalMilestoneTitle => 'Загальна репетиція';

  @override
  String rehearsalBrandMilestoneTitle(String brandName) {
    return 'Репетиція бренду: $brandName';
  }

  @override
  String get rehearsalBrandMilestoneShort => 'Репетиція бренду';

  @override
  String get rehearsalNextBookHint =>
      'Запишіться на репетицію в налаштуваннях івенту.';

  @override
  String get eventSettingsPackingTitle => 'Список «Не забудьте»';

  @override
  String get eventSettingsPackingSubtitle => '';

  @override
  String get eventSettingsPackingCta => 'ВІДКРИТИ СПИСОК';

  @override
  String get eventPackingLoadFailed =>
      'Не вдалося завантажити інформацію. Спробуйте ще раз.';

  @override
  String get eventPackingEmpty => 'Для цього івенту інформацію ще не додано.';

  @override
  String get eventDescriptionTitle => 'Опис івенту';

  @override
  String get eventProgressShowGallery => 'Галерея';

  @override
  String get eventProgressCheckin => 'Чекін';

  @override
  String get eventProgressCheckinPrompt => 'Відскануйте для старту івенту';

  @override
  String get eventProgressCheckinUnavailable => 'Чекін-код поки недоступний.';

  @override
  String get eventDescriptionLoadFailed =>
      'Не вдалося завантажити опис. Спробуйте ще раз.';

  @override
  String get eventDescriptionEmpty =>
      'Для цього івенту ще не додано текстового опису.';

  @override
  String get eventSettingsBrandTitle => 'Взуття та шкарпетки';

  @override
  String get eventSettingsBrandSubtitle =>
      'Ознайомтеся з рекомендаціями бренду для участі в івенті';

  @override
  String get eventSettingsBrandCta => 'КЕРІВНИЦТВО';

  @override
  String get brandRequirementsLoadFailed =>
      'Не вдалося завантажити вимоги бренду. Спробуйте ще раз.';

  @override
  String get brandRequirementsEmpty =>
      'Для цього івенту вимоги брендів ще не додані.';

  @override
  String get brandRequirementsEmptyItem =>
      'Для цього бренду вимоги ще не заповнені.';

  @override
  String get brandRequirementsPickBrandTitle => 'Оберіть бренд';

  @override
  String brandRequirementsBrandNumber(int brandId) {
    return 'Бренд $brandId';
  }

  @override
  String get eventSettingsParkingTitle => 'Паркування';

  @override
  String get eventSettingsParkingSubtitle =>
      'Відкрийте паркувальний пропуск і статус прибуття';

  @override
  String get eventSettingsParkingCta => 'ВІДКРИТИ ПАРКУВАННЯ';

  @override
  String get parkingChooseModeTitle => 'Режим паркування';

  @override
  String get parkingChooseModeHint => 'Оберіть стан екрана для тесту візуалу.';

  @override
  String get parkingModeInactive => 'НЕ АКТИВНО';

  @override
  String get parkingModeActive => 'АКТИВНО';

  @override
  String get parkingInactiveHeadline => 'ПАРКУВАННЯ НЕ АКТИВНЕ';

  @override
  String get parkingInactiveBody =>
      'СЕРВІС ПАРКУВАННЯ З\'ЯВИТЬСЯ ПІСЛЯ КУПІВЛІ КВИТКА.';

  @override
  String get parkingInactiveBuyCta => 'КУПИТИ';

  @override
  String get parkingInactiveVipBody =>
      'ДЛЯ ЗАМОВЛЕННЯ VIP-ПАРКУВАННЯ - ЗАБРОНЮЙТЕ МІСЦЕ ДЛЯ ВАШОГО АВТОМОБІЛЯ.';

  @override
  String get parkingInactiveVipBookCta => 'ЗАМОВИТИ ПАРКУВАННЯ';

  @override
  String get parkingActiveTicketLabel => 'КВИТОК';

  @override
  String get parkingTicketMock1 => 'КВИТОК A1 · МОДЕЛЬ';

  @override
  String get parkingTicketMock2 => 'КВИТОК B7 · ГОСТЬ';

  @override
  String get parkingActiveValetLabel => 'VALET SERVICE';

  @override
  String get parkingActiveStatusLine => 'PARKING ACTIVE';

  @override
  String get parkingActiveShowEntryPointCta => 'ПОКАЗАТИ ТОЧКУ В\'ЇЗДУ';

  @override
  String get parkingActiveCarLabel => 'АВТОМОБІЛЬ';

  @override
  String get parkingActiveRegistrationNumberLabel => 'НОМЕРНИЙ ЗНАК';

  @override
  String get parkingCreateTicketTitle => 'Створити квиток';

  @override
  String get parkingCreateEventLabel => 'Івент';

  @override
  String get parkingCreateAccountNameLabel => 'Ім\'я';

  @override
  String get parkingCreateCarModelLabel => 'МАРКА ТА МОДЕЛЬ';

  @override
  String get parkingCreateCarModelHint => 'Наприклад: Ford Mustang';

  @override
  String get parkingCreatePlateNumberLabel => 'НОМЕРНИЙ ЗНАК';

  @override
  String get parkingCreatePlateNumberHint => 'Наприклад: CA 7JXK921';

  @override
  String get parkingCreateRepeatPlateNumberLabel => 'ПОВТОРІТЬ НОМЕРНИЙ ЗНАК';

  @override
  String get parkingCreateRepeatPlateNumberHint =>
      'Повторно введіть номерний знак';

  @override
  String get parkingCreatePlateNumberMismatch => 'Номерні знаки не збігаються';

  @override
  String get parkingCreateBuyCta => 'КУПИТИ';

  @override
  String get parkingCreateBookCta => 'ЗАМОВИТИ ПАРКУВАННЯ';

  @override
  String get parkingCheckoutInBrowser => 'Завершіть оплату у браузері.';

  @override
  String get parkingPurchasedWithoutPayment => 'Квиток успішно куплено.';

  @override
  String get parkingVipBooked => 'VIP-паркування успішно заброньовано.';

  @override
  String get parkingCheckoutError =>
      'Не вдалося запустити оплату парковки. Спробуйте ще раз.';

  @override
  String get parkingActivePassLabel => 'КОД ПРОПУСКУ';

  @override
  String get eventSettingsChatTitle => 'Спільний чат';

  @override
  String get eventSettingsChatSubtitle =>
      'Спільний чат з учасниками групи та менеджерами';

  @override
  String get eventSettingsChatCta => 'ВІДКРИТИ ЧАТ';

  @override
  String get chatRoomsLoadFailed =>
      'Не вдалося завантажити кімнати чату. Спробуйте ще раз.';

  @override
  String get chatNoRooms =>
      'Для ваших брендів у цьому івенті ще немає чат-кімнат.';

  @override
  String get chatNoMessagesYet => 'Повідомлень ще немає';

  @override
  String get chatLoadFailed =>
      'Не вдалося завантажити повідомлення. Спробуйте ще раз.';

  @override
  String get chatSendFailed =>
      'Не вдалося надіслати повідомлення. Спробуйте ще раз.';

  @override
  String get chatMessagePlaceholder => 'Повідомлення в чат...';

  @override
  String get chatReply => 'Відповісти';

  @override
  String get chatReplyCancel => 'Скасувати';

  @override
  String chatReplyingTo(String name) {
    return 'Відповідь для $name';
  }

  @override
  String get chatReplyPreviewPhoto => 'Фото';

  @override
  String get chatEdit => 'Змінити';

  @override
  String get chatDelete => 'Видалити';

  @override
  String get chatDeleteTitle => 'Видалити повідомлення?';

  @override
  String get chatDeleteMessageConfirm => 'Цю дію неможливо скасувати.';

  @override
  String get chatDeleteFailed =>
      'Не вдалося видалити повідомлення. Спробуйте ще раз.';

  @override
  String get chatEditFailed =>
      'Не вдалося змінити повідомлення. Спробуйте ще раз.';

  @override
  String get chatEditingLabel => 'Редагування повідомлення';

  @override
  String get chatCancelEdit => 'Скасувати редагування';

  @override
  String eventSettingsChatMoreParticipants(int count) {
    return '+$count';
  }

  @override
  String get mealChoiceTitle => 'Вибір обіду';

  @override
  String get mealSelectChildLabel => 'Дитина';

  @override
  String get mealSelectDishLabel => 'Страва';

  @override
  String get mealSave => 'ЗАМОВИТИ';

  @override
  String get mealNoMealsConfigured => 'Для цього івенту ще не додано страв.';

  @override
  String get mealSaved => 'Збережено';

  @override
  String get mealSaveError => 'Не вдалося зберегти. Спробуйте ще раз.';

  @override
  String get mealOrdersClosed => 'Прийом замовлень закритий';

  @override
  String get mealPaid => 'Оплачено';

  @override
  String get mealPaidDetail => 'Обід для цього івенту оплачено.';

  @override
  String get mealPayInBrowser =>
      'Завершіть оплату в браузері та поверніться в застосунок.';

  @override
  String get mealCheckoutError => 'Не вдалося почати оплату. Спробуйте ще раз.';

  @override
  String get mealAwaitingPayment => 'Замовлення оформлено — очікує оплати';

  @override
  String get mealAwaitingPaymentDetail =>
      'Страву збережено. Завершіть оплату в браузері; статус оновиться після підтвердження Stripe.';

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
  String get fillOutApplication => 'Заповнити\nзаявку';

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

  @override
  String get myTicketsButton => 'МОЇ КВИТКИ';

  @override
  String get myTicketsTitle => 'Мої квитки';

  @override
  String get selectEventForTickets => 'Оберіть захід';

  @override
  String get ticketsMomName => 'Ім\'я батька/матері';

  @override
  String get ticketsEventDate => 'Дата';

  @override
  String get ticketsOpenPdf => 'ВІДКРИТИ';

  @override
  String get ticketsPdfUnavailable => 'PDF ще недоступний';

  @override
  String get ticketsBuy => 'КУПИТИ КВИТОК';

  @override
  String get ticketsBuyNoLink =>
      'Посилання на покупку не задане. Додайте в адмінці посилання на магазин квитків для івента або сайт у розділі Info.';

  @override
  String get ticketsBuyCouldNotOpen => 'Не вдалося відкрити посилання.';

  @override
  String get ticketsBuySubtitle => 'Доступні VIP і стандартні місця';

  @override
  String get extraTicketButton => 'ЕКСТРА КВИТОК';

  @override
  String get extraTicketSelectEventFirst => 'Спочатку оберіть івент.';

  @override
  String get extraTicketNoActiveHeadline => 'НЕМАЄ АКТИВНИХ ЕКСТРА КВИТКІВ';

  @override
  String get extraTicketBuyCta => 'КУПИТИ';

  @override
  String get extraTicketAccessOpen => 'ДОСТУП ДО ЕКСТРА ЗОНИ ВІДКРИТО';

  @override
  String get extraTicketCheckoutInBrowser => 'Завершіть оплату у браузері.';

  @override
  String get extraTicketCheckoutError =>
      'Не вдалося запустити оплату екстра квитка. Спробуйте ще раз.';

  @override
  String get backstageTicketButton => 'БЕКСТЕЙДЖ';

  @override
  String get backstageTicketSelectEventFirst => 'Спочатку оберіть івент.';

  @override
  String get backstageTicketNoActiveHeadline =>
      'НЕМАЄ АКТИВНИХ БЕКСТЕЙДЖ КВИТКІВ';

  @override
  String get backstageTicketBuyCta => 'КУПИТИ';

  @override
  String get backstageTicketAccessOpen => 'ДОСТУП ДО БЕКСТЕЙДЖУ ВІДКРИТО';

  @override
  String get backstageTicketCheckoutInBrowser => 'Завершіть оплату у браузері.';

  @override
  String get backstageTicketCheckoutError =>
      'Не вдалося запустити оплату бекстейдж квитка. Спробуйте ще раз.';

  @override
  String get ticketsNoEvents => 'Поки немає заходів із квитками';

  @override
  String get ticketsNoneForEvent => 'Немає квитків на цей захід';

  @override
  String get ticketsLoadError => 'Не вдалося завантажити квитки';

  @override
  String get ticketsEventsLoadError => 'Не вдалося завантажити заходи';

  @override
  String get faqBrandCatalogTitle => 'Бренди одягу';

  @override
  String get pdfViewerTitle => 'Квиток';

  @override
  String get contactFormLinkMissing =>
      'Посилання на форму не налаштовано. Додайте «Посилання на форму» у загальних налаштуваннях застосунку в адмінці.';

  @override
  String get infoHubTitle => 'Інформаційний центр';

  @override
  String get infoMenuAboutYfs => 'Про YFS';

  @override
  String get infoMenuGeneralFaq => 'Загальні FAQ';

  @override
  String get infoMenuContactManager => 'Зв\'язок із менеджером';

  @override
  String get infoFooterBrand => 'YFS';

  @override
  String get infoFooterCopyright =>
      '© 2024 Young Fashion Series. Усі права захищено.';

  @override
  String parentProgressLabel(int completed, int total) {
    return 'Прогрес батька/матері: $completed/$total';
  }

  @override
  String get appUpdateRequiredMessage => 'Оновіть застосунок, щоб продовжити.';

  @override
  String get appUpdateButton => 'Оновити застосунок';

  @override
  String get showAll => 'Показати все';

  @override
  String get staffNoneSelected => '— Немає —';

  @override
  String get staffRoleInactive => 'НЕАКТИВНА';

  @override
  String get staffWorkerStatusRefreshFailed =>
      'Не вдалося оновити статус ролі. Перевірте з\'єднання.';

  @override
  String get staffScanRoleInactive =>
      'Цю роль вимкнено в адмінці. Сканування недоступне.';

  @override
  String staffScanFailed(String error) {
    return 'Помилка сканування: $error';
  }

  @override
  String get staffScanSelectEventStageFirst =>
      'Оберіть активну подію та етап у налаштуваннях персоналу перед скануванням.';

  @override
  String get staffScanProcessed => 'Сканування виконано';

  @override
  String get chatCouldNotPickPhoto => 'Не вдалося вибрати фото';

  @override
  String get staffChildProfileTitle => 'Профіль дитини';

  @override
  String get staffCurrentStage => 'ПОТОЧНИЙ ЕТАП';

  @override
  String staffProgressPercentComplete(int percent) {
    return '$percent% завершено';
  }

  @override
  String get staffChildDetailEmpty => 'Немає даних про дитину в БД';

  @override
  String get staffLoadFailed => 'Не вдалося завантажити';

  @override
  String get staffGuardianLiaison => 'КУРАТОР';

  @override
  String get staffAssignedBrand => 'ПРИЗНАЧЕНИЙ БРЕНД';

  @override
  String get staffSupervisor => 'СУПЕРВАЙЗЕР';

  @override
  String get staffSectionCoreDetails => 'Основні дані';

  @override
  String get staffSectionParentContact => 'Контакт батька/матері';

  @override
  String staffPhaseWithName(String stageName) {
    return 'Фаза: $stageName';
  }

  @override
  String get staffNoCurrentStage => 'Немає поточного етапу';

  @override
  String staffAgeYearsOld(int age) {
    return '$age років';
  }

  @override
  String get staffNotesLabel => 'Нотатки';

  @override
  String get staffParentRoleDefault => 'Батько/мати';

  @override
  String get contactManagerIntro =>
      'Ви можете залишити повідомлення з будь-якого питання — з вами зв’яжуться найближчим часом.';

  @override
  String get contactManagerMessageLabel => 'Ваше повідомлення';

  @override
  String get contactManagerMessageRequired => 'Введіть текст повідомлення';

  @override
  String get contactManagerSend => 'Надіслати';

  @override
  String get contactManagerSent =>
      'Повідомлення надіслано. Ми зв’яжемося з вами найближчим часом.';

  @override
  String get contactManagerSendFailed =>
      'Не вдалося надіслати. Спробуйте пізніше.';

  @override
  String get contactManagerServiceUnavailable =>
      'Зв’язок тимчасово недоступний. Спробуйте пізніше.';

  @override
  String get close => 'Закрити';

  @override
  String get staffPortalTitle => 'Портал персоналу';

  @override
  String get staffActiveEvent => 'Активна подія';

  @override
  String get staffActiveStage => 'Активний етап';

  @override
  String get staffSelectEvent => 'Оберіть подію';

  @override
  String get staffSelectEventInSettings =>
      'Оберіть подію в налаштуваннях персоналу';

  @override
  String get staffSelectStage => 'Оберіть етап';

  @override
  String staffPreparatoryStageLabel(String stageName) {
    return 'Підготовка: $stageName';
  }

  @override
  String get staffScanButton => 'СКАН';

  @override
  String get staffParkingButton => 'ПАРКУВАННЯ';

  @override
  String get staffExtraZoneButton => 'ЕКСТРА ЗОНА';

  @override
  String get staffBackstageButton => 'БЕКСТЕЙДЖ';

  @override
  String get staffRehearsalCheckinButton => 'ЧЕК-ІН РЕПЕТИЦІЙ';

  @override
  String get staffTapToScanModelLanyard =>
      'НАТИСНІТЬ, ЩОБ СКАНУВАТИ БЕЙДЖ МОДЕЛІ';

  @override
  String get staffTapToScanParkingQr =>
      'НАТИСНІТЬ, ЩОБ СКАНУВАТИ QR ПАРКУВАННЯ';

  @override
  String get staffTapToScanExtraZoneQr =>
      'НАТИСНІТЬ, ЩОБ СКАНУВАТИ QR ЕКСТРА ЗОНИ';

  @override
  String get staffTapToScanBackstageQr =>
      'НАТИСНІТЬ, ЩОБ СКАНУВАТИ QR БЕКСТЕЙДЖУ';

  @override
  String get staffTapToScanRehearsalCheckinQr =>
      'НАТИСНІТЬ, ЩОБ СКАНУВАТИ QR ЧЕК-ІНУ РЕПЕТИЦІЙ';

  @override
  String get staffCurrentTask => 'Поточне завдання';

  @override
  String get staffUtilitiesAndTools => 'ІНСТРУМЕНТИ';

  @override
  String get staffScanForInfoTitle => 'Скан для інформації';

  @override
  String get staffScanForInfoSubtitle => 'Сканер бейджів та службових QR';

  @override
  String get staffToiletRequest => 'Запит до туалету';

  @override
  String get staffRestroomLog => 'ЖУРНАЛ ТУАЛЕТУ';

  @override
  String get staffSettingsCardTitle => 'Налаштування персоналу';

  @override
  String get staffPreferences => 'ПАРАМЕТРИ';

  @override
  String get staffSupervisorRoleTitle => 'Роль супервайзера';

  @override
  String get staffSupervisorRoleDescription =>
      'Керуйте потоком події, контролюйте фотографів та стежте, щоб усі діти були охоплені. Відстежуйте прогрес у реальному часі.';

  @override
  String get staffCurrentStageLabel => 'Поточний етап';

  @override
  String get staffNoMainStagesAvailable =>
      'Для цієї події немає основних етапів.';

  @override
  String get staffChildRegistry => 'Реєстр дітей';

  @override
  String staffChildrenListed(int count) {
    return 'Дітей у списку: $count';
  }

  @override
  String get staffSelectActiveEventForRegistry =>
      'Оберіть активну подію в налаштуваннях, щоб побачити реєстр дітей.';

  @override
  String get staffNoChildrenAssigned =>
      'Для цієї події немає призначених дітей.';

  @override
  String get staffRehearsalAdminSlotsTitle => 'Слоти репетицій';

  @override
  String get staffRehearsalCheckinActiveSlot => 'Активний слот репетиції';

  @override
  String get staffRehearsalAdminSelectSlot => 'Оберіть слот репетиції';

  @override
  String get staffRehearsalCheckinSelectSlotFirst =>
      'Спочатку оберіть слот репетиції';

  @override
  String get staffRehearsalAdminBookedChildrenTitle => 'Записані діти';

  @override
  String get staffRehearsalAdminNoSlots =>
      'Для цієї події ще не створено слотів репетицій.';

  @override
  String get staffRehearsalAdminNoChildrenForSlot =>
      'На цей слот поки ніхто не записаний.';

  @override
  String get staffGiftControlButton => 'КОНТРОЛЬ';

  @override
  String get staffGiftControlTitle => 'Контроль видачі подарунків';

  @override
  String get staffGiftControlSelectStage => 'Оберіть етап звіту';

  @override
  String get staffGiftControlFilterAll => 'Усі';

  @override
  String get staffGiftControlFilterPassed => 'Пройдено';

  @override
  String get staffGiftControlFilterNotPassed => 'Не пройдено';

  @override
  String get staffGiftControlNoChildren =>
      'Немає дітей за вибраними фільтрами.';

  @override
  String get staffTableProfile => 'ПРОФІЛЬ';

  @override
  String get staffTableName => 'ІМ\'Я';

  @override
  String get staffTableStatus => 'СТАТУС';

  @override
  String get staffTableAction => 'ДІЯ';

  @override
  String get staffYes => 'Так';

  @override
  String get staffNo => 'Ні';

  @override
  String get staffRoleHostessTitle => 'Роль: хостес';

  @override
  String get staffRoleHostessPlaceholder =>
      'Екран ролі хостес буде додано пізніше.';

  @override
  String get staffRoleInterviewTitle => 'Роль: інтерв\'ю';

  @override
  String get staffRoleInterviewPlaceholder =>
      'Екран ролі інтерв\'ю буде додано пізніше.';

  @override
  String get staffRoleLunchesTitle => 'Роль: обіди';

  @override
  String get staffRoleLunchesPlaceholder =>
      'Екран ролі обідів буде додано пізніше.';

  @override
  String get staffRoleSuperadminTitle => 'Роль: суперадмін';

  @override
  String get staffRoleSuperadminPlaceholder =>
      'Екран ролі суперадміна буде додано пізніше.';

  @override
  String get staffRoleRehearsalAdminTitle => 'Роль: адмін репетицій';

  @override
  String get staffRoleRehearsalAdminPlaceholder =>
      'Екран ролі адміна репетицій буде додано пізніше.';

  @override
  String get staffNavHome => 'Головна';

  @override
  String get staffNavEvent => 'Подія';

  @override
  String get staffNavMore => 'Ще';

  @override
  String get staffAccessBadge => 'ДОСТУП ПЕРСОНАЛУ';

  @override
  String get staffVenueAndContact => 'Локація та контакти';

  @override
  String get staffMainOffice => 'Головний офіс';

  @override
  String get staffSecurity => 'Охорона';

  @override
  String get staffScanHeaderParking => 'Скан паркування';

  @override
  String get staffScanHeaderExtraZone => 'Вхід до екстра зони';

  @override
  String get staffScanHeaderBackstage => 'Вхід до бекстейджу';

  @override
  String get staffScanHeaderRehearsalCheckin => 'Чек-ін репетицій';

  @override
  String get staffScanHeaderInfo => 'Скан для інформації';

  @override
  String get staffScanHeaderQr => 'Скан QR коду';

  @override
  String get staffScanHintParking =>
      'Скануйте QR паркування, щоб показати дані талона';

  @override
  String get staffScanHintExtraZone => 'Скануйте QR екстра квитка для входу';

  @override
  String get staffScanHintBackstage => 'Скануйте QR бекстейдж квитка для входу';

  @override
  String get staffScanHintRehearsalCheckin =>
      'Скануйте check-in QR дитини, щоб закрити проходження репетиції';

  @override
  String get staffScanHintInfo =>
      'Скануйте бейдж дитини або батьків, щоб відкрити профіль';

  @override
  String get staffScanHintQr => 'Розмістіть QR-код у рамці';

  @override
  String get staffScanErrorTitle => 'Помилка сканування';

  @override
  String get staffScanErrorUnknown => 'Невідома помилка сканування.';

  @override
  String get staffParkingTicketTitle => 'Паркувальний талон';

  @override
  String get staffExtraZonePassTitle => 'Перепустка до екстра зони';

  @override
  String get staffExtraZoneScanResultTitle => 'Результат сканування';

  @override
  String get staffExtraZoneResultNotFound => 'КОД ВІДСУТНІЙ У БАЗІ';

  @override
  String get staffExtraZoneResultAccessGranted =>
      'КОД ПРИЙНЯТО, ПРОХІД ДОЗВОЛЕНО';

  @override
  String get staffExtraZoneResultAccessClosed =>
      'КОД ПРИЙНЯТО, АЛЕ ДОСТУП ЗАКРИТО';

  @override
  String get staffBackstageScanResultTitle => 'Результат сканування';

  @override
  String get staffBackstageResultNotFound => 'КОД ВІДСУТНІЙ У БАЗІ';

  @override
  String get staffBackstageResultAccessGranted =>
      'КОД ПРИЙНЯТО, ПРОХІД ДОЗВОЛЕНО';

  @override
  String get staffBackstageResultAccessClosed =>
      'КОД ПРИЙНЯТО, АЛЕ ДОСТУП ЗАКРИТО';

  @override
  String get staffRehearsalCheckinScanResultTitle => 'Результат сканування';

  @override
  String get staffRehearsalCheckinResultNotFound => 'CHECK-IN КОД НЕ ЗНАЙДЕНО';

  @override
  String get staffRehearsalCheckinResultWrongSlot =>
      'ДИТИНА НЕ ЗАПИСАНА НА ЦЕЙ СЛОТ';

  @override
  String get staffRehearsalCheckinResultAlreadyClosed =>
      'ЧЕК-ІН РЕПЕТИЦІЇ ВЖЕ ЗАКРИТО';

  @override
  String get staffRehearsalCheckinResultClosedNow => 'ЧЕК-ІН РЕПЕТИЦІЇ ЗАКРИТО';

  @override
  String get staffRehearsalCheckinFieldChild => 'Дитина';

  @override
  String get staffRehearsalCheckinFieldSlot => 'Слот';

  @override
  String get staffParkingFieldEvent => 'Подія';

  @override
  String get staffParkingFieldClient => 'Клієнт';

  @override
  String get staffParkingFieldCar => 'Автомобіль';

  @override
  String get staffParkingFieldPlateNumber => 'Номерний знак';

  @override
  String get staffParkingFieldVipClient => 'VIP клієнт';

  @override
  String get staffShowProgressTitle => 'Прогрес шоу';

  @override
  String get staffCouldNotOpenDialer => 'Не вдалося відкрити набір номера';

  @override
  String get staffRealtimeTracking => 'ВІДСТЕЖЕННЯ В РЕАЛЬНОМУ ЧАСІ';

  @override
  String get staffEstimatedCompletion => 'ОРІЄНТОВНЕ ЗАВЕРШЕННЯ';

  @override
  String get staffNoMainStagesInPlan => 'У плані поки немає основних етапів.';

  @override
  String get staffStatusDone => 'ГОТОВО';

  @override
  String get staffStatusInProgress => 'В ПРОЦЕСІ';

  @override
  String get staffStatusPending => 'ОЧІКУВАННЯ';

  @override
  String get staffContactDetails => 'Контактні дані';

  @override
  String get staffPrimaryParent => 'ОСНОВНИЙ З БАТЬКІВ';

  @override
  String staffIdLabel(String id) {
    return 'ID співробітника: $id';
  }

  @override
  String get staffSwitchRole => 'Змінити роль';

  @override
  String staffCurrentRoleLabel(String role) {
    return 'ПОТОЧНА: $role';
  }

  @override
  String get staffRoleSubtitleScan => 'Скан QR та етапи';

  @override
  String get staffRoleSubtitleSupervisor => 'Повний доступ та керування';

  @override
  String get staffRoleSubtitleHostess => 'Підтримка гостей та зон';

  @override
  String get staffRoleSubtitleParking => 'Паркування та доступ';

  @override
  String get staffRoleSubtitleExtraZone => 'Доступ до екстра зони';

  @override
  String get staffRoleSubtitleBackstage => 'Доступ до бекстейджу';

  @override
  String get staffRoleSubtitleRehearsalAdmin => 'Керування репетиціями';

  @override
  String get staffRoleSubtitleRehearsalCheckin =>
      'Скан check-in по слотах репетицій';

  @override
  String get staffRoleSubtitleGiftIssue => 'Контроль видачі подарунків';

  @override
  String get staffRoleSubtitleInterview => 'Потік інтерв\'ю';

  @override
  String get staffRoleSubtitleLunches => 'Харчування та обіди';

  @override
  String get staffRoleSubtitleSuperadmin => 'Інструменти суперадміна';

  @override
  String get staffRoleSubtitlePhotographer => 'Зйомка та завантаження медіа';

  @override
  String get staffRoleSubtitleStylist => 'Гардероб та макіяж';
}
