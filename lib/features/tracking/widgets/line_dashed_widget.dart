import 'package:flutter/material.dart';

class LineDashedWidget extends CustomPainter {
  Color color;

  LineDashedWidget(this.color);

  @override
  void paint(Canvas canvas, Size size) {
    var paint = Paint()
      ..strokeWidth = 2
      ..color = color;
    var max = 45;
    var dashWidth = 5;
    var dashSpace = 5;
    double startY = 0;
    while (max >= 0) {
      canvas.drawLine(Offset(0, startY), Offset(0, startY + dashWidth), paint);
      final space = (dashSpace + dashWidth);
      startY += space;
      max -= space;
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}


class LineSolidWidget extends CustomPainter {
  final Color color;

  LineSolidWidget(this.color);

  @override
  void paint(Canvas canvas, Size size) {
    var paint = Paint()
      ..strokeWidth = 2
      ..color = color;

    // Draw a solid vertical line with fixed length
    double max = 45; // same as dashed line
    canvas.drawLine(Offset(0, 0), Offset(0, max), paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
