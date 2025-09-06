import 'package:flame/components.dart';
import 'package:flutter/material.dart';

class Heart extends ShapeComponent {
  Heart({required super.position, required super.size})
      : super(
          paint: Paint()..color = const Color(0xfff94144),
        );

  @override
  void render(Canvas canvas) {
    final path = Path()
      ..moveTo(size.x / 2, size.y / 5)
      ..cubicTo(size.x * 0.1, -size.y * 0.2, -size.x * 0.2, size.y * 0.6,
          size.x / 2, size.y)
      ..moveTo(size.x / 2, size.y / 5)
      ..cubicTo(size.x * 0.9, -size.y * 0.2, size.x * 1.2, size.y * 0.6,
          size.x / 2, size.y);

    canvas.drawPath(path, paint);
  }

  void loseLife() {
    paint.color = Colors.black;
  }

  void reset() {
    paint.color = const Color(0xfff94144);
  }
}