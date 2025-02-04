import 'package:flutter/material.dart';
import 'package:radio_skonto/helpers/app_colors.dart';

class AppBlinkedContainer extends StatefulWidget {
  final double width;
  final double height;
  final BoxDecoration? decoration;

  const AppBlinkedContainer({
    super.key,
    required this.width,
    required this.height,
    this.decoration,
  });

  @override
  State<StatefulWidget> createState() => _AppBlinkedContainerState();
}

class _AppBlinkedContainerState extends State<AppBlinkedContainer>
    with TickerProviderStateMixin {
  late AnimationController controller;
  late Animation<double> animation;

  @override
  void initState() {
    super.initState();

    const duration = Duration(milliseconds: 800);
    controller = AnimationController(vsync: this, duration: duration);
    animation = Tween<double>(begin: 0.25, end: 0.10).animate(controller);
    controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        controller.reverse();
      } else if (status == AnimationStatus.dismissed) {
        controller.forward();
      }
    });
    controller.forward();
  }

  @override
  Widget build(BuildContext context) {
    final color = AppColors.white.withOpacity(animation.value);
    return AnimatedBuilder(
      animation: animation,
      builder: (context, child) {
        return Container(
          width: widget.width,
          height: widget.height,
          decoration: widget.decoration?.copyWith(color: color),
        );
      },
    );
  }

  @override
  void dispose() {
    controller.dispose();

    super.dispose();
  }
}
