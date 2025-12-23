// lib/pages/auth/forgot_password_page.dart

import 'package:flutter/material.dart';
import 'package:dayflow/widgets/ui_kit.dart';
import 'package:dayflow/services/firebase_auth_service.dart';
import 'package:dayflow/utils/auth_localizations.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({Key? key}) : super(key: key);

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _authService = FirebaseAuthService();

  bool _isLoading = false;
  bool _emailSent = false;

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _handleResetPassword() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final result = await _authService.resetPassword(
        _emailController.text.trim(),
      );

      if (!mounted) return;

      final l10n = AuthLocalizations.of(context);

      if (result['success']) {
        setState(() {
          _emailSent = true;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(l10n.passwordResetEmailSent),
            backgroundColor: Colors.green,
            behavior: SnackBarBehavior.floating,
          ),
        );
      } else {
        String errorMessage;
        switch (result['code']) {
          case 'user-not-found':
            errorMessage = l10n.userNotFound;
            break;
          case 'invalid-email':
            errorMessage = l10n.invalidEmail;
            break;
          case 'too-many-requests':
            errorMessage = l10n.tooManyRequests;
            break;
          default:
            errorMessage = result['message'] ?? l10n.failedToSendResetEmail;
        }

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(errorMessage),
            backgroundColor: Colors.red,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } catch (e) {
      if (!mounted) return;
      final l10n = AuthLocalizations.of(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('${l10n.errorOccurred}: $e'),
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AuthLocalizations.of(context);

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 40),

                // Back button
                Align(
                  alignment: Alignment.centerLeft,
                  child: CustomIconButton(
                    icon: Icons.arrow_back,
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                ),

                const SizedBox(height: 40),

                // Icon
                Center(
                  child: Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      color: theme.colorScheme.primary.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(24),
                    ),
                    child: Icon(
                      _emailSent ? Icons.mark_email_read : Icons.lock_reset,
                      color: theme.colorScheme.primary,
                      size: 50,
                    ),
                  ),
                ),

                const SizedBox(height: 32),

                // Title
                Text(
                  _emailSent ? l10n.checkYourEmail : l10n.forgotPassword,
                  style: theme.textTheme.headlineLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),

                const SizedBox(height: 12),

                // Subtitle
                Text(
                  _emailSent
                      ? l10n.resetEmailSent
                      : l10n.forgotPasswordDesc,
                  style: theme.textTheme.bodyLarge?.copyWith(
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                  ),
                  textAlign: TextAlign.center,
                ),

                const SizedBox(height: 48),

                if (!_emailSent) ...[
                  // Email input form
                  Form(
                    key: _formKey,
                    child: CustomInput(
                      label: l10n.email,
                      hint: l10n.enterEmail,
                      controller: _emailController,
                      type: InputType.email,
                      prefixIcon: Icons.email_outlined,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return l10n.pleaseEnterEmail;
                        }
                        if (!value.contains('@')) {
                          return l10n.pleaseEnterValidEmail;
                        }
                        return null;
                      },
                    ),
                  ),

                  const SizedBox(height: 32),

                  // Send reset link button
                  CustomButton(
                    text: l10n.sendResetLink,
                    type: ButtonType.primary,
                    size: ButtonSize.large,
                    icon: Icons.send,
                    isLoading: _isLoading,
                    onPressed: _isLoading ? null : _handleResetPassword,
                  ),
                ] else ...[
                  // Success actions
                  CustomButton(
                    text: l10n.resendEmail,
                    type: ButtonType.secondary,
                    size: ButtonSize.large,
                    icon: Icons.refresh,
                    isLoading: _isLoading,
                    onPressed: _isLoading
                        ? null
                        : () {
                      setState(() {
                        _emailSent = false;
                      });
                    },
                  ),

                  const SizedBox(height: 16),

                  CustomButton(
                    text: l10n.backToLogin,
                    type: ButtonType.outlined,
                    size: ButtonSize.large,
                    icon: Icons.arrow_back,
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                ],

                const SizedBox(height: 24),

                // Help text
                if (!_emailSent)
                  Center(
                    child: TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Text(
                        l10n.rememberPassword,
                        style: TextStyle(
                          color: theme.colorScheme.primary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),

                if (_emailSent) ...[
                  const SizedBox(height: 24),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: theme.colorScheme.outline.withValues(alpha: 0.2),
                      ),
                    ),
                    child: Column(
                      children: [
                        Icon(
                          Icons.info_outline,
                          color: theme.colorScheme.primary,
                          size: 24,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          l10n.didntReceiveEmail,
                          style: theme.textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          l10n.checkSpamFolder,
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}