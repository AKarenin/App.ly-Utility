import 'package:flutter/material.dart';

class GradationColorWidget extends StatelessWidget {
  Widget child;

  GradationColorWidget({Key? key, required this.child})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ShaderMask(
      shaderCallback: (Rect bounds) {
        return LinearGradient(
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
          colors: [Color(0xFF135295), Color(0xFF0976CA),],
          stops: [0, 1],
        ).createShader(bounds);
      },
      child: child,
    );
  }
}