// lib/pages/help_support_page.dart
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:dayflow/widgets/ui_kit.dart';
import 'package:dayflow/utils/app_localizations.dart';

class HelpSupportPage extends StatelessWidget {
  const HelpSupportPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.helpAndSupport),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Header Card
            CustomCard(
              margin: const EdgeInsets.all(16),
              child: Column(
                children: [
                  Icon(
                    Icons.support_agent,
                    size: 64,
                    color: theme.colorScheme.primary.withOpacity(0.7),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'How can we help you?',
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Find answers or reach out to our support team',
                    textAlign: TextAlign.center,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.onSurface.withOpacity(0.6),
                    ),
                  ),
                ],
              ),
            ),

            // Contact Options
            _buildSection(
              context,
              title: 'Contact Us',
              children: [
                _buildContactOption(
                  context,
                  icon: Icons.email_outlined,
                  title: 'Email Support',
                  subtitle: 'support@dayflow.app',
                  onTap: () => _launchEmail(context),
                ),
                const Divider(height: 1, indent: 72),
                _buildContactOption(
                  context,
                  icon: Icons.chat_bubble_outline,
                  title: 'Live Chat',
                  subtitle: 'Chat with our team',
                  onTap: () {
                    _showComingSoon(context);
                  },
                ),
                const Divider(height: 1, indent: 72),
                _buildContactOption(
                  context,
                  icon: Icons.bug_report_outlined,
                  title: 'Report a Problem',
                  subtitle: 'Let us know what went wrong',
                  onTap: () => _showReportDialog(context),
                ),
              ],
            ),

            const SizedBox(height: 8),

            // FAQ Section
            _buildSection(
              context,
              title: 'Frequently Asked Questions',
              children: [
                _buildFAQItem(
                  context,
                  question: 'How do I create a new task?',
                  answer:
                  'Tap the + button on the Tasks page, enter your task details, and tap Save. You can set priorities, due dates, and categories.',
                ),
                _buildFAQItem(
                  context,
                  question: 'How do I enable dark mode?',
                  answer:
                  'Go to Settings → Appearance, then toggle the Theme switch to enable dark mode.',
                ),
                _buildFAQItem(
                  context,
                  question: 'Can I sync my data across devices?',
                  answer:
                  'Yes! Sign in with your account and enable Cloud Sync in Settings → Backup & Sync.',
                ),
                _buildFAQItem(
                  context,
                  question: 'How do I set reminders?',
                  answer:
                  'Open a task or create a new one, tap on "Set Reminder", choose your date and time, and save.',
                ),
                _buildFAQItem(
                  context,
                  question: 'How do I backup my data?',
                  answer:
                  'Go to Settings → Backup & Sync, then tap "Backup Now". You can also enable Auto Backup.',
                ),
                _buildFAQItem(
                  context,
                  question: 'Can I export my data?',
                  answer:
                  'For Now this is not possible, maybe in the future yes.',
                ),
              ],
            ),

            const SizedBox(height: 8),

            // Resources
            _buildSection(
              context,
              title: 'Resources',
              children: [
                _buildResourceItem(
                  context,
                  icon: Icons.menu_book,
                  title: 'User Guide',
                  subtitle: 'Learn how to use DayFlow',
                  onTap: () {
                    _showComingSoon(context);
                  },
                ),
                const Divider(height: 1, indent: 72),
                _buildResourceItem(
                  context,
                  icon: Icons.video_library,
                  title: 'Video Tutorials',
                  subtitle: 'Watch step-by-step guides',
                  onTap: () {
                    _showComingSoon(context);
                  },
                ),
                const Divider(height: 1, indent: 72),
                _buildResourceItem(
                  context,
                  icon: Icons.tips_and_updates,
                  title: 'Tips & Tricks',
                  subtitle: 'Get the most out of DayFlow',
                  onTap: () {
                    _showComingSoon(context);
                  },
                ),
              ],
            ),

            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildSection(
      BuildContext context, {
        required String title,
        required List<Widget> children,
      }) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
          child: Text(
            title,
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: theme.colorScheme.primary,
            ),
          ),
        ),
        CustomCard(
          margin: const EdgeInsets.symmetric(horizontal: 16),
          padding: EdgeInsets.zero,
          child: Column(
            children: children,
          ),
        ),
      ],
    );
  }

  Widget _buildContactOption(
      BuildContext context, {
        required IconData icon,
        required String title,
        required String subtitle,
        required VoidCallback onTap,
      }) {
    final theme = Theme.of(context);

    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      leading: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: theme.colorScheme.primary.withOpacity(0.1),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(
          icon,
          color: theme.colorScheme.primary,
          size: 22,
        ),
      ),
      title: Text(
        title,
        style: theme.textTheme.titleMedium?.copyWith(
          fontWeight: FontWeight.w600,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: theme.textTheme.bodySmall?.copyWith(
          color: theme.colorScheme.onSurface.withOpacity(0.6),
        ),
      ),
      trailing: Icon(
        Icons.chevron_right,
        color: theme.colorScheme.onSurface.withOpacity(0.4),
      ),
      onTap: onTap,
    );
  }

  Widget _buildFAQItem(
      BuildContext context, {
        required String question,
        required String answer,
      }) {
    return ExpansionTile(
      tilePadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
      childrenPadding: const EdgeInsets.fromLTRB(20, 0, 20, 16),
      title: Text(
        question,
        style: Theme.of(context).textTheme.titleSmall?.copyWith(
          fontWeight: FontWeight.w600,
        ),
      ),
      children: [
        Text(
          answer,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
            height: 1.5,
          ),
        ),
      ],
    );
  }

  Widget _buildResourceItem(
      BuildContext context, {
        required IconData icon,
        required String title,
        required String subtitle,
        required VoidCallback onTap,
      }) {
    final theme = Theme.of(context);

    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      leading: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: theme.colorScheme.secondary.withOpacity(0.1),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(
          icon,
          color: theme.colorScheme.secondary,
          size: 22,
        ),
      ),
      title: Text(
        title,
        style: theme.textTheme.titleMedium?.copyWith(
          fontWeight: FontWeight.w600,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: theme.textTheme.bodySmall?.copyWith(
          color: theme.colorScheme.onSurface.withOpacity(0.6),
        ),
      ),
      trailing: Icon(
        Icons.chevron_right,
        color: theme.colorScheme.onSurface.withOpacity(0.4),
      ),
      onTap: onTap,
    );
  }

  Future<void> _launchEmail(BuildContext context) async {
    final Uri emailUri = Uri(
      scheme: 'mailto',
      path: 'support@dayflow.app',
      query: 'subject=DayFlow Support Request&body=Hi DayFlow Team,\n\n',
    );

    try {
      if (await canLaunchUrl(emailUri)) {
        await launchUrl(emailUri);
      } else {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Could not open email app'),
              behavior: SnackBarBehavior.floating,
            ),
          );
        }
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: $e'),
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    }
  }

  void _showReportDialog(BuildContext context) {
    final problemController = TextEditingController();
    final descriptionController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Report a Problem'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CustomInput(
                label: 'Problem Type',
                hint: 'e.g., Bug, Feature Request, Other',
                controller: problemController,
                prefixIcon: Icons.category,
              ),
              const SizedBox(height: 16),
              CustomInput(
                label: 'Description',
                hint: 'Describe the issue in detail',
                controller: descriptionController,
                type: InputType.multiline,
                maxLines: 5,
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('✓ Problem report submitted. We\'ll review it soon!'),
                  backgroundColor: Colors.green,
                  behavior: SnackBarBehavior.floating,
                ),
              );
            },
            child: const Text('Submit'),
          ),
        ],
      ),
    );
  }

  void _showComingSoon(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Coming soon!'),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
}