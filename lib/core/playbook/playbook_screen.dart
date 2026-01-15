import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:playbook_ui/playbook_ui.dart';
import 'package:tictac/core/extensions/localizations_extension.dart';
import 'package:tictac/core/playbook/playbook_stories.dart';
import 'package:tictac/core/providers/service_providers.dart' show navigationServiceProvider;
import 'package:tictac/core/theme/app_theme.dart';

@RoutePage()
class PlaybookScreen extends ConsumerStatefulWidget {
  const PlaybookScreen({super.key});

  @override
  ConsumerState<PlaybookScreen> createState() => _PlaybookScreenState();
}

class _PlaybookScreenState extends ConsumerState<PlaybookScreen> {
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
              final navigation = ref.read(navigationServiceProvider);
              if (navigation.canPop()) {
                navigation.pop();
              } else {
                navigation.popAllAndNavigateToHome();
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
