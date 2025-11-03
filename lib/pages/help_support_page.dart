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
                    l10n.howCanWeHelp,
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    l10n.findAnswers,
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
              title: l10n.contactUs,
              children: [
                _buildContactOption(
                  context,
                  icon: Icons.email_outlined,
                  title: l10n.emailSupport,
                  subtitle: 'support@dayflow.app',
                  onTap: () => _launchEmail(context),
                ),
                const Divider(height: 1, indent: 72),
                _buildContactOption(
                  context,
                  icon: Icons.chat_bubble_outline,
                  title: l10n.liveChat,
                  subtitle: l10n.chatWithTeam,
                  onTap: () {
                    _showComingSoon(context);
                  },
                ),
                const Divider(height: 1, indent: 72),
                _buildContactOption(
                  context,
                  icon: Icons.bug_report_outlined,
                  title: l10n.reportProblem,
                  subtitle: l10n.letUsKnow,
                  onTap: () => _showReportDialog(context),
                ),
              ],
            ),

            const SizedBox(height: 8),

            // FAQ Section
            _buildSection(
              context,
              title: l10n.faq,
              children: [
                _buildFAQItem(
                  context,
                  question: l10n.faqCreateTask,
                  answer: l10n.faqCreateTaskAnswer,
                ),
                _buildFAQItem(
                  context,
                  question: l10n.faqDarkMode,
                  answer: l10n.faqDarkModeAnswer,
                ),
                _buildFAQItem(
                  context,
                  question: l10n.faqSyncData,
                  answer: l10n.faqSyncDataAnswer,
                ),
                _buildFAQItem(
                  context,
                  question: l10n.faqSetReminders,
                  answer: l10n.faqSetRemindersAnswer,
                ),
                _buildFAQItem(
                  context,
                  question: l10n.faqBackupData,
                  answer: l10n.faqBackupDataAnswer,
                ),
                _buildFAQItem(
                  context,
                  question: l10n.faqExportData,
                  answer: l10n.faqExportDataAnswer,
                ),
              ],
            ),

            const SizedBox(height: 8),

            // Resources
            _buildSection(
              context,
              title: l10n.resources,
              children: [
                _buildResourceItem(
                  context,
                  icon: Icons.menu_book,
                  title: l10n.userGuide,
                  subtitle: l10n.learnHowToUse,
                  onTap: () {
                    _showComingSoon(context);
                  },
                ),
                const Divider(height: 1, indent: 72),
                _buildResourceItem(
                  context,
                  icon: Icons.video_library,
                  title: l10n.videoTutorials,
                  subtitle: l10n.watchGuides,
                  onTap: () {
                    _showComingSoon(context);
                  },
                ),
                const Divider(height: 1, indent: 72),
                _buildResourceItem(
                  context,
                  icon: Icons.tips_and_updates,
                  title: l10n.tipsTricks,
                  subtitle: l10n.getMostOut,
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
    final l10n = AppLocalizations.of(context);

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
    final l10n = AppLocalizations.of(context);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Report a Problem'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CustomInput(
                label: l10n.problemType,
                hint: 'e.g., Bug, Feature Request, Other',
                controller: problemController,
                prefixIcon: Icons.category,
              ),
              const SizedBox(height: 16),
              CustomInput(
                label: l10n.description,
                hint: l10n.describeIssue,
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

            child: Text(l10n.submit),
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