// Modal bottom sheet components

import 'package:flutter/material.dart';
import 'custom_button.dart';

class CustomModalSheet {
  // Show a custom modal bottom sheet
  static Future<T?> show<T>({
    required BuildContext context,
    required Widget child,
    String? title,
    bool isDismissible = true,
    bool enableDrag = true,
    double? height,
  }) {
    return showModalBottomSheet<T>(
      context: context,
      isScrollControlled: true,
      isDismissible: isDismissible,
      enableDrag: enableDrag,
      backgroundColor: Colors.transparent,
      builder: (context) => _ModalSheetWrapper(
        title: title,
        height: height,
        child: child,
      ),
    );
  }

  // Show a form modal sheet with action buttons
  static Future<bool?> showForm({
    required BuildContext context,
    required String title,
    required Widget child,
    String confirmText = 'Save',
    String cancelText = 'Cancel',
    required VoidCallback onConfirm,
    VoidCallback? onCancel,
    bool isDismissible = true,
  }) {
    return show<bool>(
      context: context,
      title: title,
      isDismissible: isDismissible,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          child,
          const SizedBox(height: 24),
          Row(
            children: [
              Expanded(
                child: CustomButton(
                  text: cancelText,
                  type: ButtonType.outlined,
                  onPressed: () {
                    if (onCancel != null) onCancel();
                    Navigator.pop(context, false);
                  },
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: CustomButton(
                  text: confirmText,
                  type: ButtonType.primary,
                  onPressed: () {
                    onConfirm();
                    Navigator.pop(context, true);
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // Show a list selection modal sheet
  static Future<T?> showListSelection<T>({
    required BuildContext context,
    required String title,
    required List<T> items,
    required String Function(T) itemBuilder,
    IconData Function(T)? iconBuilder,
    T? selectedItem,
  }) {
    return show<T>(
      context: context,
      title: title,
      child: ListView.separated(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: items.length,
        separatorBuilder: (context, index) => const Divider(height: 1),
        itemBuilder: (context, index) {
          final item = items[index];
          final isSelected = item == selectedItem;

          return ListTile(
            leading: iconBuilder != null
                ? Icon(
              iconBuilder(item),
              color: isSelected
                  ? Theme.of(context).colorScheme.primary
                  : null,
            )
                : null,
            title: Text(
              itemBuilder(item),
              style: TextStyle(
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                color: isSelected
                    ? Theme.of(context).colorScheme.primary
                    : null,
              ),
            ),
            trailing: isSelected
                ? Icon(
              Icons.check,
              color: Theme.of(context).colorScheme.primary,
            )
                : null,
            onTap: () => Navigator.pop(context, item),
          );
        },
      ),
    );
  }

  // Show a confirmation dialog modal
  static Future<bool?> showConfirmation({
    required BuildContext context,
    required String title,
    required String message,
    String confirmText = 'Confirm',
    String cancelText = 'Cancel',
    bool isDangerous = false,
  }) {
    return show<bool>(
      context: context,
      title: title,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            message,
            style: Theme.of(context).textTheme.bodyLarge,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          Row(
            children: [
              Expanded(
                child: CustomButton(
                  text: cancelText,
                  type: ButtonType.outlined,
                  onPressed: () => Navigator.pop(context, false),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: CustomButton(
                  text: confirmText,
                  type: ButtonType.primary,
                  onPressed: () => Navigator.pop(context, true),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// Internal wrapper widget for modal sheets
class _ModalSheetWrapper extends StatelessWidget {
  final String? title;
  final Widget child;
  final double? height;

  const _ModalSheetWrapper({
    this.title,
    required this.child,
    this.height,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      height: height,
      decoration: BoxDecoration(
        color: theme.scaffoldBackgroundColor,
        borderRadius: const BorderRadius.vertical(
          top: Radius.circular(24),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Drag handle
          Container(
            margin: const EdgeInsets.only(top: 12),
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: theme.textTheme.bodyMedium?.color?.withOpacity(0.3),
              borderRadius: BorderRadius.circular(2),
            ),
          ),

          // Title
          if (title != null)
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 16, 24, 8),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      title!,
                      style: theme.textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.pop(context),
                    color: theme.textTheme.bodyMedium?.color?.withOpacity(0.7),
                  ),
                ],
              ),
            ),

          // Content
          Flexible(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(24, 16, 24, 24),
              child: child,
            ),
          ),
        ],
      ),
    );
  }
}

// Quick action modal sheet
class QuickActionSheet extends StatelessWidget {
  final String title;
  final List<QuickAction> actions;

  const QuickActionSheet({
    super.key,
    required this.title,
    required this.actions,
  });

  static Future<void> show({
    required BuildContext context,
    required String title,
    required List<QuickAction> actions,
  }) {
    return CustomModalSheet.show(
      context: context,
      title: title,
      child: QuickActionSheet(
        title: title,
        actions: actions,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: actions.length,
      separatorBuilder: (context, index) => const SizedBox(height: 8),
      itemBuilder: (context, index) {
        final action = actions[index];
        return _ActionTile(action: action);
      },
    );
  }
}

class QuickAction {
  final String title;
  final String? subtitle;
  final IconData icon;
  final Color? color;
  final VoidCallback onTap;

  QuickAction({
    required this.title,
    this.subtitle,
    required this.icon,
    this.color,
    required this.onTap,
  });
}

class _ActionTile extends StatelessWidget {
  final QuickAction action;

  const _ActionTile({required this.action});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final actionColor = action.color ?? theme.colorScheme.primary;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          Navigator.pop(context);
          action.onTap();
        },
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: actionColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: actionColor.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  action.icon,
                  color: actionColor,
                  size: 24,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      action.title,
                      style: theme.textTheme.bodyLarge?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    if (action.subtitle != null) ...[
                      const SizedBox(height: 2),
                      Text(
                        action.subtitle!,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.textTheme.bodyMedium?.color
                              ?.withOpacity(0.7),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              Icon(
                Icons.chevron_right,
                color: theme.textTheme.bodyMedium?.color?.withOpacity(0.3),
              ),
            ],
          ),
        ),
      ),
    );
  }
}