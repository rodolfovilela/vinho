import 'package:flutter/material.dart';

class GradientBorderContainer extends StatelessWidget {
  final Widget child;
  final double borderWidth;
  final List<Color> gradientColors;
  final BorderRadius borderRadius;
  final Color? backgroundColor;
  final EdgeInsets? padding;

  const GradientBorderContainer({
    super.key,
    required this.child,
    this.borderWidth = 3.0,
    required this.gradientColors,
    this.borderRadius = const BorderRadius.all(Radius.circular(12)),
    this.backgroundColor = Colors.white,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: GradientBorderPainter(
        borderWidth: borderWidth,
        gradientColors: gradientColors,
        borderRadius: borderRadius,
      ),
      child: Container(
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: borderRadius,
        ),
        padding: padding ?? EdgeInsets.all(borderWidth),
        child: child,
      ),
    );
  }
}

class GradientBorderPainter extends CustomPainter {
  final double borderWidth;
  final List<Color> gradientColors;
  final BorderRadius borderRadius;

  GradientBorderPainter({
    required this.borderWidth,
    required this.gradientColors,
    required this.borderRadius,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = borderWidth
      ..shader = LinearGradient(
        colors: gradientColors,
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ).createShader(
        Rect.fromLTWH(0, 0, size.width, size.height),
      );

    // Create a rounded rectangle path
    final path = Path();
    final rrect = RRect.fromRectAndRadius(
      Rect.fromLTWH(0, 0, size.width, size.height),
      Radius.circular(borderRadius.topLeft.x),
    );
    
    path.addRRect(rrect);
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant GradientBorderPainter oldDelegate) {
    return oldDelegate.borderWidth != borderWidth ||
        oldDelegate.gradientColors != gradientColors ||
        oldDelegate.borderRadius != borderRadius;
  }
}