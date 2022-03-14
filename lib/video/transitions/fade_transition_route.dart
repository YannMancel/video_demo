import 'package:flutter/material.dart';

class FadeTransitionRoute extends PageRouteBuilder {
  FadeTransitionRoute({required this.page})
      : super(
          pageBuilder: (_, __, ___) => page,
          transitionsBuilder: (_, animation, __, child) {
            return FadeTransition(opacity: animation, child: child);
          },
        );

  final Widget page;
}
