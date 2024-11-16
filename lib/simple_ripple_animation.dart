import 'dart:async';

import 'package:flutter/material.dart';

/// You can use whatever widget as a [child], when you don't need to provide any
/// [child], just provide an empty Container().
/// [delay] is using a [Timer] for delaying the animation, it's zero by default.
/// You can set [repeat] to true for making a pulsing effect.
class RippleAnimation extends StatefulWidget {
  ///initialize the ripple animation
  const RippleAnimation({
    required this.child,
    this.color = Colors.black,
    this.delay = Duration.zero,
    this.repeat = false,
    this.minRadius = 60,
    this.maxRadius = 120,
    this.ripplesCount = 5,
    this.duration = const Duration(milliseconds: 2300),
    super.key,
  });

  ///[Widget] this widget will placed at center of the animation
  final Widget child;

  ///[Duration] delay of the animation
  final Duration delay;

  /// [double] minimum radius of the animation
  final double minRadius;

  /// [double] maximum radius of the animation
  final double maxRadius; // Added maxRadius field

  /// [Color] color of the animation
  final Color color;

  /// [int] number of circle that u want to display in the animation
  final int ripplesCount;

  /// [Duration]  of the animation
  final Duration duration;

  /// [bool] provide true if u want repeat animation
  final bool repeat;

  @override
  RippleAnimationState createState() => RippleAnimationState();
}

///state of the animation
class RippleAnimationState extends State<RippleAnimation>
    with TickerProviderStateMixin<RippleAnimation> {
  AnimationController? _controller;

  @override
  void initState() {
    _controller = AnimationController(
      duration: widget.duration,
      vsync: this,
    );

    Timer? animationTimer;

    animationTimer = Timer(widget.delay, () {
      if (_controller != null && mounted) {
        // repeating or just forwarding the animation once.
        widget.repeat ? _controller!.repeat() : _controller!.forward();
      }
      // Cancel the timer when it's no longer needed.
      animationTimer?.cancel();
    });

    super.initState();
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => CustomPaint(
        painter: CirclePainter(
          _controller,
          color: widget.color,
          minRadius: widget.minRadius,
          maxRadius: widget.maxRadius, // Passed maxRadius to painter
          wavesCount: widget.ripplesCount + 2,
        ),
        child: widget.child,
      );
}

/// Creating a Circular painter for clipping the rect and creating circle shape
class CirclePainter extends CustomPainter {
  ///initialize the painter
  CirclePainter(
    this.animation, {
    required this.wavesCount,
    required this.color,
    this.minRadius,
    this.maxRadius, // Added maxRadius parameter
  }) : super(repaint: animation);

  ///[Color] of the painter
  final Color color;

  ///[double] minimum radius of the painter
  final double? minRadius;

  ///[double] maximum radius of the painter
  final double? maxRadius; // Added maxRadius field

  ///[int] number of wave count in the animation
  final int wavesCount;

  ///[Color] of the painter
  final Animation<double>? animation;

  @override
  void paint(Canvas canvas, Size size) {
    final Rect rect = Rect.fromLTRB(0, 0, size.width, size.height);
    for (int wave = 0; wave <= wavesCount; wave++) {
      circle(
        canvas,
        rect,
        minRadius,
        maxRadius, // Passed maxRadius to circle method
        wave,
        animation!.value,
        wavesCount,
        color,
      );
    }
  }

  /// animating the opacity according to min radius and waves count.
  void circle(
    Canvas canvas,
    Rect rect,
    double? minRadius,
    double? maxRadius, // Added maxRadius parameter
    int wave,
    double value,
    int? length,
    Color circleColor,
  ) {
    Color color = circleColor;
    double r;
    if (wave != 0) {
      final double opacity =
          (1 - ((wave - 1) / length!) - value).clamp(0.0, 1.0);
      color = color.withOpacity(opacity);

      final double sizeFactor = minRadius! + ((maxRadius! - minRadius) * value);
      r = sizeFactor * (1 + (wave * value)) * value;
      final Paint paint = Paint()..color = color;
      canvas.drawCircle(rect.center, r, paint);
    }
  }

  @override
  bool shouldRepaint(CirclePainter oldDelegate) => true;
}
