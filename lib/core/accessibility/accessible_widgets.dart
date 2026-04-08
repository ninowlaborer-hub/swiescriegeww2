// core/accessibility/accessible_widgets.dart
import 'package:flutter/material.dart';

/// Accessible card with proper semantic labeling
class AccessibleCard extends StatelessWidget {
  const AccessibleCard({
    super.key,
    required this.child,
    this.semanticLabel,
    this.onTap,
    this.margin,
    this.padding,
  });

  final Widget child;
  final String? semanticLabel;
  final VoidCallback? onTap;
  final EdgeInsetsGeometry? margin;
  final EdgeInsetsGeometry? padding;

  @override
  Widget build(BuildContext context) {
    final card = Card(
      margin: margin,
      child: padding != null
          ? Padding(padding: padding!, child: child)
          : child,
    );

    if (semanticLabel != null || onTap != null) {
      return Semantics(
        label: semanticLabel,
        button: onTap != null,
        enabled: onTap != null,
        child: InkWell(
          onTap: onTap,
          child: card,
        ),
      );
    }

    return card;
  }
}

/// Accessible list tile with semantic labels
class AccessibleListTile extends StatelessWidget {
  const AccessibleListTile({
    super.key,
    required this.title,
    this.subtitle,
    this.leading,
    this.trailing,
    this.onTap,
    this.semanticLabel,
    this.isThreeLine = false,
  });

  final Widget title;
  final Widget? subtitle;
  final Widget? leading;
  final Widget? trailing;
  final VoidCallback? onTap;
  final String? semanticLabel;
  final bool isThreeLine;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: semanticLabel,
      button: onTap != null,
      enabled: onTap != null,
      excludeSemantics: semanticLabel != null, // Exclude child semantics if we provide our own
      child: ListTile(
        title: title,
        subtitle: subtitle,
        leading: leading,
        trailing: trailing,
        onTap: onTap,
        isThreeLine: isThreeLine,
      ),
    );
  }
}

/// Accessible text with proper semantic properties
class AccessibleText extends StatelessWidget {
  const AccessibleText(
    this.data, {
    super.key,
    this.style,
    this.semanticLabel,
    this.isHeader = false,
    this.textAlign,
    this.maxLines,
    this.overflow,
  });

  final String data;
  final TextStyle? style;
  final String? semanticLabel;
  final bool isHeader;
  final TextAlign? textAlign;
  final int? maxLines;
  final TextOverflow? overflow;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: semanticLabel ?? data,
      header: isHeader,
      child: Text(
        data,
        style: style,
        textAlign: textAlign,
        maxLines: maxLines,
        overflow: overflow,
      ),
    );
  }
}

/// Accessible icon with semantic label
class AccessibleIcon extends StatelessWidget {
  const AccessibleIcon(
    this.icon, {
    super.key,
    required this.semanticLabel,
    this.size,
    this.color,
  });

  final IconData icon;
  final String semanticLabel;
  final double? size;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: semanticLabel,
      child: ExcludeSemantics(
        child: Icon(icon, size: size, color: color),
      ),
    );
  }
}

/// Accessible progress indicator with percentage announcement
class AccessibleProgressIndicator extends StatelessWidget {
  const AccessibleProgressIndicator({
    super.key,
    required this.value,
    required this.semanticLabel,
    this.backgroundColor,
    this.color,
  });

  final double? value; // 0.0 to 1.0, or null for indeterminate
  final String semanticLabel;
  final Color? backgroundColor;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final percentageLabel = value != null
        ? '$semanticLabel: ${(value! * 100).round()}%'
        : '$semanticLabel: loading';

    return Semantics(
      label: percentageLabel,
      value: value != null ? '${(value! * 100).round()}%' : 'indeterminate',
      child: ExcludeSemantics(
        child: LinearProgressIndicator(
          value: value,
          backgroundColor: backgroundColor,
          color: color,
        ),
      ),
    );
  }
}

/// Accessible switch with state announcement
class AccessibleSwitch extends StatelessWidget {
  const AccessibleSwitch({
    super.key,
    required this.value,
    required this.onChanged,
    required this.semanticLabel,
    this.activeColor,
  });

  final bool value;
  final ValueChanged<bool>? onChanged;
  final String semanticLabel;
  final Color? activeColor;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: semanticLabel,
      value: value ? 'on' : 'off',
      toggled: value,
      enabled: onChanged != null,
      child: Switch(
        value: value,
        onChanged: onChanged,
        activeColor: activeColor,
      ),
    );
  }
}

/// Accessible button with loading state
class AccessibleButton extends StatelessWidget {
  const AccessibleButton({
    super.key,
    required this.onPressed,
    required this.child,
    this.semanticLabel,
    this.isLoading = false,
    this.icon,
  });

  final VoidCallback? onPressed;
  final Widget child;
  final String? semanticLabel;
  final bool isLoading;
  final Widget? icon;

  @override
  Widget build(BuildContext context) {
    final effectiveLabel = semanticLabel ?? _extractTextFromChild(child);
    final labelWithState = isLoading ? '$effectiveLabel, loading' : effectiveLabel;

    Widget button;
    if (icon != null) {
      button = FilledButton.icon(
        onPressed: isLoading ? null : onPressed,
        icon: isLoading ? const SizedBox(
          width: 16,
          height: 16,
          child: CircularProgressIndicator(strokeWidth: 2),
        ) : icon!,
        label: child,
      );
    } else {
      button = FilledButton(
        onPressed: isLoading ? null : onPressed,
        child: isLoading ? const SizedBox(
          width: 16,
          height: 16,
          child: CircularProgressIndicator(strokeWidth: 2),
        ) : child,
      );
    }

    return Semantics(
      label: labelWithState,
      button: true,
      enabled: onPressed != null && !isLoading,
      child: button,
    );
  }

  String _extractTextFromChild(Widget widget) {
    if (widget is Text) {
      return widget.data ?? '';
    }
    return 'Button';
  }
}

/// Accessible date/time display with formatted announcement
class AccessibleDateTime extends StatelessWidget {
  const AccessibleDateTime({
    super.key,
    required this.dateTime,
    required this.format,
    this.style,
  });

  final DateTime dateTime;
  final DateTimeFormat format;
  final TextStyle? style;

  @override
  Widget build(BuildContext context) {
    final displayed = _formatForDisplay(dateTime, format);
    final announced = _formatForAnnouncement(dateTime, format);

    return Semantics(
      label: announced,
      child: ExcludeSemantics(
        child: Text(displayed, style: style),
      ),
    );
  }

  String _formatForDisplay(DateTime dt, DateTimeFormat format) {
    switch (format) {
      case DateTimeFormat.time:
        final hour = dt.hour > 12 ? dt.hour - 12 : (dt.hour == 0 ? 12 : dt.hour);
        final period = dt.hour >= 12 ? 'PM' : 'AM';
        return '${hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')} $period';
      case DateTimeFormat.date:
        return '${dt.month}/${dt.day}/${dt.year}';
      case DateTimeFormat.dateTime:
        return '${_formatForDisplay(dt, DateTimeFormat.date)} ${_formatForDisplay(dt, DateTimeFormat.time)}';
    }
  }

  String _formatForAnnouncement(DateTime dt, DateTimeFormat format) {
    final monthNames = ['', 'January', 'February', 'March', 'April', 'May', 'June',
      'July', 'August', 'September', 'October', 'November', 'December'];

    switch (format) {
      case DateTimeFormat.time:
        final hour = dt.hour > 12 ? dt.hour - 12 : (dt.hour == 0 ? 12 : dt.hour);
        final period = dt.hour >= 12 ? 'PM' : 'AM';
        return '$hour ${dt.minute.toString().padLeft(2, '0')} $period';
      case DateTimeFormat.date:
        return '${monthNames[dt.month]} ${dt.day}, ${dt.year}';
      case DateTimeFormat.dateTime:
        return '${_formatForAnnouncement(dt, DateTimeFormat.date)} at ${_formatForAnnouncement(dt, DateTimeFormat.time)}';
    }
  }
}

enum DateTimeFormat {
  time,
  date,
  dateTime,
}

/// Accessible empty state with helpful message
class AccessibleEmptyState extends StatelessWidget {
  const AccessibleEmptyState({
    super.key,
    required this.icon,
    required this.title,
    required this.message,
    this.action,
    this.actionLabel,
  });

  final IconData icon;
  final String title;
  final String message;
  final VoidCallback? action;
  final String? actionLabel;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final semanticMessage = action != null
        ? '$title. $message. ${actionLabel ?? "Action available"}'
        : '$title. $message';

    return Semantics(
      label: semanticMessage,
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ExcludeSemantics(
                child: Icon(icon, size: 64, color: Colors.grey),
              ),
              const SizedBox(height: 16),
              ExcludeSemantics(
                child: Text(
                  title,
                  style: theme.textTheme.titleLarge,
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 8),
              ExcludeSemantics(
                child: Text(
                  message,
                  style: theme.textTheme.bodyMedium?.copyWith(color: Colors.grey),
                  textAlign: TextAlign.center,
                ),
              ),
              if (action != null && actionLabel != null) ...[
                const SizedBox(height: 24),
                AccessibleButton(
                  onPressed: action,
                  semanticLabel: actionLabel,
                  child: Text(actionLabel!),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
