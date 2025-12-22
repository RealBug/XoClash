import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tictac/core/constants/language_codes.dart';
import 'package:tictac/core/extensions/localizations_extension.dart';
import 'package:tictac/core/theme/app_theme.dart';
import 'package:tictac/core/widgets/ui/modal_bottom_sheet.dart';
import 'package:tictac/features/settings/domain/entities/settings.dart';
import 'package:tictac/features/settings/presentation/providers/settings_providers.dart';

class LanguageTile extends ConsumerWidget {

  const LanguageTile({
    super.key,
    required this.settings,
    required this.settingsNotifier,
  });
  final Settings settings;
  final SettingsNotifier settingsNotifier;

  void _showLanguageDialog(BuildContext context, WidgetRef ref) {
    final bool isDarkMode = ref.read(isDarkModeProvider);
    ModalBottomSheet.show(
      context: context,
      title: context.l10n.language,
      isDarkMode: isDarkMode,
      child: _LanguageSelector(
        currentLanguage: settings.languageCode,
        onLanguageSelected: (String languageCode) {
          settingsNotifier.setLanguage(languageCode);
          Navigator.of(context).pop();
        },
        isDarkMode: isDarkMode,
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bool isDarkMode = ref.watch(isDarkModeProvider);
    final String languageCode = ref.watch(languageCodeProvider);
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(
          color: isDarkMode
              ? AppTheme.getBorderColor(true)
              : AppTheme.getBorderColor(false, opacity: 0.5),
        ),
      ),
      child: ListTile(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        leading:
            Icon(Icons.language, color: Theme.of(context).colorScheme.primary),
        title: Text(
          context.l10n.language,
          style: Theme.of(context).textTheme.titleLarge,
        ),
        subtitle: Text(
          languageCode == LanguageCodes.french
              ? context.l10n.french
              : context.l10n.english,
          style: Theme.of(context).textTheme.bodyMedium,
        ),
        trailing: Icon(
          Icons.chevron_right,
          color: isDarkMode
              ? AppTheme.darkTextPrimary.withValues(alpha: 0.7)
              : AppTheme.lightTextSecondary,
        ),
        onTap: () => _showLanguageDialog(context, ref),
      ),
    );
  }
}

class _LanguageSelector extends StatefulWidget {

  const _LanguageSelector({
    required this.currentLanguage,
    required this.onLanguageSelected,
    required this.isDarkMode,
  });
  final String currentLanguage;
  final Function(String) onLanguageSelected;
  final bool isDarkMode;

  @override
  State<_LanguageSelector> createState() => _LanguageSelectorState();
}

class _LanguageSelectorState extends State<_LanguageSelector> {
  late String _selectedLanguage;

  @override
  void initState() {
    super.initState();
    _selectedLanguage = widget.currentLanguage;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        ListTile(
          title: Text(context.l10n.french),
          leading: Container(
            width: 20,
            height: 20,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: _selectedLanguage == LanguageCodes.french
                    ? Theme.of(context).colorScheme.primary
                    : AppTheme.lightTextSecondary,
                width: 2,
              ),
              color: _selectedLanguage == LanguageCodes.french
                  ? Theme.of(context).colorScheme.primary
                  : AppTheme.darkBackgroundColor.withValues(alpha: 0.0),
            ),
            child: _selectedLanguage == LanguageCodes.french
                ? const Icon(Icons.check, size: 14, color: AppTheme.darkTextPrimary)
                : null,
          ),
          onTap: () {
            setState(() {
              _selectedLanguage = LanguageCodes.french;
            });
            widget.onLanguageSelected(LanguageCodes.french);
          },
        ),
        ListTile(
          title: Text(context.l10n.english),
          leading: Container(
            width: 20,
            height: 20,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: _selectedLanguage == LanguageCodes.english
                    ? Theme.of(context).colorScheme.primary
                    : AppTheme.lightTextSecondary,
                width: 2,
              ),
              color: _selectedLanguage == LanguageCodes.english
                  ? Theme.of(context).colorScheme.primary
                  : AppTheme.darkBackgroundColor.withValues(alpha: 0.0),
            ),
            child: _selectedLanguage == LanguageCodes.english
                ? const Icon(Icons.check, size: 14, color: AppTheme.darkTextPrimary)
                : null,
          ),
          onTap: () {
            setState(() {
              _selectedLanguage = LanguageCodes.english;
            });
            widget.onLanguageSelected(LanguageCodes.english);
          },
        ),
      ],
    );
  }
}
