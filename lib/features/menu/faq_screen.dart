import 'package:flutter/material.dart';
import 'package:ziesta/l10n/app_localizations.dart';

class FaqScreen extends StatelessWidget {
  const FaqScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final muted = theme.colorScheme.onSurfaceVariant;

    final items = [
      (l10n.faq1Q, l10n.faq1A),
      (l10n.faq2Q, l10n.faq2A),
      (l10n.faq3Q, l10n.faq3A),
      (l10n.faq4Q, l10n.faq4A),
      (l10n.faq5Q, l10n.faq5A),
      (l10n.faq6Q, l10n.faq6A),
      (l10n.faq7Q, l10n.faq7A),
      (l10n.faq8Q, l10n.faq8A),
      (l10n.faq9Q, l10n.faq9A),
      (l10n.faq10Q, l10n.faq10A),
      (l10n.faq11Q, l10n.faq11A),
      (l10n.faq12Q, l10n.faq12A),
      (l10n.faq13Q, l10n.faq13A),
    ];

    return Scaffold(
      appBar: AppBar(title: Text(l10n.helpTitle.toUpperCase())),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
        children: [
          for (final (question, answer) in items)
            ExpansionTile(
              title: Text(question, style: theme.textTheme.titleMedium),
              shape: const Border(),
              collapsedShape: const Border(),
              expandedCrossAxisAlignment: CrossAxisAlignment.start,
              childrenPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              children: [
                Text(
                  answer,
                  style: theme.textTheme.bodyMedium?.copyWith(color: muted),
                ),
              ],
            ),
        ],
      ),
    );
  }
}
