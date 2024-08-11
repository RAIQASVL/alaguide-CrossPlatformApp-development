import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/providers/language_provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class LanguageSelectionPage extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentLanguage = ref.watch(languageProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.selectLanguage),
      ),
      body: ListView(
        children: [
          _buildLanguageListTile(context, ref, 'en', 'English'),
          _buildLanguageListTile(context, ref, 'ru', 'Русский'),
          _buildLanguageListTile(context, ref, 'kk', 'Қазақша'),
        ],
      ),
    );
  }

  ListTile _buildLanguageListTile(BuildContext context, WidgetRef ref,
      String languageCode, String languageName) {
    final currentLanguage = ref.watch(languageProvider);
    return ListTile(
      title: Text(languageName),
      trailing: currentLanguage.languageCode == languageCode
          ? Icon(Icons.check)
          : null,
      onTap: () async {
        // ignore: await_only_futures
        await ref.read(languageProvider.notifier).setLanguage(languageCode);
        Navigator.pop(context);
      },
    );
  }
}
