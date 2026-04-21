import 'dart:convert';
import 'dart:developer' as developer;
import 'dart:ui' show Locale, PlatformDispatcher;

import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

import '../app_settings.dart';
import '../gen_l10n/app_localizations.dart';

/// POST /api/app/login|register вернул 404 — обычно неверный [AuthService.baseUrl] (лишний `/api`, не тот vhost).
class ApiEndpointNotFoundException implements Exception {
  ApiEndpointNotFoundException(this.requestUrl);
  final String requestUrl;
}

/// POST /api/app/client/contact-manager — почта поддержки не настроена (503).
class ContactManagerUnavailableException implements Exception {
  ContactManagerUnavailableException();
}

/// Код для заголовка `Accept-Language` в API (локализованные этапы): en, uk, ru, es.
String apiContentLanguageForLocale(Locale locale) {
  switch (locale.languageCode.toLowerCase()) {
    case 'ru':
      return 'ru';
    case 'uk':
      return 'uk';
    case 'es':
      return 'es';
    default:
      return 'en';
  }
}

class AuthService {
  AuthService(String rawBaseUrl) : baseUrl = normalizeAppApiBase(rawBaseUrl);

  final String baseUrl;

  Map<String, String> _publicContentHeaders({Locale? contentLocale}) {
    final loc = contentLocale ?? AppSettings.contentLocaleForApi();
    return {
      'Accept': 'application/json',
      'Accept-Language': apiContentLanguageForLocale(loc),
    };
  }

  Map<String, String> _authedContentHeaders(
    String token, {
    Locale? contentLocale,
  }) {
    return {
      ..._publicContentHeaders(contentLocale: contentLocale),
      'Authorization': 'Bearer $token',
    };
  }

  /// Корень сайта без завершающего `/` и без суффикса `/api` (его добавляют запросы).
  static String normalizeAppApiBase(String raw) {
    var s = raw.trim();
    while (s.endsWith('/')) {
      s = s.substring(0, s.length - 1);
    }
    if (s.toLowerCase().endsWith('/api')) {
      s = s.substring(0, s.length - 4);
      while (s.endsWith('/')) {
        s = s.substring(0, s.length - 1);
      }
    }
    return s;
  }

  static const _storage = FlutterSecureStorage();
  static const _tokenKey = 'auth_token';

  Future<String?> getToken() => _storage.read(key: _tokenKey);
  Future<void> saveToken(String token) =>
      _storage.write(key: _tokenKey, value: token);
  Future<void> clearToken() => _storage.delete(key: _tokenKey);

  Future<LoginResult> login({required String email, String? password}) async {
    final uri = Uri.parse('$baseUrl/api/app/login');

    final res = await http.post(
      uri,
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
      body: jsonEncode({
        'email': email,
        'password': (password ?? '').trim().isEmpty ? null : password,
      }),
    );

    if (res.statusCode == 404) {
      throw ApiEndpointNotFoundException(uri.toString());
    }
    if (res.statusCode != 200) {
      throw Exception(
        _tryMessage(res.body) ?? 'Login failed (${res.statusCode})',
      );
    }

    final json = jsonDecode(res.body) as Map<String, dynamic>;
    if ((json['requires_password_setup'] as bool?) ?? false) {
      return LoginResult(
        requiresPasswordSetup: true,
        setupEmail: (json['email'] as String? ?? email).trim(),
      );
    }

    return LoginResult(
      token: json['token'] as String?,
      user: json['user'] as Map<String, dynamic>?,
      requiresPasswordSetup: false,
    );
  }

  Future<LoginResult> setupClientPassword({
    required String email,
    required String password,
    required String passwordConfirmation,
  }) async {
    final uri = Uri.parse('$baseUrl/api/app/client/password/setup');

    final res = await http.post(
      uri,
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
      body: jsonEncode({
        'email': email,
        'password': password,
        'password_confirmation': passwordConfirmation,
      }),
    );

    if (res.statusCode == 404) {
      throw ApiEndpointNotFoundException(uri.toString());
    }
    if (res.statusCode != 200) {
      throw Exception(
        _tryMessage(res.body) ?? 'Password setup failed (${res.statusCode})',
      );
    }

    final json = jsonDecode(res.body) as Map<String, dynamic>;
    return LoginResult(
      token: json['token'] as String?,
      user: json['user'] as Map<String, dynamic>?,
      requiresPasswordSetup: false,
    );
  }

  Future<LoginResult> register({
    required String name,
    required String email,
    required String phone,
    required String password,
    required String role, // "client" | "worker"
  }) async {
    final uri = Uri.parse('$baseUrl/api/app/register');

    final res = await http.post(
      uri,
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
      body: jsonEncode({
        'name': name,
        'email': email,
        'phone': phone,
        'password': password,
        'role': role,
      }),
    );

    if (res.statusCode == 404) {
      throw ApiEndpointNotFoundException(uri.toString());
    }
    if (res.statusCode != 201) {
      throw Exception(
        _tryMessage(res.body) ?? 'Register failed (${res.statusCode})',
      );
    }

    final json = jsonDecode(res.body) as Map<String, dynamic>;
    return LoginResult(
      token: json['token'] as String,
      user: json['user'] as Map<String, dynamic>,
    );
  }

  Future<bool> validateToken(String token) async {
    final uri = Uri.parse('$baseUrl/api/app/me');

    final res = await http.get(
      uri,
      headers: {'Accept': 'application/json', 'Authorization': 'Bearer $token'},
    );

    return res.statusCode == 200;
  }

  /// GET /api/app/me — текущий пользователь по токену (без чтения из storage).
  /// Если в secure storage есть токен и [GET /api/app/me] успешен — возвращает [user].
  /// При 401/403 токен удаляется. При сетевой ошибке или 5xx токен сохраняется.
  Future<Map<String, dynamic>?> restoreSessionIfPossible() async {
    final token = await getToken();
    if (token == null || token.isEmpty) {
      return null;
    }
    try {
      final uri = Uri.parse('$baseUrl/api/app/me');
      final res = await http.get(
        uri,
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );
      if (res.statusCode == 200) {
        final json = jsonDecode(res.body) as Map<String, dynamic>;
        final user = json['user'];
        if (user is Map<String, dynamic>) {
          return user;
        }
        return null;
      }
      if (res.statusCode == 401 || res.statusCode == 403) {
        await clearToken();
      }
      return null;
    } catch (_) {
      return null;
    }
  }

  /// GET /api/app/worker/status — роли работника
  Future<WorkerStatus> getWorkerStatus() async {
    final token = await getToken();
    if (token == null || token.isEmpty) {
      throw Exception('Not authenticated');
    }
    final uri = Uri.parse('$baseUrl/api/app/worker/status');
    final res = await http.get(
      uri,
      headers: {'Accept': 'application/json', 'Authorization': 'Bearer $token'},
    );
    if (res.statusCode != 200) {
      throw Exception(
        _tryMessage(res.body) ??
            'Failed to load worker status (${res.statusCode})',
      );
    }
    final json = jsonDecode(res.body) as Map<String, dynamic>;
    return WorkerStatus.fromJson(json);
  }

  /// GET /api/app/worker/upcoming-events — события с датой начала в будущем (для выбора активного ивента).
  Future<List<UpcomingEvent>> getWorkerUpcomingEvents() async {
    final token = await getToken();
    if (token == null || token.isEmpty) throw Exception('Not authenticated');
    final uri = Uri.parse('$baseUrl/api/app/worker/upcoming-events');
    final res = await http.get(
      uri,
      headers: {'Accept': 'application/json', 'Authorization': 'Bearer $token'},
    );
    if (res.statusCode != 200) {
      throw Exception(
        _tryMessage(res.body) ?? 'Failed to load events (${res.statusCode})',
      );
    }
    final json = jsonDecode(res.body) as Map<String, dynamic>;
    final list = json['events'];
    if (list is! List) return [];
    return list
        .map((e) => UpcomingEvent.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  /// GET /api/app/worker/events/{id} — детали события для сотрудника (venue, shift schedule).
  Future<StaffEventDetail> getWorkerEventDetail(int eventId) async {
    final token = await getToken();
    if (token == null || token.isEmpty) throw Exception('Not authenticated');
    final uri = Uri.parse('$baseUrl/api/app/worker/events/$eventId');
    final res = await http.get(
      uri,
      headers: {'Accept': 'application/json', 'Authorization': 'Bearer $token'},
    );
    if (res.statusCode != 200) {
      throw Exception(
        _tryMessage(res.body) ?? 'Failed to load event (${res.statusCode})',
      );
    }
    final json = jsonDecode(res.body) as Map<String, dynamic>;
    return StaffEventDetail.fromJson(json);
  }

  /// GET /api/app/worker/events/{id}/stages — основные этапы для выбора рабочего контекста.
  Future<List<WorkerEventStage>> getWorkerEventStages(int eventId) async {
    final token = await getToken();
    if (token == null || token.isEmpty) throw Exception('Not authenticated');
    final uri = Uri.parse('$baseUrl/api/app/worker/events/$eventId/stages');
    final res = await http.get(
      uri,
      headers: {'Accept': 'application/json', 'Authorization': 'Bearer $token'},
    );
    if (res.statusCode != 200) {
      throw Exception(
        _tryMessage(res.body) ??
            'Failed to load event stages (${res.statusCode})',
      );
    }
    final json = jsonDecode(res.body) as Map<String, dynamic>;
    final list = json['stages'];
    if (list is! List) return [];
    return list
        .map((e) => WorkerEventStage.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  /// POST /api/scan/stage/complete — закрытие этапа по QR с контекстом сотрудника.
  Future<ScanStageResult> submitStageScan({
    required String scanCode,
    required int eventId,
    required int stageId,
    required String stageType,
    String? roleCode,
    String? photoPath,
  }) async {
    final token = await getToken();
    if (token == null || token.isEmpty) throw Exception('Not authenticated');
    final uri = Uri.parse('$baseUrl/api/scan/stage/complete');

    http.Response res;
    if (photoPath != null && photoPath.isNotEmpty) {
      final request = http.MultipartRequest('POST', uri);
      request.headers['Accept'] = 'application/json';
      request.headers['Authorization'] = 'Bearer $token';
      request.fields['scan_code'] = scanCode;
      request.fields['event_id'] = eventId.toString();
      request.fields['stage_id'] = stageId.toString();
      request.fields['stage_type'] = stageType;
      if (roleCode != null && roleCode.isNotEmpty) {
        request.fields['role_code'] = roleCode;
      }
      request.files.add(await http.MultipartFile.fromPath('photo', photoPath));
      final streamed = await request.send();
      res = await http.Response.fromStream(streamed);
    } else {
      res = await http.post(
        uri,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({
          'scan_code': scanCode,
          'event_id': eventId,
          'stage_id': stageId,
          'stage_type': stageType,
          if (roleCode != null && roleCode.isNotEmpty) 'role_code': roleCode,
        }),
      );
    }

    final map = jsonDecode(res.body) as Map<String, dynamic>;
    if (res.statusCode == 200 ||
        res.statusCode == 422 ||
        res.statusCode == 500) {
      return ScanStageResult.fromJson(map);
    }
    throw Exception(
      _tryMessage(res.body) ??
          'Failed to submit stage scan (${res.statusCode})',
    );
  }

  /// GET /api/app/worker/supervisor-children?event_id=&stage_id=&show_all=
  /// Дети по брендам супервайзера + список main-этапов для выбранного события.
  Future<SupervisorChildrenResponse> getSupervisorChildren(
    int eventId, {
    int? stageId,
    bool showAll = false,
  }) async {
    final token = await getToken();
    if (token == null || token.isEmpty) throw Exception('Not authenticated');
    final query = <String, String>{'event_id': eventId.toString()};
    if (stageId != null && stageId > 0) query['stage_id'] = stageId.toString();
    if (showAll) query['show_all'] = '1';
    final uri = Uri.parse(
      '$baseUrl/api/app/worker/supervisor-children',
    ).replace(queryParameters: eventId > 0 ? query : null);
    final res = await http.get(
      uri,
      headers: {'Accept': 'application/json', 'Authorization': 'Bearer $token'},
    );
    if (res.statusCode != 200) {
      throw Exception(
        _tryMessage(res.body) ?? 'Failed to load children (${res.statusCode})',
      );
    }
    final json = jsonDecode(res.body) as Map<String, dynamic>;
    return SupervisorChildrenResponse.fromJson(json);
  }

  /// GET /api/app/worker/rehearsal-admin/roster?event_id=&slot_id=
  Future<RehearsalAdminRosterResponse> getWorkerRehearsalAdminRoster(
    int eventId, {
    int? slotId,
  }) async {
    final token = await getToken();
    if (token == null || token.isEmpty) throw Exception('Not authenticated');
    final query = <String, String>{'event_id': eventId.toString()};
    if (slotId != null && slotId > 0) query['slot_id'] = slotId.toString();
    final uri = Uri.parse(
      '$baseUrl/api/app/worker/rehearsal-admin/roster',
    ).replace(queryParameters: query);
    final res = await http.get(
      uri,
      headers: {'Accept': 'application/json', 'Authorization': 'Bearer $token'},
    );
    if (res.statusCode != 200) {
      throw Exception(
        _tryMessage(res.body) ??
            'Failed to load rehearsal roster (${res.statusCode})',
      );
    }
    final json = jsonDecode(res.body) as Map<String, dynamic>;
    return RehearsalAdminRosterResponse.fromJson(json);
  }

  /// GET /api/app/worker/gift-control-report?event_id=&stage_id=&status_filter=
  Future<GiftControlReportResponse> getWorkerGiftControlReport(
    int eventId, {
    int? stageId,
    int? staffRoleId,
    String statusFilter = 'all',
  }) async {
    final token = await getToken();
    if (token == null || token.isEmpty) throw Exception('Not authenticated');
    final query = <String, String>{'event_id': eventId.toString()};
    if (stageId != null && stageId > 0) query['stage_id'] = stageId.toString();
    if (staffRoleId != null && staffRoleId > 0) {
      query['staff_role_id'] = staffRoleId.toString();
    }
    if (statusFilter.isNotEmpty) query['status_filter'] = statusFilter;
    final uri = Uri.parse(
      '$baseUrl/api/app/worker/gift-control-report',
    ).replace(queryParameters: query);
    final res = await http.get(
      uri,
      headers: {'Accept': 'application/json', 'Authorization': 'Bearer $token'},
    );
    if (res.statusCode != 200) {
      throw Exception(
        _tryMessage(res.body) ??
            'Failed to load gift control report (${res.statusCode})',
      );
    }
    final json = jsonDecode(res.body) as Map<String, dynamic>;
    return GiftControlReportResponse.fromJson(json);
  }

  /// POST /api/app/worker/scan-info-lookup — полная карточка по QR для любого worker (без ивента в приложении).
  Future<SupervisorChildDetail> scanInfoLookup({
    required String badgeCode,
  }) async {
    final token = await getToken();
    if (token == null || token.isEmpty) throw Exception('Not authenticated');
    final uri = Uri.parse('$baseUrl/api/app/worker/scan-info-lookup');
    final res = await http.post(
      uri,
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({'badge_code': badgeCode}),
    );
    final map = jsonDecode(res.body) as Map<String, dynamic>;
    if (res.statusCode == 403) {
      throw Exception(_tryMessage(res.body) ?? 'Forbidden');
    }
    if (res.statusCode == 200 && map['ok'] == true) {
      final copy = Map<String, dynamic>.from(map)..remove('ok');
      return SupervisorChildDetail.fromJson(copy);
    }
    throw Exception(
      _tryMessage(res.body) ??
          (map['message'] as String? ?? 'Could not resolve QR code'),
    );
  }

  /// POST /api/app/worker/parking-scan-lookup — данные парковочного тикета по QR.
  Future<ParkingScanLookupResult> parkingScanLookup({
    required String code,
  }) async {
    final token = await getToken();
    if (token == null || token.isEmpty) throw Exception('Not authenticated');
    final uri = Uri.parse('$baseUrl/api/app/worker/parking-scan-lookup');
    final res = await http.post(
      uri,
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({'code': code}),
    );
    final map = jsonDecode(res.body) as Map<String, dynamic>;
    if (res.statusCode == 200 && map['ok'] == true) {
      return ParkingScanLookupResult.fromJson(map);
    }
    throw Exception(
      _tryMessage(res.body) ??
          (map['message'] as String? ?? 'Could not resolve parking QR code'),
    );
  }

  /// POST /api/app/worker/extra-ticket-scan-lookup — данные extra ticket по QR.
  Future<ExtraTicketScanLookupResult> extraTicketScanLookup({
    required String code,
  }) async {
    final token = await getToken();
    if (token == null || token.isEmpty) throw Exception('Not authenticated');
    final uri = Uri.parse('$baseUrl/api/app/worker/extra-ticket-scan-lookup');
    final res = await http.post(
      uri,
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({'code': code}),
    );
    final map = jsonDecode(res.body) as Map<String, dynamic>;
    if (res.statusCode == 200 || res.statusCode == 422) {
      return ExtraTicketScanLookupResult.fromJson(map);
    }
    throw Exception(
      _tryMessage(res.body) ??
          (map['message'] as String? ??
              'Could not resolve extra ticket QR code'),
    );
  }

  /// POST /api/app/worker/backstage-ticket-scan-lookup — данные backstage ticket по QR.
  Future<BackstageTicketScanLookupResult> backstageTicketScanLookup({
    required String code,
  }) async {
    final token = await getToken();
    if (token == null || token.isEmpty) throw Exception('Not authenticated');
    final uri = Uri.parse(
      '$baseUrl/api/app/worker/backstage-ticket-scan-lookup',
    );
    final res = await http.post(
      uri,
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({'code': code}),
    );
    final map = jsonDecode(res.body) as Map<String, dynamic>;
    if (res.statusCode == 200 || res.statusCode == 422) {
      return BackstageTicketScanLookupResult.fromJson(map);
    }
    throw Exception(
      _tryMessage(res.body) ??
          (map['message'] as String? ??
              'Could not resolve backstage ticket QR code'),
    );
  }

  /// POST /api/app/worker/rehearsal-checkin-scan-lookup — check-in QR for selected rehearsal slot.
  Future<RehearsalCheckinScanLookupResult> rehearsalCheckinScanLookup({
    required String code,
    required int slotId,
  }) async {
    final token = await getToken();
    if (token == null || token.isEmpty) throw Exception('Not authenticated');
    final uri = Uri.parse(
      '$baseUrl/api/app/worker/rehearsal-checkin-scan-lookup',
    );
    final res = await http.post(
      uri,
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({'code': code, 'slot_id': slotId}),
    );
    final map = jsonDecode(res.body) as Map<String, dynamic>;
    if (res.statusCode == 200 || res.statusCode == 422) {
      return RehearsalCheckinScanLookupResult.fromJson(map);
    }
    throw Exception(
      _tryMessage(res.body) ??
          (map['message'] as String? ??
              'Could not resolve rehearsal check-in QR code'),
    );
  }

  /// GET /api/app/worker/supervisor-children/{assignment}/detail
  /// Детали ребёнка для экрана supervisor -> details.
  Future<SupervisorChildDetail> getSupervisorChildDetail(
    int assignmentId,
  ) async {
    final token = await getToken();
    if (token == null || token.isEmpty) throw Exception('Not authenticated');
    final uri = Uri.parse(
      '$baseUrl/api/app/worker/supervisor-children/$assignmentId/detail',
    );
    final res = await http.get(
      uri,
      headers: {'Accept': 'application/json', 'Authorization': 'Bearer $token'},
    );
    if (res.statusCode != 200) {
      throw Exception(
        _tryMessage(res.body) ??
            'Failed to load child details (${res.statusCode})',
      );
    }
    final json = jsonDecode(res.body) as Map<String, dynamic>;
    return SupervisorChildDetail.fromJson(json);
  }

  /// PATCH /api/app/client/profile — обновить имя, email, телефон текущего пользователя
  Future<void> updateProfile({
    required String name,
    required String email,
    required String phone,
  }) async {
    final token = await getToken();
    if (token == null || token.isEmpty) {
      throw Exception('Not authenticated');
    }
    final uri = Uri.parse('$baseUrl/api/app/client/profile');
    final res = await http.patch(
      uri,
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({'name': name, 'email': email, 'phone': phone}),
    );
    if (res.statusCode != 200) {
      throw Exception(
        _tryMessage(res.body) ?? 'Failed to update profile (${res.statusCode})',
      );
    }
  }

  /// DELETE /api/app/client/account — удалить аккаунт клиента и связанные данные на сервере
  Future<void> deleteClientAccount() async {
    final token = await getToken();
    if (token == null || token.isEmpty) {
      throw Exception('Not authenticated');
    }
    final uri = Uri.parse('$baseUrl/api/app/client/account');
    final res = await http.delete(
      uri,
      headers: {'Accept': 'application/json', 'Authorization': 'Bearer $token'},
    );
    if (res.statusCode != 200) {
      throw Exception(
        _tryMessage(res.body) ?? 'Failed to delete account (${res.statusCode})',
      );
    }
  }

  /// GET /api/app/client/profile — user info + children with photos
  Future<ClientProfile> getClientProfile() async {
    final token = await getToken();
    if (token == null || token.isEmpty) {
      throw Exception('Not authenticated');
    }
    final uri = Uri.parse('$baseUrl/api/app/client/profile');
    final res = await http.get(
      uri,
      headers: {'Accept': 'application/json', 'Authorization': 'Bearer $token'},
    );
    if (res.statusCode != 200) {
      throw Exception(
        _tryMessage(res.body) ?? 'Failed to load profile (${res.statusCode})',
      );
    }
    final json = jsonDecode(res.body) as Map<String, dynamic>;
    return ClientProfile.fromJson(json);
  }

  /// POST /api/app/client/contact-manager — сообщение менеджеру (Bearer).
  Future<void> submitContactManager({
    required String name,
    required String email,
    required String phone,
    required String message,
  }) async {
    final token = await getToken();
    if (token == null || token.isEmpty) {
      throw Exception('Not authenticated');
    }
    final uri = Uri.parse('$baseUrl/api/app/client/contact-manager');
    final res = await http.post(
      uri,
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({
        'name': name,
        'email': email,
        'phone': phone,
        'message': message,
      }),
    );
    if (res.statusCode == 200) {
      return;
    }
    if (res.statusCode == 503) {
      throw ContactManagerUnavailableException();
    }
    throw Exception(
      _tryMessage(res.body) ?? 'Failed to send message (${res.statusCode})',
    );
  }

  /// POST /api/app/client/children — создать ребёнка для текущего клиента
  Future<ProfileChild> createChild({
    required String firstName,
    String? gender,
    DateTime? birthdate,
  }) async {
    final token = await getToken();
    if (token == null || token.isEmpty) {
      throw Exception('Not authenticated');
    }
    final uri = Uri.parse('$baseUrl/api/app/client/children');
    final body = <String, dynamic>{'first_name': firstName};
    if (gender != null && gender.isNotEmpty) {
      body['gender'] = gender;
    }
    if (birthdate != null) {
      body['birthdate'] =
          '${birthdate.year}-${birthdate.month.toString().padLeft(2, '0')}-${birthdate.day.toString().padLeft(2, '0')}';
    }
    final res = await http.post(
      uri,
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(body),
    );
    if (res.statusCode != 201) {
      throw Exception(
        _tryMessage(res.body) ?? 'Failed to create child (${res.statusCode})',
      );
    }
    final json = jsonDecode(res.body) as Map<String, dynamic>;
    return ProfileChild.fromJson(json);
  }

  /// POST /api/app/client/children/{id}/main-photo — upload main photo
  /// Returns new main_photo_url.
  Future<String> uploadChildMainPhoto(int childId, String filePath) async {
    final token = await getToken();
    if (token == null || token.isEmpty) {
      throw Exception('Not authenticated');
    }
    final uri = Uri.parse(
      '$baseUrl/api/app/client/children/$childId/main-photo',
    );
    final request = http.MultipartRequest('POST', uri);
    request.headers['Accept'] = 'application/json';
    request.headers['Authorization'] = 'Bearer $token';
    request.files.add(await http.MultipartFile.fromPath('photo', filePath));
    final streamed = await request.send();
    final res = await http.Response.fromStream(streamed);
    if (res.statusCode != 200) {
      throw Exception(
        _tryMessage(res.body) ?? 'Failed to upload photo (${res.statusCode})',
      );
    }
    final json = jsonDecode(res.body) as Map<String, dynamic>;
    final url = json['main_photo_url'] as String?;
    if (url == null || url.isEmpty) {
      throw Exception('Invalid response: no main_photo_url');
    }
    return url;
  }

  /// DELETE /api/app/client/children/{id}/main-photo
  Future<void> deleteChildMainPhoto(int childId) async {
    final token = await getToken();
    if (token == null || token.isEmpty) {
      throw Exception('Not authenticated');
    }
    final uri = Uri.parse(
      '$baseUrl/api/app/client/children/$childId/main-photo',
    );
    final res = await http.delete(
      uri,
      headers: {'Accept': 'application/json', 'Authorization': 'Bearer $token'},
    );
    if (res.statusCode != 200) {
      throw Exception(
        _tryMessage(res.body) ?? 'Failed to delete photo (${res.statusCode})',
      );
    }
  }

  /// POST /api/app/client/children/{id}/extra-photos — upload extra photo
  /// Returns updated extra_photo_urls list.
  Future<List<String>> uploadChildExtraPhoto(
    int childId,
    String filePath,
  ) async {
    final token = await getToken();
    if (token == null || token.isEmpty) {
      throw Exception('Not authenticated');
    }
    final uri = Uri.parse(
      '$baseUrl/api/app/client/children/$childId/extra-photos',
    );
    final request = http.MultipartRequest('POST', uri);
    request.headers['Accept'] = 'application/json';
    request.headers['Authorization'] = 'Bearer $token';
    request.files.add(await http.MultipartFile.fromPath('photo', filePath));
    final streamed = await request.send();
    final res = await http.Response.fromStream(streamed);
    if (res.statusCode != 200) {
      throw Exception(
        _tryMessage(res.body) ?? 'Failed to upload photo (${res.statusCode})',
      );
    }
    final json = jsonDecode(res.body) as Map<String, dynamic>;
    final list = json['extra_photo_urls'];
    if (list is! List) {
      return [];
    }
    return list.map((e) => e.toString()).toList();
  }

  /// DELETE /api/app/client/children/{id}/extra-photos/{index}
  /// Returns updated extra_photo_urls list.
  Future<List<String>> deleteChildExtraPhoto(int childId, int index) async {
    final token = await getToken();
    if (token == null || token.isEmpty) {
      throw Exception('Not authenticated');
    }
    final uri = Uri.parse(
      '$baseUrl/api/app/client/children/$childId/extra-photos/$index',
    );
    final res = await http.delete(
      uri,
      headers: {'Accept': 'application/json', 'Authorization': 'Bearer $token'},
    );
    if (res.statusCode != 200) {
      throw Exception(
        _tryMessage(res.body) ?? 'Failed to delete photo (${res.statusCode})',
      );
    }
    final json = jsonDecode(res.body) as Map<String, dynamic>;
    final list = json['extra_photo_urls'];
    if (list is! List) {
      return [];
    }
    return list.map((e) => e.toString()).toList();
  }

  /// PATCH /api/app/client/children/{id} — update child fields
  Future<void> updateChild(int childId, Map<String, dynamic> payload) async {
    final token = await getToken();
    if (token == null || token.isEmpty) {
      throw Exception('Not authenticated');
    }
    final uri = Uri.parse('$baseUrl/api/app/client/children/$childId');
    final res = await http.patch(
      uri,
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(payload),
    );
    if (res.statusCode != 200) {
      throw Exception(
        _tryMessage(res.body) ?? 'Failed to update child (${res.statusCode})',
      );
    }
  }

  /// GET /api/app/client/dashboard — active event for client's children
  /// PATCH /api/app/client/assignments/{id}/meal — выбор обеда для назначения.
  Future<void> updateClientAssignmentMeal({
    required int assignmentId,
    int? eventMealId,
  }) async {
    final token = await getToken();
    if (token == null || token.isEmpty) {
      throw Exception('Not authenticated');
    }
    final uri = Uri.parse(
      '$baseUrl/api/app/client/assignments/$assignmentId/meal',
    );
    final res = await http.patch(
      uri,
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({'event_meal_id': eventMealId}),
    );
    if (res.statusCode != 200) {
      throw Exception(
        _tryMessage(res.body) ??
            'Failed to save meal choice (${res.statusCode})',
      );
    }
  }

  /// POST /api/app/client/assignments/{id}/meal-checkout — Stripe Checkout URL.
  Future<String> createMealCheckoutSession({
    required int assignmentId,
    required int eventMealId,
  }) async {
    final token = await getToken();
    if (token == null || token.isEmpty) {
      throw Exception('Not authenticated');
    }
    final uri = Uri.parse(
      '$baseUrl/api/app/client/assignments/$assignmentId/meal-checkout',
    );
    final res = await http.post(
      uri,
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({'event_meal_id': eventMealId}),
    );
    if (res.statusCode != 200) {
      throw Exception(
        _tryMessage(res.body) ?? 'Failed to start checkout (${res.statusCode})',
      );
    }
    final map = jsonDecode(res.body) as Map<String, dynamic>;
    final url = map['checkout_url'] as String?;
    if (url == null || url.isEmpty) {
      throw Exception('No checkout URL in response');
    }
    return url;
  }

  /// GET …/meal-payment-status — синхронизация с Stripe, флаги для UI.
  Future<MealPaymentStatusPayload> getClientAssignmentMealPaymentStatus(
    int assignmentId,
  ) async {
    final token = await getToken();
    if (token == null || token.isEmpty) {
      throw Exception('Not authenticated');
    }
    final uri = Uri.parse(
      '$baseUrl/api/app/client/assignments/$assignmentId/meal-payment-status',
    );
    final res = await http.get(
      uri,
      headers: {'Accept': 'application/json', 'Authorization': 'Bearer $token'},
    );
    if (res.statusCode != 200) {
      throw Exception(
        _tryMessage(res.body) ??
            'Failed to load meal payment status (${res.statusCode})',
      );
    }
    final map = jsonDecode(res.body) as Map<String, dynamic>;
    return MealPaymentStatusPayload.fromJson(map);
  }

  /// POST …/meal-payment-resume — URL открытой сессии или 422 (нужен новый checkout).
  Future<String> resumeClientAssignmentMealPayment(int assignmentId) async {
    final token = await getToken();
    if (token == null || token.isEmpty) {
      throw Exception('Not authenticated');
    }
    final uri = Uri.parse(
      '$baseUrl/api/app/client/assignments/$assignmentId/meal-payment-resume',
    );
    final res = await http.post(
      uri,
      headers: {'Accept': 'application/json', 'Authorization': 'Bearer $token'},
    );
    if (res.statusCode != 200) {
      throw Exception(
        _tryMessage(res.body) ??
            'Failed to resume meal checkout (${res.statusCode})',
      );
    }
    final map = jsonDecode(res.body) as Map<String, dynamic>;
    final url = map['checkout_url'] as String?;
    if (url == null || url.isEmpty) {
      throw Exception('No checkout URL in response');
    }
    return url;
  }

  /// POST …/meal-payment-cancel — expire Checkout Session в Stripe (обед).
  Future<void> cancelClientAssignmentMealPayment(int assignmentId) async {
    final token = await getToken();
    if (token == null || token.isEmpty) {
      throw Exception('Not authenticated');
    }
    final uri = Uri.parse(
      '$baseUrl/api/app/client/assignments/$assignmentId/meal-payment-cancel',
    );
    final res = await http.post(
      uri,
      headers: {'Accept': 'application/json', 'Authorization': 'Bearer $token'},
    );
    if (res.statusCode != 200) {
      throw Exception(
        _tryMessage(res.body) ??
            'Failed to cancel meal checkout (${res.statusCode})',
      );
    }
  }

  Future<MealPaymentStatusPayload> getEventParkingPaymentStatus(
    int eventId,
  ) =>
      _getEventTicketStripePaymentStatus(eventId, 'parking-payment');

  Future<String> resumeEventParkingPayment(int eventId) =>
      _resumeEventTicketStripePayment(eventId, 'parking-payment');

  Future<void> cancelEventParkingPayment(int eventId) =>
      _cancelEventTicketStripePayment(eventId, 'parking-payment');

  Future<MealPaymentStatusPayload> getEventExtraTicketPaymentStatus(
    int eventId,
  ) =>
      _getEventTicketStripePaymentStatus(eventId, 'extra-ticket-payment');

  Future<String> resumeEventExtraTicketPayment(int eventId) =>
      _resumeEventTicketStripePayment(eventId, 'extra-ticket-payment');

  Future<void> cancelEventExtraTicketPayment(int eventId) =>
      _cancelEventTicketStripePayment(eventId, 'extra-ticket-payment');

  Future<MealPaymentStatusPayload> getEventBackstageTicketPaymentStatus(
    int eventId,
  ) =>
      _getEventTicketStripePaymentStatus(
        eventId,
        'backstage-ticket-payment',
      );

  Future<String> resumeEventBackstageTicketPayment(int eventId) =>
      _resumeEventTicketStripePayment(eventId, 'backstage-ticket-payment');

  Future<void> cancelEventBackstageTicketPayment(int eventId) =>
      _cancelEventTicketStripePayment(eventId, 'backstage-ticket-payment');

  Future<MealPaymentStatusPayload> _getEventTicketStripePaymentStatus(
    int eventId,
    String pathSegment,
  ) async {
    final token = await getToken();
    if (token == null || token.isEmpty) {
      throw Exception('Not authenticated');
    }
    final uri = Uri.parse(
      '$baseUrl/api/app/client/events/$eventId/$pathSegment-status',
    );
    final res = await http.get(
      uri,
      headers: {'Accept': 'application/json', 'Authorization': 'Bearer $token'},
    );
    if (res.statusCode != 200) {
      throw Exception(
        _tryMessage(res.body) ??
            'Failed to load payment status (${res.statusCode})',
      );
    }
    final map = jsonDecode(res.body) as Map<String, dynamic>;
    return MealPaymentStatusPayload.fromJson(map);
  }

  Future<String> _resumeEventTicketStripePayment(
    int eventId,
    String pathSegment,
  ) async {
    final token = await getToken();
    if (token == null || token.isEmpty) {
      throw Exception('Not authenticated');
    }
    final uri = Uri.parse(
      '$baseUrl/api/app/client/events/$eventId/$pathSegment-resume',
    );
    final res = await http.post(
      uri,
      headers: {'Accept': 'application/json', 'Authorization': 'Bearer $token'},
    );
    if (res.statusCode != 200) {
      throw Exception(
        _tryMessage(res.body) ??
            'Failed to resume checkout (${res.statusCode})',
      );
    }
    final map = jsonDecode(res.body) as Map<String, dynamic>;
    final url = map['checkout_url'] as String?;
    if (url == null || url.isEmpty) {
      throw Exception('No checkout URL in response');
    }
    return url;
  }

  Future<void> _cancelEventTicketStripePayment(
    int eventId,
    String pathSegment,
  ) async {
    final token = await getToken();
    if (token == null || token.isEmpty) {
      throw Exception('Not authenticated');
    }
    final uri = Uri.parse(
      '$baseUrl/api/app/client/events/$eventId/$pathSegment-cancel',
    );
    final res = await http.post(
      uri,
      headers: {'Accept': 'application/json', 'Authorization': 'Bearer $token'},
    );
    if (res.statusCode != 200) {
      throw Exception(
        _tryMessage(res.body) ??
            'Failed to cancel checkout (${res.statusCode})',
      );
    }
  }

  /// GET /api/app/client/events/{event}/parking-tickets
  Future<ParkingTicketsPayload> getEventParkingTickets(int eventId) async {
    final token = await getToken();
    if (token == null || token.isEmpty) {
      throw Exception('Not authenticated');
    }

    final uri = Uri.parse(
      '$baseUrl/api/app/client/events/$eventId/parking-tickets',
    );
    final res = await http.get(
      uri,
      headers: {'Accept': 'application/json', 'Authorization': 'Bearer $token'},
    );
    if (res.statusCode == 403) {
      final code = _tryApiCode(res.body);
      if (code == 'service_disabled') {
        throw ApiServiceDisabledException(
          _tryMessage(res.body) ?? 'Service unavailable',
        );
      }
      throw Exception(_tryMessage(res.body) ?? 'Forbidden');
    }
    if (res.statusCode != 200) {
      throw Exception(
        _tryMessage(res.body) ??
            'Failed to load parking tickets (${res.statusCode})',
      );
    }

    final map = jsonDecode(res.body) as Map<String, dynamic>;
    return ParkingTicketsPayload.fromJson(map);
  }

  /// POST /api/app/client/events/{event}/parking-checkout
  Future<ParkingCheckoutResult> createParkingCheckoutSession({
    required int eventId,
    required String carModel,
    required String plateNumber,
    required String plateNumberRepeat,
  }) async {
    final token = await getToken();
    if (token == null || token.isEmpty) {
      throw Exception('Not authenticated');
    }

    final uri = Uri.parse(
      '$baseUrl/api/app/client/events/$eventId/parking-checkout',
    );
    final res = await http.post(
      uri,
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({
        'car_model': carModel.trim(),
        'plate_number': plateNumber.trim(),
        'plate_number_repeat': plateNumberRepeat.trim(),
      }),
    );
    if (res.statusCode != 200) {
      if (res.statusCode == 403 &&
          _tryApiCode(res.body) == 'service_disabled') {
        throw ApiServiceDisabledException(
          _tryMessage(res.body) ?? 'Service unavailable',
        );
      }
      throw Exception(
        _tryMessage(res.body) ?? 'Failed to start checkout (${res.statusCode})',
      );
    }
    final map = jsonDecode(res.body) as Map<String, dynamic>;
    final purchased = map['purchased'] == true;
    if (purchased) {
      return const ParkingCheckoutResult(purchased: true, checkoutUrl: null);
    }
    final url = map['checkout_url'] as String?;
    if (url == null || url.isEmpty) {
      throw Exception('No checkout URL in response');
    }
    return ParkingCheckoutResult(purchased: false, checkoutUrl: url);
  }

  /// GET /api/app/client/events/{event}/extra-tickets
  Future<ExtraTicketsPayload> getEventExtraTickets(int eventId) async {
    final token = await getToken();
    if (token == null || token.isEmpty) {
      throw Exception('Not authenticated');
    }

    final uri = Uri.parse(
      '$baseUrl/api/app/client/events/$eventId/extra-tickets',
    );
    final res = await http.get(
      uri,
      headers: {'Accept': 'application/json', 'Authorization': 'Bearer $token'},
    );
    if (res.statusCode == 403) {
      final code = _tryApiCode(res.body);
      if (code == 'service_disabled') {
        throw ApiServiceDisabledException(
          _tryMessage(res.body) ?? 'Service unavailable',
        );
      }
      throw Exception(_tryMessage(res.body) ?? 'Forbidden');
    }
    if (res.statusCode != 200) {
      throw Exception(
        _tryMessage(res.body) ??
            'Failed to load extra tickets (${res.statusCode})',
      );
    }

    final map = jsonDecode(res.body) as Map<String, dynamic>;
    return ExtraTicketsPayload.fromJson(map);
  }

  /// POST /api/app/client/events/{event}/extra-checkout
  Future<ExtraCheckoutResult> createExtraCheckoutSession({
    required int eventId,
  }) async {
    final token = await getToken();
    if (token == null || token.isEmpty) {
      throw Exception('Not authenticated');
    }

    final uri = Uri.parse(
      '$baseUrl/api/app/client/events/$eventId/extra-checkout',
    );
    final res = await http.post(
      uri,
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(<String, dynamic>{}),
    );
    if (res.statusCode != 200) {
      if (res.statusCode == 403 &&
          _tryApiCode(res.body) == 'service_disabled') {
        throw ApiServiceDisabledException(
          _tryMessage(res.body) ?? 'Service unavailable',
        );
      }
      throw Exception(
        _tryMessage(res.body) ?? 'Failed to start checkout (${res.statusCode})',
      );
    }
    final map = jsonDecode(res.body) as Map<String, dynamic>;
    final purchased = map['purchased'] == true;
    if (purchased) {
      return const ExtraCheckoutResult(purchased: true, checkoutUrl: null);
    }
    final url = map['checkout_url'] as String?;
    if (url == null || url.isEmpty) {
      throw Exception('No checkout URL in response');
    }
    return ExtraCheckoutResult(purchased: false, checkoutUrl: url);
  }

  /// GET /api/app/client/events/{event}/backstage-tickets
  Future<BackstageTicketsPayload> getEventBackstageTickets(int eventId) async {
    final token = await getToken();
    if (token == null || token.isEmpty) {
      throw Exception('Not authenticated');
    }

    final uri = Uri.parse(
      '$baseUrl/api/app/client/events/$eventId/backstage-tickets',
    );
    final res = await http.get(
      uri,
      headers: {'Accept': 'application/json', 'Authorization': 'Bearer $token'},
    );
    if (res.statusCode == 403) {
      final code = _tryApiCode(res.body);
      if (code == 'service_disabled') {
        throw ApiServiceDisabledException(
          _tryMessage(res.body) ?? 'Service unavailable',
        );
      }
      throw Exception(_tryMessage(res.body) ?? 'Forbidden');
    }
    if (res.statusCode != 200) {
      throw Exception(
        _tryMessage(res.body) ??
            'Failed to load backstage tickets (${res.statusCode})',
      );
    }

    final map = jsonDecode(res.body) as Map<String, dynamic>;
    return BackstageTicketsPayload.fromJson(map);
  }

  /// POST /api/app/client/events/{event}/backstage-checkout
  Future<BackstageCheckoutResult> createBackstageCheckoutSession({
    required int eventId,
  }) async {
    final token = await getToken();
    if (token == null || token.isEmpty) {
      throw Exception('Not authenticated');
    }

    final uri = Uri.parse(
      '$baseUrl/api/app/client/events/$eventId/backstage-checkout',
    );
    final res = await http.post(
      uri,
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(<String, dynamic>{}),
    );
    if (res.statusCode != 200) {
      if (res.statusCode == 403 &&
          _tryApiCode(res.body) == 'service_disabled') {
        throw ApiServiceDisabledException(
          _tryMessage(res.body) ?? 'Service unavailable',
        );
      }
      throw Exception(
        _tryMessage(res.body) ?? 'Failed to start checkout (${res.statusCode})',
      );
    }
    final map = jsonDecode(res.body) as Map<String, dynamic>;
    final purchased = map['purchased'] == true;
    if (purchased) {
      return const BackstageCheckoutResult(purchased: true, checkoutUrl: null);
    }
    final url = map['checkout_url'] as String?;
    if (url == null || url.isEmpty) {
      throw Exception('No checkout URL in response');
    }
    return BackstageCheckoutResult(purchased: false, checkoutUrl: url);
  }

  /// [contentLocale] — локаль UI приложения; влияет на язык названий/описаний этапов (Accept-Language).
  /// Если null, используется системная локаль устройства.
  Future<ClientDashboard> getClientDashboard({Locale? contentLocale}) async {
    final token = await getToken();
    if (token == null || token.isEmpty) {
      throw Exception('Not authenticated');
    }
    final lang = apiContentLanguageForLocale(
      contentLocale ?? PlatformDispatcher.instance.locale,
    );
    final uri = Uri.parse('$baseUrl/api/app/client/dashboard');
    final res = await http.get(
      uri,
      headers: {
        'Accept': 'application/json',
        'Accept-Language': lang,
        'Authorization': 'Bearer $token',
      },
    );
    if (res.statusCode != 200) {
      throw Exception(
        _tryMessage(res.body) ?? 'Failed to load dashboard (${res.statusCode})',
      );
    }
    final json = jsonDecode(res.body) as Map<String, dynamic>;
    return ClientDashboard.fromJson(json);
  }

  /// GET /api/app/client/events/{event}/rehearsal-slots
  Future<RehearsalSlotsPayload> getEventRehearsalSlots(
    int eventId, {
    int? assignmentId,
  }) async {
    final token = await getToken();
    if (token == null || token.isEmpty) {
      throw Exception('Not authenticated');
    }
    var uri = Uri.parse(
      '$baseUrl/api/app/client/events/$eventId/rehearsal-slots',
    );
    if (assignmentId != null && assignmentId > 0) {
      uri = uri.replace(
        queryParameters: {
          ...uri.queryParameters,
          'assignment_id': assignmentId.toString(),
        },
      );
    }
    final res = await http.get(
      uri,
      headers: {'Accept': 'application/json', 'Authorization': 'Bearer $token'},
    );
    if (res.statusCode == 403) {
      throw Exception(_tryMessage(res.body) ?? 'Forbidden');
    }
    if (res.statusCode != 200) {
      throw Exception(
        _tryMessage(res.body) ??
            'Failed to load rehearsal slots (${res.statusCode})',
      );
    }
    final map = jsonDecode(res.body) as Map<String, dynamic>;
    final list = map['slots'];
    final slots = list is List
        ? list
              .map(
                (e) => RehearsalSlotOption.fromJson(e as Map<String, dynamic>),
              )
              .toList()
        : <RehearsalSlotOption>[];
    final closed = map['rehearsal_booking_changes_closed'] == true;
    return RehearsalSlotsPayload(
      slots: slots,
      rehearsalBookingChangesClosed: closed,
    );
  }

  /// GET /api/app/client/events/{event}/packing
  Future<EventPackingInfo> getEventPackingInfo(
    int eventId, {
    Locale? contentLocale,
  }) async {
    final token = await getToken();
    if (token == null || token.isEmpty) {
      throw Exception('Not authenticated');
    }
    final uri = Uri.parse('$baseUrl/api/app/client/events/$eventId/packing');
    final res = await http.get(
      uri,
      headers: _authedContentHeaders(token, contentLocale: contentLocale),
    );
    if (res.statusCode == 403) {
      throw Exception(_tryMessage(res.body) ?? 'Forbidden');
    }
    if (res.statusCode != 200) {
      throw Exception(
        _tryMessage(res.body) ??
            'Failed to load event packing (${res.statusCode})',
      );
    }
    final map = jsonDecode(res.body) as Map<String, dynamic>;
    return EventPackingInfo.fromJson(map);
  }

  /// GET /api/app/client/events/{event}/description — вкладка «Описание» (фото + текст).
  Future<EventDescriptionInfo> getClientEventDescription(
    int eventId, {
    Locale? contentLocale,
  }) async {
    final token = await getToken();
    if (token == null || token.isEmpty) {
      throw Exception('Not authenticated');
    }
    final uri = Uri.parse(
      '$baseUrl/api/app/client/events/$eventId/description',
    );
    final res = await http.get(
      uri,
      headers: _authedContentHeaders(token, contentLocale: contentLocale),
    );
    if (res.statusCode == 403) {
      throw Exception(_tryMessage(res.body) ?? 'Forbidden');
    }
    if (res.statusCode != 200) {
      throw Exception(
        _tryMessage(res.body) ??
            'Failed to load event description (${res.statusCode})',
      );
    }
    final map = jsonDecode(res.body) as Map<String, dynamic>;
    return EventDescriptionInfo.fromJson(map);
  }

  /// GET /api/app/client/events/{event}/brand-requirements
  Future<List<BrandRequirementInfo>> getEventBrandRequirements(
    int eventId, {
    Locale? contentLocale,
  }) async {
    final token = await getToken();
    if (token == null || token.isEmpty) {
      throw Exception('Not authenticated');
    }
    final uri = Uri.parse(
      '$baseUrl/api/app/client/events/$eventId/brand-requirements',
    );
    final res = await http.get(
      uri,
      headers: _authedContentHeaders(token, contentLocale: contentLocale),
    );
    if (res.statusCode == 403) {
      throw Exception(_tryMessage(res.body) ?? 'Forbidden');
    }
    if (res.statusCode != 200) {
      throw Exception(
        _tryMessage(res.body) ??
            'Failed to load brand requirements (${res.statusCode})',
      );
    }
    final map = jsonDecode(res.body) as Map<String, dynamic>;
    final list = map['items'];
    if (list is! List) {
      return const [];
    }
    return list
        .map((e) => BrandRequirementInfo.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  /// GET /api/app/client/events/{event}/chat-rooms
  Future<List<ClientChatRoomSummary>> getEventChatRooms(int eventId) async {
    final token = await getToken();
    if (token == null || token.isEmpty) {
      throw Exception('Not authenticated');
    }
    final uri = Uri.parse('$baseUrl/api/app/client/events/$eventId/chat-rooms');
    final res = await http.get(
      uri,
      headers: {'Accept': 'application/json', 'Authorization': 'Bearer $token'},
    );
    if (res.statusCode == 403) {
      throw Exception(_tryMessage(res.body) ?? 'Forbidden');
    }
    if (res.statusCode != 200) {
      throw Exception(
        _tryMessage(res.body) ??
            'Failed to load chat rooms (${res.statusCode})',
      );
    }
    final map = jsonDecode(res.body) as Map<String, dynamic>;
    final list = map['rooms'];
    if (list is! List) return const [];
    return list
        .map((e) => ClientChatRoomSummary.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  /// GET /api/app/client/chat-rooms/{room}/messages
  Future<ClientChatRoomPayload> getChatRoomMessages(
    int roomId, {
    int afterId = 0,
  }) async {
    final token = await getToken();
    if (token == null || token.isEmpty) {
      throw Exception('Not authenticated');
    }
    final uri = Uri.parse(
      '$baseUrl/api/app/client/chat-rooms/$roomId/messages',
    ).replace(queryParameters: afterId > 0 ? {'after_id': '$afterId'} : null);
    final res = await http.get(
      uri,
      headers: {'Accept': 'application/json', 'Authorization': 'Bearer $token'},
    );
    if (res.statusCode == 403) {
      throw Exception(_tryMessage(res.body) ?? 'Forbidden');
    }
    if (res.statusCode != 200) {
      throw Exception(
        _tryMessage(res.body) ??
            'Failed to load chat messages (${res.statusCode})',
      );
    }
    final map = jsonDecode(res.body) as Map<String, dynamic>;
    return ClientChatRoomPayload.fromJson(map);
  }

  /// POST /api/app/client/chat-rooms/{room}/messages
  Future<ClientChatMessage> sendChatRoomMessage(
    int roomId, {
    String? body,
    String? photoPath,
    int? replyToMessageId,
  }) async {
    final token = await getToken();
    if (token == null || token.isEmpty) {
      throw Exception('Not authenticated');
    }
    final normalizedBody = (body ?? '').trim();
    final hasPhoto = photoPath != null && photoPath.isNotEmpty;
    if (normalizedBody.isEmpty && !hasPhoto) {
      throw Exception('Validation failed');
    }
    final uri = Uri.parse(
      '$baseUrl/api/app/client/chat-rooms/$roomId/messages',
    );
    late final http.Response res;
    final replyId = replyToMessageId;
    if (hasPhoto) {
      final request = http.MultipartRequest('POST', uri);
      request.headers['Accept'] = 'application/json';
      request.headers['Authorization'] = 'Bearer $token';
      if (normalizedBody.isNotEmpty) {
        request.fields['body'] = normalizedBody;
      }
      if (replyId != null && replyId > 0) {
        request.fields['reply_to_message_id'] = '$replyId';
      }
      request.files.add(await http.MultipartFile.fromPath('photo', photoPath));
      final streamed = await request.send();
      res = await http.Response.fromStream(streamed);
    } else {
      final payload = <String, dynamic>{'body': normalizedBody};
      if (replyId != null && replyId > 0) {
        payload['reply_to_message_id'] = replyId;
      }
      res = await http.post(
        uri,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode(payload),
      );
    }
    if (res.statusCode == 422) {
      throw Exception(_tryMessage(res.body) ?? 'Validation failed');
    }
    if (res.statusCode == 403) {
      throw Exception(_tryMessage(res.body) ?? 'Forbidden');
    }
    if (res.statusCode != 200) {
      throw Exception(
        _tryMessage(res.body) ??
            'Failed to send chat message (${res.statusCode})',
      );
    }
    final map = jsonDecode(res.body) as Map<String, dynamic>;
    final msg = map['message'];
    if (msg is! Map<String, dynamic>) {
      throw Exception('Invalid chat response');
    }
    return ClientChatMessage.fromJson(msg);
  }

  /// PATCH /api/app/client/chat-rooms/{room}/messages/{message}
  Future<ClientChatMessage> editChatRoomMessage(
    int roomId,
    int messageId, {
    required String body,
  }) async {
    final token = await getToken();
    if (token == null || token.isEmpty) {
      throw Exception('Not authenticated');
    }
    final normalizedBody = body.trim();
    if (normalizedBody.isEmpty) {
      throw Exception('Validation failed');
    }
    final uri = Uri.parse(
      '$baseUrl/api/app/client/chat-rooms/$roomId/messages/$messageId',
    );
    final res = await http.patch(
      uri,
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({'body': normalizedBody}),
    );
    if (res.statusCode == 422) {
      throw Exception(_tryMessage(res.body) ?? 'Validation failed');
    }
    if (res.statusCode == 403) {
      throw Exception(_tryMessage(res.body) ?? 'Forbidden');
    }
    if (res.statusCode != 200) {
      throw Exception(
        _tryMessage(res.body) ??
            'Failed to edit chat message (${res.statusCode})',
      );
    }
    final map = jsonDecode(res.body) as Map<String, dynamic>;
    final msg = map['message'];
    if (msg is! Map<String, dynamic>) {
      throw Exception('Invalid chat response');
    }
    return ClientChatMessage.fromJson(msg);
  }

  /// DELETE /api/app/client/chat-rooms/{room}/messages/{message}
  Future<void> deleteChatRoomMessage(int roomId, int messageId) async {
    final token = await getToken();
    if (token == null || token.isEmpty) {
      throw Exception('Not authenticated');
    }
    final uri = Uri.parse(
      '$baseUrl/api/app/client/chat-rooms/$roomId/messages/$messageId',
    );
    final res = await http.delete(
      uri,
      headers: {'Accept': 'application/json', 'Authorization': 'Bearer $token'},
    );
    if (res.statusCode == 403) {
      throw Exception(_tryMessage(res.body) ?? 'Forbidden');
    }
    if (res.statusCode != 200) {
      throw Exception(
        _tryMessage(res.body) ??
            'Failed to delete chat message (${res.statusCode})',
      );
    }
  }

  /// POST /api/app/client/assignments/{id}/rehearsal-booking
  Future<RehearsalBookingInfo> bookRehearsalSlot({
    required int assignmentId,
    required int slotId,
  }) async {
    final token = await getToken();
    if (token == null || token.isEmpty) {
      throw Exception('Not authenticated');
    }
    final uri = Uri.parse(
      '$baseUrl/api/app/client/assignments/$assignmentId/rehearsal-booking',
    );
    final res = await http.post(
      uri,
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({'slot_id': slotId}),
    );
    if (res.statusCode == 422) {
      throw Exception(_tryMessage(res.body) ?? 'Could not book this slot');
    }
    if (res.statusCode != 200) {
      throw Exception(
        _tryMessage(res.body) ?? 'Booking failed (${res.statusCode})',
      );
    }
    final map = jsonDecode(res.body) as Map<String, dynamic>;
    final list = map['rehearsal_bookings'];
    if (list is List && list.isNotEmpty) {
      final first = list.first;
      if (first is Map<String, dynamic>) {
        return RehearsalBookingInfo.fromJson(first);
      }
    }
    final b = map['rehearsal_booking'];
    if (b is! Map<String, dynamic>) {
      throw Exception('Invalid booking response');
    }
    return RehearsalBookingInfo.fromJson(b);
  }

  /// DELETE /api/app/client/assignments/{id}/rehearsal-booking
  Future<void> cancelRehearsalBooking(int assignmentId, {int? slotId}) async {
    final token = await getToken();
    if (token == null || token.isEmpty) {
      throw Exception('Not authenticated');
    }
    final uri =
        Uri.parse(
          '$baseUrl/api/app/client/assignments/$assignmentId/rehearsal-booking',
        ).replace(
          queryParameters: slotId != null && slotId > 0
              ? {'slot_id': '$slotId'}
              : null,
        );
    final res = await http.delete(
      uri,
      headers: {'Accept': 'application/json', 'Authorization': 'Bearer $token'},
    );
    if (res.statusCode != 200) {
      throw Exception(
        _tryMessage(res.body) ?? 'Cancel failed (${res.statusCode})',
      );
    }
  }

  /// PUT /api/app/client/assignments/{id}/rehearsal-booking
  Future<List<RehearsalBookingInfo>> replaceRehearsalBookings({
    required int assignmentId,
    required List<int> slotIds,
  }) async {
    final token = await getToken();
    if (token == null || token.isEmpty) {
      throw Exception('Not authenticated');
    }
    final uri = Uri.parse(
      '$baseUrl/api/app/client/assignments/$assignmentId/rehearsal-booking',
    );
    final res = await http.put(
      uri,
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({'slot_ids': slotIds}),
    );
    if (res.statusCode == 422) {
      throw Exception(_tryMessage(res.body) ?? 'Could not update bookings');
    }
    if (res.statusCode != 200) {
      throw Exception(
        _tryMessage(res.body) ?? 'Update bookings failed (${res.statusCode})',
      );
    }
    final map = jsonDecode(res.body) as Map<String, dynamic>;
    final list = map['rehearsal_bookings'];
    if (list is! List) return const [];
    return list
        .whereType<Map<String, dynamic>>()
        .map(RehearsalBookingInfo.fromJson)
        .toList();
  }

  /// GET /api/app/client/upcoming-events — события в будущем, в которые ребёнок ещё не записан
  Future<List<UpcomingEvent>> getClientUpcomingEvents() async {
    final token = await getToken();
    if (token == null || token.isEmpty) {
      throw Exception('Not authenticated');
    }
    final uri = Uri.parse('$baseUrl/api/app/client/upcoming-events');
    final res = await http.get(
      uri,
      headers: {'Accept': 'application/json', 'Authorization': 'Bearer $token'},
    );
    if (res.statusCode != 200) {
      throw Exception(
        _tryMessage(res.body) ??
            'Failed to load upcoming events (${res.statusCode})',
      );
    }
    final json = jsonDecode(res.body) as Map<String, dynamic>;
    final list = json['events'];
    if (list is! List) return [];
    return list
        .map((e) => UpcomingEvent.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  /// GET /api/app/client/ticket-events — события, по которым у клиента есть билеты.
  Future<List<ClientTicketEventRef>> getClientTicketEvents() async {
    final token = await getToken();
    if (token == null || token.isEmpty) {
      throw Exception('Not authenticated');
    }
    final uri = Uri.parse('$baseUrl/api/app/client/ticket-events');
    final res = await http.get(
      uri,
      headers: {'Accept': 'application/json', 'Authorization': 'Bearer $token'},
    );
    if (res.statusCode != 200) {
      throw Exception(
        _tryMessage(res.body) ??
            'Failed to load ticket events (${res.statusCode})',
      );
    }
    final json = jsonDecode(res.body) as Map<String, dynamic>;
    final list = json['events'];
    if (list is! List) return [];
    return list
        .map((e) => ClientTicketEventRef.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  /// GET /api/app/client/events/{id}/tickets — билеты клиента по событию.
  Future<List<ClientTicketItem>> getClientEventTickets(int eventId) async {
    final token = await getToken();
    if (token == null || token.isEmpty) {
      throw Exception('Not authenticated');
    }
    final uri = Uri.parse('$baseUrl/api/app/client/events/$eventId/tickets');
    final res = await http.get(
      uri,
      headers: {'Accept': 'application/json', 'Authorization': 'Bearer $token'},
    );
    if (res.statusCode != 200) {
      throw Exception(
        _tryMessage(res.body) ??
            'Failed to load event tickets (${res.statusCode})',
      );
    }
    final json = jsonDecode(res.body) as Map<String, dynamic>;
    final list = json['tickets'];
    if (list is! List) return [];
    return list
        .map(
          (e) => ClientTicketItem.fromJson(e as Map<String, dynamic>, baseUrl),
        )
        .toList();
  }

  /// GET /api/app/notifications/unread-count
  Future<int> getUnreadNotificationsCount() async {
    final token = await getToken();
    if (token == null || token.isEmpty) {
      throw Exception('Not authenticated');
    }
    final uri = Uri.parse('$baseUrl/api/app/notifications/unread-count');
    final res = await http.get(
      uri,
      headers: {'Accept': 'application/json', 'Authorization': 'Bearer $token'},
    );
    if (res.statusCode != 200) {
      throw Exception(
        _tryMessage(res.body) ??
            'Failed to load unread notifications (${res.statusCode})',
      );
    }
    final map = jsonDecode(res.body) as Map<String, dynamic>;
    return _jsonInt(map['unread_count']);
  }

  /// GET /api/app/notifications
  Future<List<AppNotificationListItem>> getNotifications() async {
    final token = await getToken();
    if (token == null || token.isEmpty) {
      throw Exception('Not authenticated');
    }
    final uri = Uri.parse('$baseUrl/api/app/notifications');
    final res = await http.get(
      uri,
      headers: {'Accept': 'application/json', 'Authorization': 'Bearer $token'},
    );
    if (res.statusCode != 200) {
      throw Exception(
        _tryMessage(res.body) ??
            'Failed to load notifications (${res.statusCode})',
      );
    }
    final map = jsonDecode(res.body) as Map<String, dynamic>;
    final list = map['notifications'];
    if (list is! List) return const [];
    return list
        .map((e) => AppNotificationListItem.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  /// GET /api/app/notifications/{recipientId}
  Future<AppNotificationDetails> getNotificationDetails(int recipientId) async {
    final token = await getToken();
    if (token == null || token.isEmpty) {
      throw Exception('Not authenticated');
    }
    final uri = Uri.parse('$baseUrl/api/app/notifications/$recipientId');
    final res = await http.get(
      uri,
      headers: {'Accept': 'application/json', 'Authorization': 'Bearer $token'},
    );
    if (res.statusCode != 200) {
      throw Exception(
        _tryMessage(res.body) ??
            'Failed to load notification (${res.statusCode})',
      );
    }
    final map = jsonDecode(res.body) as Map<String, dynamic>;
    final n = map['notification'];
    if (n is! Map<String, dynamic>) {
      throw Exception('Invalid notification response');
    }
    return AppNotificationDetails.fromJson(n);
  }

  /// GET /api/app/info/settings — публичные настройки раздела Info (фото, соцсети, сайт). Без авторизации.
  Future<InfoSettings> getInfoSettings({Locale? contentLocale}) async {
    final uri = Uri.parse('$baseUrl/api/app/info/settings');
    final res = await http.get(
      uri,
      headers: _publicContentHeaders(contentLocale: contentLocale),
    );
    if (res.statusCode != 200) {
      throw Exception(
        _tryMessage(res.body) ??
            'Failed to load info settings (${res.statusCode})',
      );
    }
    final json = jsonDecode(res.body) as Map<String, dynamic>;
    return InfoSettings.fromJson(json);
  }

  /// GET /api/app/info/news — список новостей для блока «Последние события». Без авторизации.
  Future<List<AppNewsItem>> getAppNews({Locale? contentLocale}) async {
    final uri = Uri.parse('$baseUrl/api/app/info/news');
    final res = await http.get(
      uri,
      headers: _publicContentHeaders(contentLocale: contentLocale),
    );
    if (res.statusCode != 200) {
      throw Exception(
        _tryMessage(res.body) ?? 'Failed to load news (${res.statusCode})',
      );
    }
    final json = jsonDecode(res.body) as Map<String, dynamic>;
    final list = json['news'];
    if (list is! List) return [];
    return list
        .map((e) => AppNewsItem.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  /// GET /api/app/info/about — данные «О нас» (фото, текст, блоки). Без авторизации.
  Future<AppAboutData> getAppAbout({Locale? contentLocale}) async {
    final uri = Uri.parse('$baseUrl/api/app/info/about');
    final res = await http.get(
      uri,
      headers: _publicContentHeaders(contentLocale: contentLocale),
    );
    if (res.statusCode != 200) {
      throw Exception(
        _tryMessage(res.body) ?? 'Failed to load about (${res.statusCode})',
      );
    }
    final json = jsonDecode(res.body) as Map<String, dynamic>;
    return AppAboutData.fromJson(json);
  }

  /// GET /api/app/info/faq-sections — разделы FAQ. Без авторизации.
  Future<List<FaqSectionItem>> getFaqSections({Locale? contentLocale}) async {
    final uri = Uri.parse('$baseUrl/api/app/info/faq-sections');
    final res = await http.get(
      uri,
      headers: _publicContentHeaders(contentLocale: contentLocale),
    );
    if (res.statusCode != 200) {
      throw Exception(
        _tryMessage(res.body) ??
            'Failed to load FAQ sections (${res.statusCode})',
      );
    }
    final json = jsonDecode(res.body) as Map<String, dynamic>;
    final list = json['sections'];
    if (list is! List) return [];
    return list
        .map((e) => FaqSectionItem.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  /// GET /api/app/info/faq-sections/{sectionId}/articles — статьи раздела FAQ. Без авторизации.
  Future<List<FaqArticleItem>> getFaqSectionArticles(
    int sectionId, {
    Locale? contentLocale,
  }) async {
    final uri = Uri.parse(
      '$baseUrl/api/app/info/faq-sections/$sectionId/articles',
    );
    final res = await http.get(
      uri,
      headers: _publicContentHeaders(contentLocale: contentLocale),
    );
    if (res.statusCode != 200) {
      throw Exception(
        _tryMessage(res.body) ??
            'Failed to load FAQ articles (${res.statusCode})',
      );
    }
    final json = jsonDecode(res.body) as Map<String, dynamic>;
    final list = json['articles'];
    if (list is! List) return [];
    return list
        .map((e) => FaqArticleItem.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  /// POST /api/app/version/check — разрешена ли версия приложения для запуска.
  /// POST /api/app/push-token — upsert FCM token for current user (requires Bearer).
  Future<void> registerPushToken({
    required String fcmToken,
    required String platform,
    String? deviceId,
    String? appVersion,
  }) async {
    final token = await getToken();
    if (token == null || token.isEmpty) {
      return;
    }
    final uri = Uri.parse('$baseUrl/api/app/push-token');
    final body = <String, dynamic>{
      'token': fcmToken,
      'platform': platform,
      if (deviceId != null && deviceId.isNotEmpty) 'device_id': deviceId,
      if (appVersion != null && appVersion.isNotEmpty)
        'app_version': appVersion,
    };
    try {
      final res = await http.post(
        uri,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode(body),
      );
      if (res.statusCode != 200) {
        developer.log(
          'registerPushToken HTTP ${res.statusCode}: ${res.body}',
          name: 'jfs.push',
        );
      }
    } catch (e, st) {
      developer.log(
        'registerPushToken error',
        name: 'jfs.push',
        error: e,
        stackTrace: st,
      );
    }
  }

  /// DELETE /api/app/push-token — deactivate token (call before logout while Bearer is valid).
  Future<void> deactivatePushToken({required String fcmToken}) async {
    final token = await getToken();
    if (token == null || token.isEmpty) {
      return;
    }
    final uri = Uri.parse('$baseUrl/api/app/push-token');
    try {
      final res = await http.delete(
        uri,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({'token': fcmToken}),
      );
      if (res.statusCode != 200 && kDebugMode) {
        // ignore: avoid_print
        print('deactivatePushToken failed ${res.statusCode} ${res.body}');
      }
    } catch (_) {}
  }

  Future<AppVersionCheckResult> checkAppVersion({
    required String platform,
    required String version,
  }) async {
    final uri = Uri.parse('$baseUrl/api/app/version/check');
    final res = await http.post(
      uri,
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
      body: jsonEncode({'platform': platform, 'version': version}),
    );

    if (res.statusCode != 200) {
      throw Exception(
        _tryMessage(res.body) ??
            'Failed to check app version (${res.statusCode})',
      );
    }

    final json = jsonDecode(res.body) as Map<String, dynamic>;
    final storeUrlRaw = json['store_url'];

    return AppVersionCheckResult(
      allowed: json['allowed'] == true,
      storeUrl: storeUrlRaw is String && storeUrlRaw.isNotEmpty
          ? storeUrlRaw
          : null,
    );
  }

  String? _tryMessage(String body) {
    try {
      final j = jsonDecode(body);
      if (j is Map) {
        final msg = j['message'];
        if (msg is String && msg.trim().isNotEmpty) {
          final errors = j['errors'];
          if (errors is Map) {
            for (final entry in errors.entries) {
              final v = entry.value;
              if (v is List && v.isNotEmpty) {
                final first = v.first;
                if (first is String && first.trim().isNotEmpty) {
                  return '$msg: $first';
                }
              } else if (v is String && v.trim().isNotEmpty) {
                return '$msg: $v';
              }
            }
          }
          return msg;
        }
      }
    } catch (_) {}
    return null;
  }

  /// JSON API `code` from error body (e.g. `service_disabled`).
  String? _tryApiCode(String body) {
    try {
      final j = jsonDecode(body);
      if (j is Map) {
        final c = j['code'];
        if (c is String && c.trim().isNotEmpty) {
          return c.trim();
        }
      }
    } catch (_) {}
    return null;
  }
}

/// 403 with `code: service_disabled` from ticket endpoints.
class ApiServiceDisabledException implements Exception {
  ApiServiceDisabledException(this.message);
  final String message;
}

/// Публичные настройки раздела Info в приложении (фото, соцсети, сайт).
class InfoSettings {
  InfoSettings({
    this.infoPhotoUrl,
    this.socialInstagram,
    this.socialFacebook,
    this.socialYoutube,
    this.socialTiktok,
    this.websiteUrl,
    this.contactFormUrl,
    this.faqPhotoUrl,
    this.faqArticlesPhotoUrl,
    this.brandCatalogPhotoUrl,
    this.brandCatalogPdfUrl,
  });
  final String? infoPhotoUrl;
  final String? socialInstagram;
  final String? socialFacebook;
  final String? socialYoutube;
  final String? socialTiktok;
  final String? websiteUrl;

  /// Ссылка на форму записи (админка: общие настройки приложения).
  final String? contactFormUrl;
  final String? faqPhotoUrl;
  final String? faqArticlesPhotoUrl;

  /// Каталог брендов на экране FAQ (общие настройки): картинка ячейки, PDF. Заголовок — l10n [AppLocalizations.faqBrandCatalogTitle].
  final String? brandCatalogPhotoUrl;
  final String? brandCatalogPdfUrl;

  static InfoSettings fromJson(Map<String, dynamic> json) {
    String? url(dynamic v) => v is String && v.isNotEmpty ? v : null;
    return InfoSettings(
      infoPhotoUrl: url(json['info_photo_url']),
      socialInstagram: url(json['social_instagram']),
      socialFacebook: url(json['social_facebook']),
      socialYoutube: url(json['social_youtube']),
      socialTiktok: url(json['social_tiktok']),
      websiteUrl: url(json['website_url']),
      contactFormUrl: url(json['contact_form_url']),
      faqPhotoUrl: url(json['faq_photo_url']),
      faqArticlesPhotoUrl: url(json['faq_articles_photo_url']),
      brandCatalogPhotoUrl: url(json['brand_catalog_photo_url']),
      brandCatalogPdfUrl: url(json['brand_catalog_pdf_url']),
    );
  }
}

/// Раздел FAQ из API.
class FaqSectionItem {
  FaqSectionItem({
    required this.id,
    required this.name,
    this.sortOrder = 0,
    this.photoUrl,
  });
  final int id;
  final String name;
  final int sortOrder;
  final String? photoUrl;

  static FaqSectionItem fromJson(Map<String, dynamic> json) {
    final u = json['photo_url'];
    return FaqSectionItem(
      id: json['id'] as int? ?? 0,
      name: json['name'] as String? ?? '',
      sortOrder: json['sort_order'] as int? ?? 0,
      photoUrl: u is String && u.isNotEmpty ? u : null,
    );
  }
}

/// Статья FAQ из API.
class FaqArticleItem {
  FaqArticleItem({
    required this.id,
    required this.title,
    this.body,
    this.sortOrder = 0,
    this.photoUrl,
  });
  final int id;
  final String title;
  final String? body;
  final int sortOrder;
  final String? photoUrl;

  static FaqArticleItem fromJson(Map<String, dynamic> json) {
    final u = json['photo_url'];
    return FaqArticleItem(
      id: json['id'] as int? ?? 0,
      title: json['title'] as String? ?? '',
      body: json['body'] as String?,
      sortOrder: json['sort_order'] as int? ?? 0,
      photoUrl: u is String && u.isNotEmpty ? u : null,
    );
  }
}

/// Элемент новости из API /api/app/info/news.
class AppNewsItem {
  AppNewsItem({
    required this.id,
    required this.title,
    this.body,
    this.photoUrl,
    this.publishedAt,
  });
  final int id;
  final String title;
  final String? body;
  final String? photoUrl;
  final DateTime? publishedAt;

  static AppNewsItem fromJson(Map<String, dynamic> json) {
    return AppNewsItem(
      id: json['id'] as int? ?? 0,
      title: (json['title'] as String? ?? ''),
      body: json['body'] as String?,
      photoUrl: json['photo_url'] as String?,
      publishedAt: json['published_at'] != null
          ? DateTime.tryParse(json['published_at'] as String)
          : null,
    );
  }
}

/// Данные «О нас» из API /api/app/info/about.
class AppAboutData {
  AppAboutData({this.photoUrl, this.mainText, this.blocks = const []});
  final String? photoUrl;
  final String? mainText;
  final List<AppAboutBlock> blocks;

  static AppAboutData fromJson(Map<String, dynamic> json) {
    final list = json['blocks'];
    final blocks = list is List
        ? list
              .map((e) => AppAboutBlock.fromJson(e as Map<String, dynamic>))
              .toList()
        : <AppAboutBlock>[];
    return AppAboutData(
      photoUrl: json['photo_url'] as String?,
      mainText: json['main_text'] as String?,
      blocks: blocks,
    );
  }
}

class AppAboutBlock {
  AppAboutBlock({required this.name, required this.text});
  final String name;
  final String text;

  static AppAboutBlock fromJson(Map<String, dynamic> json) {
    return AppAboutBlock(
      name: json['name'] as String? ?? '',
      text: json['text'] as String? ?? '',
    );
  }
}

class LoginResult {
  LoginResult({
    this.token,
    this.user,
    this.requiresPasswordSetup = false,
    this.setupEmail,
  });
  final String? token;
  final Map<String, dynamic>? user;
  final bool requiresPasswordSetup;
  final String? setupEmail;
}

class AppVersionCheckResult {
  AppVersionCheckResult({required this.allowed, this.storeUrl});

  final bool allowed;
  final String? storeUrl;
}

class WorkerStatus {
  WorkerStatus({
    required this.isWorker,
    required this.role,
    required this.staffRoles,
  });
  final bool isWorker;
  final String role;
  final List<StaffRole> staffRoles;

  factory WorkerStatus.fromJson(Map<String, dynamic> json) {
    final list = json['staff_roles'];
    return WorkerStatus(
      isWorker: json['is_worker'] as bool? ?? false,
      role: (json['role'] as String? ?? '').toString(),
      staffRoles: list is List
          ? list
                .map((e) => StaffRole.fromJson(e as Map<String, dynamic>))
                .toList()
          : [],
    );
  }
}

class StaffRole {
  StaffRole({
    required this.id,
    required this.code,
    required this.name,
    this.description = '',
    this.isActive = true,
    this.homeScreenType = '',
    this.stageIds = const [],
  });
  final int id;
  final String code;
  final String name;

  /// Текст из админки (роль персонала).
  final String description;

  /// Соответствует `is_active` роли в админке.
  final bool isActive;

  /// Код из API (`home_screen_type`): scan, supervisor, hostess, parking, extra_zone, backstage, rehearsal_admin, rehearsal_checkin, gift_issue, interview, lunches, superadmin.
  /// Пусто — до обновления бэкенда; клиент может определить экран по legacy-токенам code/name.
  final String homeScreenType;

  /// Пустой список = в админке не заданы этапы для роли → разрешены все этапы ивента.
  final List<int> stageIds;

  factory StaffRole.fromJson(Map<String, dynamic> json) {
    final rawIds = json['stage_ids'];
    final List<int> ids = [];
    if (rawIds is List) {
      for (final e in rawIds) {
        if (e is int) {
          if (e > 0) ids.add(e);
        } else {
          final v = int.tryParse(e.toString());
          if (v != null && v > 0) ids.add(v);
        }
      }
    }
    final homeRaw = json['home_screen_type'];
    final homeStr = homeRaw == null ? '' : homeRaw.toString().trim();
    final descRaw = json['description'];
    final descStr = descRaw == null ? '' : descRaw.toString().trim();
    return StaffRole(
      id: (json['id'] is int) ? json['id'] as int : 0,
      code: (json['code'] as String? ?? '').toString(),
      name: (json['name'] as String? ?? '').toString(),
      description: descStr,
      isActive: _jsonBool(json['is_active'], true),
      homeScreenType: homeStr,
      stageIds: ids,
    );
  }
}

// ---------------------------------------------------------------------------
// Client dashboard models
// ---------------------------------------------------------------------------

int? _jsonIntNullable(dynamic v) {
  if (v == null) {
    return null;
  }
  if (v is int) {
    return v;
  }
  if (v is num) {
    return v.toInt();
  }
  return int.tryParse(v.toString());
}

int _jsonInt(dynamic v, [int fallback = 0]) => _jsonIntNullable(v) ?? fallback;

double? _jsonDoubleNullable(dynamic v) {
  if (v == null) {
    return null;
  }
  if (v is double) {
    return v;
  }
  if (v is int) {
    return v.toDouble();
  }
  if (v is num) {
    return v.toDouble();
  }
  return double.tryParse(v.toString());
}

DateTime? _jsonDateTimeNullable(dynamic v) {
  if (v == null) {
    return null;
  }
  if (v is String && v.isNotEmpty) {
    return DateTime.tryParse(v);
  }
  return null;
}

bool _jsonBool(dynamic v, [bool fallback = true]) {
  if (v == null) {
    return fallback;
  }
  if (v is bool) {
    return v;
  }
  if (v is num) {
    return v != 0;
  }
  final s = v.toString().toLowerCase();
  if (s == 'true' || s == '1') {
    return true;
  }
  if (s == 'false' || s == '0') {
    return false;
  }
  return fallback;
}

class ClientDashboard {
  ClientDashboard({required this.children});
  final List<ChildWithAssignment> children;

  /// First child that has an active event assignment.
  ChildWithAssignment? get activeChild {
    for (final c in children) {
      if (c.activeAssignment != null) return c;
    }
    return null;
  }

  factory ClientDashboard.fromJson(Map<String, dynamic> json) {
    final list = json['children'];
    return ClientDashboard(
      children: list is List
          ? list
                .map(
                  (e) =>
                      ChildWithAssignment.fromJson(e as Map<String, dynamic>),
                )
                .toList()
          : [],
    );
  }
}

class ChildWithAssignment {
  ChildWithAssignment({
    required this.id,
    required this.firstName,
    this.gender,
    this.activeAssignment,
  });
  final int id;
  final String firstName;
  final String? gender;
  final ActiveAssignment? activeAssignment;

  factory ChildWithAssignment.fromJson(Map<String, dynamic> json) {
    final a = json['active_assignment'];
    return ChildWithAssignment(
      id: _jsonInt(json['id']),
      firstName: (json['first_name'] as String? ?? ''),
      gender: json['gender'] as String?,
      activeAssignment: a is Map<String, dynamic>
          ? ActiveAssignment.fromJson(a)
          : null,
    );
  }
}

class RehearsalSlotsPayload {
  RehearsalSlotsPayload({
    required this.slots,
    required this.rehearsalBookingChangesClosed,
  });

  final List<RehearsalSlotOption> slots;

  /// When true, clients who already have a slot cannot change it (first booking still allowed).
  final bool rehearsalBookingChangesClosed;
}

class RehearsalSlotOption {
  RehearsalSlotOption({
    required this.id,
    required this.slotDate,
    required this.slotTime,
    required this.place,
    this.mapUrl,
    required this.description,
    required this.capacity,
    required this.bookedCount,
    required this.freeSpots,
    this.minAge,
    this.maxAge,
    required this.familyLookOnly,
  });

  final int id;
  final String slotDate;
  final String slotTime;
  final String place;

  /// Optional HTTPS map link; absent on older API responses.
  final String? mapUrl;
  final String description;
  final int capacity;
  final int bookedCount;
  final int freeSpots;
  final int? minAge;
  final int? maxAge;
  final bool familyLookOnly;

  factory RehearsalSlotOption.fromJson(Map<String, dynamic> json) {
    final mapStr = json['map_url']?.toString().trim();
    return RehearsalSlotOption(
      id: _jsonInt(json['id']),
      slotDate: (json['slot_date'] as String? ?? '').toString(),
      slotTime: (json['slot_time'] as String? ?? '').toString(),
      place: (json['place'] as String? ?? '').toString(),
      mapUrl: (mapStr == null || mapStr.isEmpty) ? null : mapStr,
      description: (json['description'] as String? ?? '').toString(),
      capacity: _jsonInt(json['capacity']),
      bookedCount: _jsonInt(json['booked_count']),
      freeSpots: _jsonInt(json['free_spots']),
      minAge: _jsonIntNullable(json['min_age']),
      maxAge: _jsonIntNullable(json['max_age']),
      familyLookOnly: _jsonBool(json['family_look_only'], false),
    );
  }
}

class RehearsalBookingInfo {
  RehearsalBookingInfo({
    required this.slotId,
    required this.slotDate,
    required this.slotTime,
    required this.place,
    this.mapUrl,
    required this.description,
    this.bookedAt,
    this.startsAt,
    this.rehearsalCheckinCompleted = false,
    this.rehearsalCheckinAt,
  });

  final int slotId;
  final String slotDate;
  final String slotTime;
  final String place;

  /// Optional HTTPS map link; absent on older API responses.
  final String? mapUrl;
  final String description;
  final DateTime? bookedAt;

  /// Absolute instant for `starts_at` (ISO 8601, often with `Z`). Timeline UI prefers [slotDate]/[slotTime] to match admin.
  final DateTime? startsAt;

  /// Per-slot rehearsal check-in (YFS `rehearsal_checkin_completed` / `rehearsal_checkin_at`).
  final bool rehearsalCheckinCompleted;
  final DateTime? rehearsalCheckinAt;

  factory RehearsalBookingInfo.fromJson(Map<String, dynamic> json) {
    final mapStr = json['map_url']?.toString().trim();
    return RehearsalBookingInfo(
      slotId: _jsonInt(json['slot_id']),
      slotDate: (json['slot_date'] as String? ?? '').toString(),
      slotTime: (json['slot_time'] as String? ?? '').toString(),
      place: (json['place'] as String? ?? '').toString(),
      mapUrl: (mapStr == null || mapStr.isEmpty) ? null : mapStr,
      description: (json['description'] as String? ?? '').toString(),
      bookedAt: _jsonDateTimeNullable(json['booked_at']),
      startsAt: _jsonDateTimeNullable(json['starts_at']),
      rehearsalCheckinCompleted: _jsonBool(
        json['rehearsal_checkin_completed'],
        false,
      ),
      rehearsalCheckinAt: _jsonDateTimeNullable(json['rehearsal_checkin_at']),
    );
  }
}

class EventPackingInfo {
  EventPackingInfo({
    required this.eventId,
    required this.eventName,
    this.imageUrl,
    this.bodyHtml,
    this.updatedAt,
  });

  final int eventId;
  final String eventName;
  final String? imageUrl;
  final String? bodyHtml;
  final DateTime? updatedAt;

  bool get hasContent =>
      (imageUrl != null && imageUrl!.trim().isNotEmpty) ||
      (bodyHtml != null && bodyHtml!.trim().isNotEmpty);

  factory EventPackingInfo.fromJson(Map<String, dynamic> json) {
    return EventPackingInfo(
      eventId: _jsonInt(json['event_id']),
      eventName: (json['event_name'] as String? ?? '').trim(),
      imageUrl: json['image_url'] as String?,
      bodyHtml: json['body_html'] as String?,
      updatedAt: _jsonDateTimeNullable(json['updated_at']),
    );
  }
}

class EventDescriptionInfo {
  EventDescriptionInfo({
    required this.eventId,
    required this.eventName,
    this.imageUrl,
    this.description = '',
  });

  final int eventId;
  final String eventName;
  final String? imageUrl;
  final String description;

  bool get hasContent =>
      (imageUrl != null && imageUrl!.trim().isNotEmpty) ||
      description.trim().isNotEmpty;

  factory EventDescriptionInfo.fromJson(Map<String, dynamic> json) {
    return EventDescriptionInfo(
      eventId: _jsonInt(json['event_id']),
      eventName: (json['event_name'] as String? ?? '').trim(),
      imageUrl: json['image_url'] as String?,
      description: (json['description'] as String? ?? '').trim(),
    );
  }
}

class BrandRequirementInfo {
  BrandRequirementInfo({
    required this.brandId,
    required this.brandName,
    this.imageUrl,
    this.bodyHtml,
    this.description,
  });

  final int brandId;
  final String brandName;
  final String? imageUrl;
  final String? bodyHtml;

  /// Текстовое описание бренда (локализовано по Accept-Language).
  final String? description;

  bool get hasContent =>
      (imageUrl != null && imageUrl!.trim().isNotEmpty) ||
      (bodyHtml != null && bodyHtml!.trim().isNotEmpty) ||
      (description != null && description!.trim().isNotEmpty);

  factory BrandRequirementInfo.fromJson(Map<String, dynamic> json) {
    return BrandRequirementInfo(
      brandId: _jsonInt(json['brand_id']),
      brandName: (json['brand_name'] as String? ?? '').trim(),
      imageUrl: json['image_url'] as String?,
      bodyHtml: json['body_html'] as String?,
      description: json['description'] as String?,
    );
  }
}

class ClientChatRoomSummary {
  ClientChatRoomSummary({
    required this.id,
    required this.eventId,
    required this.brandId,
    required this.brandName,
    required this.title,
    required this.membersCount,
    this.lastMessagePreview,
    this.lastMessageAt,
  });

  final int id;
  final int eventId;
  final int brandId;
  final String brandName;
  final String title;
  final int membersCount;
  final String? lastMessagePreview;
  final DateTime? lastMessageAt;

  factory ClientChatRoomSummary.fromJson(Map<String, dynamic> json) {
    return ClientChatRoomSummary(
      id: _jsonInt(json['id']),
      eventId: _jsonInt(json['event_id']),
      brandId: _jsonInt(json['brand_id']),
      brandName: (json['brand_name'] as String? ?? '').trim(),
      title: (json['title'] as String? ?? '').trim(),
      membersCount: _jsonInt(json['members_count']),
      lastMessagePreview: json['last_message_preview'] as String?,
      lastMessageAt: _jsonDateTimeNullable(json['last_message_at']),
    );
  }
}

class ClientChatReplyRef {
  ClientChatReplyRef({
    required this.id,
    required this.senderName,
    required this.bodyPreview,
    required this.hasImage,
    this.imageUrl,
  });

  final int id;
  final String senderName;
  final String bodyPreview;
  final bool hasImage;
  final String? imageUrl;

  factory ClientChatReplyRef.fromJson(Map<String, dynamic>? json) {
    if (json == null) {
      throw ArgumentError('reply json required');
    }
    return ClientChatReplyRef(
      id: _jsonInt(json['id']),
      senderName: (json['sender_name'] as String? ?? '').trim(),
      bodyPreview: (json['body_preview'] as String? ?? '').trim(),
      hasImage: json['has_image'] == true,
      imageUrl: json['image_url'] as String?,
    );
  }

  static ClientChatReplyRef? tryParse(dynamic raw) {
    if (raw is! Map) {
      return null;
    }
    final m = Map<String, dynamic>.from(raw);
    if (m['id'] == null) {
      return null;
    }
    return ClientChatReplyRef.fromJson(m);
  }
}

class ClientChatMessage {
  ClientChatMessage({
    required this.id,
    required this.senderRole,
    required this.senderName,
    required this.body,
    this.imageUrl,
    required this.isMine,
    this.createdAt,
    this.replyTo,
  });

  final int id;
  final String senderRole;
  final String senderName;
  final String body;
  final String? imageUrl;
  final bool isMine;
  final DateTime? createdAt;
  final ClientChatReplyRef? replyTo;

  bool get hasImage => imageUrl != null && imageUrl!.trim().isNotEmpty;

  factory ClientChatMessage.fromJson(Map<String, dynamic> json) {
    return ClientChatMessage(
      id: _jsonInt(json['id']),
      senderRole: (json['sender_role'] as String? ?? '').trim(),
      senderName: (json['sender_name'] as String? ?? '').trim(),
      body: (json['body'] as String? ?? '').trim(),
      imageUrl: json['image_url'] as String?,
      isMine: json['is_mine'] == true,
      createdAt: _jsonDateTimeNullable(json['created_at']),
      replyTo: ClientChatReplyRef.tryParse(json['reply_to']),
    );
  }
}

class ClientChatRoomPayload {
  ClientChatRoomPayload({
    required this.roomId,
    required this.title,
    required this.brandName,
    required this.messages,
  });

  final int roomId;
  final String title;
  final String brandName;
  final List<ClientChatMessage> messages;

  factory ClientChatRoomPayload.fromJson(Map<String, dynamic> json) {
    final room = json['room'] as Map<String, dynamic>? ?? const {};
    final list = json['messages'];
    return ClientChatRoomPayload(
      roomId: _jsonInt(room['id']),
      title: (room['title'] as String? ?? '').trim(),
      brandName: (room['brand_name'] as String? ?? '').trim(),
      messages: list is List
          ? list
                .map(
                  (e) => ClientChatMessage.fromJson(e as Map<String, dynamic>),
                )
                .toList()
          : const [],
    );
  }
}

class AppNotificationListItem {
  AppNotificationListItem({
    required this.recipientId,
    required this.notificationId,
    required this.preview,
    required this.isNew,
    this.sentAt,
    required this.senderName,
    required this.type,
  });

  final int recipientId;
  final int notificationId;
  final String preview;
  final bool isNew;
  final DateTime? sentAt;
  final String senderName;
  final String type;

  factory AppNotificationListItem.fromJson(Map<String, dynamic> json) {
    return AppNotificationListItem(
      recipientId: _jsonInt(json['recipient_id']),
      notificationId: _jsonInt(json['notification_id']),
      preview: (json['preview'] as String? ?? '').trim(),
      isNew: json['is_new'] == true,
      sentAt: _jsonDateTimeNullable(json['sent_at']),
      senderName: (json['sender_name'] as String? ?? '').trim(),
      type: (json['type'] as String? ?? '').trim(),
    );
  }
}

class AppNotificationDetails {
  AppNotificationDetails({
    required this.recipientId,
    required this.notificationId,
    required this.body,
    required this.isNew,
    this.sentAt,
    required this.senderName,
    required this.type,
  });

  final int recipientId;
  final int notificationId;
  final String body;
  final bool isNew;
  final DateTime? sentAt;
  final String senderName;
  final String type;

  factory AppNotificationDetails.fromJson(Map<String, dynamic> json) {
    return AppNotificationDetails(
      recipientId: _jsonInt(json['recipient_id']),
      notificationId: _jsonInt(json['notification_id']),
      body: (json['body'] as String? ?? '').trim(),
      isNew: json['is_new'] == true,
      sentAt: _jsonDateTimeNullable(json['sent_at']),
      senderName: (json['sender_name'] as String? ?? '').trim(),
      type: (json['type'] as String? ?? '').trim(),
    );
  }
}

class ParkingTicketInfo {
  ParkingTicketInfo({
    required this.id,
    required this.label,
    required this.qrData,
    required this.carModel,
    required this.plateNumber,
    this.paidAt,
  });

  final int id;
  final String label;
  final String qrData;
  final String carModel;
  final String plateNumber;
  final DateTime? paidAt;

  factory ParkingTicketInfo.fromJson(Map<String, dynamic> json) {
    return ParkingTicketInfo(
      id: _jsonInt(json['id']),
      label: (json['label'] as String? ?? '').trim(),
      qrData: (json['qr_data'] as String? ?? '').trim(),
      carModel: (json['car_model'] as String? ?? '').trim(),
      plateNumber: (json['plate_number'] as String? ?? '').trim(),
      paidAt: _jsonDateTimeNullable(json['paid_at']),
    );
  }
}

class ParkingCheckoutResult {
  const ParkingCheckoutResult({
    required this.purchased,
    required this.checkoutUrl,
  });

  final bool purchased;
  final String? checkoutUrl;
}

class ParkingTicketsPayload {
  ParkingTicketsPayload({
    required this.eventId,
    required this.capacity,
    required this.soldCount,
    required this.serviceEnabled,
    required this.canBuy,
    required this.vipMode,
    required this.paymentRequired,
    this.freeParkingQuota,
    this.freeParkingUsed = 0,
    this.freeParkingRemaining,
    required this.entryMapUrl,
    required this.entryAppleMapUrl,
    required this.tickets,
  });

  final int eventId;
  final int capacity;
  final int soldCount;
  final bool serviceEnabled;
  final bool canBuy;
  final bool vipMode;
  final bool paymentRequired;

  /// Package complimentary parking cap for this user; null = unlimited.
  final int? freeParkingQuota;
  final int freeParkingUsed;

  /// Remaining complimentary tickets; null when unlimited.
  final int? freeParkingRemaining;
  final String? entryMapUrl;
  final String? entryAppleMapUrl;
  final List<ParkingTicketInfo> tickets;

  bool get hasActiveTickets => tickets.isNotEmpty;

  factory ParkingTicketsPayload.fromJson(Map<String, dynamic> json) {
    final rawTickets = json['tickets'];
    final tickets = rawTickets is List
        ? rawTickets
              .whereType<Map<String, dynamic>>()
              .map(ParkingTicketInfo.fromJson)
              .toList()
        : const <ParkingTicketInfo>[];

    return ParkingTicketsPayload(
      eventId: _jsonInt(json['event_id']),
      capacity: _jsonInt(json['capacity']),
      soldCount: _jsonInt(json['sold_count']),
      serviceEnabled: json['service_enabled'] != false,
      canBuy: json['can_buy'] == true,
      vipMode: json['vip_mode'] == true,
      paymentRequired: json['payment_required'] == true,
      freeParkingQuota: _jsonIntNullable(json['free_parking_quota']),
      freeParkingUsed: _jsonInt(json['free_parking_used']),
      freeParkingRemaining: _jsonIntNullable(json['free_parking_remaining']),
      entryMapUrl: (json['entry_map_url'] as String?)?.trim().isNotEmpty == true
          ? (json['entry_map_url'] as String).trim()
          : null,
      entryAppleMapUrl:
          (json['entry_apple_map_url'] as String?)?.trim().isNotEmpty == true
          ? (json['entry_apple_map_url'] as String).trim()
          : null,
      tickets: tickets,
    );
  }
}

class ExtraTicketInfo {
  ExtraTicketInfo({
    required this.id,
    required this.label,
    required this.qrData,
    this.paidAt,
  });

  final int id;
  final String label;
  final String qrData;
  final DateTime? paidAt;

  factory ExtraTicketInfo.fromJson(Map<String, dynamic> json) {
    return ExtraTicketInfo(
      id: _jsonInt(json['id']),
      label: (json['label'] as String? ?? '').trim(),
      qrData: (json['qr_data'] as String? ?? '').trim(),
      paidAt: _jsonDateTimeNullable(json['paid_at']),
    );
  }
}

class ExtraCheckoutResult {
  const ExtraCheckoutResult({
    required this.purchased,
    required this.checkoutUrl,
  });

  final bool purchased;
  final String? checkoutUrl;
}

class ExtraTicketsPayload {
  ExtraTicketsPayload({
    required this.eventId,
    required this.serviceEnabled,
    required this.canBuy,
    required this.freeMode,
    required this.paymentRequired,
    required this.tickets,
  });

  final int eventId;
  final bool serviceEnabled;
  final bool canBuy;
  final bool freeMode;
  final bool paymentRequired;
  final List<ExtraTicketInfo> tickets;

  bool get hasActiveTickets => tickets.isNotEmpty;

  factory ExtraTicketsPayload.fromJson(Map<String, dynamic> json) {
    final rawTickets = json['tickets'];
    final tickets = rawTickets is List
        ? rawTickets
              .whereType<Map<String, dynamic>>()
              .map(ExtraTicketInfo.fromJson)
              .toList()
        : const <ExtraTicketInfo>[];

    return ExtraTicketsPayload(
      eventId: _jsonInt(json['event_id']),
      serviceEnabled: json['service_enabled'] != false,
      canBuy: json['can_buy'] == true,
      freeMode: json['free_mode'] == true,
      paymentRequired: json['payment_required'] == true,
      tickets: tickets,
    );
  }
}

class BackstageTicketInfo {
  BackstageTicketInfo({
    required this.id,
    required this.label,
    required this.qrData,
    this.paidAt,
  });

  final int id;
  final String label;
  final String qrData;
  final DateTime? paidAt;

  factory BackstageTicketInfo.fromJson(Map<String, dynamic> json) {
    return BackstageTicketInfo(
      id: _jsonInt(json['id']),
      label: (json['label'] as String? ?? '').trim(),
      qrData: (json['qr_data'] as String? ?? '').trim(),
      paidAt: _jsonDateTimeNullable(json['paid_at']),
    );
  }
}

class BackstageCheckoutResult {
  const BackstageCheckoutResult({
    required this.purchased,
    required this.checkoutUrl,
  });

  final bool purchased;
  final String? checkoutUrl;
}

class BackstageTicketsPayload {
  BackstageTicketsPayload({
    required this.eventId,
    required this.serviceEnabled,
    required this.canBuy,
    required this.freeMode,
    required this.paymentRequired,
    required this.tickets,
  });

  final int eventId;
  final bool serviceEnabled;
  final bool canBuy;
  final bool freeMode;
  final bool paymentRequired;
  final List<BackstageTicketInfo> tickets;

  bool get hasActiveTickets => tickets.isNotEmpty;

  factory BackstageTicketsPayload.fromJson(Map<String, dynamic> json) {
    final rawTickets = json['tickets'];
    final tickets = rawTickets is List
        ? rawTickets
              .whereType<Map<String, dynamic>>()
              .map(BackstageTicketInfo.fromJson)
              .toList()
        : const <BackstageTicketInfo>[];

    return BackstageTicketsPayload(
      eventId: _jsonInt(json['event_id']),
      serviceEnabled: json['service_enabled'] != false,
      canBuy: json['can_buy'] == true,
      freeMode: json['free_mode'] == true,
      paymentRequired: json['payment_required'] == true,
      tickets: tickets,
    );
  }
}

class ActiveAssignment {
  ActiveAssignment({
    required this.id,
    this.brandId,
    this.secondBrandId,
    required this.event,
    required this.status,
    required this.totalMainStages,
    required this.totalPreparatoryStages,
    required this.completedStages,
    this.requiredTotalStages,
    this.requiredCompletedStages,
    this.familyLook = false,
    this.familyLookBrandId,
    this.parentParticipantsCount,
    this.parentProgress,
    this.parentTimelines = const [],
    required this.mainStages,
    required this.preparatoryStages,
    this.eventMeals = const [],
    this.selectedEventMealId,
    this.mealOrdersAccepting = true,
    this.eventMealPaidAt,
    this.checkinCode,
    this.mealFulfillmentStatus,
    this.rehearsalBookings = const [],
    this.maxMainRehearsals = 1,
    this.extraMainRehearsals = 0,
    this.effectiveMaxMainRehearsals = 1,
  });
  final int id;
  final int? brandId;
  final int? secondBrandId;
  final EventSummary event;
  final String status;
  final int totalMainStages;
  final int totalPreparatoryStages;
  final int completedStages;
  final int? requiredTotalStages;
  final int? requiredCompletedStages;
  final bool familyLook;
  final int? familyLookBrandId;
  final int? parentParticipantsCount;
  final ParentProgressInfo? parentProgress;
  final List<ParentTimelineInfo> parentTimelines;
  final List<MainStageInfo> mainStages;
  final List<PreparatoryStageInfo> preparatoryStages;
  final List<EventMealOption> eventMeals;
  final int? selectedEventMealId;

  /// When false, the client cannot change the selected lunch in the app.
  final bool mealOrdersAccepting;

  /// Set when Stripe meal checkout completed (webhook).
  final DateTime? eventMealPaidAt;

  /// QR code used to check in and start event flow.
  final String? checkinCode;

  /// Server: `none` | `awaiting_payment` | `fulfilled` (see ChildEventAssignment::getMealFulfillmentStatus).
  final String? mealFulfillmentStatus;

  final List<RehearsalBookingInfo> rehearsalBookings;
  final int maxMainRehearsals;
  final int extraMainRehearsals;
  final int effectiveMaxMainRehearsals;

  RehearsalBookingInfo? get rehearsalBooking =>
      rehearsalBookings.isNotEmpty ? rehearsalBookings.first : null;

  /// Не опираться только на [eventMealPaidAt]: после удаления блюда FK обнуляет
  /// `event_meal_id`, а метка оплаты в БД могла остаться — тогда без выбранного блюда
  /// нельзя считать заказ оплаченным.
  bool get mealPaid => eventMealPaidAt != null && selectedEventMealId != null;

  bool get isMealOrderLocked {
    switch (mealFulfillmentStatus) {
      case 'awaiting_payment':
      case 'fulfilled':
        return true;
      case 'none':
        return false;
      default:
        // Старые клиенты без meal_fulfillment_status: прежняя эвристика.
        return _legacyMealOrderLocked;
    }
  }

  bool get _legacyMealOrderLocked {
    if (selectedEventMealId == null) {
      return false;
    }
    if (mealPaid) {
      return true;
    }
    EventMealOption? selected;
    for (final m in eventMeals) {
      if (m.id == selectedEventMealId) {
        selected = m;
        break;
      }
    }
    final p = selected?.price;
    return p != null && p > 0;
  }

  factory ActiveAssignment.fromJson(Map<String, dynamic> json) {
    final ev = json['event'] as Map<String, dynamic>? ?? {};
    final main = json['main_stages'];
    final prep = json['preparatory_stages'];
    final parentProgressJson = json['parent_progress'];
    final parentTimelinesJson = json['parent_timelines'];
    final meals = json['event_meals'];
    final mealsList = meals is List
        ? meals
              .map((e) => EventMealOption.fromJson(e as Map<String, dynamic>))
              .toList()
        : <EventMealOption>[];
    final rawSelectedMealId = _jsonIntNullable(json['selected_event_meal_id']);
    final selectedMealId =
        rawSelectedMealId != null &&
            mealsList.any((m) => m.id == rawSelectedMealId)
        ? rawSelectedMealId
        : null;
    final rb = json['rehearsal_booking'];
    final rbs = json['rehearsal_bookings'];
    return ActiveAssignment(
      id: _jsonInt(json['id']),
      brandId: _jsonIntNullable(json['brand_id']),
      secondBrandId: _jsonIntNullable(json['second_brand_id']),
      event: EventSummary.fromJson(ev),
      status: (json['status'] as String? ?? ''),
      totalMainStages: _jsonInt(json['total_main_stages']),
      totalPreparatoryStages: _jsonInt(json['total_preparatory_stages']),
      completedStages: _jsonInt(json['completed_stages']),
      requiredTotalStages: _jsonIntNullable(json['required_total_stages']),
      requiredCompletedStages: _jsonIntNullable(
        json['required_completed_stages'],
      ),
      familyLook: json['family_look'] == true,
      familyLookBrandId: _jsonIntNullable(json['family_look_brand_id']),
      parentParticipantsCount: _jsonIntNullable(
        json['parent_participants_count'],
      ),
      parentProgress: parentProgressJson is Map<String, dynamic>
          ? ParentProgressInfo.fromJson(parentProgressJson)
          : null,
      parentTimelines: parentTimelinesJson is List
          ? parentTimelinesJson
                .whereType<Map<String, dynamic>>()
                .map(ParentTimelineInfo.fromJson)
                .toList()
          : const [],
      mainStages: main is List
          ? main
                .map((e) => MainStageInfo.fromJson(e as Map<String, dynamic>))
                .toList()
          : [],
      preparatoryStages: prep is List
          ? prep
                .map(
                  (e) =>
                      PreparatoryStageInfo.fromJson(e as Map<String, dynamic>),
                )
                .toList()
          : [],
      eventMeals: mealsList,
      selectedEventMealId: selectedMealId,
      mealOrdersAccepting: _jsonBool(json['meal_orders_accepting'], true),
      eventMealPaidAt: _jsonDateTimeNullable(json['event_meal_paid_at']),
      checkinCode: (json['checkin_code'] as String?)?.trim(),
      mealFulfillmentStatus: json['meal_fulfillment_status'] as String?,
      rehearsalBookings: rbs is List
          ? rbs
                .whereType<Map<String, dynamic>>()
                .map(RehearsalBookingInfo.fromJson)
                .toList()
          : (rb is Map<String, dynamic>
                ? [RehearsalBookingInfo.fromJson(rb)]
                : const []),
      maxMainRehearsals: _jsonInt(json['max_main_rehearsals'], 1),
      extraMainRehearsals: _jsonInt(json['extra_main_rehearsals'], 0),
      effectiveMaxMainRehearsals: _jsonInt(
        json['effective_max_main_rehearsals'],
        _jsonInt(json['max_main_rehearsals'], 1),
      ),
    );
  }
}

class ParentTimelineInfo {
  ParentTimelineInfo({
    required this.participantSlot,
    required this.totalStages,
    required this.completedStages,
    required this.mainStages,
  });

  final int participantSlot;
  final int totalStages;
  final int completedStages;
  final List<MainStageInfo> mainStages;

  factory ParentTimelineInfo.fromJson(Map<String, dynamic> json) {
    final main = json['main_stages'];
    return ParentTimelineInfo(
      participantSlot: _jsonInt(json['participant_slot'], 1),
      totalStages: _jsonInt(json['total_stages']),
      completedStages: _jsonInt(json['completed_stages']),
      mainStages: main is List
          ? main
                .whereType<Map<String, dynamic>>()
                .map(MainStageInfo.fromJson)
                .toList()
          : const [],
    );
  }
}

class MealPaymentStatusPayload {
  MealPaymentStatusPayload({
    required this.mealFulfillmentStatus,
    this.pendingCheckout = false,
    required this.canContinuePayment,
    required this.canCancelPayment,
    required this.canStartNewCheckout,
    this.paymentCheckoutUrl,
  });

  /// Обед: `meal_fulfillment_status` с API. Билеты: обычно `none`, см. [pendingCheckout].
  final String mealFulfillmentStatus;

  /// Парковка / extra / backstage: `pending_checkout` с API.
  final bool pendingCheckout;
  final bool canContinuePayment;
  final bool canCancelPayment;
  final bool canStartNewCheckout;
  final String? paymentCheckoutUrl;

  factory MealPaymentStatusPayload.fromJson(Map<String, dynamic> json) {
    final pay = json['payment'];
    String? url;
    if (pay is Map<String, dynamic>) {
      final u = pay['checkout_url'];
      if (u is String && u.trim().isNotEmpty) {
        url = u.trim();
      }
    }
    return MealPaymentStatusPayload(
      mealFulfillmentStatus:
          (json['meal_fulfillment_status'] as String?)?.trim() ?? 'none',
      pendingCheckout: json['pending_checkout'] == true,
      canContinuePayment: json['can_continue_payment'] == true,
      canCancelPayment: json['can_cancel_payment'] == true,
      canStartNewCheckout: json['can_start_new_checkout'] == true,
      paymentCheckoutUrl: url,
    );
  }
}

class EventMealOption {
  EventMealOption({
    required this.id,
    this.nameEn,
    this.nameRu,
    this.nameUk,
    this.nameEs,
    this.price,
    this.imageUrl,
  });

  final int id;
  final String? nameEn;
  final String? nameRu;
  final String? nameUk;
  final String? nameEs;
  final double? price;

  /// Full URL when the API includes `image_url` (newer backends).
  final String? imageUrl;

  factory EventMealOption.fromJson(Map<String, dynamic> json) {
    final rawImg = json['image_url']?.toString().trim();
    return EventMealOption(
      id: _jsonInt(json['id']),
      nameEn: json['name_en'] as String?,
      nameRu: json['name_ru'] as String?,
      nameUk: json['name_uk'] as String?,
      nameEs: json['name_es'] as String?,
      price: _jsonDoubleNullable(json['price']),
      imageUrl: (rawImg == null || rawImg.isEmpty) ? null : rawImg,
    );
  }

  /// [languageCode] — например из Localizations.localeOf (en, ru, uk, es).
  String labelForLanguageCode(String languageCode) {
    String? pick(String code) {
      switch (code) {
        case 'ru':
          return nameRu;
        case 'uk':
          return nameUk;
        case 'es':
          return nameEs;
        default:
          return nameEn;
      }
    }

    final primary = pick(languageCode);
    if (primary != null && primary.trim().isNotEmpty) {
      return primary.trim();
    }
    for (final s in [nameEn, nameRu, nameUk, nameEs]) {
      if (s != null && s.trim().isNotEmpty) {
        return s.trim();
      }
    }
    return '#$id';
  }
}

class MainStageInfo {
  MainStageInfo({required this.id, required this.name, this.description});

  final int id;
  final String name;

  /// Локализованное описание этапа (из API), для деталей в таймлайне.
  final String? description;

  factory MainStageInfo.fromJson(Map<String, dynamic> json) {
    final rawDesc = json['description'];
    return MainStageInfo(
      id: _jsonInt(json['id']),
      name: (json['name'] as String? ?? '').toString(),
      description: rawDesc is String && rawDesc.trim().isNotEmpty
          ? rawDesc.trim()
          : null,
    );
  }
}

class EventSummary {
  EventSummary({
    required this.id,
    required this.name,
    required this.city,
    this.startsAt,
    this.endsAt,
    this.imageUrl,
    this.clientParkingServiceEnabled = true,
    this.clientExtraTicketsServiceEnabled = true,
    this.clientBackstageTicketsServiceEnabled = true,
    this.userHasParkingTicket,
    this.userHasExtraTicket,
    this.userHasBackstageTicket,
  });
  final int id;
  final String name;
  final String city;
  final DateTime? startsAt;
  final DateTime? endsAt;
  final String? imageUrl;

  /// When false, new valet parking purchases are blocked (server + UI).
  final bool clientParkingServiceEnabled;

  final bool clientExtraTicketsServiceEnabled;

  final bool clientBackstageTicketsServiceEnabled;

  /// From dashboard when known; null on older API clients.
  final bool? userHasParkingTicket;
  final bool? userHasExtraTicket;
  final bool? userHasBackstageTicket;

  factory EventSummary.fromJson(Map<String, dynamic> json) {
    bool? readBoolKey(String k) {
      final v = json[k];
      return v is bool ? v : null;
    }

    return EventSummary(
      id: json['id'] as int? ?? 0,
      name: (json['name'] as String? ?? ''),
      city: (json['city'] as String? ?? ''),
      startsAt: json['starts_at'] != null
          ? DateTime.tryParse(json['starts_at'] as String)
          : null,
      endsAt: json['ends_at'] != null
          ? DateTime.tryParse(json['ends_at'] as String)
          : null,
      imageUrl: json['image_url'] as String?,
      clientParkingServiceEnabled:
          json['client_parking_service_enabled'] != false,
      clientExtraTicketsServiceEnabled:
          json['client_extra_tickets_service_enabled'] != false,
      clientBackstageTicketsServiceEnabled:
          json['client_backstage_tickets_service_enabled'] != false,
      userHasParkingTicket: readBoolKey('user_has_parking_ticket'),
      userHasExtraTicket: readBoolKey('user_has_extra_ticket'),
      userHasBackstageTicket: readBoolKey('user_has_backstage_ticket'),
    );
  }
}

/// Событие из API upcoming-events (будущее, ребёнок ещё не записан).
/// Событие из /api/app/client/ticket-events (для выбора в «Мои билеты»).
class ClientTicketEventRef {
  ClientTicketEventRef({
    required this.id,
    required this.name,
    this.startsAt,
    this.ticketStoreUrl,
    this.clientParkingServiceEnabled = true,
    this.clientExtraTicketsServiceEnabled = true,
    this.clientBackstageTicketsServiceEnabled = true,
    this.userHasParkingTicket,
    this.userHasExtraTicket,
    this.userHasBackstageTicket,
  });

  final int id;
  final String name;
  final DateTime? startsAt;

  /// Ссылка на магазин билетов для этого ивента (из админки).
  final String? ticketStoreUrl;

  final bool clientParkingServiceEnabled;
  final bool clientExtraTicketsServiceEnabled;
  final bool clientBackstageTicketsServiceEnabled;
  final bool? userHasParkingTicket;
  final bool? userHasExtraTicket;
  final bool? userHasBackstageTicket;

  factory ClientTicketEventRef.fromJson(Map<String, dynamic> json) {
    final rawUrl = json['ticket_store_url'];
    bool? readBoolKey(String k) {
      final v = json[k];
      return v is bool ? v : null;
    }

    return ClientTicketEventRef(
      id: json['id'] as int? ?? 0,
      name: (json['name'] as String? ?? ''),
      startsAt: json['starts_at'] != null
          ? DateTime.tryParse(json['starts_at'].toString())
          : null,
      ticketStoreUrl: rawUrl is String && rawUrl.trim().isNotEmpty
          ? rawUrl.trim()
          : null,
      clientParkingServiceEnabled:
          json['client_parking_service_enabled'] != false,
      clientExtraTicketsServiceEnabled:
          json['client_extra_tickets_service_enabled'] != false,
      clientBackstageTicketsServiceEnabled:
          json['client_backstage_tickets_service_enabled'] != false,
      userHasParkingTicket: readBoolKey('user_has_parking_ticket'),
      userHasExtraTicket: readBoolKey('user_has_extra_ticket'),
      userHasBackstageTicket: readBoolKey('user_has_backstage_ticket'),
    );
  }
}

/// Билет из /api/app/client/events/{id}/tickets.
class ClientTicketItem {
  ClientTicketItem({
    required this.id,
    required this.ticketType,
    this.pdfUrl,
    required this.pdfAvailable,
    this.eventName,
    this.eventStartsAt,
    required this.parentName,
  });

  final int id;
  final String ticketType;
  final String? pdfUrl;
  final bool pdfAvailable;
  final String? eventName;
  final DateTime? eventStartsAt;
  final String parentName;

  factory ClientTicketItem.fromJson(
    Map<String, dynamic> json,
    String apiBaseUrl,
  ) {
    final raw = json['pdf_url'];
    String? pdfUrl;
    if (raw is String && raw.isNotEmpty) {
      if (raw.startsWith('http://') || raw.startsWith('https://')) {
        pdfUrl = raw;
      } else {
        final base = apiBaseUrl.endsWith('/')
            ? apiBaseUrl.substring(0, apiBaseUrl.length - 1)
            : apiBaseUrl;
        final path = raw.startsWith('/') ? raw : '/$raw';
        pdfUrl = Uri.parse(base).resolveUri(Uri.parse(path)).toString();
      }
    }
    return ClientTicketItem(
      id: json['id'] as int? ?? 0,
      ticketType: (json['ticket_type'] as String? ?? ''),
      pdfUrl: pdfUrl,
      pdfAvailable: json['pdf_available'] == true,
      eventName: json['event_name'] as String?,
      eventStartsAt: json['event_starts_at'] != null
          ? DateTime.tryParse(json['event_starts_at'].toString())
          : null,
      parentName: (json['parent_name'] as String? ?? ''),
    );
  }
}

class UpcomingEvent {
  UpcomingEvent({
    required this.id,
    required this.name,
    required this.city,
    this.location,
    this.startsAt,
    this.endsAt,
    this.imageUrl,
  });
  final int id;
  final String name;
  final String city;
  final String? location;
  final DateTime? startsAt;
  final DateTime? endsAt;

  /// URL фото ивента (из настроек ивента), может быть относительным.
  final String? imageUrl;

  factory UpcomingEvent.fromJson(Map<String, dynamic> json) {
    return UpcomingEvent(
      id: json['id'] as int? ?? 0,
      name: (json['name'] as String? ?? ''),
      city: (json['city'] as String? ?? ''),
      location: json['location'] as String?,
      startsAt: json['starts_at'] != null
          ? DateTime.tryParse(json['starts_at'] as String)
          : null,
      endsAt: json['ends_at'] != null
          ? DateTime.tryParse(json['ends_at'] as String)
          : null,
      imageUrl: json['image_url'] as String?,
    );
  }
}

/// Детали события для сотрудника (API worker/events/{id}).
class StaffEventDetail {
  StaffEventDetail({
    required this.id,
    required this.name,
    this.city,
    this.location,
    this.startsAt,
    this.endsAt,
    this.imageUrl,
    this.stages = const [],
  });
  final int id;
  final String name;
  final String? city;
  final String? location;
  final DateTime? startsAt;
  final DateTime? endsAt;
  final String? imageUrl;
  final List<StaffEventStage> stages;

  factory StaffEventDetail.fromJson(Map<String, dynamic> json) {
    final list = json['stages'];
    return StaffEventDetail(
      id: json['id'] as int? ?? 0,
      name: (json['name'] as String? ?? ''),
      city: json['city'] as String?,
      location: json['location'] as String?,
      startsAt: json['starts_at'] != null
          ? DateTime.tryParse(json['starts_at'] as String)
          : null,
      endsAt: json['ends_at'] != null
          ? DateTime.tryParse(json['ends_at'] as String)
          : null,
      imageUrl: json['image_url'] as String?,
      stages: list is List
          ? list
                .map((e) => StaffEventStage.fromJson(e as Map<String, dynamic>))
                .toList()
          : [],
    );
  }
}

class WorkerEventStage {
  WorkerEventStage({required this.id, required this.name, required this.type});
  final int id;
  final String name;
  final String type;

  factory WorkerEventStage.fromJson(Map<String, dynamic> json) {
    return WorkerEventStage(
      id: json['id'] as int? ?? 0,
      name: (json['name'] as String? ?? '').toString(),
      type: (json['type'] as String? ?? 'main').toString(),
    );
  }
}

class StaffEventStage {
  StaffEventStage({this.scheduledAt, this.title, this.address});
  final DateTime? scheduledAt;
  final String? title;
  final String? address;

  factory StaffEventStage.fromJson(Map<String, dynamic> json) {
    return StaffEventStage(
      scheduledAt: json['scheduled_at'] != null
          ? DateTime.tryParse(json['scheduled_at'] as String)
          : null,
      title: json['title'] as String?,
      address: json['address'] as String?,
    );
  }
}

/// Ребёнок из реестра супервайзера (назначен бренду, которым руководит супервайзер).
class SupervisorChildItem {
  SupervisorChildItem({
    required this.assignmentId,
    required this.childId,
    required this.firstName,
    this.photoUrl,
    required this.status,
  });
  final int assignmentId;
  final int childId;
  final String firstName;
  final String? photoUrl;

  /// given | not_given
  final String status;

  factory SupervisorChildItem.fromJson(Map<String, dynamic> json) {
    return SupervisorChildItem(
      assignmentId: json['assignment_id'] as int? ?? 0,
      childId: json['child_id'] as int? ?? 0,
      firstName: (json['first_name'] as String? ?? '').toString(),
      photoUrl: json['photo_url'] as String?,
      status: (json['status'] as String? ?? 'not_given').toString(),
    );
  }
}

class SupervisorStageItem {
  SupervisorStageItem({required this.id, required this.name});
  final int id;
  final String name;

  factory SupervisorStageItem.fromJson(Map<String, dynamic> json) {
    return SupervisorStageItem(
      id: json['id'] as int? ?? 0,
      name: (json['name'] as String? ?? '').toString(),
    );
  }
}

class SupervisorChildrenResponse {
  SupervisorChildrenResponse({
    required this.stages,
    required this.children,
    this.currentStageId,
  });
  final List<SupervisorStageItem> stages;
  final List<SupervisorChildItem> children;
  final int? currentStageId;

  factory SupervisorChildrenResponse.fromJson(Map<String, dynamic> json) {
    final stageList = json['stages'];
    final childList = json['children'];
    return SupervisorChildrenResponse(
      stages: stageList is List
          ? stageList
                .map(
                  (e) =>
                      SupervisorStageItem.fromJson(e as Map<String, dynamic>),
                )
                .toList()
          : const [],
      children: childList is List
          ? childList
                .map(
                  (e) =>
                      SupervisorChildItem.fromJson(e as Map<String, dynamic>),
                )
                .toList()
          : const [],
      currentStageId: json['current_stage_id'] as int?,
    );
  }
}

class RehearsalAdminSlotItem {
  RehearsalAdminSlotItem({
    required this.id,
    this.slotDate,
    required this.slotTime,
    required this.place,
    required this.description,
    required this.capacity,
    required this.bookedCount,
  });

  final int id;
  final DateTime? slotDate;
  final String slotTime;
  final String place;
  final String description;
  final int capacity;
  final int bookedCount;

  factory RehearsalAdminSlotItem.fromJson(Map<String, dynamic> json) {
    return RehearsalAdminSlotItem(
      id: _jsonInt(json['id']),
      slotDate: _jsonDateTimeNullable(json['slot_date']),
      slotTime: (json['slot_time'] as String? ?? '').toString(),
      place: (json['place'] as String? ?? '').toString(),
      description: (json['description'] as String? ?? '').toString(),
      capacity: _jsonInt(json['capacity']),
      bookedCount: _jsonInt(json['booked_count']),
    );
  }
}

class RehearsalAdminChildItem {
  RehearsalAdminChildItem({
    required this.assignmentId,
    required this.childId,
    required this.firstName,
    this.photoUrl,
    required this.checkedIn,
  });

  final int assignmentId;
  final int childId;
  final String firstName;
  final String? photoUrl;
  final bool checkedIn;

  factory RehearsalAdminChildItem.fromJson(Map<String, dynamic> json) {
    return RehearsalAdminChildItem(
      assignmentId: _jsonInt(json['assignment_id']),
      childId: _jsonInt(json['child_id']),
      firstName: (json['first_name'] as String? ?? '').toString(),
      photoUrl: json['photo_url'] as String?,
      checkedIn: _jsonBool(json['checked_in'], false),
    );
  }
}

class RehearsalAdminRosterResponse {
  RehearsalAdminRosterResponse({
    required this.eventId,
    required this.slots,
    required this.children,
    this.currentSlotId,
  });

  final int eventId;
  final List<RehearsalAdminSlotItem> slots;
  final List<RehearsalAdminChildItem> children;
  final int? currentSlotId;

  factory RehearsalAdminRosterResponse.fromJson(Map<String, dynamic> json) {
    final slotList = json['slots'];
    final childList = json['children'];
    return RehearsalAdminRosterResponse(
      eventId: _jsonInt(json['event_id']),
      slots: slotList is List
          ? slotList
                .map(
                  (e) => RehearsalAdminSlotItem.fromJson(
                    e as Map<String, dynamic>,
                  ),
                )
                .toList()
          : const [],
      children: childList is List
          ? childList
                .map(
                  (e) => RehearsalAdminChildItem.fromJson(
                    e as Map<String, dynamic>,
                  ),
                )
                .toList()
          : const [],
      currentSlotId: _jsonIntNullable(json['current_slot_id']),
    );
  }
}

class GiftControlChildItem {
  GiftControlChildItem({
    required this.assignmentId,
    required this.childId,
    required this.firstName,
    this.photoUrl,
    required this.isPassed,
  });

  final int assignmentId;
  final int childId;
  final String firstName;
  final String? photoUrl;
  final bool isPassed;

  factory GiftControlChildItem.fromJson(Map<String, dynamic> json) {
    return GiftControlChildItem(
      assignmentId: _jsonInt(json['assignment_id']),
      childId: _jsonInt(json['child_id']),
      firstName: (json['first_name'] as String? ?? '').toString(),
      photoUrl: json['photo_url'] as String?,
      isPassed: json['is_passed'] == true,
    );
  }
}

class GiftControlReportResponse {
  GiftControlReportResponse({
    required this.eventId,
    required this.stages,
    required this.children,
    required this.statusFilter,
    this.currentStageId,
  });

  final int eventId;
  final List<WorkerEventStage> stages;
  final List<GiftControlChildItem> children;
  final String statusFilter;
  final int? currentStageId;

  factory GiftControlReportResponse.fromJson(Map<String, dynamic> json) {
    final stageList = json['stages'];
    final childList = json['children'];
    return GiftControlReportResponse(
      eventId: _jsonInt(json['event_id']),
      stages: stageList is List
          ? stageList
                .map(
                  (e) => WorkerEventStage.fromJson(e as Map<String, dynamic>),
                )
                .toList()
          : const [],
      children: childList is List
          ? childList
                .map(
                  (e) =>
                      GiftControlChildItem.fromJson(e as Map<String, dynamic>),
                )
                .toList()
          : const [],
      statusFilter: (json['status_filter'] as String? ?? 'all').toString(),
      currentStageId: _jsonIntNullable(json['current_stage_id']),
    );
  }
}

/// Main-flow stage for Scan for Info / supervisor child detail (`status`: done | in_progress | pending).
class StaffMainProgressStage {
  StaffMainProgressStage({
    required this.stageId,
    required this.name,
    required this.status,
    required this.subtitle,
  });

  final int stageId;
  final String name;
  final String status;
  final String subtitle;

  factory StaffMainProgressStage.fromJson(Map<String, dynamic> json) {
    return StaffMainProgressStage(
      stageId: _jsonInt(json['stage_id']),
      name: (json['name'] as String? ?? '').toString(),
      status: (json['status'] as String? ?? 'pending').toString(),
      subtitle: (json['subtitle'] as String? ?? '').toString(),
    );
  }
}

/// Одна вкладка таймлайна (как в Filament Event Flow): prep / бренд / мама / тато.
class StaffProgressTabData {
  StaffProgressTabData({
    required this.key,
    required this.title,
    required this.mainProgressStages,
    required this.progressPercent,
    this.currentStageName,
    required this.completedStages,
    required this.totalStages,
  });

  final String key;
  final String title;
  final List<StaffMainProgressStage> mainProgressStages;
  final int progressPercent;
  final String? currentStageName;
  final int completedStages;
  final int totalStages;

  factory StaffProgressTabData.fromJson(Map<String, dynamic> json) {
    final mps = json['main_progress_stages'];
    return StaffProgressTabData(
      key: (json['key'] as String? ?? '').toString(),
      title: (json['title'] as String? ?? '').toString(),
      mainProgressStages: mps is List
          ? mps
                .map(
                  (e) => StaffMainProgressStage.fromJson(
                    e as Map<String, dynamic>,
                  ),
                )
                .toList()
          : const [],
      progressPercent: json['progress_percent'] as int? ?? 0,
      currentStageName: json['current_stage_name'] as String?,
      completedStages: json['completed_stages'] as int? ?? 0,
      totalStages: json['total_stages'] as int? ?? 0,
    );
  }
}

class SupervisorChildDetail {
  SupervisorChildDetail({
    required this.assignmentId,
    required this.childId,
    required this.firstName,
    this.gender,
    this.publicCode,
    this.photoUrl,
    this.birthdate,
    this.age,
    this.notes,
    this.heightValue,
    this.heightUnit,
    this.parentName,
    this.parentRole,
    this.parentPhone,
    this.parentEmail,
    this.brandName,
    this.supervisorName,
    this.supervisorPhone,
    this.supervisorPhotoUrl,
    required this.progressPercent,
    this.currentStageName,
    required this.completedStages,
    required this.totalStages,
    this.mainProgressStages = const [],
    this.progressTabs = const [],
  });

  final int assignmentId;
  final int childId;
  final String firstName;
  final String? gender;
  final String? publicCode;
  final String? photoUrl;
  final DateTime? birthdate;
  final int? age;
  final String? notes;
  final double? heightValue;
  final String? heightUnit;
  final String? parentName;
  final String? parentRole;
  final String? parentPhone;
  final String? parentEmail;
  final String? brandName;
  final String? supervisorName;
  final String? supervisorPhone;
  final String? supervisorPhotoUrl;
  final int progressPercent;
  final String? currentStageName;
  final int completedStages;
  final int totalStages;
  final List<StaffMainProgressStage> mainProgressStages;
  final List<StaffProgressTabData> progressTabs;

  String get fullName => firstName;

  factory SupervisorChildDetail.fromJson(Map<String, dynamic> json) {
    final mps = json['main_progress_stages'];
    return SupervisorChildDetail(
      assignmentId: json['assignment_id'] as int? ?? 0,
      childId: json['child_id'] as int? ?? 0,
      firstName: (json['first_name'] as String? ?? '').toString(),
      gender: json['gender'] as String?,
      publicCode: json['public_code'] as String?,
      photoUrl: json['photo_url'] as String?,
      birthdate: json['birthdate'] != null
          ? DateTime.tryParse(json['birthdate'] as String)
          : null,
      age: json['age'] as int?,
      notes: json['notes'] as String?,
      heightValue: _toDouble(json['height_value']),
      heightUnit: json['height_unit'] as String?,
      parentName: json['parent_name'] as String?,
      parentRole: json['parent_role'] as String?,
      parentPhone: json['parent_phone'] as String?,
      parentEmail: json['parent_email'] as String?,
      brandName: json['brand_name'] as String?,
      supervisorName: json['supervisor_name'] as String?,
      supervisorPhone: json['supervisor_phone'] as String?,
      supervisorPhotoUrl: json['supervisor_photo_url'] as String?,
      progressPercent: json['progress_percent'] as int? ?? 0,
      currentStageName: json['current_stage_name'] as String?,
      completedStages: json['completed_stages'] as int? ?? 0,
      totalStages: json['total_stages'] as int? ?? 0,
      mainProgressStages: mps is List
          ? mps
                .map(
                  (e) => StaffMainProgressStage.fromJson(
                    e as Map<String, dynamic>,
                  ),
                )
                .toList()
          : const [],
      progressTabs: () {
        final pt = json['progress_tabs'];
        if (pt is! List) {
          return const <StaffProgressTabData>[];
        }
        return pt
            .map(
              (e) => StaffProgressTabData.fromJson(e as Map<String, dynamic>),
            )
            .toList();
      }(),
    );
  }
}

class PreparatoryStageInfo {
  PreparatoryStageInfo({
    required this.id,
    required this.name,
    this.scheduledAt,
    this.address,
    this.description,
    this.brandName,
    this.isCompleted = false,
    this.kind,
    this.stageCode,
  });
  final int id;
  final String name;
  final DateTime? scheduledAt;
  final String? address;

  /// Admin notes for brand rehearsal rows (API `description`); optional.
  final String? description;

  /// Brand display name for [kind] `brand_rehearsal` (API `brand_name`); app builds the title in l10n.
  final String? brandName;

  /// From dashboard API; completion follows `child_stage_plan` (staff scan), not booking.
  final bool isCompleted;

  /// `rehearsal` | `brand_rehearsal` | `preparatory_stage` | null (legacy).
  final String? kind;

  /// Optional; rehearsal rows set [kind] to `rehearsal` (API stage_code `jfs_rehearsal`).
  final String? stageCode;

  bool get isRehearsalMilestone =>
      kind == 'rehearsal' || stageCode == 'jfs_rehearsal';

  bool get isBrandRehearsalMilestone =>
      kind == 'brand_rehearsal' ||
      (stageCode != null &&
          RegExp(r'^jfs_brand_reh_e\d+_b\d+$').hasMatch(stageCode!));

  factory PreparatoryStageInfo.fromJson(Map<String, dynamic> json) {
    return PreparatoryStageInfo(
      id: _jsonInt(json['id']),
      name: (json['stage_name'] as String? ?? json['name'] as String? ?? ''),
      scheduledAt: json['scheduled_at'] != null
          ? DateTime.tryParse(json['scheduled_at'] as String)
          : null,
      address: json['address'] as String?,
      description: json['description'] as String?,
      brandName: json['brand_name'] as String?,
      isCompleted: json['is_completed'] == true,
      kind: json['kind'] as String?,
      stageCode: json['stage_code'] as String?,
    );
  }
}

extension PreparatoryStageInfoDisplayTitle on PreparatoryStageInfo {
  /// Localized milestone title for client UI (rehearsal / brand rehearsal / other prep).
  String displayTitle(AppLocalizations l10n) {
    if (isRehearsalMilestone) {
      return l10n.rehearsalMilestoneTitle;
    }
    if (isBrandRehearsalMilestone) {
      final b = brandName?.trim() ?? '';
      if (b.isEmpty) {
        final legacy = name.trim();
        if (legacy.isNotEmpty) {
          return legacy;
        }
        return l10n.rehearsalBrandMilestoneShort;
      }
      return l10n.rehearsalBrandMilestoneTitle(b);
    }
    final n = name.trim();
    if (n.isEmpty) {
      return id > 0 ? 'Preparatory #$id' : 'Preparatory';
    }
    return n;
  }
}

class ParentProgressInfo {
  ParentProgressInfo({
    required this.totalStages,
    required this.completedStages,
  });

  final int totalStages;
  final int completedStages;

  factory ParentProgressInfo.fromJson(Map<String, dynamic> json) {
    return ParentProgressInfo(
      totalStages: json['total_stages'] as int? ?? 0,
      completedStages: json['completed_stages'] as int? ?? 0,
    );
  }
}

class ScanStageResult {
  ScanStageResult({
    required this.ok,
    required this.resultStatus,
    required this.resultCode,
    required this.message,
    this.attemptId,
  });

  final bool ok;
  final String resultStatus;
  final String resultCode;
  final String message;
  final int? attemptId;

  bool get isSuccess => ok && resultCode == 'success';

  factory ScanStageResult.fromJson(Map<String, dynamic> json) {
    return ScanStageResult(
      ok: json['ok'] == true,
      resultStatus: (json['result_status'] as String? ?? '').toString(),
      resultCode: (json['result_code'] as String? ?? '').toString(),
      message: (json['message'] as String? ?? '').toString(),
      attemptId: json['attempt_id'] as int?,
    );
  }
}

class ParkingScanLookupResult {
  ParkingScanLookupResult({
    required this.eventName,
    required this.clientName,
    required this.carModel,
    required this.plateNumber,
    required this.isVipClient,
  });

  final String eventName;
  final String clientName;
  final String carModel;
  final String plateNumber;
  final bool isVipClient;

  factory ParkingScanLookupResult.fromJson(Map<String, dynamic> json) {
    return ParkingScanLookupResult(
      eventName: (json['event_name'] as String? ?? '').trim(),
      clientName: (json['client_name'] as String? ?? '').trim(),
      carModel: (json['car_model'] as String? ?? '').trim(),
      plateNumber: (json['plate_number'] as String? ?? '').trim(),
      isVipClient: _jsonBool(json['is_vip_client'], false),
    );
  }
}

class ExtraTicketScanLookupResult {
  ExtraTicketScanLookupResult({
    required this.ok,
    required this.resultCode,
    required this.message,
    required this.eventName,
    required this.clientName,
  });

  final bool ok;
  final String resultCode;
  final String message;
  final String eventName;
  final String clientName;

  bool get isNotFound => resultCode == 'not_found';
  bool get isAccessGranted => resultCode == 'access_granted';
  bool get isAccessClosed => resultCode == 'access_closed';

  factory ExtraTicketScanLookupResult.fromJson(Map<String, dynamic> json) {
    final ok = json['ok'] == true;
    final code =
        (json['result_code'] as String?)?.trim().toLowerCase() ??
        (ok ? 'access_granted' : 'not_found');

    return ExtraTicketScanLookupResult(
      ok: ok,
      resultCode: code,
      message: (json['message'] as String? ?? '').trim(),
      eventName: (json['event_name'] as String? ?? '').trim(),
      clientName: (json['client_name'] as String? ?? '').trim(),
    );
  }
}

class BackstageTicketScanLookupResult {
  BackstageTicketScanLookupResult({
    required this.ok,
    required this.resultCode,
    required this.message,
    required this.eventName,
    required this.clientName,
  });

  final bool ok;
  final String resultCode;
  final String message;
  final String eventName;
  final String clientName;

  bool get isNotFound => resultCode == 'not_found';
  bool get isAccessGranted => resultCode == 'access_granted';
  bool get isAccessClosed => resultCode == 'access_closed';

  factory BackstageTicketScanLookupResult.fromJson(Map<String, dynamic> json) {
    final ok = json['ok'] == true;
    final code =
        (json['result_code'] as String?)?.trim().toLowerCase() ??
        (ok ? 'access_granted' : 'not_found');

    return BackstageTicketScanLookupResult(
      ok: ok,
      resultCode: code,
      message: (json['message'] as String? ?? '').trim(),
      eventName: (json['event_name'] as String? ?? '').trim(),
      clientName: (json['client_name'] as String? ?? '').trim(),
    );
  }
}

class RehearsalCheckinScanLookupResult {
  RehearsalCheckinScanLookupResult({
    required this.ok,
    required this.resultCode,
    required this.message,
    required this.childName,
    required this.eventName,
    this.slotDate,
    required this.slotTime,
  });

  final bool ok;
  final String resultCode;
  final String message;
  final String childName;
  final String eventName;
  final DateTime? slotDate;
  final String slotTime;

  bool get isNotFound => resultCode == 'not_found';
  bool get isWrongSlot => resultCode == 'wrong_slot';
  bool get isAlreadyClosed => resultCode == 'already_closed';
  bool get isClosedNow => resultCode == 'checkin_closed';

  factory RehearsalCheckinScanLookupResult.fromJson(Map<String, dynamic> json) {
    final ok = json['ok'] == true;
    final code =
        (json['result_code'] as String?)?.trim().toLowerCase() ??
        (ok ? 'checkin_closed' : 'not_found');

    return RehearsalCheckinScanLookupResult(
      ok: ok,
      resultCode: code,
      message: (json['message'] as String? ?? '').trim(),
      childName: (json['child_name'] as String? ?? '').trim(),
      eventName: (json['event_name'] as String? ?? '').trim(),
      slotDate: _jsonDateTimeNullable(json['slot_date']),
      slotTime: (json['slot_time'] as String? ?? '').trim(),
    );
  }
}

// ---------------------------------------------------------------------------
// Client profile models
// ---------------------------------------------------------------------------

class ClientProfile {
  ClientProfile({required this.user, required this.children});
  final ProfileUser user;
  final List<ProfileChild> children;

  factory ClientProfile.fromJson(Map<String, dynamic> json) {
    final u = json['user'] as Map<String, dynamic>? ?? {};
    final c = json['children'];
    return ClientProfile(
      user: ProfileUser.fromJson(u),
      children: c is List
          ? c
                .map((e) => ProfileChild.fromJson(e as Map<String, dynamic>))
                .toList()
          : [],
    );
  }
}

class ProfileUser {
  ProfileUser({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
  });
  final int id;
  final String name;
  final String email;
  final String phone;

  factory ProfileUser.fromJson(Map<String, dynamic> json) {
    return ProfileUser(
      id: json['id'] as int? ?? 0,
      name: (json['name'] as String? ?? ''),
      email: (json['email'] as String? ?? ''),
      phone: (json['phone'] as String? ?? ''),
    );
  }
}

class ProfileChild {
  ProfileChild({
    required this.id,
    required this.firstName,
    this.gender,
    this.birthdate,
    this.mainPhotoUrl,
    this.extraPhotoUrls,
    this.heightValue,
    required this.heightUnit,
    this.chestValue,
    this.waistValue,
    this.hipsValue,
    required this.extraPhotosCount,
    required this.hasMeasurements,
    this.activeEventName,
  });
  final int id;
  final String firstName;
  final String? gender;
  final DateTime? birthdate;
  final String? mainPhotoUrl;
  final List<String>? extraPhotoUrls;
  final double? heightValue;
  final String heightUnit;
  final double? chestValue;
  final double? waistValue;
  final double? hipsValue;
  final int extraPhotosCount;
  final bool hasMeasurements;
  final String? activeEventName;

  int? get age {
    if (birthdate == null) return null;
    final now = DateTime.now();
    int a = now.year - birthdate!.year;
    if (now.month < birthdate!.month ||
        (now.month == birthdate!.month && now.day < birthdate!.day)) {
      a--;
    }
    return a;
  }

  factory ProfileChild.fromJson(Map<String, dynamic> json) {
    return ProfileChild(
      id: _toInt(json['id']) ?? 0,
      firstName: (json['first_name'] as String? ?? ''),
      gender: json['gender'] as String?,
      birthdate: json['birthdate'] != null
          ? DateTime.tryParse(json['birthdate'].toString())
          : null,
      mainPhotoUrl: json['main_photo_url'] as String?,
      extraPhotoUrls: _toStringList(json['extra_photo_urls']),
      heightValue: _toDouble(json['height_value']),
      heightUnit: (json['height_unit'] as String? ?? 'metric'),
      chestValue: _toDouble(json['chest_value']),
      waistValue: _toDouble(json['waist_value']),
      hipsValue: _toDouble(json['hips_value']),
      extraPhotosCount: _toInt(json['extra_photos_count']) ?? 0,
      hasMeasurements:
          json['has_measurements'] == true ||
          json['has_measurements'] == 'true' ||
          json['has_measurements'] == 1,
      activeEventName: json['active_event_name'] as String?,
    );
  }
}

int? _toInt(dynamic v) {
  if (v == null) return null;
  if (v is int) return v;
  if (v is num) return v.toInt();
  if (v is String) return int.tryParse(v);
  return null;
}

double? _toDouble(dynamic v) {
  if (v == null) return null;
  if (v is num) return v.toDouble();
  if (v is String) return double.tryParse(v);
  return null;
}

List<String>? _toStringList(dynamic v) {
  if (v == null || v is! List) return null;
  final list = <String>[];
  for (final e in v) {
    if (e is String) list.add(e);
  }
  return list.isEmpty ? null : list;
}
