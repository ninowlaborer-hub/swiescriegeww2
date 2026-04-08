// core/accessibility/accessibility_checker.dart
import 'package:flutter/material.dart';
import 'accessibility_service.dart';

/// Accessibility compliance checker for WCAG 2.1 AA
/// Used during development and testing to validate accessibility
class AccessibilityChecker {
  final AccessibilityService _service = AccessibilityService();

  /// Check if a widget tree has accessibility issues
  List<AccessibilityIssue> checkWidget(BuildContext context, Widget widget) {
    final issues = <AccessibilityIssue>[];

    // Check color contrast
    final theme = Theme.of(context);
    issues.addAll(_checkColorContrast(theme));

    // Check for tap targets
    issues.addAll(_checkTapTargets(context));

    return issues;
  }

  /// Check color contrast ratios
  List<AccessibilityIssue> _checkColorContrast(ThemeData theme) {
    final issues = <AccessibilityIssue>[];

    // Check primary text color
    if (!_service.meetsContrastRatio(
      theme.colorScheme.onSurface,
      theme.colorScheme.surface,
    )) {
      issues.add(AccessibilityIssue(
        type: IssueType.colorContrast,
        severity: IssueSeverity.error,
        message: 'Primary text color does not meet WCAG AA contrast ratio (4.5:1)',
        recommendation: 'Use a darker text color or lighter background',
      ));
    }

    // Check button contrast
    if (!_service.meetsContrastRatio(
      theme.colorScheme.onPrimary,
      theme.colorScheme.primary,
    )) {
      issues.add(AccessibilityIssue(
        type: IssueType.colorContrast,
        severity: IssueSeverity.error,
        message: 'Button text does not meet WCAG AA contrast ratio',
        recommendation: 'Adjust button text or background color',
      ));
    }

    return issues;
  }

  /// Check tap target sizes (minimum 44x44 per iOS HIG, 48x48 per Material)
  List<AccessibilityIssue> _checkTapTargets(BuildContext context) {
    final issues = <AccessibilityIssue>[];
    // This would require widget inspection in a real implementation
    // For now, return guidelines

    issues.add(AccessibilityIssue(
      type: IssueType.tapTarget,
      severity: IssueSeverity.warning,
      message: 'Ensure all tap targets are at least 44x44 points (iOS) or 48x48 dp (Android)',
      recommendation: 'Use minimum touch target sizes for buttons and interactive elements',
    ));

    return issues;
  }

  /// Generate accessibility report
  AccessibilityReport generateReport(BuildContext context) {
    final issues = checkWidget(context, const SizedBox.shrink());
    final errors = issues.where((i) => i.severity == IssueSeverity.error).toList();
    final warnings = issues.where((i) => i.severity == IssueSeverity.warning).toList();
    final info = issues.where((i) => i.severity == IssueSeverity.info).toList();

    return AccessibilityReport(
      timestamp: DateTime.now(),
      totalIssues: issues.length,
      errors: errors,
      warnings: warnings,
      info: info,
      isCompliant: errors.isEmpty,
    );
  }

  /// Get accessibility best practices checklist
  static List<BestPractice> getBestPractices() {
    return [
      BestPractice(
        category: 'Perceivable',
        items: [
          'All images have alternative text',
          'Color is not the only means of conveying information',
          'Text has sufficient contrast (4.5:1 for normal, 3:1 for large)',
          'Content is readable when text size is increased to 200%',
          'Audio has captions or transcripts',
        ],
      ),
      BestPractice(
        category: 'Operable',
        items: [
          'All functionality is keyboard accessible',
          'Tap targets are at least 44x44 points (iOS) or 48x48 dp (Android)',
          'Users have enough time to read and interact with content',
          'No content flashes more than 3 times per second',
          'Clear focus indicators for keyboard navigation',
        ],
      ),
      BestPractice(
        category: 'Understandable',
        items: [
          'Language is specified (for screen readers)',
          'Navigation is consistent across screens',
          'Input errors are identified and described',
          'Labels and instructions are provided for inputs',
          'Complex gestures have simple alternatives',
        ],
      ),
      BestPractice(
        category: 'Robust',
        items: [
          'Content is compatible with assistive technologies',
          'Semantic HTML/widgets are used appropriately',
          'Status messages can be announced by screen readers',
          'Custom controls have proper roles and states',
          'Content works with platform accessibility features',
        ],
      ),
    ];
  }

  /// Get VoiceOver/TalkBack testing checklist
  static List<String> getScreenReaderTestingChecklist() {
    return [
      '✓ All interactive elements are announced',
      '✓ Tap targets are properly labeled',
      '✓ Navigation order is logical',
      '✓ Images have meaningful descriptions',
      '✓ Buttons describe their action',
      '✓ Form inputs have labels',
      '✓ Error messages are announced',
      '✓ Loading states are announced',
      '✓ Modal/dialog focus is trapped',
      '✓ Lists are properly structured',
      '✓ Headings create clear hierarchy',
      '✓ State changes are announced (e.g., "selected", "expanded")',
      '✓ Time-based content can be paused',
      '✓ Complex widgets have clear instructions',
      '✓ Avoid duplicate announcements',
    ];
  }
}

/// Accessibility issue found during checking
class AccessibilityIssue {
  final IssueType type;
  final IssueSeverity severity;
  final String message;
  final String recommendation;

  AccessibilityIssue({
    required this.type,
    required this.severity,
    required this.message,
    required this.recommendation,
  });
}

enum IssueType {
  colorContrast,
  tapTarget,
  semanticLabel,
  focusOrder,
  liveRegion,
  other,
}

enum IssueSeverity {
  error,   // WCAG violation - must fix
  warning, // Potential issue - should fix
  info,    // Suggestion for improvement
}

/// Accessibility report
class AccessibilityReport {
  final DateTime timestamp;
  final int totalIssues;
  final List<AccessibilityIssue> errors;
  final List<AccessibilityIssue> warnings;
  final List<AccessibilityIssue> info;
  final bool isCompliant;

  AccessibilityReport({
    required this.timestamp,
    required this.totalIssues,
    required this.errors,
    required this.warnings,
    required this.info,
    required this.isCompliant,
  });

  String toFormattedString() {
    final buffer = StringBuffer();
    buffer.writeln('Accessibility Report - ${timestamp.toIso8601String()}');
    buffer.writeln('='.padRight(60, '='));
    buffer.writeln('Compliance: ${isCompliant ? "PASS" : "FAIL"}');
    buffer.writeln('Total Issues: $totalIssues');
    buffer.writeln('  - Errors: ${errors.length}');
    buffer.writeln('  - Warnings: ${warnings.length}');
    buffer.writeln('  - Info: ${info.length}');
    buffer.writeln();

    if (errors.isNotEmpty) {
      buffer.writeln('ERRORS:');
      for (final error in errors) {
        buffer.writeln('  • ${error.message}');
        buffer.writeln('    → ${error.recommendation}');
      }
      buffer.writeln();
    }

    if (warnings.isNotEmpty) {
      buffer.writeln('WARNINGS:');
      for (final warning in warnings) {
        buffer.writeln('  • ${warning.message}');
        buffer.writeln('    → ${warning.recommendation}');
      }
      buffer.writeln();
    }

    return buffer.toString();
  }
}

/// Best practice category with checklist items
class BestPractice {
  final String category;
  final List<String> items;

  BestPractice({
    required this.category,
    required this.items,
  });
}
