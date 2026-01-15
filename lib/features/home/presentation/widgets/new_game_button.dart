import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tictac/core/extensions/localizations_extension.dart';
import 'package:tictac/core/providers/service_providers.dart' show navigationServiceProvider;
import 'package:tictac/core/widgets/buttons/game_button.dart';

class NewGameButton extends ConsumerWidget {
  const NewGameButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final navigation = ref.watch(navigationServiceProvider);

    return GameButton(
      text: context.l10n.newGame,
      onPressed: () => navigation.toGameMode(),
    );
  }
}


