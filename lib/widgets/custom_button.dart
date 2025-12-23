// Button components

import 'package:flutter/material.dart';

enum ButtonType { primary, secondary, outlined, text }

enum ButtonSize { small, medium, large }

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final ButtonType type;
  final ButtonSize size;
  final IconData? icon;
  final bool isLoading;
  final double? width;

  const CustomButton({
    super.key,
    required this.text,
    this.onPressed,
    this.type = ButtonType.primary,
    this.size = ButtonSize.medium,
    this.icon,
    this.isLoading = false,
    this.width,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDisabled = onPressed == null || isLoading;

    // Size configurations
    double height;
    double fontSize;
    double iconSize;
    EdgeInsets padding;

    switch (size) {
      case ButtonSize.small:
        height = 36;
        fontSize = 14;
        iconSize = 18;
        padding = const EdgeInsets.symmetric(horizontal: 12, vertical: 8);
        break;
      case ButtonSize.medium:
        height = 44;
        fontSize = 16;
        iconSize = 20;
        padding = const EdgeInsets.symmetric(horizontal: 16, vertical: 12);
        break;
      case ButtonSize.large:
        height = 52;
        fontSize = 18;
        iconSize = 22;
        padding = const EdgeInsets.symmetric(horizontal: 20, vertical: 14);
        break;
    }

    Widget buttonChild = isLoading
        ? SizedBox(
      width: iconSize,
      height: iconSize,
      child: CircularProgressIndicator(
        strokeWidth: 2,
        valueColor: AlwaysStoppedAnimation<Color>(
          type == ButtonType.primary
              ? Colors.white
              : theme.colorScheme.primary,
        ),
      ),
    )
        : Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (icon != null) ...[
          Icon(icon, size: iconSize),
          const SizedBox(width: 8),
        ],
        Text(
          text,
          style: TextStyle(
            fontSize: fontSize,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );

    Widget button;

    switch (type) {
      case ButtonType.primary:
        button = ElevatedButton(
          onPressed: isDisabled ? null : onPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor: theme.colorScheme.primary,
            foregroundColor: Colors.white,
            disabledBackgroundColor: theme.colorScheme.primary.withOpacity(0.5),
            disabledForegroundColor: Colors.white.withOpacity(0.6),
            padding: padding,
            minimumSize: Size(width ?? 0, height),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            elevation: isDisabled ? 0 : 2,
          ),
          child: buttonChild,
        );
        break;

      case ButtonType.secondary:
        button = ElevatedButton(
          onPressed: isDisabled ? null : onPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor: theme.colorScheme.secondary,
            foregroundColor: Colors.white,
            disabledBackgroundColor: theme.colorScheme.secondary.withOpacity(0.5),
            disabledForegroundColor: Colors.white.withOpacity(0.6),
            padding: padding,
            minimumSize: Size(width ?? 0, height),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            elevation: isDisabled ? 0 : 2,
          ),
          child: buttonChild,
        );
        break;

      case ButtonType.outlined:
        button = OutlinedButton(
          onPressed: isDisabled ? null : onPressed,
          style: OutlinedButton.styleFrom(
            foregroundColor: theme.colorScheme.primary,
            disabledForegroundColor: theme.colorScheme.primary.withOpacity(0.5),
            padding: padding,
            minimumSize: Size(width ?? 0, height),
            side: BorderSide(
              color: isDisabled
                  ? theme.colorScheme.primary.withOpacity(0.3)
                  : theme.colorScheme.primary,
              width: 2,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          child: buttonChild,
        );
        break;

      case ButtonType.text:
        button = TextButton(
          onPressed: isDisabled ? null : onPressed,
          style: TextButton.styleFrom(
            foregroundColor: theme.colorScheme.primary,
            disabledForegroundColor: theme.colorScheme.primary.withOpacity(0.5),
            padding: padding,
            minimumSize: Size(width ?? 0, height),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          child: buttonChild,
        );
        break;
    }

    return SizedBox(
      width: width,
      child: button,
    );
  }
}

// Icon Button Component
class CustomIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback? onPressed;
  final Color? color;
  final Color? backgroundColor;
  final double size;
  final String? tooltip;

  const CustomIconButton({
    super.key,
    required this.icon,
    this.onPressed,
    this.color,
    this.backgroundColor,
    this.size = 40,
    this.tooltip,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final button = Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: backgroundColor ??
            (onPressed == null
                ? theme.colorScheme.primary.withOpacity(0.1)
                : theme.colorScheme.primary.withOpacity(0.1)),
        borderRadius: BorderRadius.circular(12),
      ),
      child: IconButton(
        icon: Icon(icon),
        onPressed: onPressed,
        color: color ??
            (onPressed == null
                ? theme.colorScheme.primary.withOpacity(0.5)
                : theme.colorScheme.primary),
        iconSize: size * 0.5,
        padding: EdgeInsets.zero,
      ),
    );

    if (tooltip != null) {
      return Tooltip(
        message: tooltip!,
        child: button,
      );
    }

    return button;
  }
}