import 'package:flutter/material.dart';

// Card components

// The base card widget that provides the container and styling
class CustomCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final Color? color;
  final double? elevation;
  final VoidCallback? onTap;
  final BorderRadius? borderRadius;
  final Border? border;

  const CustomCard({
    super.key,
    required this.child,
    this.padding,
    this.margin,
    this.color,
    this.elevation,
    this.onTap,
    this.borderRadius,
    this.border,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cardColor = color ?? theme.cardTheme.color ?? theme.colorScheme.surface;

    // The core container for the card's appearance
    Widget card = Container(
      margin: margin ?? const EdgeInsets.symmetric(vertical: 8, horizontal: 0),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: borderRadius ?? BorderRadius.circular(12),
        border: border,
        boxShadow: elevation != null && elevation! > 0
            ? [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: elevation! * 2,
                  offset: Offset(0, elevation! / 2),
                ),
              ]
            : null,
      ),
      child: Padding(
        padding: padding ?? const EdgeInsets.all(16),
        child: child,
      ),
    );

    // If an onTap function is provided, wrap the card in an InkWell for a ripple effect
    if (onTap != null) {
      return Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: borderRadius ?? BorderRadius.circular(12),
          child: card,
        ),
      );
    }

    return card;
  }
}

// Info Card with an Icon, Title, and optional Subtitle
class InfoCard extends StatelessWidget {
  final String title;
  final String? subtitle;
  final IconData icon;
  final Color? iconColor;
  final Color? backgroundColor;
  final VoidCallback? onTap;

  const InfoCard({
    super.key,
    required this.title,
    this.subtitle,
    required this.icon,
    this.iconColor,
    this.backgroundColor,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cardIconColor = iconColor ?? theme.colorScheme.primary;
    final cardBgColor = backgroundColor ?? cardIconColor.withOpacity(0.1);

    return CustomCard(
      onTap: onTap,
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: cardBgColor,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              icon,
              color: cardIconColor,
              size: 24,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: theme.textTheme.bodyLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                if (subtitle != null) ...[
                  const SizedBox(height: 4),
                  Text(
                    subtitle!,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.textTheme.bodyMedium?.color?.withOpacity(0.7),
                    ),
                  ),
                ],
              ],
            ),
          ),
          if (onTap != null)
            Icon(
              Icons.chevron_right,
              color: theme.textTheme.bodyMedium?.color?.withOpacity(0.5),
            ),
        ],
      ),
    );
  }
}

// Stat Card with a Progress Bar and Delete Icon
class StatCard extends StatelessWidget {
  final String label;
  final String value;
  final double progress;
  final IconData? icon;
  final Color? color;
  final VoidCallback? onDelete;
  final VoidCallback? onTap;

  const StatCard({
    super.key,
    required this.label,
    required this.value,
    this.icon,
    this.color,
    required this.progress,
    this.onDelete,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final statColor = color ?? theme.colorScheme.primary;

    return CustomCard(
      onTap: onTap,
      padding: const EdgeInsets.fromLTRB(20, 20, 16, 20), // Adjusted padding for icon
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Left Icon
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: statColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  icon,
                  color: statColor,
                  size: 24,
                ),
              ),
              const SizedBox(width: 12),

              // Progress Bar (FIXED: Wrapped in Expanded)
              Expanded(
                child: LinearProgressIndicator(
                  value: progress,
                  backgroundColor: statColor.withOpacity(0.2),
                  color: statColor,
                  minHeight: 6,
                  borderRadius: BorderRadius.circular(3),
                ),
              ),
              const SizedBox(width: 12), // Spacing before the icon

              // Delete Icon (Always Visible)
              Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: onDelete,
                  borderRadius: BorderRadius.circular(24),
                  child: const Padding(
                    padding: EdgeInsets.all(4.0),
                    child: Icon(
                      Icons.delete,
                      color: Colors.red,
                      size: 22,
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Main Value Text
          Text(
            value,
            style: theme.textTheme.headlineMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: statColor,
            ),
          ),
          const SizedBox(height: 4),

          // Label Text
          Text(
            label,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.textTheme.bodyMedium?.color?.withOpacity(0.7),
            ),
          ),
        ],
      ),
    );
  }
}