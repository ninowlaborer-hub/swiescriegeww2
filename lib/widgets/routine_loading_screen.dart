import 'package:flutter/material.dart';
import '../core/theme/app_theme.dart';

class RoutineLoadingScreen extends StatelessWidget {
  final AnimationController spinController;
  final double currentProgress;
  final double totalProgress;

  const RoutineLoadingScreen({
    Key? key,
    required this.spinController,
    required this.currentProgress,
    required this.totalProgress,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.white,
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              AppTheme.white,
              AppTheme.greyLight,
            ],
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildSpinningIcon(),
              const SizedBox(height: 40),
              _buildTitle(context),
              const SizedBox(height: 30),
              _buildProgressBar(),
              const SizedBox(height: 20),
              _buildPercentageText(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSpinningIcon() {
    return AnimatedBuilder(
      animation: spinController,
      builder: (context, child) {
        return Transform.rotate(
          angle: spinController.value * 2 * 3.14159,
          child: Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [AppTheme.swissRed, AppTheme.swissRedLight],
              ),
              borderRadius: BorderRadius.circular(30),
              boxShadow: [
                BoxShadow(
                  color: AppTheme.swissRed.withValues(alpha: 0.5),
                  blurRadius: 30,
                  spreadRadius: 5,
                ),
              ],
            ),
            child: const Icon(Icons.settings, size: 60, color: AppTheme.white),
          ),
        );
      },
    );
  }

  Widget _buildTitle(BuildContext context) {
    return Text(
      'Initializing Environment...',
      style: Theme.of(context).textTheme.headlineMedium?.copyWith(
            fontWeight: FontWeight.bold,
            color: AppTheme.black,
          ),
    );
  }

  Widget _buildProgressBar() {
    return Container(
      width: 280,
      height: 8,
      decoration: BoxDecoration(
        color: AppTheme.greyLight,
        borderRadius: BorderRadius.circular(10),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: Stack(
          children: [
            Container(
              width: totalProgress > 0 ? 280 * (currentProgress / totalProgress) : 0,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [AppTheme.swissRed, AppTheme.swissRedLight],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPercentageText(BuildContext context) {
    return Text(
      '${((currentProgress / totalProgress * 100).clamp(0, 100)).toInt()}%',
      style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
            color: AppTheme.swissRed,
          ),
    );
  }
}
