// core/ui/loading_states.dart
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'adaptive_widgets.dart';

/// Skeleton loader for time block list
class TimeBlockSkeleton extends StatelessWidget {
  const TimeBlockSkeleton({super.key, this.count = 5});

  final int count;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: count,
      itemBuilder: (context, index) => const Padding(
        padding: EdgeInsets.only(bottom: 12),
        child: _TimeBlockSkeletonItem(),
      ),
    );
  }
}

class _TimeBlockSkeletonItem extends StatelessWidget {
  const _TimeBlockSkeletonItem();

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const SkeletonBox(width: 60, height: 12),
                const SizedBox(width: 8),
                const SkeletonBox(width: 40, height: 12),
                const Spacer(),
                SkeletonBox(
                  width: 24,
                  height: 24,
                  borderRadius: BorderRadius.circular(12),
                ),
              ],
            ),
            const SizedBox(height: 12),
            const SkeletonBox(width: double.infinity, height: 16),
            const SizedBox(height: 8),
            const SkeletonBox(width: 200, height: 12),
          ],
        ),
      ),
    );
  }
}

/// Skeleton loader for routine summary card
class RoutineSummarySkeleton extends StatelessWidget {
  const RoutineSummarySkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SkeletonBox(width: 150, height: 20),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: Column(
                    children: [
                      SkeletonBox(
                        width: 40,
                        height: 40,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      const SizedBox(height: 8),
                      const SkeletonBox(width: 60, height: 12),
                    ],
                  ),
                ),
                Expanded(
                  child: Column(
                    children: [
                      SkeletonBox(
                        width: 40,
                        height: 40,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      const SizedBox(height: 8),
                      const SkeletonBox(width: 60, height: 12),
                    ],
                  ),
                ),
                Expanded(
                  child: Column(
                    children: [
                      SkeletonBox(
                        width: 40,
                        height: 40,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      const SizedBox(height: 8),
                      const SkeletonBox(width: 60, height: 12),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

/// Skeleton box with shimmer animation
class SkeletonBox extends StatefulWidget {
  const SkeletonBox({
    super.key,
    required this.width,
    required this.height,
    this.borderRadius,
  });

  final double width;
  final double height;
  final BorderRadius? borderRadius;

  @override
  State<SkeletonBox> createState() => _SkeletonBoxState();
}

class _SkeletonBoxState extends State<SkeletonBox>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat();

    _animation = Tween<double>(begin: -1.0, end: 2.0).animate(
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
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final baseColor = isDark ? Colors.grey[800]! : Colors.grey[300]!;
    final highlightColor = isDark ? Colors.grey[700]! : Colors.grey[100]!;

    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Container(
          width: widget.width,
          height: widget.height,
          decoration: BoxDecoration(
            borderRadius: widget.borderRadius ?? BorderRadius.circular(4),
            gradient: LinearGradient(
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
              colors: [
                baseColor,
                highlightColor,
                baseColor,
              ],
              stops: [
                _animation.value - 0.3,
                _animation.value,
                _animation.value + 0.3,
              ],
            ),
          ),
        );
      },
    );
  }
}

/// Loading overlay for entire screen
class LoadingOverlay extends StatelessWidget {
  const LoadingOverlay({
    super.key,
    required this.isLoading,
    required this.child,
    this.message,
  });

  final bool isLoading;
  final Widget child;
  final String? message;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        child,
        if (isLoading)
          Container(
            color: Colors.black54,
            child: Center(
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const AdaptiveActivityIndicator(),
                      if (message != null) ...[
                        const SizedBox(height: 16),
                        Text(message!),
                      ],
                    ],
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }
}

/// Button with loading state
class LoadingButton extends StatelessWidget {
  const LoadingButton({
    super.key,
    required this.onPressed,
    required this.child,
    this.isLoading = false,
    this.icon,
  });

  final VoidCallback? onPressed;
  final Widget child;
  final bool isLoading;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return FilledButton(
        onPressed: null,
        child: const SizedBox(
          width: 16,
          height: 16,
          child: CircularProgressIndicator(strokeWidth: 2),
        ),
      );
    }

    if (icon != null) {
      return FilledButton.icon(
        onPressed: onPressed,
        icon: Icon(icon),
        label: child,
      );
    }

    return FilledButton(
      onPressed: onPressed,
      child: child,
    );
  }
}

/// Pull to refresh wrapper
class PullToRefreshWrapper extends StatelessWidget {
  const PullToRefreshWrapper({
    super.key,
    required this.onRefresh,
    required this.child,
  });

  final Future<void> Function() onRefresh;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    if (Platform.isIOS) {
      return CustomScrollView(
        slivers: [
          CupertinoSliverRefreshControl(
            onRefresh: onRefresh,
          ),
          SliverFillRemaining(
            child: child,
          ),
        ],
      );
    }

    return RefreshIndicator(
      onRefresh: onRefresh,
      child: child,
    );
  }
}

/// Empty state with loading option
class StatefulEmptyOrLoading extends StatelessWidget {
  const StatefulEmptyOrLoading({
    super.key,
    required this.isLoading,
    required this.isEmpty,
    required this.emptyIcon,
    required this.emptyTitle,
    required this.emptyMessage,
    required this.child,
    this.skeletonBuilder,
    this.onRetry,
  });

  final bool isLoading;
  final bool isEmpty;
  final IconData emptyIcon;
  final String emptyTitle;
  final String emptyMessage;
  final Widget child;
  final Widget Function()? skeletonBuilder;
  final VoidCallback? onRetry;

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      if (skeletonBuilder != null) {
        return skeletonBuilder!();
      }
      return const Center(child: AdaptiveActivityIndicator());
    }

    if (isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(emptyIcon, size: 64, color: Colors.grey),
              const SizedBox(height: 16),
              Text(
                emptyTitle,
                style: Theme.of(context).textTheme.titleLarge,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                emptyMessage,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Colors.grey,
                    ),
                textAlign: TextAlign.center,
              ),
              if (onRetry != null) ...[
                const SizedBox(height: 24),
                FilledButton.icon(
                  onPressed: onRetry,
                  icon: const Icon(Icons.refresh),
                  label: const Text('Retry'),
                ),
              ],
            ],
          ),
        ),
      );
    }

    return child;
  }
}

/// Async data builder with loading/error states
class AsyncDataBuilder<T> extends StatelessWidget {
  const AsyncDataBuilder({
    super.key,
    required this.data,
    required this.builder,
    this.loadingBuilder,
    this.errorBuilder,
  });

  final AsyncSnapshot<T> data;
  final Widget Function(BuildContext context, T data) builder;
  final Widget Function(BuildContext context)? loadingBuilder;
  final Widget Function(BuildContext context, Object error)? errorBuilder;

  @override
  Widget build(BuildContext context) {
    if (data.hasError) {
      if (errorBuilder != null) {
        return errorBuilder!(context, data.error!);
      }
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, size: 64, color: Colors.red),
              const SizedBox(height: 16),
              Text(
                'Error',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 8),
              Text(
                data.error.toString(),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      );
    }

    if (!data.hasData) {
      if (loadingBuilder != null) {
        return loadingBuilder!(context);
      }
      return const Center(child: AdaptiveActivityIndicator());
    }

    return builder(context, data.data as T);
  }
}
