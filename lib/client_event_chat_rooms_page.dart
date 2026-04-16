import 'package:flutter/material.dart';

import 'app_settings.dart';
import 'api/auth_service.dart';
import 'client_event_chat_room_page.dart';
import 'gen_l10n/app_localizations.dart';

const _kChatRoomsBg = Color(0xFF131313);
const _kChatRoomsCard = Color(0xFF1B1B1B);
const _kChatRoomsPrimary = Color(0xFFF2CA50);

class ClientEventChatRoomsPage extends StatelessWidget {
  const ClientEventChatRoomsPage({
    super.key,
    required this.auth,
    required this.rooms,
  });

  final AuthService auth;
  final List<ClientChatRoomSummary> rooms;

  String _timeLabel(DateTime? dt) {
    if (dt == null) return '';
    final d = dt.toLocal();
    return AppSettings.formatTime(d.hour, d.minute);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      backgroundColor: _kChatRoomsBg,
      appBar: AppBar(
        backgroundColor: _kChatRoomsBg,
        foregroundColor: _kChatRoomsPrimary,
        elevation: 0,
        title: Text(l10n.eventSettingsChatTitle),
      ),
      body: rooms.isEmpty
          ? Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Text(
                  l10n.chatNoRooms,
                  style: const TextStyle(color: Colors.white70, fontSize: 14),
                  textAlign: TextAlign.center,
                ),
              ),
            )
          : ListView.separated(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
              itemCount: rooms.length,
              separatorBuilder: (_, index) => const SizedBox(height: 10),
              itemBuilder: (context, index) {
                final room = rooms[index];
                return Material(
                  color: Colors.transparent,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(14),
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute<void>(
                          builder: (_) => ClientEventChatRoomPage(
                            auth: auth,
                            roomId: room.id,
                            title: room.title.isNotEmpty
                                ? room.title
                                : room.brandName,
                            subtitle: room.brandName,
                          ),
                        ),
                      );
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: _kChatRoomsCard,
                        borderRadius: BorderRadius.circular(14),
                      ),
                      padding: const EdgeInsets.fromLTRB(14, 12, 14, 12),
                      child: Row(
                        children: [
                          Container(
                            width: 42,
                            height: 42,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: _kChatRoomsPrimary.withValues(alpha: 0.12),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.chat_bubble_outline,
                              color: _kChatRoomsPrimary,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  room.title.isNotEmpty
                                      ? room.title
                                      : room.brandName,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 15,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                const SizedBox(height: 3),
                                Text(
                                  (room.lastMessagePreview ?? '').trim().isEmpty
                                      ? l10n.chatNoMessagesYet
                                      : (room.lastMessagePreview ?? ''),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                    color: Colors.white60,
                                    fontSize: 12.5,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 8),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                _timeLabel(room.lastMessageAt),
                                style: const TextStyle(
                                  color: Colors.white38,
                                  fontSize: 11,
                                ),
                              ),
                              const SizedBox(height: 6),
                              Text(
                                '${room.membersCount}',
                                style: const TextStyle(
                                  color: _kChatRoomsPrimary,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
    );
  }
}
