import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:tictac/core/extensions/localizations_extension.dart';
import 'package:tictac/core/navigation/flow_events.dart';
import 'package:tictac/core/providers/service_providers.dart' show navigate;
import 'package:tictac/core/spacing/app_spacing.dart';
import 'package:tictac/core/theme/app_theme.dart';
import 'package:tictac/core/widgets/buttons/game_button.dart';
import 'package:tictac/core/widgets/effects/cosmic_background.dart';
import 'package:tictac/core/widgets/snackbars/error_snackbar.dart';
import 'package:tictac/core/widgets/snackbars/warning_snackbar.dart';
import 'package:tictac/features/onboarding/presentation/widgets/avatar_selection_content.dart';
import 'package:tictac/features/settings/presentation/providers/settings_providers.dart';
import 'package:tictac/features/user/domain/entities/user.dart';
import 'package:tictac/features/user/presentation/providers/user_providers.dart';

@RoutePage()
class AvatarSelectionScreen extends ConsumerStatefulWidget {
  const AvatarSelectionScreen({super.key});

  @override
  ConsumerState<AvatarSelectionScreen> createState() => _AvatarSelectionScreenState();
}

class _AvatarSelectionScreenState extends ConsumerState<AvatarSelectionScreen> {
  String? _selectedAvatar;
  bool _isLoading = false;
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _saveAvatar() async {
    if (_selectedAvatar == null) {
      if (mounted) {
        WarningSnackbar.show(context, context.l10n.pleaseSelectAvatar);
      }
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final User? currentUser = ref.read(userProvider).value;
      if (currentUser != null) {
        await ref.read(userProvider.notifier).saveUser(currentUser.username, email: currentUser.email, avatar: _selectedAvatar);
        if (mounted) {
          navigate(ref, AvatarSelectionCompleted());
        }
      }
    } catch (e) {
      if (mounted) {
        ErrorSnackbar.showFromError(context, e);
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool isDarkMode = ref.watch(isDarkModeProvider);

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.adaptive.arrow_back),
          onPressed: () => navigate(ref, RequestBack()),
        ),
        title: Text(context.l10n.chooseAvatar),
        elevation: 0,
        backgroundColor: AppTheme.transparent,
      ),
      body: CosmicBackground(
        isDarkMode: isDarkMode,
        child: SafeArea(
          child: Column(
            children: <Widget>[
              Expanded(
                child: Scrollbar(
                  controller: _scrollController,
                  thumbVisibility: true,
                  radius: const Radius.circular(4),
                  thickness: 6,
                  interactive: true,
                  child: SingleChildScrollView(
                    controller: _scrollController,
                    physics: const AlwaysScrollableScrollPhysics(),
                    child: LayoutBuilder(
                      builder: (BuildContext context, BoxConstraints constraints) {
                        return SizedBox(
                          width: constraints.maxWidth,
                          child: Center(
                            child: ConstrainedBox(
                              constraints: const BoxConstraints(maxWidth: 500),
                              child: Padding(
                                padding: const EdgeInsets.all(24),
                                child: AvatarSelectionContent(
                                  selectedAvatar: _selectedAvatar,
                                  onAvatarSelected: (String avatar) {
                                    setState(() {
                                      _selectedAvatar = avatar;
                                    });
                                  },
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.fromLTRB(24, 16, 24, 24),
                child: Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 500),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        GameButton(text: context.l10n.continueButton, onPressed: _isLoading ? null : _saveAvatar, isLoading: _isLoading),
                        Gap(AppSpacing.sm),
                        TextButton(
                          onPressed: _isLoading
                              ? null
                              : () => navigate(ref, AvatarSelectionSkipped()),
                          child: Text(
                            context.l10n.skip,
                            style: Theme.of(
                              context,
                            ).textTheme.bodyLarge?.copyWith(color: isDarkMode ? AppTheme.darkTextSecondary : AppTheme.lightTextSecondary),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
