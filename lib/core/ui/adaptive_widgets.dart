// core/ui/adaptive_widgets.dart
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'dart:io';

/// Adaptive scaffold that uses Cupertino on iOS, Material on Android
class AdaptiveScaffold extends StatelessWidget {
  const AdaptiveScaffold({
    super.key,
    this.appBar,
    required this.body,
    this.floatingActionButton,
    this.bottomNavigationBar,
    this.backgroundColor,
  });

  final PreferredSizeWidget? appBar;
  final Widget body;
  final Widget? floatingActionButton;
  final Widget? bottomNavigationBar;
  final Color? backgroundColor;

  @override
  Widget build(BuildContext context) {
    if (Platform.isIOS) {
      return CupertinoPageScaffold(
        navigationBar: appBar != null ? _toCupertinoNavigationBar(appBar!) : null,
        backgroundColor: backgroundColor ?? CupertinoColors.systemBackground,
        child: SafeArea(
          child: body,
        ),
      );
    }

    return Scaffold(
      appBar: appBar,
      body: body,
      floatingActionButton: floatingActionButton,
      bottomNavigationBar: bottomNavigationBar,
      backgroundColor: backgroundColor,
    );
  }

  CupertinoNavigationBar _toCupertinoNavigationBar(PreferredSizeWidget appBar) {
    if (appBar is AppBar) {
      return CupertinoNavigationBar(
        middle: appBar.title,
        leading: appBar.leading,
        trailing: appBar.actions != null
            ? Row(
                mainAxisSize: MainAxisSize.min,
                children: appBar.actions!,
              )
            : null,
        backgroundColor: appBar.backgroundColor,
      );
    }
    throw UnsupportedError('Cannot convert ${appBar.runtimeType} to CupertinoNavigationBar');
  }
}

/// Adaptive button that uses Cupertino style on iOS
class AdaptiveButton extends StatelessWidget {
  const AdaptiveButton({
    super.key,
    required this.onPressed,
    required this.child,
    this.isPrimary = true,
  });

  final VoidCallback? onPressed;
  final Widget child;
  final bool isPrimary;

  @override
  Widget build(BuildContext context) {
    if (Platform.isIOS) {
      return CupertinoButton.filled(
        onPressed: onPressed,
        child: child,
      );
    }

    return isPrimary
        ? FilledButton(
            onPressed: onPressed,
            child: child,
          )
        : OutlinedButton(
            onPressed: onPressed,
            child: child,
          );
  }
}

/// Adaptive switch
class AdaptiveSwitch extends StatelessWidget {
  const AdaptiveSwitch({
    super.key,
    required this.value,
    required this.onChanged,
  });

  final bool value;
  final ValueChanged<bool>? onChanged;

  @override
  Widget build(BuildContext context) {
    if (Platform.isIOS) {
      return CupertinoSwitch(
        value: value,
        onChanged: onChanged,
      );
    }

    return Switch(
      value: value,
      onChanged: onChanged,
    );
  }
}

/// Adaptive slider
class AdaptiveSlider extends StatelessWidget {
  const AdaptiveSlider({
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
  Widget build(BuildContext context) {
    if (Platform.isIOS) {
      return CupertinoSlider(
        value: value,
        onChanged: onChanged,
        min: min,
        max: max,
        divisions: divisions,
      );
    }

    return Slider(
      value: value,
      onChanged: onChanged,
      min: min,
      max: max,
      divisions: divisions,
    );
  }
}

/// Adaptive activity indicator
class AdaptiveActivityIndicator extends StatelessWidget {
  const AdaptiveActivityIndicator({
    super.key,
    this.radius,
  });

  final double? radius;

  @override
  Widget build(BuildContext context) {
    if (Platform.isIOS) {
      return CupertinoActivityIndicator(
        radius: radius ?? 10,
      );
    }

    return CircularProgressIndicator(
      strokeWidth: 2,
    );
  }
}

/// Adaptive dialog
class AdaptiveDialog extends StatelessWidget {
  const AdaptiveDialog({
    super.key,
    required this.title,
    required this.content,
    required this.actions,
  });

  final String title;
  final String content;
  final List<AdaptiveDialogAction> actions;

  @override
  Widget build(BuildContext context) {
    if (Platform.isIOS) {
      return CupertinoAlertDialog(
        title: Text(title),
        content: Text(content),
        actions: actions.map((action) {
          return CupertinoDialogAction(
            onPressed: action.onPressed,
            isDefaultAction: action.isDefault,
            isDestructiveAction: action.isDestructive,
            child: Text(action.label),
          );
        }).toList(),
      );
    }

    return AlertDialog(
      title: Text(title),
      content: Text(content),
      actions: actions.map((action) {
        return TextButton(
          onPressed: action.onPressed,
          child: Text(
            action.label,
            style: action.isDestructive
                ? const TextStyle(color: Colors.red)
                : null,
          ),
        );
      }).toList(),
    );
  }

  static Future<T?> show<T>({
    required BuildContext context,
    required String title,
    required String content,
    required List<AdaptiveDialogAction> actions,
  }) {
    if (Platform.isIOS) {
      return showCupertinoDialog<T>(
        context: context,
        builder: (context) => AdaptiveDialog(
          title: title,
          content: content,
          actions: actions,
        ),
      );
    }

    return showDialog<T>(
      context: context,
      builder: (context) => AdaptiveDialog(
        title: title,
        content: content,
        actions: actions,
      ),
    );
  }
}

class AdaptiveDialogAction {
  final String label;
  final VoidCallback? onPressed;
  final bool isDefault;
  final bool isDestructive;

  AdaptiveDialogAction({
    required this.label,
    this.onPressed,
    this.isDefault = false,
    this.isDestructive = false,
  });
}

/// Adaptive modal bottom sheet
class AdaptiveModalBottomSheet extends StatelessWidget {
  const AdaptiveModalBottomSheet({
    super.key,
    required this.child,
  });

  final Widget child;

  @override
  Widget build(BuildContext context) {
    if (Platform.isIOS) {
      return CupertinoPopupSurface(
        child: Container(
          padding: const EdgeInsets.all(16),
          child: child,
        ),
      );
    }

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
        color: Theme.of(context).colorScheme.surface,
      ),
      child: child,
    );
  }

  static Future<T?> show<T>({
    required BuildContext context,
    required Widget child,
  }) {
    if (Platform.isIOS) {
      return showCupertinoModalPopup<T>(
        context: context,
        builder: (context) => AdaptiveModalBottomSheet(child: child),
      );
    }

    return showModalBottomSheet<T>(
      context: context,
      builder: (context) => child,
    );
  }
}

/// Adaptive date picker
class AdaptiveDatePicker {
  static Future<DateTime?> show({
    required BuildContext context,
    required DateTime initialDate,
    DateTime? firstDate,
    DateTime? lastDate,
  }) async {
    if (Platform.isIOS) {
      DateTime? selectedDate = initialDate;
      await showCupertinoModalPopup<void>(
        context: context,
        builder: (context) => Container(
          height: 300,
          color: CupertinoColors.systemBackground,
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CupertinoButton(
                    child: const Text('Cancel'),
                    onPressed: () {
                      selectedDate = null;
                      Navigator.pop(context);
                    },
                  ),
                  CupertinoButton(
                    child: const Text('Done'),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
              Expanded(
                child: CupertinoDatePicker(
                  mode: CupertinoDatePickerMode.date,
                  initialDateTime: initialDate,
                  minimumDate: firstDate,
                  maximumDate: lastDate,
                  onDateTimeChanged: (date) {
                    selectedDate = date;
                  },
                ),
              ),
            ],
          ),
        ),
      );
      return selectedDate;
    }

    return showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: firstDate ?? DateTime(1900),
      lastDate: lastDate ?? DateTime(2100),
    );
  }
}

/// Adaptive time picker
class AdaptiveTimePicker {
  static Future<TimeOfDay?> show({
    required BuildContext context,
    required TimeOfDay initialTime,
  }) async {
    if (Platform.isIOS) {
      TimeOfDay? selectedTime = initialTime;
      await showCupertinoModalPopup<void>(
        context: context,
        builder: (context) => Container(
          height: 300,
          color: CupertinoColors.systemBackground,
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CupertinoButton(
                    child: const Text('Cancel'),
                    onPressed: () {
                      selectedTime = null;
                      Navigator.pop(context);
                    },
                  ),
                  CupertinoButton(
                    child: const Text('Done'),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
              Expanded(
                child: CupertinoDatePicker(
                  mode: CupertinoDatePickerMode.time,
                  initialDateTime: DateTime(
                    2000,
                    1,
                    1,
                    initialTime.hour,
                    initialTime.minute,
                  ),
                  onDateTimeChanged: (date) {
                    selectedTime = TimeOfDay(hour: date.hour, minute: date.minute);
                  },
                ),
              ),
            ],
          ),
        ),
      );
      return selectedTime;
    }

    return showTimePicker(
      context: context,
      initialTime: initialTime,
    );
  }
}
