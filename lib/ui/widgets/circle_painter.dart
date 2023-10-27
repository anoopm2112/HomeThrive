import 'package:flutter/rendering.dart';
import 'package:meta/meta.dart';

class CirclePainter extends CustomPainter {
  final Offset offset;
  final double radius;
  final Color color;
  final Paint circlePaint = Paint();

  CirclePainter({
    this.offset = const Offset(0, 0),
    @required this.radius,
    this.color,
  })  : assert(offset != null),
        assert(radius != null);

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;

  @override
  void paint(Canvas canvas, Size size) {
    if (this.color != null) {
      circlePaint.color = this.color;
    }
    canvas.drawCircle(this.offset, this.radius, circlePaint);
  }
}
