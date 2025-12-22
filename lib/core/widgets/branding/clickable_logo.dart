import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tictac/core/constants/app_constants.dart';
import 'package:tictac/core/theme/app_theme.dart';
import 'package:tictac/core/widgets/branding/app_logo.dart';
import 'package:tictac/features/settings/presentation/providers/settings_providers.dart'
    show isDarkModeProvider, animationsEnabledProvider;

class ClickableLogo extends ConsumerStatefulWidget {

  const ClickableLogo({
    super.key,
    this.fontSize = 56,
    this.blurRadius = 30,
    this.spreadRadius = 5,
    this.shadowBlurRadius = 20,
    this.shadowSpreadRadius = 2,
  });
  final double fontSize;
  final double blurRadius;
  final double spreadRadius;
  final double shadowBlurRadius;
  final double shadowSpreadRadius;

  @override
  ConsumerState<ClickableLogo> createState() => _ClickableLogoState();
}

class _ClickableLogoState extends ConsumerState<ClickableLogo>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late AnimationController _logoClickController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _rotationAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat(reverse: true);

    _logoClickController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );

    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 1.1,
    ).animate(
      CurvedAnimation(
        parent: _logoClickController,
        curve: Curves.elasticOut,
      ),
    );

    _rotationAnimation = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween<double>(begin: 0.0, end: 0.15).chain(
          CurveTween(curve: Curves.easeOutCubic),
        ),
        weight: 0.2,
      ),
      TweenSequenceItem(
        tween: Tween<double>(begin: 0.15, end: -0.12).chain(
          CurveTween(curve: Curves.easeInOut),
        ),
        weight: 0.2,
      ),
      TweenSequenceItem(
        tween: Tween<double>(begin: -0.12, end: 0.08).chain(
          CurveTween(curve: Curves.easeInOut),
        ),
        weight: 0.2,
      ),
      TweenSequenceItem(
        tween: Tween<double>(begin: 0.08, end: -0.05).chain(
          CurveTween(curve: Curves.easeInOut),
        ),
        weight: 0.2,
      ),
      TweenSequenceItem(
        tween: Tween<double>(begin: -0.05, end: 0.0).chain(
          CurveTween(curve: Curves.easeOutCubic),
        ),
        weight: 0.2,
      ),
    ]).animate(_logoClickController);
  }

  @override
  void dispose() {
    _animationController.dispose();
    _logoClickController.dispose();
    super.dispose();
  }

  void _onLogoTap() {
    _logoClickController.reset();
    _logoClickController.forward();
  }

  @override
  Widget build(BuildContext context) {
    final bool isDarkMode = ref.watch(isDarkModeProvider);
    final bool animationsEnabled = ref.watch(animationsEnabledProvider);
    final AppLogo logo = AppLogo(
      isDarkMode: isDarkMode,
      fontSize: widget.fontSize,
      blurRadius: widget.blurRadius,
      spreadRadius: widget.spreadRadius,
      shadowBlurRadius: widget.shadowBlurRadius,
      shadowSpreadRadius: widget.shadowSpreadRadius,
    );

    if (!animationsEnabled) {
      return Hero(
        tag: AppConstants.heroTagAppLogo,
        child: GestureDetector(
          onTap: _onLogoTap,
          child: logo,
        ),
      );
    }

    return Hero(
      tag: AppConstants.heroTagAppLogo,
      child: GestureDetector(
        onTap: _onLogoTap,
        child: AnimatedBuilder(
          animation: Listenable.merge(<Listenable?>[_animationController, _logoClickController]),
          builder: (BuildContext context, Widget? child) {
            final double animationValue = _animationController.value;
            final double scale = 1.0 + (animationValue * 0.05);
            final double haloOpacity =
                0.2 + (math.sin(animationValue * 2 * math.pi) * 0.5 + 0.5) * 0.25;

            final double clickScale = _logoClickController.status != AnimationStatus.dismissed
                ? _scaleAnimation.value
                : 1.0;
            
            final double combinedScale = scale * (clickScale == 0.0 ? 1.0 : clickScale);
            final double clickRotation = _logoClickController.status != AnimationStatus.dismissed
                ? _rotationAnimation.value
                : 0.0;

            return Transform.scale(
              scale: combinedScale,
              child: Transform.rotate(
                angle: clickRotation,
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(AppTheme.appIconBorderRadius),
                    boxShadow: <BoxShadow>[
                      BoxShadow(
                        color: AppTheme.getPrimaryColor(isDarkMode)
                            .withValues(alpha: haloOpacity * 0.6),
                        blurRadius: 40,
                      ),
                      BoxShadow(
                        color: AppTheme.getPrimaryColor(isDarkMode)
                            .withValues(alpha: haloOpacity * 0.6),
                        blurRadius: 50,
                        spreadRadius: 8,
                      ),
                      BoxShadow(
                        color: AppTheme.getPrimaryColor(isDarkMode)
                            .withValues(alpha: haloOpacity * 0.3),
                        blurRadius: 60,
                        spreadRadius: 12,
                      ),
                    ],
                  ),
                  child: logo,
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}


