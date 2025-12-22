import 'package:flutter/material.dart';

class ScrollableSection extends StatelessWidget {

  const ScrollableSection({
    super.key,
    required this.controller,
    required this.child,
    this.showScrollbar = true,
  });
  final ScrollController controller;
  final Widget child;
  final bool showScrollbar;

  @override
  Widget build(BuildContext context) {
    if (!showScrollbar) {
      return SingleChildScrollView(
        controller: controller,
        physics: const AlwaysScrollableScrollPhysics(),
        child: child,
      );
    }

    return Scrollbar(
      controller: controller,
      thumbVisibility: true,
      radius: const Radius.circular(4),
      thickness: 6,
      interactive: true,
      child: SingleChildScrollView(
        controller: controller,
        physics: const AlwaysScrollableScrollPhysics(),
        child: child,
      ),
    );
  }
}

