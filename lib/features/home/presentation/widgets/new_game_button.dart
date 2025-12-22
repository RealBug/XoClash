import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tictac/core/extensions/localizations_extension.dart';
import 'package:tictac/core/routing/app_router.dart';
import 'package:tictac/core/widgets/buttons/game_button.dart';

class NewGameButton extends ConsumerWidget {
  const NewGameButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return GameButton(
      text: context.l10n.newGame,
      onPressed: () {
        context.router.push(const GameModeRoute());
      },
    );
  }
}


