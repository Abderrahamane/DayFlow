// lib/pages/terms_privacy_page.dart
import 'package:flutter/material.dart';
import 'package:dayflow/utils/app_localizations.dart';

class TermsPrivacyPage extends StatelessWidget {
  const TermsPrivacyPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.termsAndPrivacy),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Text(
              'Terms of Service & Privacy Policy',
              style: theme.textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Last updated: ${_getLastUpdatedDate()}',
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurface.withOpacity(0.6),
              ),
            ),
            const SizedBox(height: 24),

            // Terms of Service
            _buildSection(
              context,
              title: 'Terms of Service',
              content: '''
1. Acceptance of Terms
By accessing and using DayFlow ("the App"), you accept and agree to be bound by the terms and provisions of this agreement.

2. Use License
DayFlow grants you a personal, non-exclusive, non-transferable license to use the App for personal productivity purposes.

3. User Accounts
• You are responsible for maintaining the confidentiality of your account
• You must provide accurate and complete information
• You must be at least 13 years old to use the App
• You are responsible for all activities under your account

4. User Content
• You retain all rights to your data (tasks, notes, reminders)
• You grant DayFlow a license to store and sync your data
• We do not claim ownership of your content
• You can delete your data at any time

5. Prohibited Uses
You agree not to use the App to:
• Violate any laws or regulations
• Infringe on others' intellectual property rights
• Upload malicious code or viruses
• Attempt to gain unauthorized access
• Harass or harm other users

6. Service Modifications
We reserve the right to:
• Modify or discontinue features
• Update these terms
• Suspend accounts that violate terms
• Refuse service to anyone

7. Disclaimer of Warranties
The App is provided "as is" without warranties of any kind. We do not guarantee uninterrupted or error-free service.

8. Limitation of Liability
DayFlow shall not be liable for any indirect, incidental, special, or consequential damages arising from your use of the App.
''',
            ),

            const SizedBox(height: 24),

            // Privacy Policy
            _buildSection(
              context,
              title: 'Privacy Policy',
              content: '''
1. Information We Collect
• Account Information: Name, email address
• Usage Data: App interactions, features used
• Device Information: Device type, OS version
• Content Data: Tasks, notes, reminders you create

2. How We Use Your Information
• Provide and maintain the App
• Sync your data across devices
• Send important notifications
• Improve our services
• Respond to support requests
• Ensure security and prevent fraud

3. Data Storage and Security
• Your data is encrypted in transit and at rest
• We use industry-standard security measures
• Data is stored on secure servers
• Regular security audits are performed

4. Data Sharing
We do not sell your personal information. We may share data only:
• With your consent
• For legal compliance
• To protect our rights
• With service providers (under strict agreements)

5. Your Privacy Rights
You have the right to:
• Access your personal data
• Correct inaccurate data
• Delete your account and data
• Export your data
• Opt-out of marketing communications
• Object to data processing

6. Cookies and Tracking
We use cookies and similar technologies to:
• Remember your preferences
• Understand app usage
• Improve user experience
• We do not use advertising trackers

7. Children's Privacy
The App is not intended for children under 13. We do not knowingly collect data from children.

8. Data Retention
• Active account data is retained as long as your account is active
• Deleted data is permanently removed within 30 days
• Backup copies are deleted within 90 days

9. International Data Transfers
Your data may be transferred and stored in different countries. We ensure appropriate safeguards are in place.

10. Third-Party Services
The App may integrate with:
• Cloud storage providers
• Analytics services
• Notification services
Each has their own privacy policies.

11. Changes to Privacy Policy
We will notify you of significant changes via:
• In-app notifications
• Email
• App update notes

12. Contact Us
For privacy concerns or requests:
• Email: privacy@dayflow.app
• Response time: Within 48 hours
''',
            ),

            const SizedBox(height: 24),

            // Data Collection Summary
            _buildSection(
              context,
              title: 'Data Collection Summary',
              content: '''
✓ What we collect:
• Name and email (for account)
• Tasks, notes, reminders (your content)
• App usage patterns
• Device information

✗ What we DON'T collect:
• Location data
• Contacts or photos
• Browsing history
• Financial information
• Biometric data
''',
            ),

            const SizedBox(height: 24),

            // User Rights
            _buildSection(
              context,
              title: 'Your Rights (GDPR/CCPA Compliant)',
              content: '''
You have the right to:

1. Access - Request a copy of your data
2. Rectification - Correct inaccurate data
3. Erasure - Delete your account and data
4. Portability - Export your data
5. Restriction - Limit how we process data
6. Objection - Object to data processing
7. Complaint - File a complaint with authorities

To exercise these rights, contact us at: rights@dayflow.app
''',
            ),

            const SizedBox(height: 32),

            // Agreement Checkbox
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: theme.colorScheme.primary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: theme.colorScheme.primary.withOpacity(0.3),
                  width: 2,
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.info_outline,
                    color: theme.colorScheme.primary,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'By using DayFlow, you agree to these Terms of Service and Privacy Policy.',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.primary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
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
        required String content,
      }) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
            color: theme.colorScheme.primary,
          ),
        ),
        const SizedBox(height: 12),
        Text(
          content,
          style: theme.textTheme.bodyMedium?.copyWith(
            height: 1.6,
            color: theme.colorScheme.onSurface.withOpacity(0.8),
          ),
        ),
      ],
    );
  }

  String _getLastUpdatedDate() {
    final now = DateTime.now();
    return '${_getMonthName(now.month)} ${now.day}, ${now.year}';
  }

  String _getMonthName(int month) {
    const months = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December'
    ];
    return months[month - 1];
  }
}