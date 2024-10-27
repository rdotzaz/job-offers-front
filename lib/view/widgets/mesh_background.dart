import 'package:flutter/material.dart';

import 'dart:math' as math;

import 'package:mesh/mesh.dart';

class MeshBackground extends StatelessWidget {
  const MeshBackground({super.key});

  @override
  Widget build(BuildContext context) {
    return Transform.rotate(
      angle: math.pi,
      child: OMeshGradient(
          debugMode: DebugMode.none,
          tessellation: 128,
          mesh: OMeshRect(
              width: 2,
              height: 2,
              backgroundColor: Colors.white,
              vertices: [
                (0.0, 0.3).v,
                (0.0, 1.0).v,
                (1.0, 0.6).v,
                (1.0, 1.5).v,
              ],
              colors: [
                Colors.purple,
                Colors.red,
                Colors.cyan,
                Colors.blue,
              ])),
    );
  }
}
