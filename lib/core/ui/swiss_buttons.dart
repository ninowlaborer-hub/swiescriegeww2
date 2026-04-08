import 'package:flutter/material.dart';
import 'animations.dart';

/// Swiss precision-inspired button with elegant micro-interactions
class SwissButton extends StatefulWidget {
  const SwissButton({
    super.key,
    required this.onPressed,
    required this.child,
    this.style,
    this.animationDuration = SwissAnimations.instant,
    this.scaleOnPress = 0.95,
  });

  final VoidCallback? onPressed;
  final Widget child;
  final ButtonStyle? style;
  final Duration animationDuration;
  final double scaleOnPress;

  @override
  State<SwissButton> createState() => _SwissButtonState();
}

class _SwissButtonState extends State<SwissButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: widget.animationDuration,
      vsync: this,
    );
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: widget.scaleOnPress,
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

  Future<void> _handlePress() async {
    if (widget.onPressed != null) {
      await _controller.forward();
      await _controller.reverse();
      widget.onPressed!();
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => _controller.forward(),
      onTapUp: (_) => _controller.reverse(),
      onTapCancel: () => _controller.reverse(),
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: ElevatedButton(
          onPressed: _handlePress,
          style: widget.style,
          child: widget.child,
        ),
      ),
    );
  }
}

/// Swiss-styled elevated button with micro-interactions
class SwissElevatedButton extends StatelessWidget {
  const SwissElevatedButton({
    super.key,
    required this.onPressed,
    required this.child,
    this.icon,
    this.backgroundColor,
    this.foregroundColor,
    this.padding,
    this.borderRadius,
  });

  final VoidCallback? onPressed;
  final Widget child;
  final Widget? icon;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final EdgeInsetsGeometry? padding;
  final double? borderRadius;

  @override
  Widget build(BuildContext context) {
    final button = icon != null
        ? ElevatedButton.icon(
            onPressed: onPressed,
            icon: icon!,
            label: child,
            style: _buildStyle(context),
          )
        : ElevatedButton(
            onPressed: onPressed,
            style: _buildStyle(context),
            child: child,
          );

    return SwissAnimations.buttonPress(
      onPressed: onPressed ?? () {},
      child: button,
    );
  }

  ButtonStyle _buildStyle(BuildContext context) {
    return ElevatedButton.styleFrom(
      backgroundColor: backgroundColor ?? Theme.of(context).colorScheme.primary,
      foregroundColor: foregroundColor ?? Theme.of(context).colorScheme.onPrimary,
      padding: padding ?? const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(borderRadius ?? 8),
      ),
    );
  }
}

/// Swiss-styled outlined button with micro-interactions
class SwissOutlinedButton extends StatelessWidget {
  const SwissOutlinedButton({
    super.key,
    required this.onPressed,
    required this.child,
    this.icon,
    this.foregroundColor,
    this.borderColor,
    this.padding,
    this.borderRadius,
  });

  final VoidCallback? onPressed;
  final Widget child;
  final Widget? icon;
  final Color? foregroundColor;
  final Color? borderColor;
  final EdgeInsetsGeometry? padding;
  final double? borderRadius;

  @override
  Widget build(BuildContext context) {
    final button = icon != null
        ? OutlinedButton.icon(
            onPressed: onPressed,
            icon: icon!,
            label: child,
            style: _buildStyle(context),
          )
        : OutlinedButton(
            onPressed: onPressed,
            style: _buildStyle(context),
            child: child,
          );

    return SwissAnimations.buttonPress(
      onPressed: onPressed ?? () {},
      child: button,
    );
  }

  ButtonStyle _buildStyle(BuildContext context) {
    return OutlinedButton.styleFrom(
      foregroundColor: foregroundColor ?? Theme.of(context).colorScheme.primary,
      side: BorderSide(
        color: borderColor ?? Theme.of(context).colorScheme.primary,
        width: 1.5,
      ),
      padding: padding ?? const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(borderRadius ?? 8),
      ),
    );
  }
}

/// Swiss-styled text button with micro-interactions
class SwissTextButton extends StatelessWidget {
  const SwissTextButton({
    super.key,
    required this.onPressed,
    required this.child,
    this.icon,
    this.foregroundColor,
    this.padding,
  });

  final VoidCallback? onPressed;
  final Widget child;
  final Widget? icon;
  final Color? foregroundColor;
  final EdgeInsetsGeometry? padding;

  @override
  Widget build(BuildContext context) {
    final button = icon != null
        ? TextButton.icon(
            onPressed: onPressed,
            icon: icon!,
            label: child,
            style: _buildStyle(context),
          )
        : TextButton(
            onPressed: onPressed,
            style: _buildStyle(context),
            child: child,
          );

    return SwissAnimations.buttonPress(
      onPressed: onPressed ?? () {},
      scale: 0.97, // Lighter press animation for text buttons
      child: button,
    );
  }

  ButtonStyle _buildStyle(BuildContext context) {
    return TextButton.styleFrom(
      foregroundColor: foregroundColor ?? Theme.of(context).colorScheme.primary,
      padding: padding ?? const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
    );
  }
}

/// Swiss-styled icon button with ripple animation
class SwissIconButton extends StatefulWidget {
  const SwissIconButton({
    super.key,
    required this.icon,
    required this.onPressed,
    this.tooltip,
    this.color,
    this.backgroundColor,
    this.size = 40.0,
  });

  final Widget icon;
  final VoidCallback? onPressed;
  final String? tooltip;
  final Color? color;
  final Color? backgroundColor;
  final double size;

  @override
  State<SwissIconButton> createState() => _SwissIconButtonState();
}

class _SwissIconButtonState extends State<SwissIconButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: SwissAnimations.instant,
      vsync: this,
    );
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.9,
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

  Future<void> _handlePress() async {
    if (widget.onPressed != null) {
      await _controller.forward();
      await _controller.reverse();
      widget.onPressed!();
    }
  }

  @override
  Widget build(BuildContext context) {
    final button = Container(
      width: widget.size,
      height: widget.size,
      decoration: BoxDecoration(
        color: widget.backgroundColor ?? Colors.transparent,
        borderRadius: BorderRadius.circular(widget.size / 2),
      ),
      child: IconButton(
        icon: widget.icon,
        onPressed: _handlePress,
        tooltip: widget.tooltip,
        color: widget.color ?? Theme.of(context).colorScheme.primary,
      ),
    );

    return ScaleTransition(
      scale: _scaleAnimation,
      child: GestureDetector(
        onTapDown: (_) => _controller.forward(),
        onTapUp: (_) => _controller.reverse(),
        onTapCancel: () => _controller.reverse(),
        child: button,
      ),
    );
  }
}

/// Swiss floating action button with elegant animations
class SwissFAB extends StatefulWidget {
  const SwissFAB({
    super.key,
    required this.onPressed,
    required this.child,
    this.backgroundColor,
    this.foregroundColor,
    this.tooltip,
    this.extended = false,
    this.label,
  });

  final VoidCallback onPressed;
  final Widget child;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final String? tooltip;
  final bool extended;
  final Widget? label;

  @override
  State<SwissFAB> createState() => _SwissFABState();
}

class _SwissFABState extends State<SwissFAB>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _rotationAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: SwissAnimations.quick,
      vsync: this,
    );
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.92,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));
    _rotationAnimation = Tween<double>(
      begin: 0,
      end: 0.1,
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

  Future<void> _handlePress() async {
    await _controller.forward();
    await _controller.reverse();
    widget.onPressed();
  }

  @override
  Widget build(BuildContext context) {
    final fab = widget.extended && widget.label != null
        ? FloatingActionButton.extended(
            onPressed: _handlePress,
            icon: widget.child,
            label: widget.label!,
            backgroundColor: widget.backgroundColor ??
                Theme.of(context).colorScheme.primary,
            foregroundColor: widget.foregroundColor ??
                Theme.of(context).colorScheme.onPrimary,
            tooltip: widget.tooltip,
          )
        : FloatingActionButton(
            onPressed: _handlePress,
            backgroundColor: widget.backgroundColor ??
                Theme.of(context).colorScheme.primary,
            foregroundColor: widget.foregroundColor ??
                Theme.of(context).colorScheme.onPrimary,
            tooltip: widget.tooltip,
            child: widget.child,
          );

    return ScaleTransition(
      scale: _scaleAnimation,
      child: RotationTransition(
        turns: _rotationAnimation,
        child: GestureDetector(
          onTapDown: (_) => _controller.forward(),
          onTapUp: (_) => _controller.reverse(),
          onTapCancel: () => _controller.reverse(),
          child: fab,
        ),
      ),
    );
  }
}
