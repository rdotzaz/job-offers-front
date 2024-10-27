import 'dart:ui';

import 'package:flutter/cupertino.dart';

class CupertinoBlur extends StatelessWidget {
  const CupertinoBlur(
      {super.key,
      required this.child,
      this.backgroundColor = CupertinoColors.systemGrey5,
      this.opacity = 0.8,
      this.radius = 25});

  final Color backgroundColor;
  final double opacity;
  final double radius;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
        borderRadius: BorderRadius.all(Radius.circular(radius)),
        child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 30, sigmaY: 30),
            child: Container(
                color: backgroundColor?.withOpacity(opacity), child: child)));
  }
}
