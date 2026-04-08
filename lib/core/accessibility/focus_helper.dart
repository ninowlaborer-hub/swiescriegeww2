// core/accessibility/focus_helper.dart
import 'package:flutter/material.dart';
import 'package:flutter/semantics.dart';

/// Helper for managing focus and screen reader navigation
class FocusHelper {
  /// Request focus on a specific widget (for screen readers)
  static void requestFocus(BuildContext context, GlobalKey key) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (key.currentContext != null) {
        Scrollable.ensureVisible(
          key.currentContext!,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  /// Announce a message to screen reader after a delay
  static Future<void> announceDelayed(
    String message, {
    Duration delay = const Duration(milliseconds: 500),
  }) async {
    await Future<void>.delayed(delay);
    SemanticsService.announce(message, TextDirection.ltr);
  }

  /// Create a focus scope for keyboard navigation
  static Widget createFocusScope({
    required Widget child,
    bool autofocus = false,
  }) {
    return FocusScope(
      autofocus: autofocus,
      child: child,
    );
  }
}

/// Widget that announces when it appears on screen
class AnnounceOnAppear extends StatefulWidget {
  const AnnounceOnAppear({
    super.key,
    required this.message,
    required this.child,
    this.delay = const Duration(milliseconds: 500),
  });

  final String message;
  final Widget child;
  final Duration delay;

  @override
  State<AnnounceOnAppear> createState() => _AnnounceOnAppearState();
}

class _AnnounceOnAppearState extends State<AnnounceOnAppear> {
  @override
  void initState() {
    super.initState();
    _announce();
  }

  Future<void> _announce() async {
    await Future<void>.delayed(widget.delay);
    if (mounted) {
      SemanticsService.announce(widget.message, TextDirection.ltr);
    }
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}

/// Widget that manages focus order for keyboard navigation
class FocusOrder extends StatelessWidget {
  const FocusOrder({
    super.key,
    required this.order,
    required this.child,
  });

  final double order;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return FocusTraversalOrder(
      order: NumericFocusOrder(order),
      child: child,
    );
  }
}

/// Keyboard navigation wrapper for lists
class KeyboardNavigableList extends StatelessWidget {
  const KeyboardNavigableList({
    super.key,
    required this.children,
    this.scrollDirection = Axis.vertical,
    this.padding,
  });

  final List<Widget> children;
  final Axis scrollDirection;
  final EdgeInsetsGeometry? padding;

  @override
  Widget build(BuildContext context) {
    return FocusTraversalGroup(
      policy: OrderedTraversalPolicy(),
      child: ListView(
        scrollDirection: scrollDirection,
        padding: padding,
        children: children,
      ),
    );
  }
}

/// Screen reader skip link (for jumping to main content)
class SkipToContent extends StatelessWidget {
  const SkipToContent({
    super.key,
    required this.contentKey,
    required this.child,
    this.label = 'Skip to main content',
  });

  final GlobalKey contentKey;
  final Widget child;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Hidden button for screen readers
        Semantics(
          label: label,
          button: true,
          child: SizedBox(
            height: 0,
            width: 0,
            child: TextButton(
              onPressed: () => _skipToContent(),
              child: const SizedBox.shrink(),
            ),
          ),
        ),
        Expanded(child: child),
      ],
    );
  }

  void _skipToContent() {
    if (contentKey.currentContext != null) {
      Scrollable.ensureVisible(
        contentKey.currentContext!,
        duration: const Duration(milliseconds: 300),
      );
    }
  }
}

/// Accessible section header with proper semantics
class SectionHeader extends StatelessWidget {
  const SectionHeader({
    super.key,
    required this.title,
    this.subtitle,
    this.level = 2,
  });

  final String title;
  final String? subtitle;
  final int level; // Heading level (1-6)

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textStyle = _getTextStyleForLevel(theme, level);

    return Semantics(
      header: true,
      label: subtitle != null ? '$title, $subtitle' : title,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ExcludeSemantics(
              child: Text(
                title,
                style: textStyle,
              ),
            ),
            if (subtitle != null) ...[
              const SizedBox(height: 4),
              ExcludeSemantics(
                child: Text(
                  subtitle!,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: Colors.grey,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  TextStyle? _getTextStyleForLevel(ThemeData theme, int level) {
    switch (level) {
      case 1:
        return theme.textTheme.displaySmall;
      case 2:
        return theme.textTheme.headlineMedium;
      case 3:
        return theme.textTheme.titleLarge;
      case 4:
        return theme.textTheme.titleMedium;
      case 5:
        return theme.textTheme.titleSmall;
      default:
        return theme.textTheme.bodyLarge;
    }
  }
}

/// Live region for dynamic content announcements
class LiveRegion extends StatelessWidget {
  const LiveRegion({
    super.key,
    required this.child,
    this.liveRegion = true,
  });

  final Widget child;
  final bool liveRegion;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      liveRegion: liveRegion,
      child: child,
    );
  }
}
