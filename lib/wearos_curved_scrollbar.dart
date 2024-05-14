library wearos_curved_scrollbar;

import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:math' as math;

class CurvedScrollbar extends StatefulWidget {
  final Widget child;
  final Color color;
  final double blockThickness;
  final double trackWidth;
  final ScrollController controller;
  final bool isCurved;
  final bool hideOnNoScroll;

  const CurvedScrollbar({
    super.key,
    required this.child,
    required this.controller,
    this.color = Colors.grey,
    this.blockThickness = 4.0,
    this.trackWidth = 8.0,
    this.isCurved = true,
    this.hideOnNoScroll = true,
  });

  @override
  _CurvedScrollbarState createState() => _CurvedScrollbarState();
}

class _CurvedScrollbarState extends State<CurvedScrollbar>
    with SingleTickerProviderStateMixin {
  bool _isScrolling = true;
  Timer? _hideTimer;
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    //widget.controller.addListener(_onScroll);
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
      value: widget.hideOnNoScroll ? 0.0 : 1.0,
    );
  }

  @override
  void dispose() {
    //widget.controller.removeListener(_onScroll);
    _hideTimer?.cancel();
    _animationController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (widget.hideOnNoScroll) {
      _showScrollbar();
    }
  }

  void _showScrollbar() {
    if (_hideTimer?.isActive ?? false) {
      _hideTimer!.cancel();
    }
    setState(() {
      _isScrolling = true;
      _animationController.forward();
    });
    _hideTimer = Timer(Duration(seconds: 1), () {
      _animationController.reverse().then((_) {
        setState(() {
          _isScrolling = false;
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return widget.isCurved
        ? Stack(
            children: [
              NotificationListener(
                onNotification: (notification) {
                  if (notification is ScrollStartNotification ||
                      notification is ScrollNotification) {
                    _showScrollbar();
                  }
                  return false;
                },
                child: widget.child,
              ),
              Positioned.fill(
                child: IgnorePointer(
                  child: FadeTransition(
                    opacity: _animationController,
                    child: CustomPaint(
                      painter: CurvedScrollbarPainter(
                        controller: widget.controller,
                        color: widget.color,
                        blockThickness: widget.blockThickness,
                        trackWidth: widget.trackWidth,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          )
        : Scrollbar(
            controller: widget.controller,
            thickness: widget.trackWidth,
            radius: const Radius.circular(10),
            child: widget.child,
          );
  }
}

class CurvedScrollbarPainter extends CustomPainter {
  final ScrollController controller;
  final Color color;
  final double blockThickness;
  final double trackWidth;

  CurvedScrollbarPainter({
    required this.controller,
    required this.color,
    required this.blockThickness,
    required this.trackWidth,
  }) : super(repaint: controller);

  @override
  void paint(Canvas canvas, Size size) {
    var center = Offset(size.width / 2, size.height / 2);
    double radius = size.width / 2 - 10;

    var trackPaint = Paint()
      ..color = color.withOpacity(0.3)
      ..style = PaintingStyle.stroke
      ..strokeWidth = trackWidth;

    var blockPaint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = blockThickness;

    // Adjusting angles for 30 degrees to 120 degrees range
    double startAngle = -math.pi / 6; // -30 degrees
    double endAngle = math.pi / 4; // 120 degrees
    double angleRange = endAngle - startAngle;

    var path = Path();
    path.addArc(Rect.fromCircle(center: center, radius: radius), startAngle,
        angleRange);
    canvas.drawPath(path, trackPaint);

    double blockLength = angleRange / 6; // Static size of the block
    double blockAngleRange =
        (endAngle - blockLength * 0.65) - (startAngle + blockLength * 1.2);

    // Calculate the correct sweep angle based on the controller offset
    double maxScrollExtent = controller.position.maxScrollExtent;
    double scrollOffset = controller.offset.clamp(0.0, maxScrollExtent);
    double sweepAngle = (blockAngleRange * scrollOffset / maxScrollExtent);

    // Adjust the block position to ensure it finishes correctly
    path = Path();
    path.addArc(
        Rect.fromCircle(center: center, radius: radius),
        (startAngle - blockLength / 2) +
            sweepAngle +
            blockLength, // Adjusting start position
        blockLength);
    canvas.drawPath(path, blockPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true; // Always repaint for simplicity
  }
}
