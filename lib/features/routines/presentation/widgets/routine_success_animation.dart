import 'package:flutter/material.dart';
import 'dart:math' as math;

/// Success animation shown when routine is generated/regenerated
class RoutineSuccessAnimation extends StatefulWidget {
  const RoutineSuccessAnimation({
    super.key,
    required this.message,
    this.onComplete,
    this.isClaudeGenerated = false,
  });

  final String message;
  final VoidCallback? onComplete;
  final bool isClaudeGenerated;

  @override
  State<RoutineSuccessAnimation> createState() => _RoutineSuccessAnimationState();
}

class _RoutineSuccessAnimationState extends State<RoutineSuccessAnimation>
    with TickerProviderStateMixin {
  late AnimationController _scaleController;
  late AnimationController _checkController;
  late AnimationController _particlesController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _checkAnimation;

  @override
  void initState() {
    super.initState();

    // Circle scale animation
    _scaleController = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    );

    _scaleAnimation = CurvedAnimation(
      parent: _scaleController,
      curve: Curves.elasticOut,
    );

    // Checkmark draw animation
    _checkController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    _checkAnimation = CurvedAnimation(
      parent: _checkController,
      curve: Curves.easeInOut,
    );

    // Particles animation
    _particlesController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );

    // Start animations in sequence
    _startAnimations();
  }

  Future<void> _startAnimations() async {
    await _scaleController.forward();
    await _checkController.forward();
    _particlesController.forward();

    // Auto dismiss after showing animation
    await Future.delayed(const Duration(milliseconds: 1500));
    widget.onComplete?.call();
  }

  @override
  void dispose() {
    _scaleController.dispose();
    _checkController.dispose();
    _particlesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.black54,
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Animated success icon with particles
            SizedBox(
              width: 200,
              height: 200,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  // Animated particles
                  AnimatedBuilder(
                    animation: _particlesController,
                    builder: (context, child) {
                      return CustomPaint(
                        size: const Size(200, 200),
                        painter: _ParticlesPainter(
                          _particlesController.value,
                          isClaudeGenerated: widget.isClaudeGenerated,
                        ),
                      );
                    },
                  ),

                  // Success circle with check
                  ScaleTransition(
                    scale: _scaleAnimation,
                    child: Container(
                      width: 120,
                      height: 120,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: widget.isClaudeGenerated
                              ? [
                                  const Color(0xFFCC785C), // Claude red/brown
                                  const Color(0xFFA85C3C),
                                ]
                              : [
                                  Colors.green.shade400,
                                  Colors.green.shade600,
                                ],
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: widget.isClaudeGenerated
                                ? const Color(0xFFCC785C).withValues(alpha: 0.6)
                                : Colors.green.shade300.withValues(alpha: 0.6),
                            blurRadius: 30,
                            spreadRadius: 10,
                          ),
                        ],
                      ),
                      child: AnimatedBuilder(
                        animation: _checkAnimation,
                        builder: (context, child) {
                          return CustomPaint(
                            painter: _CheckmarkPainter(_checkAnimation.value),
                          );
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Success message
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.1),
                    blurRadius: 20,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.auto_awesome,
                        color: Colors.blue.shade700,
                        size: 20,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        widget.message,
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: widget.isClaudeGenerated
                                  ? const Color(0xFFCC785C)
                                  : Colors.green.shade700,
                            ),
                      ),
                    ],
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

/// Custom painter for checkmark animation
class _CheckmarkPainter extends CustomPainter {
  final double progress;

  _CheckmarkPainter(this.progress);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white
      ..strokeWidth = 6
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    final path = Path();

    // Checkmark path
    final startX = size.width * 0.3;
    final startY = size.height * 0.5;
    final midX = size.width * 0.45;
    final midY = size.height * 0.65;
    final endX = size.width * 0.7;
    final endY = size.height * 0.35;

    if (progress <= 0.5) {
      // Draw first part (down stroke)
      final t = progress / 0.5;
      path.moveTo(startX, startY);
      path.lineTo(
        startX + (midX - startX) * t,
        startY + (midY - startY) * t,
      );
    } else {
      // Draw second part (up stroke)
      final t = (progress - 0.5) / 0.5;
      path.moveTo(startX, startY);
      path.lineTo(midX, midY);
      path.lineTo(
        midX + (endX - midX) * t,
        midY + (endY - midY) * t,
      );
    }

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(_CheckmarkPainter oldDelegate) {
    return oldDelegate.progress != progress;
  }
}

/// Custom painter for particle explosion effect
class _ParticlesPainter extends CustomPainter {
  final double progress;
  final bool isClaudeGenerated;

  _ParticlesPainter(this.progress, {this.isClaudeGenerated = false});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..style = PaintingStyle.fill;

    final center = Offset(size.width / 2, size.height / 2);
    final particleCount = 12;

    for (int i = 0; i < particleCount; i++) {
      final angle = (2 * math.pi * i) / particleCount;
      final distance = 60 * progress;
      final x = center.dx + distance * math.cos(angle);
      final y = center.dy + distance * math.sin(angle);

      // Fade out particles
      final opacity = 1.0 - progress;
      paint.color = _getParticleColor(i).withValues(alpha: opacity);

      // Shrink particles
      final radius = 6 * (1.0 - progress * 0.5);

      canvas.drawCircle(Offset(x, y), radius, paint);
    }
  }

  Color _getParticleColor(int index) {
    final colors = isClaudeGenerated
        ? [
            const Color(0xFFCC785C), // Claude red/brown
            const Color(0xFFFFFFFF), // White
            const Color(0xFFA85C3C), // Darker red/brown
            const Color(0xFFEEEEEE), // Off-white
          ]
        : [
            Colors.blue.shade400,
            Colors.purple.shade400,
            Colors.green.shade400,
            Colors.orange.shade400,
          ];
    return colors[index % colors.length];
  }

  @override
  bool shouldRepaint(_ParticlesPainter oldDelegate) {
    return oldDelegate.progress != progress;
  }
}

/// Show success animation as overlay
Future<void> showRoutineSuccessAnimation(
  BuildContext context, {
  required String message,
  bool isClaudeGenerated = false,
}) async {
  final overlay = Overlay.of(context);
  late OverlayEntry entry;

  entry = OverlayEntry(
    builder: (context) => RoutineSuccessAnimation(
      message: message,
      isClaudeGenerated: isClaudeGenerated,
      onComplete: () => entry.remove(),
    ),
  );

  overlay.insert(entry);
}
