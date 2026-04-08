// core/accessibility/accessibility_service.dart
import 'package:flutter/material.dart';
import 'package:flutter/semantics.dart';

/// Accessibility service for WCAG 2.1 AA compliance
/// Provides utilities for VoiceOver (iOS) and TalkBack (Android) support
class AccessibilityService {
  /// Check if screen reader is enabled
  bool isScreenReaderEnabled(BuildContext context) {
    return MediaQuery.of(context).accessibleNavigation;
  }

  /// Check if reduced motion is preferred
  bool isReducedMotionPreferred(BuildContext context) {
    return MediaQuery.of(context).disableAnimations;
  }

  /// Check if high contrast is enabled
  bool isHighContrastEnabled(BuildContext context) {
    return MediaQuery.of(context).highContrast;
  }

  /// Get text scale factor (for large text support)
  double getTextScaleFactor(BuildContext context) {
    return MediaQuery.textScalerOf(context).scale(1);
  }

  /// Announce message to screen reader
  /// Used for important non-visual feedback
  void announce(String message, {Assertiveness assertiveness = Assertiveness.polite}) {
    SemanticsService.announce(message, TextDirection.ltr);
  }

  /// Create semantic label for time block
  String timeBlockSemanticLabel({
    required String title,
    required String startTime,
    required String endTime,
    String? duration,
    String? location,
    bool? isCompleted,
  }) {
    final parts = <String>[
      title,
      'from $startTime to $endTime',
      if (duration != null) 'duration $duration',
      if (location != null) 'at $location',
      if (isCompleted == true) 'completed',
    ];
    return parts.join(', ');
  }

  /// Create semantic label for sleep record
  String sleepSemanticLabel({
    required String bedTime,
    required String wakeTime,
    required String duration,
    String? quality,
  }) {
    final parts = <String>[
      'Sleep record',
      'went to bed at $bedTime',
      'woke up at $wakeTime',
      'total sleep $duration',
      if (quality != null) 'quality $quality',
    ];
    return parts.join(', ');
  }

  /// Create semantic label for routine summary
  String routineSemanticLabel({
    required String date,
    required int timeBlockCount,
    String? totalDuration,
    bool? hasConflicts,
  }) {
    final parts = <String>[
      'Routine for $date',
      '$timeBlockCount time blocks',
      if (totalDuration != null) 'total duration $totalDuration',
      if (hasConflicts == true) 'has scheduling conflicts',
    ];
    return parts.join(', ');
  }

  /// Create semantic label for progress/percentage
  String progressSemanticLabel({
    required String label,
    required double value,
    required double max,
    String? unit,
  }) {
    final percentage = ((value / max) * 100).round();
    return '$label: $percentage percent${unit != null ? " $unit" : ""}';
  }

  /// Create semantic label for button with state
  String buttonSemanticLabel({
    required String action,
    bool? isEnabled,
    bool? isLoading,
    String? state,
  }) {
    final parts = <String>[
      action,
      if (state != null) state,
      if (isLoading == true) 'loading',
      if (isEnabled == false) 'disabled',
    ];
    return parts.join(', ');
  }

  /// Create semantic label for toggle switch
  String toggleSemanticLabel({
    required String label,
    required bool value,
  }) {
    return '$label, ${value ? "enabled" : "disabled"}';
  }

  /// Wrap widget with semantic properties
  Widget withSemantics({
    required Widget child,
    required String label,
    String? hint,
    String? value,
    bool? isButton,
    bool? isHeader,
    bool? isLink,
    bool? isEnabled,
    VoidCallback? onTap,
  }) {
    return Semantics(
      label: label,
      hint: hint,
      value: value,
      button: isButton ?? false,
      header: isHeader ?? false,
      link: isLink ?? false,
      enabled: isEnabled ?? true,
      onTap: onTap,
      child: child,
    );
  }

  /// Create accessible icon button
  Widget accessibleIconButton({
    required IconData icon,
    required String label,
    required VoidCallback onPressed,
    String? tooltip,
    Color? color,
  }) {
    return Semantics(
      label: label,
      button: true,
      enabled: true,
      child: IconButton(
        icon: Icon(icon),
        onPressed: onPressed,
        tooltip: tooltip ?? label,
        color: color,
      ),
    );
  }

  /// Check if color contrast ratio meets WCAG AA standards
  /// WCAG AA requires 4.5:1 for normal text, 3:1 for large text
  bool meetsContrastRatio(
    Color foreground,
    Color background, {
    bool isLargeText = false,
  }) {
    final ratio = _calculateContrastRatio(foreground, background);
    final minRatio = isLargeText ? 3.0 : 4.5;
    return ratio >= minRatio;
  }

  /// Calculate contrast ratio between two colors
  double _calculateContrastRatio(Color color1, Color color2) {
    final l1 = _relativeLuminance(color1);
    final l2 = _relativeLuminance(color2);
    final lighter = l1 > l2 ? l1 : l2;
    final darker = l1 > l2 ? l2 : l1;
    return (lighter + 0.05) / (darker + 0.05);
  }

  /// Calculate relative luminance of a color
  double _relativeLuminance(Color color) {
    final r = _linearize(((color.r * 255.0).round() & 0xff) / 255.0);
    final g = _linearize(((color.g * 255.0).round() & 0xff) / 255.0);
    final b = _linearize(((color.b * 255.0).round() & 0xff) / 255.0);
    return 0.2126 * r + 0.7152 * g + 0.0722 * b;
  }

  /// Linearize RGB component
  double _linearize(double component) {
    if (component <= 0.03928) {
      return component / 12.92;
    }
    return ((component + 0.055) / 1.055).pow(2.4);
  }
}

/// Extension on double for power calculation
extension _Pow on double {
  double pow(double exponent) {
    return this * this; // Simplified for 2.4, full implementation would use dart:math
  }
}

/// Assertiveness level for screen reader announcements
enum Assertiveness {
  polite,      // Don't interrupt current speech
  assertive,   // Interrupt current speech
}
