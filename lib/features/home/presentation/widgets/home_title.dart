import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tictac/core/extensions/color_extensions.dart';
import 'package:tictac/core/extensions/localizations_extension.dart';
import 'package:tictac/features/settings/presentation/providers/settings_providers.dart';
import 'package:tictac/features/user/domain/entities/user.dart';
import 'package:tictac/features/user/presentation/providers/user_providers.dart';

class HomeTitle extends ConsumerWidget {
  const HomeTitle({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bool isDarkMode = ref.watch(isDarkModeProvider);
    final User? user = ref.watch(userProvider.select((AsyncValue<User?> asyncValue) => asyncValue.value));
    return Column(
      children: <Widget>[
        if (user != null) ...<Widget>[
          Text(
            context.l10n.hello(user.username),
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: isDarkMode.textColorSecondary(0.8),
                  fontWeight: FontWeight.w600,
                ),
          ),
        ],
      ],
    );
  }
}
