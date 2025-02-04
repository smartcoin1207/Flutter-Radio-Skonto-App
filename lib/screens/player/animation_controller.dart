import 'package:flutter/animation.dart';
import 'package:flutter/scheduler.dart';

class AppAnimationController implements TickerProvider {
  late AnimationController controller;

  AppAnimationController() {
    controller = AnimationController(vsync: this, duration: Duration.zero);
  }

  @override
  Ticker createTicker(TickerCallback onTick) => Ticker(onTick);

  void startAnimation() {
    controller.forward();
  }

  void setValue(double newValue) {
    controller.value = newValue;
  }

  void reverseAnimation() {
    controller.reverse();
  }

  void dispose() {
    controller.dispose();
  }
}
