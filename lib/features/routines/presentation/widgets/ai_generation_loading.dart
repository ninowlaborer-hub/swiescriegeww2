import 'package:flutter/material.dart';

/// Animated loading widget shown during AI routine generation
///
/// Shows a pulsing Claude AI icon with animated text and progress indicator
class AIGenerationLoading extends StatefulWidget {
  const AIGenerationLoading({
    super.key,
    this.isRegenerating = false,
  });

  final bool isRegenerating;

  @override
  State<AIGenerationLoading> createState() => _AIGenerationLoadingState();
}

class _AIGenerationLoadingState extends State<AIGenerationLoading>
    with TickerProviderStateMixin {
  late AnimationController _pulseController;
  late AnimationController _rotateController;
  late AnimationController _fadeController;
  late Animation<double> _pulseAnimation;
  late Animation<double> _rotateAnimation;
  late Animation<double> _fadeAnimation;

  int _currentStep = 0;
  final List<String> _steps = [
    'Analyzing your calendar...',
    'Processing sleep patterns...',
    'Checking weather forecast...',
    'Consulting Claude AI...',
    'Optimizing your schedule...',
    'Finalizing routine...',
  ];

  @override
  void initState() {
    super.initState();

    // Pulse animation for the icon
    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    )..repeat(reverse: true);

    _pulseAnimation = Tween<double>(begin: 0.85, end: 1.15).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    // Rotate animation for sparkles
    _rotateController = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    )..repeat();

    _rotateAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _rotateController, curve: Curves.linear),
    );

    // Fade animation for text
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _fadeController, curve: Curves.easeIn),
    );

    // Cycle through steps
    _cycleSteps();
  }

  void _cycleSteps() {
    Future.delayed(const Duration(milliseconds: 1500), () {
      if (mounted) {
        setState(() {
          _currentStep = (_currentStep + 1) % _steps.length;
        });
        _fadeController.forward(from: 0.0);
        _cycleSteps();
      }
    });
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _rotateController.dispose();
    _fadeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.red.shade50,
            Colors.white,
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.red.withValues(alpha: 0.1),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Animated AI Icon
          Stack(
            alignment: Alignment.center,
            children: [
              // Rotating sparkles background
              RotationTransition(
                turns: _rotateAnimation,
                child: Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: RadialGradient(
                      colors: [
                        Colors.red.shade100.withValues(alpha: 0.3),
                        Colors.red.shade50.withValues(alpha: 0.1),
                        Colors.transparent,
                      ],
                    ),
                  ),
                ),
              ),

              // Pulsing main icon
              ScaleTransition(
                scale: _pulseAnimation,
                child: Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        Colors.red.shade600,
                        Colors.red.shade400,
                      ],
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.red.shade300.withValues(alpha: 0.5),
                        blurRadius: 20,
                        spreadRadius: 5,
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.auto_awesome,
                    size: 40,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 24),

          // Title
          Text(
            widget.isRegenerating
                ? 'Regenerating with Claude AI'
                : 'Generating with Claude AI',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Colors.red.shade900,
                ),
          ),

          const SizedBox(height: 12),

          // Animated step text
          SizedBox(
            height: 24,
            child: FadeTransition(
              opacity: _fadeAnimation,
              child: Text(
                _steps[_currentStep],
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Colors.red.shade700,
                    ),
                textAlign: TextAlign.center,
              ),
            ),
          ),

          const SizedBox(height: 20),

          // Progress indicator
          SizedBox(
            width: 200,
            child: LinearProgressIndicator(
              backgroundColor: Colors.red.shade100,
              valueColor: AlwaysStoppedAnimation<Color>(Colors.red.shade600),
              minHeight: 6,
              borderRadius: BorderRadius.circular(3),
            ),
          ),

          const SizedBox(height: 16),

          // Hint text
          Text(
            'This may take a few seconds...',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Colors.grey.shade600,
                  fontStyle: FontStyle.italic,
                ),
          ),
        ],
      ),
    );
  }
}

/// Full-screen overlay loading widget
class AIGenerationOverlay extends StatelessWidget {
  const AIGenerationOverlay({
    super.key,
    this.isRegenerating = false,
  });

  final bool isRegenerating;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.black54,
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: AIGenerationLoading(isRegenerating: isRegenerating),
        ),
      ),
    );
  }
}

/// Compact inline loading indicator
class AIGenerationInlineLoading extends StatelessWidget {
  const AIGenerationInlineLoading({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.red.shade100, Colors.red.shade50],
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: 20,
            height: 20,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              valueColor: AlwaysStoppedAnimation<Color>(Colors.red.shade700),
            ),
          ),
          const SizedBox(width: 12),
          Text(
            'Claude AI is thinking...',
            style: TextStyle(
              color: Colors.red.shade900,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(width: 8),
          Icon(Icons.auto_awesome, size: 18, color: Colors.red.shade700),
        ],
      ),
    );
  }
}
