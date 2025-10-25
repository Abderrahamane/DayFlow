// Input field components

import 'package:flutter/material.dart';

enum InputType { text, password, email, number, multiline, search }

class CustomInput extends StatefulWidget {
  final String? label;
  final String? hint;
  final String? initialValue;
  final InputType type;
  final TextEditingController? controller;
  final String? Function(String?)? validator;
  final void Function(String)? onChanged;
  final void Function(String)? onSubmitted;
  final IconData? prefixIcon;
  final IconData? suffixIcon;
  final VoidCallback? onSuffixIconPressed;
  final bool enabled;
  final int? maxLines;
  final int? maxLength;
  final TextInputAction? textInputAction;
  final FocusNode? focusNode;

  const CustomInput({
    super.key,
    this.label,
    this.hint,
    this.initialValue,
    this.type = InputType.text,
    this.controller,
    this.validator,
    this.onChanged,
    this.onSubmitted,
    this.prefixIcon,
    this.suffixIcon,
    this.onSuffixIconPressed,
    this.enabled = true,
    this.maxLines,
    this.maxLength,
    this.textInputAction,
    this.focusNode,
  });

  @override
  State<CustomInput> createState() => _CustomInputState();
}

class _CustomInputState extends State<CustomInput> {
  bool _obscureText = true;
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = widget.controller ?? TextEditingController(text: widget.initialValue);
  }

  @override
  void dispose() {
    if (widget.controller == null) {
      _controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    // Configure input based on type
    TextInputType keyboardType;
    int? maxLines = widget.maxLines;
    bool obscureText = false;
    IconData? suffixIcon = widget.suffixIcon;
    VoidCallback? suffixIconPressed = widget.onSuffixIconPressed;

    switch (widget.type) {
      case InputType.password:
        keyboardType = TextInputType.visiblePassword;
        obscureText = _obscureText;
        suffixIcon = _obscureText ? Icons.visibility_off : Icons.visibility;
        suffixIconPressed = () {
          setState(() {
            _obscureText = !_obscureText;
          });
        };
        maxLines = 1;
        break;
      case InputType.email:
        keyboardType = TextInputType.emailAddress;
        maxLines = 1;
        break;
      case InputType.number:
        keyboardType = TextInputType.number;
        maxLines = 1;
        break;
      case InputType.multiline:
        keyboardType = TextInputType.multiline;
        maxLines ??= 5;
        break;
      case InputType.search:
        keyboardType = TextInputType.text;
        maxLines = 1;
        break;
      default:
        keyboardType = TextInputType.text;
        maxLines ??= 1;
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.label != null) ...[
          Text(
            widget.label!,
            style: theme.textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w600,
              color: theme.brightness == Brightness.dark
                  ? Colors.white
                  : Colors.black87,
            ),
          ),
          const SizedBox(height: 8),
        ],
        TextFormField(
          controller: _controller,
          focusNode: widget.focusNode,
          enabled: widget.enabled,
          obscureText: obscureText,
          keyboardType: keyboardType,
          maxLines: maxLines,
          maxLength: widget.maxLength,
          textInputAction: widget.textInputAction,
          validator: widget.validator,
          onChanged: widget.onChanged,
          onFieldSubmitted: widget.onSubmitted,
          style: theme.textTheme.bodyLarge,
          decoration: InputDecoration(
            hintText: widget.hint,
            hintStyle: TextStyle(
              color: theme.textTheme.bodyMedium?.color?.withOpacity(0.5),
            ),
            prefixIcon: widget.prefixIcon != null
                ? Icon(widget.prefixIcon, color: theme.colorScheme.primary)
                : null,
            suffixIcon: suffixIcon != null
                ? IconButton(
              icon: Icon(suffixIcon),
              onPressed: suffixIconPressed,
              color: theme.colorScheme.primary,
            )
                : null,
            filled: true,
            fillColor: theme.brightness == Brightness.dark
                ? Colors.grey.shade900
                : Colors.grey.shade100,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: theme.colorScheme.primary,
                width: 2,
              ),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: theme.colorScheme.error,
                width: 2,
              ),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: theme.colorScheme.error,
                width: 2,
              ),
            ),
            disabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 16,
            ),
          ),
        ),
      ],
    );
  }
}

// Search Input Component
class SearchInput extends StatelessWidget {
  final TextEditingController? controller;
  final String? hint;
  final void Function(String)? onChanged;
  final void Function(String)? onSubmitted;
  final VoidCallback? onClear;

  const SearchInput({
    super.key,
    this.controller,
    this.hint,
    this.onChanged,
    this.onSubmitted,
    this.onClear,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textController = controller ?? TextEditingController();

    return TextField(
      controller: textController,
      onChanged: onChanged,
      onSubmitted: onSubmitted,
      style: theme.textTheme.bodyLarge,
      decoration: InputDecoration(
        hintText: hint ?? 'Search...',
        hintStyle: TextStyle(
          color: theme.textTheme.bodyMedium?.color?.withOpacity(0.5),
        ),
        prefixIcon: Icon(Icons.search, color: theme.colorScheme.primary),
        suffixIcon: textController.text.isNotEmpty
            ? IconButton(
          icon: const Icon(Icons.clear),
          onPressed: () {
            textController.clear();
            if (onClear != null) onClear!();
            if (onChanged != null) onChanged!('');
          },
          color: theme.colorScheme.primary,
        )
            : null,
        filled: true,
        fillColor: theme.brightness == Brightness.dark
            ? Colors.grey.shade900
            : Colors.grey.shade100,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: theme.colorScheme.primary,
            width: 2,
          ),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 12,
        ),
      ),
    );
  }
}