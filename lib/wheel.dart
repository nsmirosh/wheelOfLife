import 'dart:math' as math;
import 'package:flutter/material.dart';

class WheelPainter extends CustomPainter {
  List<int> values = [];
  List<Color> colors = [];

  WheelPainter(this.values, this.colors);

  Paint getPaint(Color color, {bool isStroke = false}) {
    return Paint()
      ..color = color
      ..style = isStroke ? PaintingStyle.stroke : PaintingStyle.fill;
  }

  @override
  void paint(Canvas canvas, Size size) {
    double wheelSize = 275;
    int totalPossibleGrades = 10;

    double radius = (2 * math.pi) / values.length;

    canvas.drawPath(
        getWheelPath(
            wheelSize, 0, radius, values[0] * wheelSize / totalPossibleGrades),
        getPaint(colors[0]));

    for (var i = 1; i < values.length; i++) {
      canvas.drawPath(
          getWheelPath(wheelSize, radius * i, radius,
              values[i] * wheelSize / totalPossibleGrades),
          getPaint(colors[i]));
      canvas.drawPath(getWheelPath(wheelSize, radius * i, radius, wheelSize),
          getPaint(Colors.black, isStroke: true));
    }

      drawGrid(canvas, wheelSize);
  }

  void drawGrid(Canvas canvas, double wheelSize) {
    for (var i = 1; i <= 10; i++) {
      canvas.drawCircle(
        Offset(wheelSize, wheelSize),
        wheelSize / 10 * i,
        getPaint(
            Color(
              int.parse("0xffa6aba8"),
            ),
            isStroke: true),
      );
    }
  }

  Path getWheelPath(double wheelSize, double fromRadius, double toRadius,
      double sizeOfRadius) {
    return Path()
      ..moveTo(wheelSize, wheelSize)
      ..arcTo(
          Rect.fromCircle(
              radius: sizeOfRadius, center: Offset(wheelSize, wheelSize)),
          fromRadius,
          toRadius,
          false)
      ..close();
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return oldDelegate != this;
  }
}
