import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'api/auth_service.dart';
import 'app_route_observer.dart';
import 'app_settings.dart';
import 'gen_l10n/app_localizations.dart';

/// Экран редактирования данных ребёнка. Каждый пункт — стрелка для изменения; данные сохраняются на сервер.
class ChildEditPage extends StatefulWidget {
  const ChildEditPage({
    super.key,
    required this.child,
    required this.auth,
    this.onChildUpdated,
  });

  final ProfileChild child;
  final AuthService auth;
  /// Вызывается после успешного обновления (можно обновить профиль в родителе).
  final VoidCallback? onChildUpdated;

  @override
  State<ChildEditPage> createState() => _ChildEditPageState();
}

class _ChildEditPageState extends State<ChildEditPage> with RouteAware {
  late String _firstName;
  late String _lastName;
  late DateTime? _birthdate;
  late double? _heightValue;
  late double? _weightValue;
  late double? _shoulderValue;
  late double? _chestValue;
  late double? _waistValue;
  late double? _hipsValue;
  late String? _mainPhotoUrl;
  late List<String> _extraPhotoUrls;
  bool _saving = false;
  bool _routeObserverSubscribed = false;
  static final _imagePicker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _syncFromChild();
    AppSettings.load().then((_) {
      if (mounted) setState(() {});
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_routeObserverSubscribed) {
      final route = ModalRoute.of(context);
      if (route is ModalRoute) {
        appRouteObserver.subscribe(this, route);
        _routeObserverSubscribed = true;
      }
    }
  }

  @override
  void dispose() {
    if (_routeObserverSubscribed) {
      appRouteObserver.unsubscribe(this);
    }
    super.dispose();
  }

  @override
  void didPopNext() {
    AppSettings.load().then((_) {
      if (mounted) setState(() {});
    });
  }

  void _syncFromChild() {
    final c = widget.child;
    _firstName = c.firstName;
    _lastName = c.lastName;
    _birthdate = c.birthdate;
    _heightValue = c.heightValue;
    _weightValue = c.weightValue;
    _shoulderValue = c.shoulderValue;
    _chestValue = c.chestValue;
    _waistValue = c.waistValue;
    _hipsValue = c.hipsValue;
    _mainPhotoUrl = c.mainPhotoUrl;
    _extraPhotoUrls = List<String>.from(c.extraPhotoUrls ?? []);
  }

  int? get _age {
    if (_birthdate == null) return null;
    final now = DateTime.now();
    int a = now.year - _birthdate!.year;
    if (now.month < _birthdate!.month ||
        (now.month == _birthdate!.month && now.day < _birthdate!.day)) {
      a--;
    }
    return a;
  }

  Future<void> _update(Map<String, dynamic> payload) async {
    if (_saving) return;
    setState(() => _saving = true);
    try {
      await widget.auth.updateChild(widget.child.id, payload);
      if (!mounted) return;
      widget.onChildUpdated?.call();
      setState(() => _saving = false);
    } catch (e) {
      if (!mounted) return;
      setState(() => _saving = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.toString()),
          backgroundColor: Colors.red.shade700,
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  static String _formatDate(DateTime d) {
    return '${d.year}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';
  }

  static String _num(double? v) {
    if (v == null) return '—';
    return v == v.roundToDouble() ? '${v.toInt()}' : v.toStringAsFixed(1);
  }

  /// Значения в state хранятся в метрике (см, кг). Для отображения переводим в выбранные единицы.
  double? get _displayHeight =>
      _heightValue != null ? AppSettings.lengthFromMetric(_heightValue!) : null;
  double? get _displayWeight =>
      _weightValue != null ? AppSettings.weightFromMetric(_weightValue!) : null;
  double? get _displayShoulder =>
      _shoulderValue != null ? AppSettings.lengthFromMetric(_shoulderValue!) : null;
  double? get _displayChest =>
      _chestValue != null ? AppSettings.lengthFromMetric(_chestValue!) : null;
  double? get _displayWaist =>
      _waistValue != null ? AppSettings.lengthFromMetric(_waistValue!) : null;
  double? get _displayHips =>
      _hipsValue != null ? AppSettings.lengthFromMetric(_hipsValue!) : null;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text('$_firstName $_lastName'),
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
      ),
      body: _saving
          ? const Center(
              child: CircularProgressIndicator(color: Color(0xFFD4AF37)),
            )
          : SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _buildMainPhotoSection(),
                  const SizedBox(height: 24),
                  _EditableRow(
                    label: AppLocalizations.of(context)!.firstName,
                    value: _firstName.isEmpty ? '—' : _firstName,
                    onTap: () => _showEditText(
                      context: context,
                      label: AppLocalizations.of(context)!.firstName,
                      value: _firstName,
                      onSave: (v) async {
                        await _update({'first_name': v});
                        setState(() => _firstName = v);
                      },
                    ),
                  ),
                  const SizedBox(height: 16),
                  _EditableRow(
                    label: AppLocalizations.of(context)!.lastName,
                    value: _lastName.isEmpty ? '—' : _lastName,
                    onTap: () => _showEditText(
                      context: context,
                      label: AppLocalizations.of(context)!.lastName,
                      value: _lastName,
                      onSave: (v) async {
                        await _update({'last_name': v});
                        setState(() => _lastName = v);
                      },
                    ),
                  ),
                  const SizedBox(height: 16),
                  _EditableRow(
                    label: AppLocalizations.of(context)!.birthdate,
                    value: _birthdate != null ? _formatDate(_birthdate!) : '—',
                    onTap: () => _showEditDate(
                      context: context,
                      initial: _birthdate,
                      onSave: (v) async {
                        await _update({'birthdate': v != null ? _formatDate(v) : null});
                        setState(() => _birthdate = v);
                      },
                    ),
                  ),
                  const SizedBox(height: 16),
                  _EditableRow(
                    label: AppLocalizations.of(context)!.ageLabel,
                    value: _age != null ? '$_age' : '—',
                    onTap: null,
                  ),
                  const SizedBox(height: 16),
                  _EditableRow(
                    label: '${AppLocalizations.of(context)!.height} (${AppSettings.lengthUnitLabel})',
                    value: _num(_displayHeight),
                    onTap: () => _showEditNumber(
                      context: context,
                      label: '${AppLocalizations.of(context)!.height} (${AppSettings.lengthUnitLabel})',
                      value: _displayHeight,
                      onSave: (v) async {
                        final metric = v != null ? AppSettings.lengthToMetric(v) : null;
                        await _update({'height_value': metric});
                        setState(() => _heightValue = metric);
                      },
                    ),
                  ),
                  const SizedBox(height: 16),
                  _EditableRow(
                    label: '${AppLocalizations.of(context)!.weight} (${AppSettings.weightUnitLabel})',
                    value: _num(_displayWeight),
                    onTap: () => _showEditNumber(
                      context: context,
                      label: '${AppLocalizations.of(context)!.weight} (${AppSettings.weightUnitLabel})',
                      value: _displayWeight,
                      onSave: (v) async {
                        final metric = v != null ? AppSettings.weightToMetric(v) : null;
                        await _update({'weight_value': metric});
                        setState(() => _weightValue = metric);
                      },
                    ),
                  ),
                  const SizedBox(height: 16),
                  _EditableRow(
                    label: '${AppLocalizations.of(context)!.shoulders} (${AppSettings.lengthUnitLabel})',
                    value: _num(_displayShoulder),
                    onTap: () => _showEditNumber(
                      context: context,
                      label: '${AppLocalizations.of(context)!.shoulders} (${AppSettings.lengthUnitLabel})',
                      value: _displayShoulder,
                      onSave: (v) async {
                        final metric = v != null ? AppSettings.lengthToMetric(v) : null;
                        await _update({'shoulder_value': metric});
                        setState(() => _shoulderValue = metric);
                      },
                    ),
                  ),
                  const SizedBox(height: 16),
                  _EditableRow(
                    label: '${AppLocalizations.of(context)!.chest} (${AppSettings.lengthUnitLabel})',
                    value: _num(_displayChest),
                    onTap: () => _showEditNumber(
                      context: context,
                      label: '${AppLocalizations.of(context)!.chest} (${AppSettings.lengthUnitLabel})',
                      value: _displayChest,
                      onSave: (v) async {
                        final metric = v != null ? AppSettings.lengthToMetric(v) : null;
                        await _update({'chest_value': metric});
                        setState(() => _chestValue = metric);
                      },
                    ),
                  ),
                  const SizedBox(height: 16),
                  _EditableRow(
                    label: 'Талия (${AppSettings.lengthUnitLabel})',
                    value: _num(_displayWaist),
                    onTap: () => _showEditNumber(
                      context: context,
                      label: 'Талия (${AppSettings.lengthUnitLabel})',
                      value: _displayWaist,
                      onSave: (v) async {
                        final metric = v != null ? AppSettings.lengthToMetric(v) : null;
                        await _update({'waist_value': metric});
                        setState(() => _waistValue = metric);
                      },
                    ),
                  ),
                  const SizedBox(height: 16),
                  _EditableRow(
                    label: '${AppLocalizations.of(context)!.hips} (${AppSettings.lengthUnitLabel})',
                    value: _num(_displayHips),
                    onTap: () => _showEditNumber(
                      context: context,
                      label: '${AppLocalizations.of(context)!.hips} (${AppSettings.lengthUnitLabel})',
                      value: _displayHips,
                      onSave: (v) async {
                        final metric = v != null ? AppSettings.lengthToMetric(v) : null;
                        await _update({'hips_value': metric});
                        setState(() => _hipsValue = metric);
                      },
                    ),
                  ),
                  const SizedBox(height: 24),
                  _buildExtraPhotosSection(),
                ],
              ),
            ),
    );
  }

  Widget _buildMainPhotoSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          AppLocalizations.of(context)!.mainPhoto,
          style: TextStyle(
            color: Colors.white54,
            fontSize: 12,
          ),
        ),
        const SizedBox(height: 8),
        Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            GestureDetector(
              onTap: () => _showFullPhoto(_mainPhotoUrl),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: SizedBox(
                  width: 120,
                  height: 156,
                  child: _mainPhotoUrl != null && _mainPhotoUrl!.isNotEmpty
                      ? Image.network(
                          _mainPhotoUrl!,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => _placeholder(),
                          loadingBuilder: (_, w, progress) {
                            if (progress == null) return w;
                            return _placeholder(
                              child: const SizedBox(
                                width: 32,
                                height: 32,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: Colors.white24,
                                ),
                              ),
                            );
                          },
                        )
                      : _placeholder(),
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (_mainPhotoUrl != null && _mainPhotoUrl!.isNotEmpty) ...[
                    TextButton.icon(
                      onPressed: _saving ? null : _pickAndUploadMainPhoto,
                      icon: const Icon(Icons.edit, size: 20, color: Colors.white70),
                      label: Text(
                        AppLocalizations.of(context)!.changePhoto,
                        style: TextStyle(color: Colors.white70),
                      ),
                    ),
                    TextButton.icon(
                      onPressed: _saving ? null : _deleteMainPhoto,
                      icon: const Icon(Icons.delete_outline, size: 20, color: Colors.redAccent),
                      label: const Text(
                        'Удалить',
                        style: TextStyle(color: Colors.redAccent),
                      ),
                    ),
                  ] else
                    FilledButton.icon(
                      onPressed: _saving ? null : _pickAndUploadMainPhoto,
                      icon: const Icon(Icons.add_photo_alternate, size: 20),
                      label: Text(AppLocalizations.of(context)!.addPhoto),
                      style: FilledButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: Colors.black,
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  Future<void> _pickAndUploadMainPhoto() async {
    final xFile = await _imagePicker.pickImage(
      source: ImageSource.gallery,
      maxWidth: 1920,
      imageQuality: 85,
    );
    if (xFile == null || !mounted) return;
    setState(() => _saving = true);
    try {
      final url = await widget.auth.uploadChildMainPhoto(widget.child.id, xFile.path);
      if (!mounted) return;
      widget.onChildUpdated?.call();
      setState(() {
        _mainPhotoUrl = url;
        _saving = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(AppLocalizations.of(context)!.photoSaved),
          behavior: SnackBarBehavior.floating,
        ),
      );
    } catch (e) {
      if (!mounted) return;
      setState(() => _saving = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.toString()),
          backgroundColor: Colors.red.shade700,
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  Future<void> _deleteMainPhoto() async {
    setState(() => _saving = true);
    try {
      await widget.auth.deleteChildMainPhoto(widget.child.id);
      if (!mounted) return;
      widget.onChildUpdated?.call();
      setState(() {
        _mainPhotoUrl = null;
        _saving = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(AppLocalizations.of(context)!.photoDeleted),
          behavior: SnackBarBehavior.floating,
        ),
      );
    } catch (e) {
      if (!mounted) return;
      setState(() => _saving = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.toString()),
          backgroundColor: Colors.red.shade700,
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  Widget _buildExtraPhotosSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Дополнительные фото',
          style: TextStyle(
            color: Colors.white54,
            fontSize: 12,
          ),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 12,
          runSpacing: 12,
          children: [
            ..._extraPhotoUrls.asMap().entries.map((e) => _extraPhotoThumb(
                  url: e.value,
                  index: e.key,
                  onTap: () => _showFullPhoto(e.value),
                  onDelete: () => _deleteExtraPhoto(e.key),
                )),
            if (!_saving)
              _addExtraPhotoButton(),
          ],
        ),
      ],
    );
  }

  Widget _extraPhotoThumb({
    required String url,
    required int index,
    required VoidCallback onTap,
    required VoidCallback onDelete,
  }) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        GestureDetector(
          onTap: onTap,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: SizedBox(
              width: 80,
              height: 80,
              child: Image.network(
                url,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Container(
                  color: const Color(0xFF1A1A1A),
                  child: const Icon(Icons.broken_image, color: Colors.grey),
                ),
              ),
            ),
          ),
        ),
        Positioned(
          top: -6,
          right: -6,
          child: Material(
            color: Colors.black87,
            shape: const CircleBorder(),
            child: InkWell(
              onTap: onDelete,
              customBorder: const CircleBorder(),
              child: const Padding(
                padding: EdgeInsets.all(6),
                child: Icon(Icons.close, size: 18, color: Colors.white),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _addExtraPhotoButton() {
    return GestureDetector(
      onTap: _pickAndUploadExtraPhoto,
      child: Container(
        width: 80,
        height: 80,
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.08),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.white24),
        ),
        child: const Icon(Icons.add_photo_alternate, color: Colors.white54, size: 32),
      ),
    );
  }

  Future<void> _pickAndUploadExtraPhoto() async {
    final xFile = await _imagePicker.pickImage(
      source: ImageSource.gallery,
      maxWidth: 1920,
      imageQuality: 85,
    );
    if (xFile == null || !mounted) return;
    setState(() => _saving = true);
    try {
      final list = await widget.auth.uploadChildExtraPhoto(widget.child.id, xFile.path);
      if (!mounted) return;
      widget.onChildUpdated?.call();
      setState(() {
        _extraPhotoUrls = list;
        _saving = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(AppLocalizations.of(context)!.photoAdded),
          behavior: SnackBarBehavior.floating,
        ),
      );
    } catch (e) {
      if (!mounted) return;
      setState(() => _saving = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.toString()),
          backgroundColor: Colors.red.shade700,
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  Future<void> _deleteExtraPhoto(int index) async {
    setState(() => _saving = true);
    try {
      final list = await widget.auth.deleteChildExtraPhoto(widget.child.id, index);
      if (!mounted) return;
      widget.onChildUpdated?.call();
      setState(() {
        _extraPhotoUrls = list;
        _saving = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(AppLocalizations.of(context)!.photoDeleted),
          behavior: SnackBarBehavior.floating,
        ),
      );
    } catch (e) {
      if (!mounted) return;
      setState(() => _saving = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.toString()),
          backgroundColor: Colors.red.shade700,
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  void _showFullPhoto(String? url) {
    if (url == null || url.isEmpty) return;
    showDialog<void>(
      context: context,
      builder: (ctx) => Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: const EdgeInsets.all(16),
        child: Stack(
          alignment: Alignment.topRight,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: InteractiveViewer(
                child: Image.network(
                  url,
                  fit: BoxFit.contain,
                  loadingBuilder: (_, child, progress) {
                    if (progress == null) return child;
                    return const Center(
                      child: CircularProgressIndicator(color: Color(0xFFD4AF37)),
                    );
                  },
                  errorBuilder: (_, __, ___) => const Center(
                    child: Icon(Icons.broken_image, size: 64, color: Colors.grey),
                  ),
                ),
              ),
            ),
            IconButton(
              onPressed: () => Navigator.of(ctx).pop(),
              icon: const Icon(Icons.close, color: Colors.white, size: 28),
              style: IconButton.styleFrom(
                backgroundColor: Colors.black54,
              ),
            ),
          ],
        ),
      ),
    );
  }

  static Widget _placeholder({Widget? child}) {
    return Container(
      color: const Color(0xFF1A1A1A),
      child: Center(
        child: child ?? Icon(Icons.person, color: Colors.grey[700], size: 48),
      ),
    );
  }

  static void _showEditText({
    required BuildContext context,
    required String label,
    required String value,
    required Future<void> Function(String) onSave,
  }) {
    final controller = TextEditingController(text: value);
    showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: const Color(0xFF121212),
        title: Text(label, style: const TextStyle(color: Colors.white)),
        content: TextField(
          controller: controller,
          autofocus: true,
          style: const TextStyle(color: Colors.white),
          decoration: InputDecoration(
            hintText: label,
            hintStyle: TextStyle(color: Colors.grey[600]),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.grey[700]!),
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: Text(AppLocalizations.of(context)!.cancel, style: const TextStyle(color: Colors.white70)),
          ),
          FilledButton(
            onPressed: () async {
              final v = controller.text.trim();
              Navigator.of(ctx).pop();
              await onSave(v);
            },
            child: Text(AppLocalizations.of(context)!.save),
          ),
        ],
      ),
    );
  }

  static void _showEditNumber({
    required BuildContext context,
    required String label,
    required double? value,
    required Future<void> Function(double?) onSave,
  }) {
    final controller = TextEditingController(
      text: value != null ? (value == value.roundToDouble() ? '${value.toInt()}' : value.toString()) : '',
    );
    showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: const Color(0xFF121212),
        title: Text(label, style: const TextStyle(color: Colors.white)),
        content: TextField(
          controller: controller,
          autofocus: true,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'[\d.]'))],
          style: const TextStyle(color: Colors.white),
          decoration: InputDecoration(
            hintText: label,
            hintStyle: TextStyle(color: Colors.grey[600]),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.grey[700]!),
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: Text(AppLocalizations.of(context)!.cancel, style: const TextStyle(color: Colors.white70)),
          ),
          TextButton(
            onPressed: () async {
              Navigator.of(ctx).pop();
              await onSave(null);
            },
            child: const Text('Очистить', style: TextStyle(color: Colors.white70)),
          ),
          FilledButton(
            onPressed: () async {
              final raw = controller.text.trim();
              final v = raw.isEmpty ? null : double.tryParse(raw);
              Navigator.of(ctx).pop();
              await onSave(v);
            },
            child: Text(AppLocalizations.of(context)!.save),
          ),
        ],
      ),
    );
  }

  static void _showEditDate({
    required BuildContext context,
    required DateTime? initial,
    required Future<void> Function(DateTime?) onSave,
  }) {
    DateTime? picked = initial;
    showDialog<void>(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (context, setDialogState) {
          return AlertDialog(
            backgroundColor: const Color(0xFF121212),
            title: Text(AppLocalizations.of(context)!.birthdateDialogTitle, style: const TextStyle(color: Colors.white)),
            content: SizedBox(
              width: double.maxFinite,
              child: CalendarDatePicker(
                initialDate: picked ?? DateTime.now(),
                firstDate: DateTime(1990),
                lastDate: DateTime.now(),
                onDateChanged: (d) => setDialogState(() => picked = d),
                initialCalendarMode: DatePickerMode.day,
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(ctx).pop(),
                child: Text(AppLocalizations.of(context)!.cancel, style: const TextStyle(color: Colors.white70)),
              ),
              TextButton(
                onPressed: () async {
                  Navigator.of(ctx).pop();
                  await onSave(null);
                },
                child: const Text('Очистить', style: TextStyle(color: Colors.white70)),
              ),
              FilledButton(
                onPressed: () async {
                  Navigator.of(ctx).pop();
                  if (picked != null) await onSave(picked);
                },
                child: Text(AppLocalizations.of(context)!.save),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _EditableRow extends StatelessWidget {
  const _EditableRow({
    required this.label,
    required this.value,
    this.onTap,
  });

  final String label;
  final String value;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: const TextStyle(
                      color: Colors.white54,
                      fontSize: 12,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    value,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            if (onTap != null)
              Icon(Icons.chevron_right, color: Colors.grey[600], size: 24),
          ],
        ),
      ),
    );
  }
}
