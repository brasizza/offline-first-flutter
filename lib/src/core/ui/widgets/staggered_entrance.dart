import 'package:flutter/material.dart';

/// Entrada suave (fade + slide) escalonada pelo índice do item na lista.
class StaggeredEntrance extends StatelessWidget {
  final int index;
  final Widget child;

  const StaggeredEntrance({super.key, required this.index, required this.child});

  @override
  Widget build(BuildContext context) {
    final delay = (index.clamp(0, 8)) * 60;
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: 1),
      duration: Duration(milliseconds: 380 + delay),
      curve: Interval(delay / (380 + delay), 1, curve: Curves.easeOutCubic),
      builder: (context, t, child) => Opacity(
        opacity: t,
        child: Transform.translate(offset: Offset(0, 24 * (1 - t)), child: child),
      ),
      child: child,
    );
  }
}
