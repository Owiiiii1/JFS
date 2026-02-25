import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

class AuthService {
  AuthService(this.baseUrl);

  final String baseUrl;
  static const _storage = FlutterSecureStorage();
  static const _tokenKey = 'auth_token';

  Future<String?> getToken() => _storage.read(key: _tokenKey);
  Future<void> saveToken(String token) => _storage.write(key: _tokenKey, value: token);
  Future<void> clearToken() => _storage.delete(key: _tokenKey);

  Future<LoginResult> login({required String email, required String password}) async {
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
      throw Exception(_tryMessage(res.body) ?? 'Login failed (${res.statusCode})');
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
      throw Exception(_tryMessage(res.body) ?? 'Register failed (${res.statusCode})');
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
      headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
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
      headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );
    if (res.statusCode != 200) {
      throw Exception(_tryMessage(res.body) ?? 'Failed to load worker status (${res.statusCode})');
    }
    final json = jsonDecode(res.body) as Map<String, dynamic>;
    return WorkerStatus.fromJson(json);
  }

  String? _tryMessage(String body) {
    try {
      final j = jsonDecode(body);
      if (j is Map && j['message'] is String) return j['message'] as String;
    } catch (_) {}
    return null;
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
          ? list.map((e) => StaffRole.fromJson(e as Map<String, dynamic>)).toList()
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
