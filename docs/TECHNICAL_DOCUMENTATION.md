# JFS Client App — техническая документация

**jfs_application** — Flutter-приложение для родителей и клиентов Young Fashion Show.

| Параметр | Значение |
|----------|----------|
| Версия | `1.2.3+21` (`pubspec.yaml`) |
| Bundle ID (iOS) | `com.youngfashionshow.yfs` |
| Dart SDK | `^3.10.7` |
| Backend | Laravel YFS REST API |
| Роль пользователя | `client` |

---

## 1. Назначение

Приложение позволяет клиенту:

- следить за участием ребёнка на ивенте (этапы, прогресс, чек-ин);
- покупать/просматривать билеты, паркинг, OPEN BAR, backstage;
- управлять профилем и детьми, family-подписками;
- бронировать репетиции, выбирать блюда, подписывать договор;
- общаться в чатах брендов, получать push/in-app уведомления;
- просматривать Info (FAQ, news, about).

Staff-функции в этом приложении **отсутствуют** — они в `yfs_app_staff`.

---

## 2. Структура `lib/`

```
lib/
├── main.dart                    # Точка входа, тема, Firebase, AuthService
├── intro_video_page.dart        # Старт: maintenance, версия, intro video, session
├── login_page.dart              # Вход / регистрация
├── app_maintenance_page.dart    # Экран технических работ
├── client_home_page.dart        # Главная оболочка (4 вкладки)
├── client_profile_tab.dart      # Профиль и дети
├── client_event_*.dart          # Flow по ивенту (parking, open bar, progress…)
├── api/auth_service.dart        # REST-клиент + DTO (~4300 строк)
├── push/                        # FCM token sync
├── app_settings.dart            # SharedPreferences (язык, единицы)
├── gen_l10n/                    # Сгенерированные локализации
└── l10n/*.arb                   # Исходники строк (en, ru, uk, es)
```

### Ключевые экраны

| Экран | Файл | Когда показывается |
|-------|------|-------------------|
| Intro | `intro_video_page.dart` | Старт приложения |
| Maintenance | `app_maintenance_page.dart` | `app_active=false` |
| Login | `login_page.dart` | Нет сессии |
| Home | `client_home_page.dart` | Авторизованный client |
| Event progress | `client_event_progress_tab.dart` | Push с home/events |

---

## 3. Поток запуска

```
main()
  → Firebase.init
  → AuthService(API_BASE_URL)
  → IntroVideoPage
       → checkAppActive() → Maintenance?
       → checkAppVersion() → Force update?
       → intro_logo.mp4
       → restoreSessionIfPossible()
            → ClientHomePage (role=client)
            → LoginPage
```

При каждом переключении вкладки нижнего меню вызывается `checkAppActive()`.  
Если приложение выключено в админке — переход на maintenance screen.

---

## 4. Навигация (нижнее меню)

| Tab | Содержимое |
|-----|------------|
| 0 Home | Dashboard, кнопки действий, live YouTube |
| 1 Events | Предстоящие ивенты, прогресс |
| 2 Profile | Профиль, дети, family |
| 3 Info | News, FAQ, About, контакты |

**Кнопки на главной (без активного назначения):**

1. Купить билет  
2. Паркинг + OPEN BAR  
3. Бронирование отеля  

**С активным назначением:**

1. Мои билеты + паркинг (если включён)  
2. OPEN BAR + Backstage  
3. Отель (если включён)

OPEN BAR: ивент и текст кнопки из `home_buttons` (админка → Настройки кнопок).

---

## 5. Зависимости (основные)

| Пакет | Назначение |
|-------|------------|
| `http` | REST |
| `flutter_secure_storage` | Bearer token |
| `firebase_messaging` | Push |
| `mobile_scanner`, `qr_flutter` | QR |
| `pdfx` | PDF-билеты |
| `video_player` | Intro video |
| `youtube_player_flutter` | Live stream |
| `package_info_plus` | Версия для API |

**State management:** `StatefulWidget` + `setState`. Отдельной библиотеки (Riverpod/BLoC) нет.  
`AuthService` передаётся через конструктор виджетов.

---

## 6. Конфигурация и сборка

### API base URL

```dart
// lib/main.dart
const _kApiBaseUrl = String.fromEnvironment(
  'API_BASE_URL',
  defaultValue: 'http://178.156.234.23',
);
```

Запуск:

```bash
flutter run --dart-define=API_BASE_URL=https://your-api-host
```

`AuthService.normalizeAppApiBase()` убирает trailing `/` и `/api`.

### Codemagic (iOS)

Файл: `codemagic.yaml` — workflow `ios-release`, `flutter build ipa --release`.  
Signing: `com.youngfashionshow.yfs`.  
**Важно:** задайте `API_BASE_URL` в Codemagic Environment variables, иначе используется default.

### Локализация

- ARB: `lib/l10n/`
- Генерация: `flutter gen-l10n` (авто через `pubspec.yaml`)
- API: заголовок `Accept-Language` из `AppSettings.contentLocaleForApi()`

### Assets

- `assets/logo.png`, `assets/intro_logo.mp4`
- Шрифты: `HelveticaNeueCyr`, `Luxenta`

---

## 7. Push-уведомления

- `PushTokenService` регистрирует FCM token через `POST /api/app/push-token`
- При logout: `DELETE /api/app/push-token`
- Background handler в `main.dart`

---

# Инструкция по API (клиентское приложение)

Все запросы идут на `{API_BASE_URL}/api/...`.  
Реализация: **`lib/api/auth_service.dart`**.

## Аутентификация

| Метод Dart | HTTP | Path | Auth |
|------------|------|------|------|
| `login` | POST | `/app/login` | — |
| `register` | POST | `/app/register` | — |
| `setupClientPassword` | POST | `/app/client/password/setup` | — |
| `restoreSessionIfPossible` | GET | `/app/me` | Bearer |
| `validateToken` | GET | `/app/me` | Bearer |

Token хранится в `FlutterSecureStorage` (`auth_token`).

## Жизненный цикл приложения

| Метод Dart | HTTP | Path |
|------------|------|------|
| `checkAppActive` | GET | `/app/status` |
| `checkAppVersion` | POST | `/app/version/check` |

`checkAppActive` при недоступности `/status` fallback на `version/check` (поле `app_active`).

## Dashboard и ивенты

| Метод Dart | HTTP | Path |
|------------|------|------|
| `getClientDashboard` | GET | `/app/client/dashboard` |
| `getClientUpcomingEvents` | GET | `/app/client/upcoming-events` |
| `getClientTicketEvents` | GET | `/app/client/ticket-events` |
| `getClientEventTickets` | GET | `/app/client/events/{id}/tickets` |
| `getClientEventDescription` | GET | `/app/client/events/{id}/description` |
| `getEventPackingInfo` | GET | `/app/client/events/{id}/packing` |
| `getEventBrandRequirements` | GET | `/app/client/events/{id}/brand-requirements` |
| `getEventRehearsalSlots` | GET | `/app/client/events/{id}/rehearsal-slots` |
| `getEventChatRooms` | GET | `/app/client/events/{id}/chat-rooms` |

## Профиль и дети

| Метод Dart | HTTP | Path |
|------------|------|------|
| `getClientProfile` | GET | `/app/client/profile` |
| `updateProfile` | PATCH | `/app/client/profile` |
| `deleteClientAccount` | DELETE | `/app/client/account` |
| `getClientPastShowPhotos` | GET | `/app/client/past-show-photos` |
| `createChild` | POST | `/app/client/children` |
| `updateChild` | PATCH | `/app/client/children/{id}` |
| `uploadChildMainPhoto` | POST multipart | `/app/client/children/{id}/main-photo` |
| `deleteChildMainPhoto` | DELETE | `/app/client/children/{id}/main-photo` |
| `uploadChildExtraPhoto` | POST multipart | `/app/client/children/{id}/extra-photos` |
| `deleteChildExtraPhoto` | DELETE | `/app/client/children/{id}/extra-photos/{index}` |

## Family

| Метод Dart | HTTP | Path |
|------------|------|------|
| `joinFamilyByCode` | POST | `/app/client/family/join-by-code` |
| `disconnectFromFamily` | POST | `/app/client/family/disconnect` |
| `getAssignmentFamilySubscriptionSettings` | GET | `/app/client/assignments/{id}/family-subscription` |
| `setAssignmentFamilySubscriptionEnabled` | PATCH | `/app/client/assignments/{id}/family-subscription` |
| `regenerateAssignmentFamilyCode` | POST | `/app/client/assignments/{id}/family-subscription/regenerate-code` |

## Договор

| Метод Dart | HTTP | Path |
|------------|------|------|
| `getClientContractStatus` | GET | `/app/client/contract/status` |
| `signClientContract` | POST | `/app/client/contract/sign` |

## Репетиции

| Метод Dart | HTTP | Path |
|------------|------|------|
| `bookRehearsalSlot` | POST | `/app/client/assignments/{id}/rehearsal-booking` |
| `replaceRehearsalBookings` | PUT | `/app/client/assignments/{id}/rehearsal-booking` |
| `cancelRehearsalBooking` | DELETE | `/app/client/assignments/{id}/rehearsal-booking` |

## Блюда (Stripe)

| Метод Dart | HTTP | Path |
|------------|------|------|
| `updateClientAssignmentMeal` | PATCH | `/app/client/assignments/{id}/meal` |
| `createMealCheckoutSession` | POST | `/app/client/assignments/{id}/meal-checkout` |
| `getClientAssignmentMealPaymentStatus` | GET | `.../meal-payment-status` |
| `resumeClientAssignmentMealPayment` | POST | `.../meal-payment-resume` |
| `cancelClientAssignmentMealPayment` | POST | `.../meal-payment-cancel` |

## Паркинг

| Метод Dart | HTTP | Path |
|------------|------|------|
| `getEventParkingTickets` | GET | `/app/client/events/{id}/parking-tickets` |
| `createParkingCheckoutSession` | POST | `/app/client/events/{id}/parking-checkout` |
| `getEventParkingPaymentStatus` | GET | `.../parking-payment-status` |
| `resumeEventParkingPayment` | POST | `.../parking-payment-resume` |
| `cancelEventParkingPayment` | POST | `.../parking-payment-cancel` |

## OPEN BAR (extra ticket)

| Метод Dart | HTTP | Path |
|------------|------|------|
| `getEventExtraTickets` | GET | `/app/client/events/{id}/extra-tickets` |
| `createExtraCheckoutSession` | POST | `/app/client/events/{id}/extra-checkout` |
| `getEventExtraTicketPaymentStatus` | GET | `.../extra-ticket-payment-status` |
| `resumeEventExtraTicketPayment` | POST | `.../extra-ticket-payment-resume` |
| `cancelEventExtraTicketPayment` | POST | `.../extra-ticket-payment-cancel` |

Ивент `{id}` должен совпадать с `open_bar_event_id` из `home_buttons`.

## Backstage

| Метод Dart | HTTP | Path |
|------------|------|------|
| `getEventBackstageTickets` | GET | `/app/client/events/{id}/backstage-tickets` |
| `createBackstageCheckoutSession` | POST | `/app/client/events/{id}/backstage-checkout` |
| + payment status / resume / cancel | | `.../backstage-ticket-payment-*` |

## Чат

| Метод Dart | HTTP | Path |
|------------|------|------|
| `getChatRoomMessages` | GET | `/app/client/chat-rooms/{roomId}/messages` |
| `sendChatRoomMessage` | POST | `/app/client/chat-rooms/{roomId}/messages` |
| `editChatRoomMessage` | PATCH | `.../messages/{messageId}` |
| `deleteChatRoomMessage` | DELETE | `.../messages/{messageId}` |

## Уведомления

| Метод Dart | HTTP | Path |
|------------|------|------|
| `getUnreadNotificationsCount` | GET | `/app/notifications/unread-count` |
| `getNotifications` | GET | `/app/notifications` |
| `getNotificationDetails` | GET | `/app/notifications/{recipientId}` |

## Info (публичные)

| Метод Dart | HTTP | Path |
|------------|------|------|
| `getInfoSettings` | GET | `/app/info/settings` |
| `getAppNews` | GET | `/app/info/news` |
| `getAppAbout` | GET | `/app/info/about` |
| `getFaqSections` | GET | `/app/info/faq-sections` |
| `getFaqSectionArticles` | GET | `/app/info/faq-sections/{id}/articles` |

## Push

| Метод Dart | HTTP | Path |
|------------|------|------|
| `registerPushToken` | POST | `/app/push-token` |
| `deactivatePushToken` | DELETE | `/app/push-token` |

## Типичные ошибки

| Ситуация | Поведение клиента |
|----------|-------------------|
| `403` + `code: service_disabled` | `ApiServiceDisabledException`, диалог «сервис недоступен» |
| `404` на login/register | `ApiEndpointNotFoundException` — неверный base URL |
| Stripe checkout | Открытие `checkout_url` во внешнем браузере, resume при возврате |

---

## Связанные проекты

| Проект | Документация |
|--------|--------------|
| YFS (API + админка) | `YFS/docs/TECHNICAL_DOCUMENTATION.md` |
| Staff app | `yfs_app_staff/docs/TECHNICAL_DOCUMENTATION.md` |

При изменении API сначала обновляйте backend, затем этот файл и `auth_service.dart`.
