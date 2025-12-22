import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:tictac/core/theme/app_theme.dart';

class ConfettiWidget extends StatefulWidget {

  const ConfettiWidget({
    super.key,
    required this.isActive,
    this.color1 = const Color(0xFFFF3B5C),
    this.color2 = const Color(0xFFFF6B35),
    this.color3 = const Color(0xFFFFD700),
    this.onAnimationComplete,
  });
  final bool isActive;
  final Color color1;
  final Color color2;
  final Color color3;
  final VoidCallback? onAnimationComplete;

  @override
  State<ConfettiWidget> createState() => _ConfettiWidgetState();
}

class _ConfettiWidgetState extends State<ConfettiWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  final List<ConfettiParticle> _particles = <ConfettiParticle>[];
  final math.Random _random = math.Random();
  bool _hasCalledComplete = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 4000),
    );

    if (widget.onAnimationComplete != null) {
      _controller.addStatusListener(_statusListener);
    }

    if (widget.isActive) {
      _generateParticles();
      _controller.forward(from: 0.0);
    } else {
      _controller.stop();
    }
  }

  @override
  void didUpdateWidget(ConfettiWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isActive && !oldWidget.isActive) {
      _generateParticles();
      _hasCalledComplete = false;
      _controller.reset();
      _controller.forward();
    } else if (!widget.isActive && oldWidget.isActive) {
      _controller.stop();
      _particles.clear();
      _hasCalledComplete = false;
    }
    if (widget.onAnimationComplete != oldWidget.onAnimationComplete) {
      _controller.removeStatusListener(_statusListener);
      if (widget.onAnimationComplete != null) {
        _controller.addStatusListener(_statusListener);
      }
    }
  }

  void _statusListener(AnimationStatus status) {
    if (status == AnimationStatus.completed && widget.onAnimationComplete != null) {
      widget.onAnimationComplete!();
    }
  }

  bool _checkHasVisibleParticles(double progress) {
    const double fadeStart = 0.7;
    const double gravity = 0.6;
    const double airResistance = 0.988;
    
    for (final particle in _particles) {
      final effectiveProgress = math.max(0.0, progress - particle.delay);
      if (effectiveProgress <= 0) {
        continue;
      }
      
      final easedTime = _easeOut(effectiveProgress);
      final velocityY = particle.velocityY + (gravity * easedTime * 0.008);
      final velocityX = particle.velocityX * airResistance;
      final finalVelocityY = velocityY * airResistance;
      
      final windEffect = math.sin(easedTime * 2 * math.pi) * 0.03;
      final currentX = particle.x + (velocityX * easedTime * 1.2) + (windEffect * easedTime);
      final currentY = particle.y + (particle.speed * easedTime) + (finalVelocityY * easedTime * easedTime * 50);
      
      if (currentY > 1.2 || currentX < -0.2 || currentX > 1.2) {
        continue;
      }
      
      final opacity = effectiveProgress < fadeStart
          ? 1.0
          : 1.0 - ((effectiveProgress - fadeStart) / (1.0 - fadeStart));
      
      if (opacity > 0) {
        return true;
      }
    }
    return false;
  }

  static double _easeOut(double t) {
    return 1 - math.pow(1 - t, 3).toDouble();
  }

  void _generateParticles() {
    _particles.clear();
    const double centerX = 0.5;
    const double centerY = 0.1;

    const int particleCount = 75;

    for (var i = 0; i < particleCount; i++) {
      final angle = _random.nextDouble() * 2 * math.pi;
      final distance = _random.nextDouble() * 0.2;
      final explosionForce = 0.4 + _random.nextDouble() * 0.6;

      final horizontalMultiplier = 1.5 + _random.nextDouble() * 1.0;
      final initialVelocityX =
          math.cos(angle) * explosionForce * horizontalMultiplier * 0.9;
      final initialVelocityY = math.sin(angle).abs() * explosionForce * 0.15 +
          _random.nextDouble() * 0.08;

      final delay = _random.nextDouble() * 0.1;

      _particles.add(ConfettiParticle(
        x: centerX + math.cos(angle) * distance * 1.5,
        y: centerY + math.sin(angle) * distance * 0.5,
        size: 5 + _random.nextDouble() * 12,
        speed: 0.35 + _random.nextDouble() * 0.6,
        velocityX: initialVelocityX,
        velocityY: initialVelocityY,
        rotationSpeed: (_random.nextDouble() - 0.5) * 0.2,
        color: <Color>[
          widget.color1,
          widget.color2,
          widget.color3,
        ][_random.nextInt(3)],
        shape: _random.nextDouble() < 0.4
            ? ConfettiShape.circle
            : (_random.nextDouble() < 0.7
                ? ConfettiShape.square
                : ConfettiShape.rectangle),
        delay: delay,
      ));
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.isActive) {
      return const SizedBox.shrink();
    }

    return RepaintBoundary(
      child: AnimatedBuilder(
        animation: _controller,
        builder: (BuildContext context, Widget? child) {
          final progress = _controller.value;
          
          if (!_hasCalledComplete && progress > 0.85 && widget.onAnimationComplete != null) {
            final hasVisibleParticles = _checkHasVisibleParticles(progress);
            if (!hasVisibleParticles) {
              _hasCalledComplete = true;
              WidgetsBinding.instance.addPostFrameCallback((_) {
                if (mounted && widget.onAnimationComplete != null) {
                  widget.onAnimationComplete!();
                }
              });
            }
          }
          
          return CustomPaint(
            painter: ConfettiPainter(
              particles: _particles,
              progress: progress,
            ),
            size: Size.infinite,
          );
        },
      ),
    );
  }
}

enum ConfettiShape { circle, square, rectangle }

class ConfettiParticle {

  ConfettiParticle({
    required this.x,
    required this.y,
    required this.size,
    required this.speed,
    this.velocityX = 0.0,
    this.velocityY = 0.0,
    required this.rotationSpeed,
    required this.color,
    required this.shape,
    this.delay = 0.0,
  })  : width = size,
        height = shape == ConfettiShape.rectangle ? size * 0.6 : size;
  double x;
  double y;
  double size;
  double speed;
  double velocityX;
  double velocityY;
  double rotationSpeed;
  Color color;
  ConfettiShape shape;
  double rotation = 0;
  double width;
  double height;
  double delay;
}

class ConfettiPainter extends CustomPainter {

  ConfettiPainter({
    required this.particles,
    required this.progress,
  });
  final List<ConfettiParticle> particles;
  final double progress;
  final Paint _shadowPaint = Paint()..style = PaintingStyle.fill;
  final Paint _paint = Paint()..style = PaintingStyle.fill;

  @override
  void paint(Canvas canvas, Size size) {
    const double gravity = 0.6;
    const double airResistance = 0.988;
    const double shadowOffset = 1.0;
    const double fadeStart = 0.7;

    final visibleParticles = <_ParticleRenderData>[];

    for (final particle in particles) {
      final effectiveProgress = math.max(0.0, progress - particle.delay);
      if (effectiveProgress <= 0) {
        continue;
      }

      final easedTime = _easeOut(effectiveProgress);

      final velocityY = particle.velocityY + (gravity * easedTime * 0.008);
      final velocityX = particle.velocityX * airResistance;
      final finalVelocityY = velocityY * airResistance;

      final windEffect = math.sin(easedTime * 2 * math.pi) * 0.03;
      final currentX = particle.x +
          (velocityX * easedTime * 1.2) +
          (windEffect * easedTime);
      final currentY = particle.y +
          (particle.speed * easedTime) +
          (finalVelocityY * easedTime * easedTime * 50);

      if (currentY > 1.2 || currentX < -0.2 || currentX > 1.2) {
        continue;
      }

      final opacity = effectiveProgress < fadeStart
          ? 1.0
          : 1.0 - ((effectiveProgress - fadeStart) / (1.0 - fadeStart));

      if (opacity <= 0) {
        continue;
      }

      final rotation = particle.rotationSpeed * easedTime * 2.0;
      final baseOpacity = opacity * 0.95;
      final x = currentX * size.width;
      final y = currentY * size.height;

      visibleParticles.add(_ParticleRenderData(
        x: x,
        y: y,
        rotation: rotation,
        size: particle.size,
        width: particle.width,
        height: particle.height,
        shape: particle.shape,
        color: particle.color,
        opacity: baseOpacity,
      ));
    }

    for (final data in visibleParticles) {
      _shadowPaint.color =
          AppTheme.darkBackgroundColor.withValues(alpha: data.opacity * 0.2);
      _paint.color = data.color.withValues(alpha: data.opacity);

      canvas.save();
      canvas.translate(data.x, data.y);
      canvas.rotate(data.rotation);

      canvas.translate(shadowOffset, shadowOffset);

      if (data.shape == ConfettiShape.circle) {
        canvas.drawCircle(Offset.zero, data.size / 2, _shadowPaint);
      } else {
        canvas.drawRect(
          Rect.fromCenter(
            center: Offset.zero,
            width: data.width,
            height: data.height,
          ),
          _shadowPaint,
        );
      }

      canvas.translate(-shadowOffset, -shadowOffset);

      if (data.shape == ConfettiShape.circle) {
        canvas.drawCircle(Offset.zero, data.size / 2, _paint);
      } else {
        canvas.drawRect(
          Rect.fromCenter(
            center: Offset.zero,
            width: data.width,
            height: data.height,
          ),
          _paint,
        );
      }

      canvas.restore();
    }
  }

  static double _easeOut(double t) {
    return 1 - math.pow(1 - t, 3).toDouble();
  }

  @override
  bool shouldRepaint(ConfettiPainter oldDelegate) {
    return oldDelegate.progress != progress;
  }
}

class _ParticleRenderData {

  _ParticleRenderData({
    required this.x,
    required this.y,
    required this.rotation,
    required this.size,
    required this.width,
    required this.height,
    required this.shape,
    required this.color,
    required this.opacity,
  });
  final double x;
  final double y;
  final double rotation;
  final double size;
  final double width;
  final double height;
  final ConfettiShape shape;
  final Color color;
  final double opacity;
}
