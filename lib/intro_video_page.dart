import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:video_player/video_player.dart';
import 'api/auth_service.dart';
import 'app_maintenance_page.dart';
import 'client_home_page.dart';
import 'gen_l10n/app_localizations.dart';
import 'login_page.dart';
import 'push/push_token_service.dart';

/// Экран при запуске: проигрывает видеоролик, по окончании переходит на вход.
class IntroVideoPage extends StatefulWidget {
  const IntroVideoPage({super.key, required this.auth});

  final AuthService auth;

  @override
  State<IntroVideoPage> createState() => _IntroVideoPageState();
}

class _IntroVideoPageState extends State<IntroVideoPage> {
  VideoPlayerController? _controller;
  bool _checkingVersion = true;
  bool _updateRequired = false;
  String? _storeUrl;
  bool _initialized = false;
  String? _error;
  bool _checkingSession = false;
  Timer? _videoEndFallbackTimer;
  bool _introExitStarted = false;

  bool _isClientRole(Map<String, dynamic> user) {
    final role = (user['role'] ?? '').toString().trim().toLowerCase();
    return role == 'client';
  }

  @override
  void initState() {
    super.initState();
    _checkVersionAndStart();
  }

  Future<void> _checkVersionAndStart() async {
    try {
      final appActive = await widget.auth.checkAppActive();
      if (!appActive) {
        if (!mounted) return;
        setState(() => _checkingVersion = false);
        openClientAppMaintenanceScreen(context, auth: widget.auth);
        return;
      }
    } catch (_) {}

    try {
      String? platform;
      if (Platform.isAndroid) {
        platform = 'android';
      } else if (Platform.isIOS) {
        platform = 'ios';
      }

      if (platform != null) {
        final info = await PackageInfo.fromPlatform();
        final result = await widget.auth.checkAppVersion(
          platform: platform,
          version: info.version,
        );

        if (!mounted) return;

        if (!result.appActive) {
          setState(() => _checkingVersion = false);
          openClientAppMaintenanceScreen(context, auth: widget.auth);
          return;
        }

        if (!result.allowed) {
          setState(() {
            _checkingVersion = false;
            _updateRequired = true;
            _storeUrl = result.storeUrl;
          });
          return;
        }
      }
    } catch (_) {}

    if (!mounted) return;
    setState(() => _checkingVersion = false);
    _initializeVideo();
  }

  void _initializeVideo() {
    _controller = VideoPlayerController.asset('assets/intro_logo.mp4')
      ..initialize().then((_) {
        if (!mounted) return;
        setState(() => _initialized = true);
        _controller?.play();
        _controller?.setLooping(false);
        _scheduleVideoEndFallback();
      }).catchError((Object e) {
        if (!mounted) return;
        setState(() {
          _initialized = false;
          _error = e.toString();
        });
      });
    _controller?.addListener(_onVideoUpdate);
  }

  void _scheduleVideoEndFallback() {
    final c = _controller;
    if (c == null || !c.value.isInitialized) return;
    final d = c.value.duration;
    if (d.inMilliseconds <= 0) return;
    _videoEndFallbackTimer?.cancel();
    _videoEndFallbackTimer = Timer(d + const Duration(seconds: 2), () {
      if (!mounted || _introExitStarted) return;
      _completeIntroFromVideo();
    });
  }

  void _completeIntroFromVideo() {
    final controller = _controller;
    if (controller == null) return;
    controller.removeListener(_onVideoUpdate);
    _goToLoginOrHome();
  }

  void _onVideoUpdate() {
    final controller = _controller;
    if (!mounted || controller == null || !controller.value.isInitialized) return;
    final durationMs = controller.value.duration.inMilliseconds;
    if (durationMs <= 0) return;
    final posMs = controller.value.position.inMilliseconds;
    // На части устройств position никогда не достигает duration — ловим «почти конец» и остановку.
    const toleranceMs = 500;
    final nearEnd = posMs >= durationMs - toleranceMs;
    final stoppedNearEnd =
        !controller.value.isPlaying && posMs >= durationMs - toleranceMs * 2;
    if (nearEnd || stoppedNearEnd) {
      _completeIntroFromVideo();
    }
  }

  Future<void> _goToLoginOrHome() async {
    if (_introExitStarted) return;
    _introExitStarted = true;
    _videoEndFallbackTimer?.cancel();
    _controller?.removeListener(_onVideoUpdate);

    setState(() => _checkingSession = true);
    try {
      final user = await widget.auth.restoreSessionIfPossible();
      if (!mounted) return;
      if (user != null && _isClientRole(user)) {
        final next = ClientHomePage(auth: widget.auth, user: user);
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => next),
        );
        unawaited(
          PushTokenServiceHolder.instance?.syncWithBackendIfLoggedIn(),
        );
      } else {
        if (user != null) {
          await widget.auth.clearToken();
        }
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => LoginPage(auth: widget.auth)),
        );
      }
    } catch (e, st) {
      if (kDebugMode) {
        debugPrint('restoreSessionIfPossible failed: $e\n$st');
      }
      if (!mounted) return;
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => LoginPage(auth: widget.auth)),
      );
    } finally {
      if (mounted) {
        setState(() => _checkingSession = false);
      }
    }
  }

  Future<void> _openStore() async {
    final url = _storeUrl;
    if (url == null || url.isEmpty) {
      return;
    }

    final uri = Uri.tryParse(url);
    if (uri == null) {
      return;
    }

    await launchUrl(uri, mode: LaunchMode.externalApplication);
  }

  @override
  void dispose() {
    _videoEndFallbackTimer?.cancel();
    _controller?.removeListener(_onVideoUpdate);
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_checkingSession) {
      return const Scaffold(
        backgroundColor: Colors.black,
        body: Center(
          child: CircularProgressIndicator(color: Colors.white),
        ),
      );
    }

    if (_checkingVersion) {
      return const Scaffold(
        backgroundColor: Colors.black,
        body: Center(
          child: CircularProgressIndicator(color: Colors.white),
        ),
      );
    }

    if (_updateRequired) {
      return Scaffold(
        backgroundColor: Colors.black,
        body: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.system_update, color: Colors.white70, size: 56),
                const SizedBox(height: 16),
                Text(
                  AppLocalizations.of(context)!.appUpdateRequiredMessage,
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Colors.white, fontSize: 18),
                ),
                const SizedBox(height: 24),
                FilledButton(
                  onPressed: _storeUrl != null ? _openStore : null,
                  child: Text(AppLocalizations.of(context)!.appUpdateButton),
                ),
              ],
            ),
          ),
        ),
      );
    }

    if (_error != null) {
      return Scaffold(
        backgroundColor: Colors.black,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, color: Colors.white54, size: 48),
              const SizedBox(height: 16),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Text(
                  _error!,
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Colors.white70),
                ),
              ),
              const SizedBox(height: 24),
              FilledButton(
                onPressed: _goToLoginOrHome,
                child: Text(AppLocalizations.of(context)!.continueButton),
              ),
            ],
          ),
        ),
      );
    }

    if (!_initialized) {
      return const Scaffold(
        backgroundColor: Colors.black,
        body: Center(
          child: CircularProgressIndicator(color: Colors.white),
        ),
      );
    }

    final controller = _controller;
    if (controller == null) {
      return const Scaffold(
        backgroundColor: Colors.black,
        body: Center(
          child: CircularProgressIndicator(color: Colors.white),
        ),
      );
    }

    final ar = controller.value.aspectRatio;
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        fit: StackFit.expand,
        children: [
          Center(
            child: AspectRatio(
              aspectRatio: ar > 0 ? ar : 16 / 9,
              child: VideoPlayer(controller),
            ),
          ),
          // Тап по экрану — пропустить и перейти к входу
          Positioned.fill(
            child: GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: _goToLoginOrHome,
            ),
          ),
        ],
      ),
    );
  }
}
