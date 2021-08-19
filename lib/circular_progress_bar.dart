import 'dart:math';

import 'package:flutter/material.dart';

class CircularProgressBar extends StatefulWidget {
  const CircularProgressBar({Key? key}) : super(key: key);

  @override
  _CircularProgressBarState createState() => _CircularProgressBarState();
}

class _CircularProgressBarState extends State<CircularProgressBar>
    with SingleTickerProviderStateMixin {
  double percentage = 10;
  late AnimationController controller;
  late Animation<double> percentageAnimation;
  Tween<double> percentageTween = Tween(begin: 10.0, end: 70);

  @override
  void initState() {
    super.initState();

    controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: 2),
    );

    percentageAnimation = percentageTween.animate(
      CurvedAnimation(parent: controller, curve: Curves.linear),
    );
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: AnimatedBuilder(
            animation: controller,
            builder: (context, child) {
              return Container(
                width: 200,
                height: 200,
                child: CustomPaint(
                  painter:
                      ProgressBarPainter(percentage: percentageAnimation.value),
                  child: Center(
                    child: Text(
                      "${percentageAnimation.value.toInt()}%",
                      style:
                          TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              );
            }),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.pink,
        onPressed: () {
          controller.forward();
          // if (percentageAnimation.value == 0.1) {

          // }
          // if (percentageAnimation.value == 80) {
          //   controller.reverse();
          // } else {
          //   controller.forward();
          // }
          // setState(() {
          //   percentage += 0.1;
          // });
          // if (percentage > 1) {
          //   percentage = 0.1;
          // }
        },
        child: Icon(Icons.add),
      ),
    );
  }
}

class ProgressBarPainter extends CustomPainter {
  final double percentage;

  ProgressBarPainter({required this.percentage});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.grey
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4;

    final center = Offset(size.width * 0.5, size.height * 0.5);

    // radius is the minimum of the half of the width and the height, now we are taking a minimum of both as the container might not be a square always.
    final radius = min(size.width * 0.5, size.height * 0.5);

    // Offset center = Offset(size.width / 2, size.height / 2);
    // double radius = min(size.width / 2, size.height / 2);
    canvas.drawCircle(center, radius, paint);

    final paintArc = Paint()
      ..color = Colors.pink
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 10;

    Rect rect = Rect.fromCircle(center: center, radius: radius);
    double startAngle = -pi / 2;
    double sweepAngle = (2 * pi * (percentage / 100));

    canvas.drawArc(rect, startAngle, sweepAngle, false, paintArc);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

// The rect is what the full oval would be inscribed within.
// The startAngle is the location on the oval that the line starts drawing from. An angle of 0 is at the right side. Angles are in radians, not degrees. The top is at 3π/2 (or -π/2), the left at π, and the bottom at π/2.
// The sweepAngle is how much of the oval is included in the arc. Again, angles are in radians. A value of 2π would draw the entire oval.
// If you set useCenter to true, then there will be a straight line from both sides of the arc to the center.