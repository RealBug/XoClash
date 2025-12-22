import 'package:flutter/material.dart';

class AnimatedCellWrapper extends StatefulWidget {

  const AnimatedCellWrapper({
    super.key,
    required this.row,
    required this.col,
    required this.boardSize,
    required this.animationsEnabled,
    required this.child,
    required this.isCellEmpty,
    required this.isBoardEmpty,
  });
  final int row;
  final int col;
  final int boardSize;
  final bool animationsEnabled;
  final Widget child;
  final bool isCellEmpty;
  final bool isBoardEmpty;

  @override
  State<AnimatedCellWrapper> createState() => _AnimatedCellWrapperState();
}

class _AnimatedCellWrapperState extends State<AnimatedCellWrapper>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _opacityAnimation;
  late Animation<double> _scaleAnimation;
  bool _hasAnimated = false;

  void _startAnimation() {
    if (!widget.animationsEnabled || _hasAnimated) {
      return;
    }

    final delay = (widget.row * widget.boardSize + widget.col) * 60;
    Future<void>.delayed(Duration(milliseconds: delay), () {
      if (mounted && !_hasAnimated) {
        _controller.forward();
        _hasAnimated = true;
      }
    });
  }

  @override
  void initState() {
    super.initState();
    if (widget.animationsEnabled) {
      _controller = AnimationController(
        vsync: this,
        duration: const Duration(milliseconds: 700),
      );

      _opacityAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(
          parent: _controller,
          curve: Curves.easeOut,
        ),
      );

      _scaleAnimation = Tween<double>(begin: 0.5, end: 1.0).animate(
        CurvedAnimation(
          parent: _controller,
          curve: Curves.easeOutBack,
        ),
      );

      if (widget.isCellEmpty) {
        _startAnimation();
      } else {
        _controller.value = 1.0;
        _hasAnimated = true;
      }
    }
  }

  @override
  void didUpdateWidget(AnimatedCellWrapper oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.animationsEnabled) {
      if (widget.isBoardEmpty &&
          !oldWidget.isBoardEmpty &&
          widget.isCellEmpty) {
        _hasAnimated = false;
        _controller.reset();
        _startAnimation();
      }
    }
  }

  @override
  void dispose() {
    if (widget.animationsEnabled) {
      _controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.animationsEnabled) {
      return widget.child;
    }

    return AnimatedBuilder(
      animation: _controller,
      child: widget.child,
      builder: (BuildContext context, Widget? child) {
        return Opacity(
          opacity: _opacityAnimation.value,
          child: Transform.scale(
            scale: _scaleAnimation.value,
            child: child!,
          ),
        );
      },
    );
  }
}


