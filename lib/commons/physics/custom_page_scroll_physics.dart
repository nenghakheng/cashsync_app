import 'package:flutter/material.dart';
import 'dart:math' as math;

class CustomPageScrollPhysics extends ScrollPhysics {
  final double itemDimension;

  const CustomPageScrollPhysics({super.parent, required this.itemDimension});

  @override
  CustomPageScrollPhysics applyTo(ScrollPhysics? ancestor) {
    return CustomPageScrollPhysics(
      parent: buildParent(ancestor),
      itemDimension: itemDimension,
    );
  }

  @override
  SpringDescription get spring =>
      const SpringDescription(mass: 80, stiffness: 100, damping: 1);

  @override
  bool get allowImplicitScrolling => false;

  // This enables the bouncing effect
  @override
  double get minFlingVelocity => 50.0;

  @override
  double get maxFlingVelocity => 8000.0;

  double frictionFactor(double overscrollFraction) =>
      0.2; // Lower friction for smoother bouncing

  // Enable iOS-like bouncing behavior
  @override
  double applyPhysicsToUserOffset(ScrollMetrics position, double offset) {
    if (!position.outOfRange) return offset;

    final double overscrollPastStart = math.max(
      position.pixels - position.minScrollExtent,
      0.0,
    );
    final double overscrollPastEnd = math.max(
      position.maxScrollExtent - position.pixels,
      0.0,
    );
    final double overscrollPast = math.max(
      overscrollPastStart,
      overscrollPastEnd,
    );

    final bool easing =
        (overscrollPastStart > 0.0 && offset < 0.0) ||
        (overscrollPastEnd > 0.0 && offset > 0.0);

    final double friction =
        easing
            ? frictionFactor(
              (overscrollPast - offset.abs()) / position.viewportDimension,
            )
            : frictionFactor(overscrollPast / position.viewportDimension);

    final double direction = offset.sign;
    return direction * _applyFriction(overscrollPast, offset.abs(), friction);
  }

  static double _applyFriction(
    double extentOutside,
    double absDelta,
    double gamma,
  ) {
    assert(absDelta > 0);
    double total = 0.0;
    if (extentOutside > 0) {
      final double deltaToLimit = extentOutside;
      if (absDelta < deltaToLimit) {
        return absDelta;
      }
      total += deltaToLimit;
      absDelta -= deltaToLimit;
      return total + absDelta * gamma;
    }
    return absDelta;
  }

  @override
  Simulation? createBallisticSimulation(
    ScrollMetrics position,
    double velocity,
  ) {
    // The key change is here - we allow simulation at boundaries when there's velocity
    // Only cancel simulation if at boundary and not moving
    if ((velocity == 0.0 && position.pixels <= position.minScrollExtent) ||
        (velocity == 0.0 && position.pixels >= position.maxScrollExtent)) {
      return null;
    }

    // Handle bouncing at boundaries with velocity
    if (position.pixels < position.minScrollExtent ||
        position.pixels > position.maxScrollExtent) {
      return BouncingScrollSimulation(
        spring: spring,
        position: position.pixels,
        velocity: velocity,
        leadingExtent: position.minScrollExtent,
        trailingExtent: position.maxScrollExtent,
        tolerance: const Tolerance(velocity: 0.1, distance: 0.01),
      );
    }

    // For normal scrolling, calculate the nearest item
    final int page = (position.pixels / itemDimension).round();

    // Clamp the target page to valid range
    final int clampedPage = math.min(
      math.max(page, 0),
      (position.maxScrollExtent / itemDimension).floor(),
    );

    final double target = clampedPage * itemDimension;

    // Create a simulation to snap to the target
    if ((target - position.pixels).abs() < 0.01 && velocity.abs() < 10) {
      return null;
    }

    // For normal scrolling, use spring simulation for snapping
    return ScrollSpringSimulation(
      spring,
      position.pixels,
      target,
      velocity,
      tolerance: const Tolerance(velocity: 0.1, distance: 0.01),
    );
  }
}
