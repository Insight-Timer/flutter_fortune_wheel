part of 'wheel.dart';

/// Draws a slice of a circle. The slice's arc starts at the right (3 o'clock)
/// and moves clockwise as far as specified by angle.
class _CircleSlicePainter extends CustomPainter {
  final Color fillColor;
  final Color? strokeColor;
  final double strokeWidth;
  final double angle;
  final bool isHighlighted;
  final bool isBigCircle;

  const _CircleSlicePainter({
    required this.fillColor,
    this.strokeColor,
    this.strokeWidth = 1,
    this.isHighlighted = false,
    required this.isBigCircle,
    this.angle = _math.pi / 2,
  }) : assert(angle > 0 && angle < 2 * _math.pi);

  @override
  void paint(Canvas canvas, Size size) {
    final radius = isBigCircle
        ? _math.max(size.width, size.height)
        : _math.min(size.width, size.height);
    final path = isBigCircle
        ? _CircleSlice.buildSlicePath(radius, angle)
        : _CircleSlice.buildSlicePath(
            isHighlighted ? radius : radius - 5, angle);

    final gradient = LinearGradient(
      colors: [fillColor, fillColor.withOpacity(0.5)],
      stops: [0.7, 1.0],
      begin: Alignment.centerLeft,
      end: Alignment.centerRight,
    );

    final paint = Paint()
      ..color = isBigCircle ? Colors.white : fillColor //Color(0xFF709A4F)
      ..style = PaintingStyle.fill;

    if (!isHighlighted && isBigCircle) {
      paint.shader =
          gradient.createShader(Rect.fromLTWH(0, 0, size.width, size.height));
    }

    // fill slice area
    canvas.drawPath(path, paint);

    // draw slice border
    if (strokeWidth > 0) {
      canvas.drawPath(
        path,
        Paint()
          ..color = Colors.white
          ..strokeWidth = strokeWidth
          ..style = PaintingStyle.stroke,
      );

      canvas.drawPath(
        Path()
          ..arcTo(
              Rect.fromCircle(
                center: Offset(0, 0),
                radius: radius,
              ),
              0,
              angle,
              false),
        Paint()
          ..color = strokeColor!
          ..strokeWidth = strokeWidth * 2
          ..style = PaintingStyle.stroke,
      );
    }
  }

  @override
  bool shouldRepaint(_CircleSlicePainter oldDelegate) {
    return angle != oldDelegate.angle ||
        fillColor != oldDelegate.fillColor ||
        strokeColor != oldDelegate.strokeColor ||
        strokeWidth != oldDelegate.strokeWidth;
  }
}
