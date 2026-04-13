import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

import 'gen_l10n/app_localizations.dart';

const _kGold = Color(0xFFD4AF37);

class ClientEventCheckinPage extends StatelessWidget {
  const ClientEventCheckinPage({super.key, required this.checkinCode});

  final String checkinCode;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        foregroundColor: _kGold,
        elevation: 0,
        title: Text(l10n.eventProgressCheckin),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                l10n.eventProgressCheckinPrompt,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: _kGold,
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 28),
              Expanded(
                child: Center(
                  child: SizedBox(
                    width: 280,
                    height: 280,
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(18),
                        border: Border.all(color: _kGold, width: 2),
                        boxShadow: const [
                          BoxShadow(
                            color: Color(0x33D4AF37),
                            blurRadius: 18,
                            spreadRadius: 1,
                          ),
                        ],
                      ),
                      padding: const EdgeInsets.all(10),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(14),
                        ),
                        padding: const EdgeInsets.all(10),
                        child: QrImageView(
                          data: checkinCode,
                          backgroundColor: Colors.white,
                          foregroundColor: Colors.black,
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
