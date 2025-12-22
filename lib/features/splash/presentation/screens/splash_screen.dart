import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tictac/core/theme/app_theme.dart';
import 'package:tictac/features/settings/presentation/providers/settings_providers.dart';
import 'package:tictac/features/splash/presentation/widgets/splash_content.dart';

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen> with TickerProviderStateMixin {
  late AnimationController _logoController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _rotationAnimation;
  bool _showContent = false;

  @override
  void initState() {
    super.initState();
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: AppTheme.darkSurfaceColor,
        statusBarIconBrightness: Brightness.light,
        systemNavigationBarColor: AppTheme.darkSurfaceColor,
        systemNavigationBarIconBrightness: Brightness.light,
      ),
    );
    _logoController = AnimationController(vsync: this, duration: const Duration(milliseconds: 1500));

    _scaleAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(parent: _logoController, curve: Curves.elasticOut));

    _rotationAnimation = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween<double>(begin: -0.2, end: 0.15).chain(
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
    ]).animate(_logoController);

    Future<void>.microtask(() {
      if (mounted && _logoController.status == AnimationStatus.dismissed) {
        _logoController.forward();
      }
    });

    Future<void>.delayed(const Duration(milliseconds: 500), () {
      if (mounted) {
        setState(() {
          _showContent = true;
        });
      }
    });

  }

  @override
  void dispose() {
    _logoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final appVersionAsync = ref.watch(appVersionProvider);
    final version = appVersionAsync.value ?? '';

    return SplashContent(
      logoController: _logoController,
      scaleAnimation: _scaleAnimation,
      rotationAnimation: _rotationAnimation,
      showContent: _showContent,
      version: version,
    );
  }
}

