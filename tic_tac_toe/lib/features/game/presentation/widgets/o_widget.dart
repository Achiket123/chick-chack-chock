import 'package:flutter/material.dart';
import 'package:tic_tac_toe/core/colors.dart';

class OWidget extends StatefulWidget {
  const OWidget({Key? key, this.density = 1}) : super(key: key);
  final double density;
  @override
  State<OWidget> createState() => _OWidgetState();
}

class _OWidgetState extends State<OWidget> with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    )..forward(); // Start the animation
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return CustomPaint(
          size: const Size(70, 70),
          painter: _OPainter(_controller.value, widget.density),
        );
      },
    );
  }
}

class _OPainter extends CustomPainter {
  final double progress;
  final double density;
  _OPainter(this.progress, this.density);

  @override
  void paint(Canvas canvas, Size size) {
    final paint =
        Paint()
          ..color = AppColors.warningColor.withOpacity(density)
          ..strokeWidth = 8.0
          ..style = PaintingStyle.stroke;

    final rect = Rect.fromLTWH(0, 0, size.width, size.height);
    final startAngle = -90.0 * (3.14159265359 / 180.0); // Start at the top
    final sweepAngle = 2 * 3.14159265359 * progress; // Animate the circle

    canvas.drawArc(rect, startAngle, sweepAngle, false, paint);
  }

  @override
  bool shouldRepaint(covariant _OPainter oldDelegate) {
    return oldDelegate.progress != progress;
  }
}
