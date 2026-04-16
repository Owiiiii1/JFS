import 'dart:ui' show Locale, PlatformDispatcher;

import 'package:shared_preferences/shared_preferences.dart';

/// Единицы измерения: метрические (см, кг) или американские (imperial: дюймы, фунты).
enum MeasurementUnit { metric, imperial }

/// Код языка приложения. System = следовать системной локали; иначе фиксированный язык.
enum AppLanguage { system, en, ru, uk, esUs }

/// Формат отображения времени в приложении.
enum TimeDisplayFormat { h12, h24 }

/// Настройки приложения (язык, единицы измерения). Хранятся в SharedPreferences.
class AppSettings {
  AppSettings._();

  static const _keyUnit = 'measurement_unit';
  static const _keyLanguage = 'app_language';
  static const _keyTimeDisplayFormat = 'time_display_format';
  static const _keyStaffActiveEventId = 'staff_active_event_id';
  static const _keyStaffActiveStageId = 'staff_active_stage_id';
  static const _keyStaffActiveStageType = 'staff_active_stage_type';
  static const _keyStaffSelectedRoleCode = 'staff_selected_role_code';

  /// Вызывается после смены языка, чтобы приложение перестроилось с новой локалью.
  static void Function()? onLocaleChanged;

  static MeasurementUnit _unit = MeasurementUnit.metric;
  static AppLanguage _language = AppLanguage.system;
  static TimeDisplayFormat _timeDisplayFormat = TimeDisplayFormat.h12;
  static int? _staffActiveEventId;
  static int? _staffActiveStageId;
  static String? _staffActiveStageType;
  static String? _staffSelectedRoleCode;
  static bool _loaded = false;

  static Future<void> load() async {
    if (_loaded) return;
    final prefs = await SharedPreferences.getInstance();
    _unit = MeasurementUnit.values.firstWhere(
      (e) => e.name == prefs.getString(_keyUnit),
      orElse: () => MeasurementUnit.metric,
    );
    _language = AppLanguage.values.firstWhere(
      (e) => e.name == prefs.getString(_keyLanguage),
      orElse: () => AppLanguage.system,
    );
    _timeDisplayFormat = TimeDisplayFormat.values.firstWhere(
      (e) => e.name == prefs.getString(_keyTimeDisplayFormat),
      orElse: () => TimeDisplayFormat.h12,
    );
    _staffActiveEventId = prefs.getInt(_keyStaffActiveEventId);
    _staffActiveStageId = prefs.getInt(_keyStaffActiveStageId);
    _staffActiveStageType = prefs.getString(_keyStaffActiveStageType)?.trim();
    _staffSelectedRoleCode = prefs.getString(_keyStaffSelectedRoleCode)?.trim();
    _loaded = true;
  }

  static MeasurementUnit get measurementUnit => _unit;
  static AppLanguage get language => _language;
  static TimeDisplayFormat get timeDisplayFormat => _timeDisplayFormat;

  /// Локаль для запросов контента к API (`Accept-Language`), совпадает с выбором языка в настройках.
  static Locale contentLocaleForApi() {
    switch (_language) {
      case AppLanguage.en:
        return const Locale('en');
      case AppLanguage.ru:
        return const Locale('ru');
      case AppLanguage.uk:
        return const Locale('uk');
      case AppLanguage.esUs:
        return const Locale('es', 'US');
      case AppLanguage.system:
        return PlatformDispatcher.instance.locale;
    }
  }

  /// ID выбранного активного ивента для сотрудника (null — не выбран).
  static int? get staffActiveEventId => _staffActiveEventId;
  static int? get staffActiveStageId => _staffActiveStageId;
  static String? get staffActiveStageType => _staffActiveStageType;
  static String? get staffSelectedRoleCode => _staffSelectedRoleCode;

  static Future<void> setStaffActiveEventId(int? value) async {
    if (_staffActiveEventId == value) return;
    _staffActiveEventId = value;
    final prefs = await SharedPreferences.getInstance();
    if (value == null) {
      await prefs.remove(_keyStaffActiveEventId);
    } else {
      await prefs.setInt(_keyStaffActiveEventId, value);
    }
  }

  static Future<void> setStaffActiveStageId(int? value) async {
    if (_staffActiveStageId == value) return;
    _staffActiveStageId = value;
    final prefs = await SharedPreferences.getInstance();
    if (value == null) {
      await prefs.remove(_keyStaffActiveStageId);
    } else {
      await prefs.setInt(_keyStaffActiveStageId, value);
    }
  }

  static Future<void> setStaffActiveStageType(String? value) async {
    final normalized = value?.trim();
    if (_staffActiveStageType == normalized) return;
    _staffActiveStageType = normalized;
    final prefs = await SharedPreferences.getInstance();
    if (normalized == null || normalized.isEmpty) {
      await prefs.remove(_keyStaffActiveStageType);
    } else {
      await prefs.setString(_keyStaffActiveStageType, normalized);
    }
  }

  static Future<void> setStaffSelectedRoleCode(String? value) async {
    final normalized = value?.trim();
    if (_staffSelectedRoleCode == normalized) return;
    _staffSelectedRoleCode = normalized;
    final prefs = await SharedPreferences.getInstance();
    if (normalized == null || normalized.isEmpty) {
      await prefs.remove(_keyStaffSelectedRoleCode);
    } else {
      await prefs.setString(_keyStaffSelectedRoleCode, normalized);
    }
  }

  static Future<void> setMeasurementUnit(MeasurementUnit value) async {
    if (_unit == value) return;
    _unit = value;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyUnit, value.name);
  }

  static Future<void> setLanguage(AppLanguage value) async {
    if (_language == value) return;
    _language = value;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyLanguage, value.name);
  }

  static Future<void> setTimeDisplayFormat(TimeDisplayFormat value) async {
    if (_timeDisplayFormat == value) return;
    _timeDisplayFormat = value;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyTimeDisplayFormat, value.name);
  }

  /// Формат времени в зависимости от пользовательской настройки (12/24).
  static String formatTime(int hour, int minute) {
    if (_timeDisplayFormat == TimeDisplayFormat.h24) {
      final hh = hour.toString().padLeft(2, '0');
      final mm = minute.toString().padLeft(2, '0');
      return '$hh:$mm';
    }
    final period = hour >= 12 ? 'PM' : 'AM';
    final hour12 = hour == 0 ? 12 : (hour > 12 ? hour - 12 : hour);
    final mm = minute.toString().padLeft(2, '0');
    return '$hour12:$mm $period';
  }

  /// Парсит строку времени (`H:i`, `HH:mm`, `HH:mm:ss`) и форматирует в выбранный формат.
  static String formatTimeLabel(String raw) {
    var value = raw.trim();
    if (value.isEmpty) return raw;
    if (value.length > 8) value = value.substring(0, 8);
    final parts = value.split(':');
    if (parts.isEmpty) return raw;
    final hour = int.tryParse(parts[0]);
    final minute = parts.length > 1 ? int.tryParse(parts[1]) : 0;
    if (hour == null || minute == null || hour < 0 || hour > 23) return raw;
    return formatTime(hour, minute);
  }

  // --- Конвертация (бэкенд хранит в метрике: см, кг) ---

  static const double _cmPerInch = 2.54;
  static const double _lbPerKg = 2.20462262;

  /// Длина: значение в см -> в выбранных единицах (см или in).
  static double lengthFromMetric(double cm) {
    if (_unit == MeasurementUnit.imperial) {
      return cm / _cmPerInch;
    }
    return cm;
  }

  /// Длина: значение в выбранных единицах -> см для отправки на сервер.
  static double lengthToMetric(double value) {
    if (_unit == MeasurementUnit.imperial) {
      return value * _cmPerInch;
    }
    return value;
  }

  /// Вес: значение в кг -> в выбранных единицах (кг или lb).
  static double weightFromMetric(double kg) {
    if (_unit == MeasurementUnit.imperial) {
      return kg * _lbPerKg;
    }
    return kg;
  }

  /// Вес: значение в выбранных единицах -> кг для отправки на сервер.
  static double weightToMetric(double value) {
    if (_unit == MeasurementUnit.imperial) {
      return value / _lbPerKg;
    }
    return value;
  }

  /// Подпись единицы длины: "cm" или "in".
  static String get lengthUnitLabel =>
      _unit == MeasurementUnit.imperial ? 'in' : 'cm';

  /// Подпись единицы веса: "kg" или "lb".
  static String get weightUnitLabel =>
      _unit == MeasurementUnit.imperial ? 'lb' : 'kg';
}
