import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'api/auth_service.dart';
import 'login_page.dart';

/// Экран при запуске: проигрывает видеоролик, по окончании переходит на вход.
class IntroVideoPage extends StatefulWidget {
  const IntroVideoPage({super.key, required this.auth});

  final AuthService auth;

  @override
  State<IntroVideoPage> createState() => _IntroVideoPageState();
}

class _IntroVideoPageState extends State<IntroVideoPage> {
  late VideoPlayerController _controller;
  bool _initialized = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.asset('assets/intro_logo.mp4')
      ..initialize().then((_) {
        if (!mounted) return;
        setState(() => _initialized = true);
        _controller.play();
        _controller.setLooping(false);
      }).catchError((Object e) {
        if (!mounted) return;
        setState(() {
          _initialized = false;
          _error = e.toString();
        });
      });
    _controller.addListener(_onVideoUpdate);
  }

  void _onVideoUpdate() {
    if (!mounted || !_controller.value.isInitialized) return;
    if (_controller.value.position >= _controller.value.duration &&
        _controller.value.duration.inMilliseconds > 0) {
      _controller.removeListener(_onVideoUpdate);
      _goToLogin();
    }
  }

  void _goToLogin() {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => LoginPage(auth: widget.auth)),
    );
  }

  @override
  void dispose() {
    _controller.removeListener(_onVideoUpdate);
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
                onPressed: _goToLogin,
                child: const Text('Continue'),
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

    final ar = _controller.value.aspectRatio;
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        fit: StackFit.expand,
        children: [
          Center(
            child: AspectRatio(
              aspectRatio: ar > 0 ? ar : 16 / 9,
              child: VideoPlayer(_controller),
            ),
          ),
          // Тап по экрану — пропустить и перейти к входу
          Positioned.fill(
            child: GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: _goToLogin,
            ),
          ),
        ],
      ),
    );
  }
}
