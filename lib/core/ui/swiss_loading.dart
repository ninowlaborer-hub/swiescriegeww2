import 'package:flutter/material.dart';
import 'animations.dart';

/// Swiss precision-inspired loading indicators
///
/// Elegant, minimalist loading states that reflect Swiss watch precision
class SwissLoading extends StatelessWidget {
  const SwissLoading({
    super.key,
    this.message,
    this.size = 48.0,
  });

  final String? message;
  final double size;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Rotating Swiss precision indicator
          SwissAnimations.rotate(
            child: Container(
              width: size,
              height: size,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: Theme.of(context).colorScheme.primary,
                  width: 3,
                ),
              ),
              child: CustomPaint(
                painter: _SwissPrecisionPainter(
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
            ),
          ),
          if (message != null) ...[
            const SizedBox(height: 16),
            SwissAnimations.fadeIn(
              child: Text(
                message!,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Colors.grey[600],
                    ),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

/// Custom painter for Swiss precision loading indicator
class _SwissPrecisionPainter extends CustomPainter {
  _SwissPrecisionPainter({required this.color});

  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;

    // Draw Swiss watch-inspired markers (like hour markers)
    for (int i = 0; i < 12; i++) {
      final angle = (i * 30) * 3.14159 / 180;
      final x = center.dx + (radius * 0.8) * cos(angle);
      final y = center.dy + (radius * 0.8) * sin(angle);

      canvas.drawCircle(
        Offset(x, y),
        i % 3 == 0 ? 2.5 : 1.5, // Larger dots at 12, 3, 6, 9
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;

  // Simple cos/sin implementations
  double cos(double radians) {
    return (1 - radians * radians / 2 + radians * radians * radians * radians / 24);
  }

  double sin(double radians) {
    return (radians - radians * radians * radians / 6 + radians * radians * radians * radians * radians / 120);
  }
}

/// Shimmer loading placeholder for content
class SwissShimmer extends StatelessWidget {
  const SwissShimmer({
    super.key,
    required this.child,
  });

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return SwissAnimations.shimmer(
      baseColor: isDark ? Colors.grey[800]! : Colors.grey[300]!,
      highlightColor: isDark ? Colors.grey[700]! : Colors.grey[100]!,
      child: child,
    );
  }
}

/// Swiss-styled skeleton loader for list items
class SwissSkeletonItem extends StatelessWidget {
  const SwissSkeletonItem({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final baseColor = isDark ? Colors.grey[800]! : Colors.grey[300]!;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: SwissShimmer(
        child: Row(
          children: [
            // Icon placeholder
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: baseColor,
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            const SizedBox(width: 16),
            // Text placeholders
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: 16,
                    decoration: BoxDecoration(
                      color: baseColor,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    height: 12,
                    width: double.infinity * 0.6,
                    decoration: BoxDecoration(
                      color: baseColor,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Pulsing dot indicator - minimal Swiss style
class SwissPulsingDot extends StatefulWidget {
  const SwissPulsingDot({
    super.key,
    this.size = 12.0,
    this.color,
  });

  final double size;
  final Color? color;

  @override
  State<SwissPulsingDot> createState() => _SwissPulsingDotState();
}

class _SwissPulsingDotState extends State<SwissPulsingDot>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    )..repeat(reverse: true);

    _animation = Tween<double>(begin: 0.4, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final color = widget.color ?? Theme.of(context).colorScheme.primary;

    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Container(
          width: widget.size,
          height: widget.size,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: color.withValues(alpha: _animation.value),
          ),
        );
      },
    );
  }
}

/// Swiss-styled linear progress indicator
class SwissLinearProgress extends StatelessWidget {
  const SwissLinearProgress({
    super.key,
    this.value,
    this.backgroundColor,
    this.color,
    this.height = 4.0,
  });

  final double? value;
  final Color? backgroundColor;
  final Color? color;
  final double height;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      child: LinearProgressIndicator(
        value: value,
        backgroundColor: backgroundColor ??
            Theme.of(context).colorScheme.surfaceContainerHighest,
        valueColor: AlwaysStoppedAnimation<Color>(
          color ?? Theme.of(context).colorScheme.primary,
        ),
        borderRadius: BorderRadius.circular(height / 2),
      ),
    );
  }
}
