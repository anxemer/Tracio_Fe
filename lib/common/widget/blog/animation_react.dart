import 'package:flutter/widgets.dart';

class AnimationReact extends StatefulWidget {
  const AnimationReact(
      {super.key,
      required this.child,
      required this.isAnimating,
      required this.duration,
      this.End,
      required this.iconlike});
  final Widget child;
  final bool isAnimating;
  final Duration duration;
  final VoidCallback? End;
  final bool iconlike;
  @override
  State<AnimationReact> createState() => _AnimationReactState();
}

class _AnimationReactState extends State<AnimationReact>
    with SingleTickerProviderStateMixin {
  late AnimationController controller;
  late Animation<double> scale;

  @override
  void initState() {
    super.initState();
    controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: widget.duration.inMilliseconds ~/ 2),
    );
    scale = Tween<double>(begin: 1, end: 1.2).animate(controller);
  }

  @override
  void didUpdateWidget(covariant AnimationReact oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.isAnimating != oldWidget.isAnimating) {
      startAnimation();
    }
  }

  startAnimation() async {
    if (widget.isAnimating || widget.iconlike) {
      await controller.forward();
      await controller.reverse();
      await Future.delayed(
        const Duration(milliseconds: 200),
      );

      if (widget.End != null) {
        widget.End!();
      }
    }
  }

  @override
  void dispose() {
    super.dispose();
    controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: scale,
      child: widget.child,
    );
  }
}
