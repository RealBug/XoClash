import 'package:flutter/material.dart';

/// Wrapper for playbook scenarios with RepaintBoundary optimization
class OptimizedScenario extends StatelessWidget {
  const OptimizedScenario({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(child: child);
  }
}
