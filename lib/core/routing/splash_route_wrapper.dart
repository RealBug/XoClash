import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tictac/core/routing/app_router.dart';
import 'package:tictac/features/splash/presentation/screens/splash_screen.dart';
import 'package:tictac/features/user/domain/entities/user.dart';
import 'package:tictac/features/user/presentation/providers/user_providers.dart';

@RoutePage(name: 'SplashRoute')
class SplashRouteWrapper extends ConsumerStatefulWidget {
  const SplashRouteWrapper({super.key});

  @override
  ConsumerState<SplashRouteWrapper> createState() => _SplashRouteWrapperState();
}

class _SplashRouteWrapperState extends ConsumerState<SplashRouteWrapper> {
  bool _hasNavigated = false;
  late final DateTime _startTime;
  bool _navigationScheduled = false;

  @override
  void initState() {
    super.initState();
    _startTime = DateTime.now();
  }

  void _navigateToNextScreen(AsyncValue<User?> userAsync) {
    if (_hasNavigated || !mounted) {
      return;
    }
    _hasNavigated = true;

    final User? user = userAsync.value;

    if (user != null) {
      context.router.push(const HomeRoute());
    } else {
      context.router.push(const AuthRoute());
    }
  }

  void _scheduleNavigation(AsyncValue<User?> userAsync) {
    if (_navigationScheduled || _hasNavigated || !mounted) {
      return;
    }
    _navigationScheduled = true;

    final elapsed = DateTime.now().difference(_startTime);
    final remaining = const Duration(seconds: 3) - elapsed;

    if (remaining.isNegative || remaining == Duration.zero) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted && !_hasNavigated) {
          _navigateToNextScreen(userAsync);
        }
      });
    } else {
      Future<void>.delayed(remaining).then((_) {
        if (mounted && !_hasNavigated) {
          _navigateToNextScreen(userAsync);
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final AsyncValue<User?> userAsync = ref.watch(userProvider);

    if (!_hasNavigated && !userAsync.isLoading) {
      _scheduleNavigation(userAsync);
    }

    return const SplashScreen();
  }
}
