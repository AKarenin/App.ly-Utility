import 'package:flutter/material.dart';
import 'dart:math' as math;

class ColorUtil {
  static Color random(){
    return Color((math.Random().nextDouble() * 0xFFFFFF).toInt()).withOpacity(1.0);
  }
}