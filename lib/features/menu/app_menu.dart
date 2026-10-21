import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ziesta/core/app_links.dart';
import 'package:ziesta/features/menu/faq_screen.dart';
import 'package:ziesta/features/timer/timer_notifier.dart';
import 'package:ziesta/l10n/app_localizations.dart';

enum _MenuAction { share, faq }

class AppMenu extends ConsumerWidget {
  const AppMenu({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;

    return PopupMenuButton<_MenuAction>(
      tooltip: l10n.menu,
      onSelected: (action) {
        switch (action) {
          case _MenuAction.share:
            ref
                .read(audioChannelProvider)
                .shareText(l10n.shareMessage(releasesUrl));
          case _MenuAction.faq:
            Navigator.push(
              context,
              MaterialPageRoute<void>(builder: (_) => const FaqScreen()),
            );
        }
      },
      itemBuilder: (_) => [
        PopupMenuItem(value: _MenuAction.share, child: Text(l10n.shareApp)),
        PopupMenuItem(value: _MenuAction.faq, child: Text(l10n.faq)),
      ],
    );
  }
}
