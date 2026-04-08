// core/ui/haptic_service.dart
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Haptic feedback service for iOS and Android
/// Provides tactile responses for user interactions
class HapticService {
  /// Light impact (e.g., button tap, toggle switch)
  static Future<void> lightImpact() async {
    if (Platform.isIOS) {
      await HapticFeedback.lightImpact();
    } else {
      await HapticFeedback.vibrate();
    }
  }

  /// Medium impact (e.g., picker selection, drag and drop)
  static Future<void> mediumImpact() async {
    if (Platform.isIOS) {
      await HapticFeedback.mediumImpact();
    } else {
      await HapticFeedback.vibrate();
    }
  }

  /// Heavy impact (e.g., deletion, error)
  static Future<void> heavyImpact() async {
    if (Platform.isIOS) {
      await HapticFeedback.heavyImpact();
    } else {
      await HapticFeedback.vibrate();
    }
  }

  /// Selection changed (e.g., scrolling through list, adjusting slider)
  static Future<void> selectionClick() async {
    await HapticFeedback.selectionClick();
  }

  /// Success feedback (e.g., save completed, task completed)
  static Future<void> success() async {
    if (Platform.isIOS) {
      // iOS has notification feedback
      await HapticFeedback.mediumImpact();
      await Future<void>.delayed(const Duration(milliseconds: 100));
      await HapticFeedback.lightImpact();
    } else {
      await HapticFeedback.vibrate();
    }
  }

  /// Warning feedback (e.g., validation error, permission required)
  static Future<void> warning() async {
    if (Platform.isIOS) {
      await HapticFeedback.heavyImpact();
    } else {
      await HapticFeedback.vibrate();
    }
  }

  /// Error feedback (e.g., operation failed, critical error)
  static Future<void> error() async {
    if (Platform.isIOS) {
      await HapticFeedback.heavyImpact();
      await Future<void>.delayed(const Duration(milliseconds: 100));
      await HapticFeedback.heavyImpact();
    } else {
      await HapticFeedback.vibrate();
      await Future<void>.delayed(const Duration(milliseconds: 100));
      await HapticFeedback.vibrate();
    }
  }

  /// Long press feedback
  static Future<void> longPress() async {
    await HapticFeedback.vibrate();
  }

  /// Contextual feedback based on action type
  static Future<void> forAction(HapticAction action) async {
    switch (action) {
      case HapticAction.buttonTap:
        await lightImpact();
        break;
      case HapticAction.toggleSwitch:
        await lightImpact();
        break;
      case HapticAction.pickerChange:
        await selectionClick();
        break;
      case HapticAction.sliderChange:
        await selectionClick();
        break;
      case HapticAction.dragStart:
        await mediumImpact();
        break;
      case HapticAction.dragEnd:
        await mediumImpact();
        break;
      case HapticAction.delete:
        await heavyImpact();
        break;
      case HapticAction.save:
        await success();
        break;
      case HapticAction.taskComplete:
        await success();
        break;
      case HapticAction.validationError:
        await warning();
        break;
      case HapticAction.operationFailed:
        await error();
        break;
      case HapticAction.longPress:
        await longPress();
        break;
    }
  }
}

/// Common haptic action types
enum HapticAction {
  buttonTap,
  toggleSwitch,
  pickerChange,
  sliderChange,
  dragStart,
  dragEnd,
  delete,
  save,
  taskComplete,
  validationError,
  operationFailed,
  longPress,
}

/// Extension for adding haptic feedback to widgets
extension HapticGestureDetector on GestureDetector {
  /// Wrap onTap with haptic feedback
  static GestureDetector withHapticTap({
    required void Function()? onTap,
    required Widget child,
    HapticAction action = HapticAction.buttonTap,
  }) {
    return GestureDetector(
      onTap: onTap != null
          ? () async {
              await HapticService.forAction(action);
              onTap();
            }
          : null,
      child: child,
    );
  }

  /// Wrap onLongPress with haptic feedback
  static GestureDetector withHapticLongPress({
    required void Function()? onLongPress,
    required Widget child,
  }) {
    return GestureDetector(
      onLongPress: onLongPress != null
          ? () async {
              await HapticService.longPress();
              onLongPress();
            }
          : null,
      child: child,
    );
  }
}

/// Haptic-enabled button
class HapticButton extends StatelessWidget {
  const HapticButton({
    super.key,
    required this.onPressed,
    required this.child,
    this.hapticAction = HapticAction.buttonTap,
    this.icon,
  });

  final VoidCallback? onPressed;
  final Widget child;
  final HapticAction hapticAction;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    final handlePress = onPressed != null
        ? () async {
            await HapticService.forAction(hapticAction);
            onPressed!();
          }
        : null;

    if (icon != null) {
      return FilledButton.icon(
        onPressed: handlePress,
        icon: Icon(icon),
        label: child,
      );
    }

    return FilledButton(
      onPressed: handlePress,
      child: child,
    );
  }
}

/// Haptic-enabled icon button
class HapticIconButton extends StatelessWidget {
  const HapticIconButton({
    super.key,
    required this.icon,
    required this.onPressed,
    this.hapticAction = HapticAction.buttonTap,
    this.tooltip,
    this.color,
  });

  final IconData icon;
  final VoidCallback? onPressed;
  final HapticAction hapticAction;
  final String? tooltip;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final handlePress = onPressed != null
        ? () async {
            await HapticService.forAction(hapticAction);
            onPressed!();
          }
        : null;

    return IconButton(
      icon: Icon(icon),
      onPressed: handlePress,
      tooltip: tooltip,
      color: color,
    );
  }
}

/// Haptic-enabled switch
class HapticSwitch extends StatelessWidget {
  const HapticSwitch({
    super.key,
    required this.value,
    required this.onChanged,
  });

  final bool value;
  final ValueChanged<bool>? onChanged;

  @override
  Widget build(BuildContext context) {
    final handleChange = onChanged != null
        ? (bool newValue) async {
            await HapticService.forAction(HapticAction.toggleSwitch);
            onChanged!(newValue);
          }
        : null;

    return Switch(
      value: value,
      onChanged: handleChange,
    );
  }
}

/// Haptic-enabled slider
class HapticSlider extends StatefulWidget {
  const HapticSlider({
    super.key,
    required this.value,
    required this.onChanged,
    this.min = 0.0,
    this.max = 1.0,
    this.divisions,
  });

  final double value;
  final ValueChanged<double>? onChanged;
  final double min;
  final double max;
  final int? divisions;

  @override
  State<HapticSlider> createState() => _HapticSliderState();
}

class _HapticSliderState extends State<HapticSlider> {
  double? _lastHapticValue;

  @override
  Widget build(BuildContext context) {
    return Slider(
      value: widget.value,
      onChanged: widget.onChanged != null ? _handleChange : null,
      min: widget.min,
      max: widget.max,
      divisions: widget.divisions,
    );
  }

  void _handleChange(double value) {
    // Trigger haptic on discrete value changes (for divisions)
    if (widget.divisions != null) {
      final step = (widget.max - widget.min) / widget.divisions!;
      final currentStep = ((value - widget.min) / step).round();
      final lastStep = _lastHapticValue != null
          ? ((_lastHapticValue! - widget.min) / step).round()
          : null;

      if (lastStep == null || currentStep != lastStep) {
        HapticService.selectionClick();
        _lastHapticValue = value;
      }
    }

    widget.onChanged?.call(value);
  }
}
