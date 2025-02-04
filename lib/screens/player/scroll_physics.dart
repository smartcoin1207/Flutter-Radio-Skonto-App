import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:radio_skonto/screens/player/player.dart';

class ClampScrollPhysics extends ScrollPhysics {
  const ClampScrollPhysics({super.parent});

  @override
  ClampScrollPhysics applyTo(ScrollPhysics? ancestor) {
    return ClampScrollPhysics(parent: buildParent(ancestor));
  }

  @override
  double applyBoundaryConditions(ScrollMetrics position, double value) {
    assert(
        () {
      if (value == position.pixels) {
        throw FlutterError.fromParts(
          <DiagnosticsNode>[
            ErrorSummary(
                '$runtimeType.applyBoundaryConditions() was called redundantly.'),
            ErrorDescription(
              'The proposed new position, $value, is exactly equal to the current position of the '
                  'given ${position.runtimeType}, ${position.pixels}.\n'
                  'The applyBoundaryConditions method should only be called when the value is '
                  'going to actually change the pixels, otherwise it is redundant.',
            ),
            DiagnosticsProperty<ScrollPhysics>(
                'The physics object in question was', this,
                style: DiagnosticsTreeStyle.errorProperty),
            DiagnosticsProperty<ScrollMetrics>(
                'The position object in question was', position,
                style: DiagnosticsTreeStyle.errorProperty),
          ],
        );
      }
      return true;
    }(),
    );

    if (value < position.pixels &&
        position.pixels <= position.minScrollExtent) {
      // Under scroll.
      return value - position.pixels;
    }
    if (position.maxScrollExtent <= position.pixels &&
        position.pixels < value) {
      // Over scroll.
      return value - position.pixels;
    }
    if (value < position.minScrollExtent &&
        position.minScrollExtent < position.pixels) {
      // Hit top edge.
      return value - position.minScrollExtent;
    }
    if (position.pixels < position.maxScrollExtent &&
        position.maxScrollExtent < value) {
      // Hit bottom edge.
      return value - position.maxScrollExtent;
    }
    bool scrollStatus = false;
    if (isScroll) {
      scrollStatus = true;
    }
    return scrollStatus ? value : 0.0;
  }

  @override
  Simulation? createBallisticSimulation(
      ScrollMetrics position, double velocity) {
    final Tolerance tolerance = toleranceFor(position);
    if (position.outOfRange) {
      double? end;
      if (position.pixels > position.maxScrollExtent) {
        end = position.maxScrollExtent;
      }
      if (position.pixels < position.minScrollExtent) {
        end = position.minScrollExtent;
      }
      assert(end != null);
      return ScrollSpringSimulation(
        spring,
        position.pixels,
        end!,
        min(0.0, velocity),
        tolerance: tolerance,
      );
    }
    if (velocity.abs() < tolerance.velocity) {
      return null;
    }
    if (velocity > 0.0 && position.pixels >= position.maxScrollExtent) {
      return null;
    }
    if (velocity < 0.0 && position.pixels <= position.minScrollExtent) {
      return null;
    }
    return ClampingScrollSimulation(
      position: position.pixels,
      velocity: velocity,
      tolerance: tolerance,
    );
  }
}
