import 'package:flutter/material.dart';

/// Swiss precision-inspired animations
///
/// Following Swiss design principles: smooth, elegant, precise timing.
/// All animations use Swiss watch-inspired timing with exact durations.
class SwissAnimations {
  SwissAnimations._();

  // Swiss precision timing constants (in milliseconds)
  static const Duration instant = Duration(milliseconds: 100);
  static const Duration quick = Duration(milliseconds: 200);
  static const Duration standard = Duration(milliseconds: 300);
  static const Duration smooth = Duration(milliseconds: 400);
  static const Duration elegant = Duration(milliseconds: 500);
  static const Duration slow = Duration(milliseconds: 700);

  // Swiss precision curves - smooth and predictable
  static const Curve precisionCurve = Curves.easeInOutCubic;
  static const Curve enterCurve = Curves.easeOut;
  static const Curve exitCurve = Curves.easeIn;
  static const Curve bounceCurve = Curves.elasticOut;

  /// Fade in animation with Swiss precision timing
  static Widget fadeIn({
    required Widget child,
    Duration duration = standard,
    Curve curve = precisionCurve,
    double begin = 0.0,
    double end = 1.0,
  }) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: begin, end: end),
      duration: duration,
      curve: curve,
      builder: (context, value, child) {
        return Opacity(
          opacity: value,
          child: child,
        );
      },
      child: child,
    );
  }

  /// Slide in animation with fade - Swiss smooth entry
  static Widget slideInFade({
    required Widget child,
    Duration duration = standard,
    Curve curve = enterCurve,
    Offset begin = const Offset(0, 0.05),
    Offset end = Offset.zero,
  }) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: duration,
      curve: curve,
      builder: (context, value, child) {
        return Transform.translate(
          offset: Offset.lerp(begin, end, value)!,
          child: Opacity(
            opacity: value,
            child: child,
          ),
        );
      },
      child: child,
    );
  }

  /// Scale in animation - Swiss precision entrance
  static Widget scaleIn({
    required Widget child,
    Duration duration = standard,
    Curve curve = enterCurve,
    double begin = 0.8,
    double end = 1.0,
  }) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: begin, end: end),
      duration: duration,
      curve: curve,
      builder: (context, value, child) {
        return Transform.scale(
          scale: value,
          child: Opacity(
            opacity: value,
            child: child,
          ),
        );
      },
      child: child,
    );
  }

  /// Staggered list animation - Swiss precision cascade
  static Widget staggeredList({
    required List<Widget> children,
    Duration itemDelay = const Duration(milliseconds: 50),
    Duration itemDuration = standard,
    Curve curve = enterCurve,
    Axis scrollDirection = Axis.vertical,
  }) {
    return ListView(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      children: List.generate(
        children.length,
        (index) => TweenAnimationBuilder<double>(
          tween: Tween(begin: 0.0, end: 1.0),
          duration: itemDuration + (itemDelay * index),
          curve: curve,
          builder: (context, value, child) {
            final offset = scrollDirection == Axis.vertical
                ? Offset(0, 20 * (1 - value))
                : Offset(20 * (1 - value), 0);

            return Transform.translate(
              offset: offset,
              child: Opacity(
                opacity: value,
                child: child,
              ),
            );
          },
          child: children[index],
        ),
      ),
    );
  }

  /// Button press animation - Swiss tactile feedback
  static Widget buttonPress({
    required Widget child,
    required VoidCallback onPressed,
    Duration duration = instant,
    double scale = 0.95,
  }) {
    return _ButtonPressAnimation(
      onPressed: onPressed,
      duration: duration,
      scale: scale,
      child: child,
    );
  }

  /// Shimmer loading animation - Swiss precision loading
  static Widget shimmer({
    required Widget child,
    Duration duration = const Duration(milliseconds: 1500),
    Color baseColor = const Color(0xFFE0E0E0),
    Color highlightColor = const Color(0xFFF5F5F5),
  }) {
    return _ShimmerAnimation(
      duration: duration,
      baseColor: baseColor,
      highlightColor: highlightColor,
      child: child,
    );
  }

  /// Swiss watch-inspired rotation animation
  static Widget rotate({
    required Widget child,
    Duration duration = const Duration(milliseconds: 1000),
    Curve curve = Curves.linear,
    bool repeat = true,
  }) {
    return _RotationAnimation(
      duration: duration,
      curve: curve,
      repeat: repeat,
      child: child,
    );
  }

  /// Page transition builder - Swiss smooth navigation
  static Widget pageTransition({
    required Animation<double> animation,
    required Widget child,
    PageTransitionType type = PageTransitionType.slideUp,
  }) {
    switch (type) {
      case PageTransitionType.fade:
        return FadeTransition(
          opacity: animation,
          child: child,
        );

      case PageTransitionType.slideUp:
        return SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(0, 0.1),
            end: Offset.zero,
          ).animate(CurvedAnimation(
            parent: animation,
            curve: precisionCurve,
          )),
          child: FadeTransition(
            opacity: animation,
            child: child,
          ),
        );

      case PageTransitionType.slideLeft:
        return SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(1, 0),
            end: Offset.zero,
          ).animate(CurvedAnimation(
            parent: animation,
            curve: precisionCurve,
          )),
          child: child,
        );

      case PageTransitionType.scale:
        return ScaleTransition(
          scale: Tween<double>(
            begin: 0.8,
            end: 1.0,
          ).animate(CurvedAnimation(
            parent: animation,
            curve: enterCurve,
          )),
          child: FadeTransition(
            opacity: animation,
            child: child,
          ),
        );
    }
  }
}

enum PageTransitionType {
  fade,
  slideUp,
  slideLeft,
  scale,
}

/// Button press animation widget
class _ButtonPressAnimation extends StatefulWidget {
  const _ButtonPressAnimation({
    required this.child,
    required this.onPressed,
    required this.duration,
    required this.scale,
  });

  final Widget child;
  final VoidCallback onPressed;
  final Duration duration;
  final double scale;

  @override
  State<_ButtonPressAnimation> createState() => _ButtonPressAnimationState();
}

class _ButtonPressAnimationState extends State<_ButtonPressAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: widget.duration,
      vsync: this,
    );
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: widget.scale,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _handleTap() async {
    await _controller.forward();
    await _controller.reverse();
    widget.onPressed();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _handleTap,
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: widget.child,
      ),
    );
  }
}

/// Shimmer loading animation widget
class _ShimmerAnimation extends StatefulWidget {
  const _ShimmerAnimation({
    required this.child,
    required this.duration,
    required this.baseColor,
    required this.highlightColor,
  });

  final Widget child;
  final Duration duration;
  final Color baseColor;
  final Color highlightColor;

  @override
  State<_ShimmerAnimation> createState() => _ShimmerAnimationState();
}

class _ShimmerAnimationState extends State<_ShimmerAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: widget.duration,
      vsync: this,
    )..repeat();
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
      child: widget.child,
      builder: (context, child) {
        return ShaderMask(
          blendMode: BlendMode.srcATop,
          shaderCallback: (bounds) {
            return LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                widget.baseColor,
                widget.highlightColor,
                widget.baseColor,
              ],
              stops: [
                _controller.value - 0.3,
                _controller.value,
                _controller.value + 0.3,
              ].map((stop) => stop.clamp(0.0, 1.0)).toList(),
            ).createShader(bounds);
          },
          child: child,
        );
      },
    );
  }
}

/// Rotation animation widget
class _RotationAnimation extends StatefulWidget {
  const _RotationAnimation({
    required this.child,
    required this.duration,
    required this.curve,
    required this.repeat,
  });

  final Widget child;
  final Duration duration;
  final Curve curve;
  final bool repeat;

  @override
  State<_RotationAnimation> createState() => _RotationAnimationState();
}

class _RotationAnimationState extends State<_RotationAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: widget.duration,
      vsync: this,
    );

    if (widget.repeat) {
      _controller.repeat();
    } else {
      _controller.forward();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return RotationTransition(
      turns: CurvedAnimation(
        parent: _controller,
        curve: widget.curve,
      ),
      child: widget.child,
    );
  }
}

/// Swiss precision animated container
class SwissAnimatedContainer extends StatelessWidget {
  const SwissAnimatedContainer({
    super.key,
    required this.child,
    this.duration = SwissAnimations.standard,
    this.curve = SwissAnimations.precisionCurve,
    this.padding,
    this.margin,
    this.width,
    this.height,
    this.decoration,
    this.alignment,
  });

  final Widget child;
  final Duration duration;
  final Curve curve;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final double? width;
  final double? height;
  final Decoration? decoration;
  final AlignmentGeometry? alignment;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: duration,
      curve: curve,
      padding: padding,
      margin: margin,
      width: width,
      height: height,
      decoration: decoration,
      alignment: alignment,
      child: child,
    );
  }
}
