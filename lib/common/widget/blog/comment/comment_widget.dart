import 'package:flutter/material.dart';

class CommentWidget extends StatelessWidget {
  final PreferredSizeWidget avatar;
  final Widget content;
  final Color lineColor;
  final double lineWidth;
  final bool hasChild;

  const CommentWidget(
      {super.key,
      required this.avatar,
      required this.content,
      this.hasChild = false,
      this.lineColor = Colors.grey,
      this.lineWidth = 2});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: RootPainter(avatar.preferredSize, lineColor, lineWidth,
          Directionality.of(context), hasChild),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          avatar,
          const SizedBox(
            width: 8,
          ),
          Expanded(
            child: content,
          )
        ],
      ),
    );
  }
}

class RootPainter extends CustomPainter {
  Size? avatar;
  bool hasChild;
  late Paint _paint;
  Color? pathColor;
  double? strokeWidth;
  final TextDirection textDecoration;
  RootPainter(this.avatar, this.pathColor, this.strokeWidth,
      this.textDecoration, this.hasChild) {
    _paint = Paint()
      ..color = pathColor!
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth!
      ..strokeCap = StrokeCap.round;
  }

  @override
  void paint(Canvas canvas, Size size) {
    if (textDecoration == TextDirection.rtl) canvas.translate(size.width, 0);
    double dx = avatar!.width / 2;
    double dy = avatar!.height + 8.0;
    if (textDecoration == TextDirection.rtl) dx *= -1;
    if (hasChild) {
      canvas.drawLine(
        Offset(dx, dy),
        Offset(dx, size.height),
        _paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
