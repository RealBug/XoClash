import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tictac/core/extensions/color_extensions.dart';
import 'package:tictac/core/extensions/localizations_extension.dart';
import 'package:tictac/features/settings/presentation/providers/settings_providers.dart';

class HomeSubtitle extends ConsumerWidget {
  const HomeSubtitle({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bool isDarkMode = ref.watch(isDarkModeProvider);
    return Text(
      context.l10n.playOnline,
      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
            color: isDarkMode.textColorSecondary(0.7),
            fontWeight: FontWeight.w500,
            height: 1.4,
          ),
      textAlign: TextAlign.center,
    );
  }
}
