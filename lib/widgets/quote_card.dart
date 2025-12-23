// quote card 

import 'package:flutter/material.dart';
import '../utils/app_localizations.dart';

class QuoteCard extends StatelessWidget {
  const QuoteCard({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context);
    final bg = theme.colorScheme.primary.withValues(alpha: 0.12);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 22),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        children: [
          Text(
            l10n.quoteText,
            textAlign: TextAlign.center,
            style: theme.textTheme.bodyMedium?.copyWith(
              fontStyle: FontStyle.italic,
              color: theme.textTheme.bodySmall?.color?.withValues(alpha: 0.85),
            ),
          ),
          const SizedBox(height: 10),
          Align(
            alignment: Alignment.centerRight,
            child: Text(l10n.quoteAuthor, style: theme.textTheme.bodySmall),
          ),
        ],
      ),
    );
  }
}
