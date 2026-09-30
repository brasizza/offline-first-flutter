import 'package:flutter/material.dart';

/// Placeholder pulsante exibido enquanto a lista local é carregada.
class BoxCardSkeleton extends StatefulWidget {
  const BoxCardSkeleton({super.key});

  @override
  State<BoxCardSkeleton> createState() => _BoxCardSkeletonState();
}

class _BoxCardSkeletonState extends State<BoxCardSkeleton> with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 900),
    lowerBound: 0.45,
  )..repeat(reverse: true);

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme.surfaceContainerHighest;

    Widget bar(double width, double height, [double radius = 8]) => Container(
      width: width,
      height: height,
      decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(radius)),
    );

    return Card(
      child: FadeTransition(
        opacity: _controller,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              bar(52, 52, 16),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        bar(140, 16),
                        const Spacer(),
                        bar(80, 22, 100),
                      ],
                    ),
                    const SizedBox(height: 10),
                    bar(100, 12),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        bar(60, 20),
                        const SizedBox(width: 8),
                        bar(60, 20),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
