import 'api/auth_service.dart';
import 'app_settings.dart';

/// Этапы ивента, разрешённые для роли: если в админке роли не назначены этапы — доступны все этапы ивента.
List<WorkerEventStage> stagesAllowedForRole(
  List<WorkerEventStage> all,
  StaffRole role,
) {
  if (role.stageIds.isEmpty) {
    return List<WorkerEventStage>.from(all);
  }
  final allowed = role.stageIds.toSet();
  return all.where((s) => allowed.contains(s.id)).toList();
}

StaffRole? _roleByCode(WorkerStatus status, String? code) {
  if (code == null || code.trim().isEmpty) {
    return null;
  }
  final want = code.trim().toLowerCase();
  for (final r in status.staffRoles) {
    if (r.code.toLowerCase() == want) {
      return r;
    }
  }
  return null;
}

/// После [AppSettings.load]: если ивент, роль и этап из prefs ещё допустимы — не трогаем.
/// Иначе: ближайший ивент (первый в списке upcoming), первая назначенная роль (если код в prefs невалиден), первый этап из пересечения этапов ивента и этапов роли.
Future<void> bootstrapStaffWorkspace(AuthService auth, WorkerStatus status) async {
  if (!status.isWorker || status.staffRoles.isEmpty) {
    return;
  }

  try {
    final events = await auth.getWorkerUpcomingEvents();
    final savedEid = AppSettings.staffActiveEventId;
    final savedRcode = AppSettings.staffSelectedRoleCode;
    final savedSid = AppSettings.staffActiveStageId;
    final savedStype = AppSettings.staffActiveStageType;

    final roleFromSaved = _roleByCode(status, savedRcode);

    if (savedEid != null &&
        events.any((e) => e.id == savedEid) &&
        roleFromSaved != null &&
        savedSid != null) {
      final raw = await auth.getWorkerEventStages(savedEid);
      final allowed = stagesAllowedForRole(raw, roleFromSaved);
      final stageOk = allowed.any(
        (s) => s.id == savedSid && (savedStype == null || s.type == savedStype),
      );
      if (stageOk) {
        return;
      }
    }

    final defaultRole = roleFromSaved ?? status.staffRoles.first;
    int? defaultEid;
    if (savedEid != null && events.any((e) => e.id == savedEid)) {
      defaultEid = savedEid;
    } else {
      defaultEid = events.isNotEmpty ? events.first.id : null;
    }

    if (defaultEid == null) {
      await AppSettings.setStaffActiveEventId(null);
      await AppSettings.setStaffActiveStageId(null);
      await AppSettings.setStaffActiveStageType(null);
      await AppSettings.setStaffSelectedRoleCode(defaultRole.code);
      return;
    }

    final raw = await auth.getWorkerEventStages(defaultEid);
    final allowed = stagesAllowedForRole(raw, defaultRole);

    WorkerEventStage? pick;
    if (savedSid != null &&
        allowed.any(
          (s) => s.id == savedSid && (savedStype == null || s.type == savedStype),
        )) {
      pick = allowed.firstWhere(
        (s) => s.id == savedSid && (savedStype == null || s.type == savedStype),
      );
    } else if (allowed.isNotEmpty) {
      pick = allowed.first;
    }

    await AppSettings.setStaffActiveEventId(defaultEid);
    await AppSettings.setStaffSelectedRoleCode(defaultRole.code);
    if (pick != null) {
      await AppSettings.setStaffActiveStageId(pick.id);
      await AppSettings.setStaffActiveStageType(pick.type);
    } else {
      await AppSettings.setStaffActiveStageId(null);
      await AppSettings.setStaffActiveStageType(null);
    }
  } catch (_) {
    // Не блокируем вход при сетевой ошибке: остаются последние сохранённые prefs.
  }
}
