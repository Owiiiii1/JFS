import 'package:flutter/material.dart';

import 'gen_l10n/app_localizations.dart';

/// True when the dashboard (or ticket-events) says the user has no pass and the feature is off — skip GET.
bool shouldBlockClientTicketPrefetch({
  required bool serviceEnabled,
  required bool? userHasTicket,
}) {
  return !serviceEnabled && userHasTicket == false;
}

Future<void> showClientTicketServiceUnavailableDialog(
  BuildContext context,
  AppLocalizations l10n, {
  String? message,
}) async {
  await showDialog<void>(
    context: context,
    builder: (ctx) => AlertDialog(
      title: Text(l10n.clientTicketServiceUnavailableTitle),
      content: Text(
        message ?? l10n.clientTicketServiceUnavailableBody,
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(ctx).pop(),
          child: Text(l10n.close),
        ),
      ],
    ),
  );
}
