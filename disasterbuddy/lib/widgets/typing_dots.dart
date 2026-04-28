import 'package:flutter/material.dart';

class TypingDots extends StatefulWidget {
  const TypingDots({super.key});

  @override
  State<TypingDots> createState() => _TypingDotsState();
}

class _TypingDotsState extends State<TypingDots>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  double _opacityFor(double t, double phase) {
    final shifted = (t - phase) % 1.0;
    if (shifted < 0.3) {
      return 0.3 + (shifted / 0.3) * 0.7;
    } else if (shifted < 0.6) {
      return 1.0 - ((shifted - 0.3) / 0.3) * 0.7;
    } else {
      return 0.3;
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, _) {
        final t = _controller.value;
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            _dot(_opacityFor(t, 0.0)),
            const SizedBox(width: 4),
            _dot(_opacityFor(t, 0.15)),
            const SizedBox(width: 4),
            _dot(_opacityFor(t, 0.30)),
          ],
        );
      },
    );
  }

  Widget _dot(double opacity) {
    return Container(
      width: 7,
      height: 7,
      decoration: BoxDecoration(
        color: const Color(0xff888888).withValues(alpha: opacity),
        shape: BoxShape.circle,
      ),
    );
  }
}
