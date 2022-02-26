import 'package:flutter/material.dart';

class AnimatedRoutes extends PageRouteBuilder {
  final Widget routeWidget;
  AnimatedRoutes({required this.routeWidget})
      : super(
          pageBuilder: (__, animation, secondaryAnimation) => routeWidget,
          transitionDuration: Duration(microseconds: 500),
          reverseTransitionDuration: Duration(milliseconds: 500),
          transitionsBuilder: (__, animation, secondAnimation, child) {
            animation =
                CurvedAnimation(parent: animation, curve: Curves.slowMiddle);
            return FadeTransition(
              opacity: animation,
              child: child,
            );
          },
        );
}
