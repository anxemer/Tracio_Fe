import 'package:flutter/material.dart';

class SecondRespondentWidget extends StatelessWidget {
  final PreferredSizeWidget? avatar;
  final Widget? content;
  final bool? isLast;
  final Size? avatarRoot;
  final Size? avatarFirstChild;
  final Color lineColor;
  final double lineWidth;
  final bool hasOtherRoots;

  const SecondRespondentWidget(
      {super.key,
      required this.isLast,
      required this.avatar,
      required this.content,
      required this.avatarRoot,
      required this.avatarFirstChild,
      required this.hasOtherRoots,
      this.lineColor = Colors.grey,
      this.lineWidth = 2});

  @override
  Widget build(BuildContext context) {
    bool isRTL = Directionality.of(context) == TextDirection.rtl;
    final EdgeInsets padding = EdgeInsets.only(
        left: isRTL ? 0 : avatarRoot!.width + avatarFirstChild!.width + 8.0,
        bottom: 8,
        top: 8,
        right: isRTL ? avatarRoot!.width + avatarFirstChild!.width + 8.0 : 0);

    return CustomPaint(
      painter: _Painter(
        isLast: isLast!,
        hasOtherRoots: hasOtherRoots,
        padding: padding,
        textDirection: Directionality.of(context),
        avatarRoot: avatarRoot,
        avatarChild: avatar!.preferredSize,
        pathColor: lineColor,
        strokeWidth: lineWidth,
      ),
      child: Container(
        padding: padding,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            avatar!,
            const SizedBox(
              width: 8,
            ),
            Expanded(child: content!),
          ],
        ),
      ),
    );
  }
}

class _Painter extends CustomPainter {
  bool isLast = false;
  bool hasOtherRoots = false;

  EdgeInsets? padding;
  final TextDirection textDirection;
  Size? avatarRoot;
  Size? avatarChild;
  Color? pathColor;
  double? strokeWidth;

  _Painter({
    required this.isLast,
    required this.textDirection,
    required this.hasOtherRoots,
    this.padding,
    this.avatarRoot,
    this.avatarChild,
    this.pathColor,
    this.strokeWidth,
  }) {
    _paint = Paint()
      ..color = pathColor!
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth!
      ..strokeCap = StrokeCap.round;
  }

  late Paint _paint;

  @override
  void paint(Canvas canvas, Size size) {
    final Path path = Path();
    if (textDirection == TextDirection.rtl) canvas.translate(size.width, 0);
    double rootDx = avatarRoot!.width / 2;
    double childDx = avatarRoot!.width + avatarChild!.width / 2 + 8;
    if (textDirection == TextDirection.rtl) rootDx *= -1;
    path.moveTo(childDx, 0);
    path.cubicTo(
      childDx,
      padding!.top  + avatarChild!.height / 2,
      childDx,
      padding!.top + avatarChild!.height / 2,
      childDx + 10,
      padding!.top + avatarChild!.height / 2,
    );
    canvas.drawPath(path, _paint);
    if (hasOtherRoots) {
      canvas.drawLine(
        Offset(rootDx, 0),
        Offset(rootDx, size.height),
        _paint,
      );
    }

    if (!isLast) {
      canvas.drawLine(
        Offset(childDx, 0),
        Offset(childDx, size.height),
        _paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
