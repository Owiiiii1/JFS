import 'dart:async';

import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

import 'gen_l10n/app_localizations.dart';

/// Full-screen YouTube stream/VOD via the official iframe player ([InAppWebView]),
/// not raw [webview_flutter] embed — avoids YouTube error 152–153 in many cases.
class ClientYoutubeLivePage extends StatefulWidget {
  const ClientYoutubeLivePage({
    super.key,
    required this.videoId,
    required this.titleText,
    this.fallbackOpenUri,
    this.livePlayerUi = true,
  });

  /// 11-character YouTube video id (same for live and replay).
  final String videoId;

  final String titleText;

  /// Opens in the YouTube app / browser if in-app playback still fails.
  final Uri? fallbackOpenUri;

  /// Uses live-style controls when true (banner is "YouTube live").
  final bool livePlayerUi;

  @override
  State<ClientYoutubeLivePage> createState() => _ClientYoutubeLivePageState();
}

class _ClientYoutubeLivePageState extends State<ClientYoutubeLivePage> {
  late final YoutubePlayerController _player;
  Timer? _readyTimeout;
  var _isReady = false;
  var _showStuckOverlay = false;

  @override
  void initState() {
    super.initState();
    _player = YoutubePlayerController(
      initialVideoId: widget.videoId,
      flags: YoutubePlayerFlags(
        isLive: widget.livePlayerUi,
        // false: if autoplay is blocked, autoPlay=true hides Play and shows a spinner forever.
        autoPlay: false,
        mute: false,
        enableCaption: false,
        controlsVisibleAtStart: true,
      ),
    );
    _readyTimeout = Timer(const Duration(seconds: 10), () {
      if (!mounted || _isReady) {
        return;
      }
      setState(() => _showStuckOverlay = true);
    });
  }

  @override
  void dispose() {
    _readyTimeout?.cancel();
    _player.dispose();
    super.dispose();
  }

  Future<void> _openFallback() async {
    final uri = widget.fallbackOpenUri;
    if (uri == null) {
      return;
    }
    if (!await canLaunchUrl(uri)) {
      return;
    }
    await launchUrl(uri, mode: LaunchMode.externalApplication);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final hasFallback = widget.fallbackOpenUri != null;
    const accent = Color(0xFFE53935);
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        title: Text(
          widget.titleText,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        actions: [
          if (hasFallback)
            IconButton(
              tooltip: l10n.eventsYoutubeLiveOpenExternally,
              onPressed: _openFallback,
              icon: const Icon(Icons.open_in_new),
            ),
        ],
      ),
      body: ColoredBox(
        color: Colors.black,
        child: SafeArea(
          child: Stack(
            children: [
              Center(
                child: YoutubePlayer(
                  controller: _player,
                  showVideoProgressIndicator: true,
                  progressIndicatorColor: accent,
                  liveUIColor: accent,
                  onReady: () {
                    if (!mounted) {
                      return;
                    }
                    _readyTimeout?.cancel();
                    setState(() {
                      _isReady = true;
                      _showStuckOverlay = false;
                    });
                  },
                  progressColors: const ProgressBarColors(
                    playedColor: accent,
                    handleColor: accent,
                    bufferedColor: Colors.white24,
                    backgroundColor: Colors.white12,
                  ),
                ),
              ),
              if (_showStuckOverlay)
                Positioned.fill(
                  child: ColoredBox(
                    color: const Color(0xCC000000),
                    child: Center(
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(maxWidth: 320),
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(
                                Icons.error_outline,
                                color: Colors.white70,
                                size: 30,
                              ),
                              const SizedBox(height: 10),
                              const Text(
                                'Video did not start in the embedded player.',
                                textAlign: TextAlign.center,
                                style: TextStyle(color: Colors.white),
                              ),
                              const SizedBox(height: 12),
                              if (hasFallback)
                                FilledButton.icon(
                                  onPressed: _openFallback,
                                  icon: const Icon(Icons.open_in_new),
                                  label: Text(l10n.eventsYoutubeLiveOpenExternally),
                                ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
