import 'package:flutter/material.dart';
import 'package:tictac/core/constants/app_constants.dart';
import 'package:tictac/core/theme/app_theme.dart';

class SplashContent extends StatefulWidget {

  const SplashContent({
    super.key,
    required this.logoController,
    required this.scaleAnimation,
    required this.rotationAnimation,
    required this.showContent,
    required this.version,
  });
  final AnimationController logoController;
  final Animation<double> scaleAnimation;
  final Animation<double> rotationAnimation;
  final bool showContent;
  final String version;

  @override
  State<SplashContent> createState() => _SplashContentState();
}

class _SplashContentState extends State<SplashContent> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.darkSurfaceColor,
      body: Stack(
        children: <Widget>[
          Center(
            child: RepaintBoundary(
              child: AnimatedBuilder(
                animation: widget.logoController,
                builder: (BuildContext context, Widget? child) {
                  return Hero(
                    tag: AppConstants.heroTagAppLogo,
                    child: Transform.scale(
                      scale: widget.scaleAnimation.value,
                      child: Transform.rotate(
                        angle: widget.rotationAnimation.value,
                        child: Container(
                          width: AppTheme.appIconSize,
                          height: AppTheme.appIconSize,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(
                                AppTheme.appIconBorderRadius),
                            boxShadow: <BoxShadow>[
                              BoxShadow(
                                color: AppTheme.darkBackgroundColor
                                    .withValues(alpha: 0.5),
                                blurRadius: 20,
                                spreadRadius: 5,
                              ),
                            ],
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(
                                AppTheme.appIconBorderRadius),
                            child: Image.asset(
                              'assets/app_icon.png',
                              fit: BoxFit.contain,
                              filterQuality: FilterQuality.high,
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
          if (widget.showContent)
            Positioned(
              top: MediaQuery.of(context).size.height / 2 + 100,
              left: 0,
              right: 0,
              child: const Center(
                child: SizedBox(
                  width: 40,
                  height: 40,
                  child: CircularProgressIndicator(
                    strokeWidth: 3,
                    valueColor: AlwaysStoppedAnimation<Color>(
                      AppTheme.darkTextPrimary,
                    ),
                  ),
                ),
              ),
            ),
          if (widget.version.isNotEmpty)
            Positioned(
              bottom: 40,
              left: 0,
              right: 0,
              child: Center(
                child: Text(
                  widget.version,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: AppTheme.darkTextPrimary.withValues(alpha: 0.7),
                        fontWeight: FontWeight.w500,
                      ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

