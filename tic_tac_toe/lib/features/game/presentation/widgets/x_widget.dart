import 'package:flutter/material.dart';

class XWidget extends StatefulWidget {
  const XWidget({Key? key, this.density = 1}) : super(key: key);
  final double density;
  @override
  State<XWidget> createState() => _XWidgetState();
}

class _XWidgetState extends State<XWidget> with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    )..forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return CustomPaint(
            size: const Size(50, 50),
            painter: _XPainter(_controller.value, widget.density),
          );
        },
      ),
    );
  }
}

class _XPainter extends CustomPainter {
  final double progress;
  final double density;
  _XPainter(this.progress, this.density);

  @override
  void paint(Canvas canvas, Size size) {
    final paint =
        Paint()
          ..color = Colors.red.withOpacity(density)
          ..strokeWidth = 5.0
          ..style = PaintingStyle.stroke
          ..strokeCap = StrokeCap.round;

    double offset = 10 * (progress - 0.5); // Breathing effect: -5 to +5

    // Draw two dynamic lines forming X
    final path1 =
        Path()
          ..moveTo(0 + offset, 0 + offset)
          ..lineTo(size.width - offset, size.height - offset);

    final path2 =
        Path()
          ..moveTo(size.width - offset, 0 + offset)
          ..lineTo(0 + offset, size.height - offset);

    canvas.drawPath(path1, paint);
    canvas.drawPath(path2, paint);
  }

  @override
  bool shouldRepaint(covariant _XPainter oldDelegate) {
    return oldDelegate.progress != progress;
  }
}
