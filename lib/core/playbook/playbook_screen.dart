import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:playbook_ui/playbook_ui.dart';
import 'package:tictac/core/extensions/localizations_extension.dart';
import 'package:tictac/core/playbook/playbook_stories.dart';
import 'package:tictac/core/routing/app_router.dart';
import 'package:tictac/core/theme/app_theme.dart';

@RoutePage()
class PlaybookScreen extends StatefulWidget {
  const PlaybookScreen({super.key});

  @override
  State<PlaybookScreen> createState() => _PlaybookScreenState();
}

class _PlaybookScreenState extends State<PlaybookScreen> {
  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Theme(
      data: isDarkMode ? AppTheme.darkTheme : AppTheme.lightTheme,
      child: Scaffold(
        appBar: AppBar(
          title: Text(context.l10n.componentLibrary),
          leading: IconButton(
            icon: Icon(Icons.adaptive.arrow_back),
            onPressed: () {
              if (context.router.canPop()) {
                context.router.pop();
              } else {
                while (context.router.canPop()) {
                  context.router.pop();
                }
                context.router.push(const HomeRoute());
              }
            },
          ),
        ),
        body: RepaintBoundary(
          child: ClipRect(
            child: MediaQuery.removePadding(
              context: context,
              removeTop: true,
              child: PlaybookGallery(title: context.l10n.componentLibrary, playbook: playbook),
            ),
          ),
        ),
      ),
    );
  }
}
