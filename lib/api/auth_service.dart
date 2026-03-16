import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

class AuthService {
  AuthService(this.baseUrl);

  final String baseUrl;
  static const _storage = FlutterSecureStorage();
  static const _tokenKey = 'auth_token';

  Future<String?> getToken() => _storage.read(key: _tokenKey);
  Future<void> saveToken(String token) =>
      _storage.write(key: _tokenKey, value: token);
  Future<void> clearToken() => _storage.delete(key: _tokenKey);

  Future<LoginResult> login({
    required String email,
    required String password,
  }) async {
    final uri = Uri.parse('$baseUrl/api/app/login');

    final res = await http.post(
      uri,
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
      body: jsonEncode({'email': email, 'password': password}),
    );

    if (res.statusCode != 200) {
      throw Exception(
        _tryMessage(res.body) ?? 'Login failed (${res.statusCode})',
      );
    }

    final json = jsonDecode(res.body) as Map<String, dynamic>;
    return LoginResult(
      token: json['token'] as String,
      user: json['user'] as Map<String, dynamic>,
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
    required String badgeCode,
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
      request.fields['badge_code'] = badgeCode;
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
          'badge_code': badgeCode,
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

  /// POST /api/app/client/children — создать ребёнка для текущего клиента
  Future<ProfileChild> createChild({
    required String firstName,
    String lastName = '',
    DateTime? birthdate,
  }) async {
    final token = await getToken();
    if (token == null || token.isEmpty) {
      throw Exception('Not authenticated');
    }
    final uri = Uri.parse('$baseUrl/api/app/client/children');
    final body = <String, dynamic>{
      'first_name': firstName,
      'last_name': lastName,
    };
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
  Future<ClientDashboard> getClientDashboard() async {
    final token = await getToken();
    if (token == null || token.isEmpty) {
      throw Exception('Not authenticated');
    }
    final uri = Uri.parse('$baseUrl/api/app/client/dashboard');
    final res = await http.get(
      uri,
      headers: {'Accept': 'application/json', 'Authorization': 'Bearer $token'},
    );
    if (res.statusCode != 200) {
      throw Exception(
        _tryMessage(res.body) ?? 'Failed to load dashboard (${res.statusCode})',
      );
    }
    final json = jsonDecode(res.body) as Map<String, dynamic>;
    return ClientDashboard.fromJson(json);
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

  /// GET /api/app/info/settings — публичные настройки раздела Info (фото, соцсети, сайт). Без авторизации.
  Future<InfoSettings> getInfoSettings() async {
    final uri = Uri.parse('$baseUrl/api/app/info/settings');
    final res = await http.get(uri, headers: {'Accept': 'application/json'});
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
  Future<List<AppNewsItem>> getAppNews() async {
    final uri = Uri.parse('$baseUrl/api/app/info/news');
    final res = await http.get(uri, headers: {'Accept': 'application/json'});
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
  Future<AppAboutData> getAppAbout() async {
    final uri = Uri.parse('$baseUrl/api/app/info/about');
    final res = await http.get(uri, headers: {'Accept': 'application/json'});
    if (res.statusCode != 200) {
      throw Exception(
        _tryMessage(res.body) ?? 'Failed to load about (${res.statusCode})',
      );
    }
    final json = jsonDecode(res.body) as Map<String, dynamic>;
    return AppAboutData.fromJson(json);
  }

  /// GET /api/app/info/terms — данные «Terms & Conditions». Без авторизации.
  Future<AppTermsData> getAppTerms() async {
    final uri = Uri.parse('$baseUrl/api/app/info/terms');
    final res = await http.get(uri, headers: {'Accept': 'application/json'});
    if (res.statusCode != 200) {
      throw Exception(
        _tryMessage(res.body) ?? 'Failed to load terms (${res.statusCode})',
      );
    }
    final json = jsonDecode(res.body) as Map<String, dynamic>;
    return AppTermsData.fromJson(json);
  }

  /// GET /api/app/info/faq-sections — разделы FAQ. Без авторизации.
  Future<List<FaqSectionItem>> getFaqSections() async {
    final uri = Uri.parse('$baseUrl/api/app/info/faq-sections');
    final res = await http.get(uri, headers: {'Accept': 'application/json'});
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
  Future<List<FaqArticleItem>> getFaqSectionArticles(int sectionId) async {
    final uri = Uri.parse(
      '$baseUrl/api/app/info/faq-sections/$sectionId/articles',
    );
    final res = await http.get(uri, headers: {'Accept': 'application/json'});
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

  String? _tryMessage(String body) {
    try {
      final j = jsonDecode(body);
      if (j is Map && j['message'] is String) return j['message'] as String;
    } catch (_) {}
    return null;
  }
}

/// Публичные настройки раздела Info в приложении (фото, соцсети, сайт).
class InfoSettings {
  InfoSettings({
    this.infoPhotoUrl,
    this.socialInstagram,
    this.socialTwitter,
    this.socialYoutube,
    this.websiteUrl,
    this.faqPhotoUrl,
    this.faqArticlesPhotoUrl,
  });
  final String? infoPhotoUrl;
  final String? socialInstagram;
  final String? socialTwitter;
  final String? socialYoutube;
  final String? websiteUrl;
  final String? faqPhotoUrl;
  final String? faqArticlesPhotoUrl;

  static InfoSettings fromJson(Map<String, dynamic> json) {
    String? url(dynamic v) => v is String && v.isNotEmpty ? v : null;
    return InfoSettings(
      infoPhotoUrl: url(json['info_photo_url']),
      socialInstagram: url(json['social_instagram']),
      socialTwitter: url(json['social_twitter']),
      socialYoutube: url(json['social_youtube']),
      websiteUrl: url(json['website_url']),
      faqPhotoUrl: url(json['faq_photo_url']),
      faqArticlesPhotoUrl: url(json['faq_articles_photo_url']),
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

/// Данные «Terms & Conditions» из API /api/app/info/terms.
class AppTermsData {
  AppTermsData({this.photoUrl, this.body});
  final String? photoUrl;
  final String? body;

  static AppTermsData fromJson(Map<String, dynamic> json) {
    return AppTermsData(
      photoUrl: json['photo_url'] as String?,
      body: json['body'] as String?,
    );
  }
}

class LoginResult {
  LoginResult({required this.token, required this.user});
  final String token;
  final Map<String, dynamic> user;
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
  StaffRole({required this.id, required this.code, required this.name});
  final int id;
  final String code;
  final String name;

  factory StaffRole.fromJson(Map<String, dynamic> json) {
    return StaffRole(
      id: (json['id'] is int) ? json['id'] as int : 0,
      code: (json['code'] as String? ?? '').toString(),
      name: (json['name'] as String? ?? '').toString(),
    );
  }
}

// ---------------------------------------------------------------------------
// Client dashboard models
// ---------------------------------------------------------------------------

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
    required this.lastName,
    this.activeAssignment,
  });
  final int id;
  final String firstName;
  final String lastName;
  final ActiveAssignment? activeAssignment;

  factory ChildWithAssignment.fromJson(Map<String, dynamic> json) {
    final a = json['active_assignment'];
    return ChildWithAssignment(
      id: json['id'] as int? ?? 0,
      firstName: (json['first_name'] as String? ?? ''),
      lastName: (json['last_name'] as String? ?? ''),
      activeAssignment: a is Map<String, dynamic>
          ? ActiveAssignment.fromJson(a)
          : null,
    );
  }
}

class ActiveAssignment {
  ActiveAssignment({
    required this.id,
    required this.event,
    required this.status,
    required this.totalMainStages,
    required this.totalPreparatoryStages,
    required this.completedStages,
    this.requiredTotalStages,
    this.requiredCompletedStages,
    this.familyLook = false,
    this.familyLookBrandId,
    this.parentProgress,
    required this.mainStages,
    required this.preparatoryStages,
  });
  final int id;
  final EventSummary event;
  final String status;
  final int totalMainStages;
  final int totalPreparatoryStages;
  final int completedStages;
  final int? requiredTotalStages;
  final int? requiredCompletedStages;
  final bool familyLook;
  final int? familyLookBrandId;
  final ParentProgressInfo? parentProgress;
  final List<MainStageInfo> mainStages;
  final List<PreparatoryStageInfo> preparatoryStages;

  factory ActiveAssignment.fromJson(Map<String, dynamic> json) {
    final ev = json['event'] as Map<String, dynamic>? ?? {};
    final main = json['main_stages'];
    final prep = json['preparatory_stages'];
    final parentProgressJson = json['parent_progress'];
    return ActiveAssignment(
      id: json['id'] as int? ?? 0,
      event: EventSummary.fromJson(ev),
      status: (json['status'] as String? ?? ''),
      totalMainStages: json['total_main_stages'] as int? ?? 0,
      totalPreparatoryStages: json['total_preparatory_stages'] as int? ?? 0,
      completedStages: json['completed_stages'] as int? ?? 0,
      requiredTotalStages: json['required_total_stages'] as int?,
      requiredCompletedStages: json['required_completed_stages'] as int?,
      familyLook: json['family_look'] == true,
      familyLookBrandId: json['family_look_brand_id'] as int?,
      parentProgress: parentProgressJson is Map<String, dynamic>
          ? ParentProgressInfo.fromJson(parentProgressJson)
          : null,
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
    );
  }
}

class MainStageInfo {
  MainStageInfo({required this.id, required this.name});

  final int id;
  final String name;

  factory MainStageInfo.fromJson(Map<String, dynamic> json) {
    return MainStageInfo(
      id: json['id'] as int? ?? 0,
      name: (json['name'] as String? ?? '').toString(),
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
  });
  final int id;
  final String name;
  final String city;
  final DateTime? startsAt;
  final DateTime? endsAt;
  final String? imageUrl;

  factory EventSummary.fromJson(Map<String, dynamic> json) {
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
    );
  }
}

/// Событие из API upcoming-events (будущее, ребёнок ещё не записан).
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
    required this.lastName,
    this.photoUrl,
    required this.status,
  });
  final int assignmentId;
  final int childId;
  final String firstName;
  final String lastName;
  final String? photoUrl;

  /// given | not_given
  final String status;

  factory SupervisorChildItem.fromJson(Map<String, dynamic> json) {
    return SupervisorChildItem(
      assignmentId: json['assignment_id'] as int? ?? 0,
      childId: json['child_id'] as int? ?? 0,
      firstName: (json['first_name'] as String? ?? '').toString(),
      lastName: (json['last_name'] as String? ?? '').toString(),
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

class SupervisorChildDetail {
  SupervisorChildDetail({
    required this.assignmentId,
    required this.childId,
    required this.firstName,
    required this.lastName,
    this.publicCode,
    this.photoUrl,
    this.birthdate,
    this.age,
    this.notes,
    this.heightValue,
    this.heightUnit,
    this.weightValue,
    this.weightUnit,
    this.parentName,
    this.parentRole,
    this.parentPhone,
    required this.progressPercent,
    this.currentStageName,
    required this.completedStages,
    required this.totalStages,
  });

  final int assignmentId;
  final int childId;
  final String firstName;
  final String lastName;
  final String? publicCode;
  final String? photoUrl;
  final DateTime? birthdate;
  final int? age;
  final String? notes;
  final double? heightValue;
  final String? heightUnit;
  final double? weightValue;
  final String? weightUnit;
  final String? parentName;
  final String? parentRole;
  final String? parentPhone;
  final int progressPercent;
  final String? currentStageName;
  final int completedStages;
  final int totalStages;

  String get fullName => '$firstName $lastName'.trim();

  factory SupervisorChildDetail.fromJson(Map<String, dynamic> json) {
    return SupervisorChildDetail(
      assignmentId: json['assignment_id'] as int? ?? 0,
      childId: json['child_id'] as int? ?? 0,
      firstName: (json['first_name'] as String? ?? '').toString(),
      lastName: (json['last_name'] as String? ?? '').toString(),
      publicCode: json['public_code'] as String?,
      photoUrl: json['photo_url'] as String?,
      birthdate: json['birthdate'] != null
          ? DateTime.tryParse(json['birthdate'] as String)
          : null,
      age: json['age'] as int?,
      notes: json['notes'] as String?,
      heightValue: _toDouble(json['height_value']),
      heightUnit: json['height_unit'] as String?,
      weightValue: _toDouble(json['weight_value']),
      weightUnit: json['weight_unit'] as String?,
      parentName: json['parent_name'] as String?,
      parentRole: json['parent_role'] as String?,
      parentPhone: json['parent_phone'] as String?,
      progressPercent: json['progress_percent'] as int? ?? 0,
      currentStageName: json['current_stage_name'] as String?,
      completedStages: json['completed_stages'] as int? ?? 0,
      totalStages: json['total_stages'] as int? ?? 0,
    );
  }
}

class PreparatoryStageInfo {
  PreparatoryStageInfo({
    required this.id,
    required this.name,
    this.scheduledAt,
    this.address,
  });
  final int id;
  final String name;
  final DateTime? scheduledAt;
  final String? address;

  factory PreparatoryStageInfo.fromJson(Map<String, dynamic> json) {
    return PreparatoryStageInfo(
      id: json['id'] as int? ?? 0,
      name: (json['stage_name'] as String? ?? json['name'] as String? ?? ''),
      scheduledAt: json['scheduled_at'] != null
          ? DateTime.tryParse(json['scheduled_at'] as String)
          : null,
      address: json['address'] as String?,
    );
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
    required this.lastName,
    this.birthdate,
    this.mainPhotoUrl,
    this.extraPhotoUrls,
    this.heightValue,
    required this.heightUnit,
    this.weightValue,
    this.shoulderValue,
    this.chestValue,
    this.waistValue,
    this.hipsValue,
    required this.extraPhotosCount,
    required this.hasMeasurements,
    this.activeEventName,
  });
  final int id;
  final String firstName;
  final String lastName;
  final DateTime? birthdate;
  final String? mainPhotoUrl;
  final List<String>? extraPhotoUrls;
  final double? heightValue;
  final String heightUnit;
  final double? weightValue;
  final double? shoulderValue;
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
      lastName: (json['last_name'] as String? ?? ''),
      birthdate: json['birthdate'] != null
          ? DateTime.tryParse(json['birthdate'].toString())
          : null,
      mainPhotoUrl: json['main_photo_url'] as String?,
      extraPhotoUrls: _toStringList(json['extra_photo_urls']),
      heightValue: _toDouble(json['height_value']),
      heightUnit: (json['height_unit'] as String? ?? 'metric'),
      weightValue: _toDouble(json['weight_value']),
      shoulderValue: _toDouble(json['shoulder_value']),
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
