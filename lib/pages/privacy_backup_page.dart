// lib/pages/privacy_backup_page.dart
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:dayflow/widgets/ui_kit.dart';
import 'package:dayflow/utils/app_localizations.dart';
import 'package:path_provider/path_provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dayflow/data/repositories/task_repository.dart';
import 'package:dayflow/services/firebase_auth_service.dart';
import 'package:dayflow/utils/routes.dart';

class PrivacyBackupPage extends StatefulWidget {
  const PrivacyBackupPage({Key? key}) : super(key: key);

  @override
  State<PrivacyBackupPage> createState() => _PrivacyBackupPageState();
}

class _PrivacyBackupPageState extends State<PrivacyBackupPage> {
  bool _autoBackup = true;
  bool _cloudSync = false;
  bool _encryptData = true;
  DateTime? _lastBackup;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _autoBackup = prefs.getBool('auto_backup') ?? true;
      _cloudSync = prefs.getBool('cloud_sync') ?? false;
      _encryptData = prefs.getBool('encrypt_data') ?? true;
      final lastBackupStr = prefs.getString('last_backup');
      if (lastBackupStr != null) {
        _lastBackup = DateTime.parse(lastBackupStr);
      }
    });
  }

  Future<void> _saveSettings() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('auto_backup', _autoBackup);
    await prefs.setBool('cloud_sync', _cloudSync);
    await prefs.setBool('encrypt_data', _encryptData);
  }

  Future<void> _performBackup() async {
    setState(() {
      _isLoading = true;
    });

    // Simulate backup process
    await Future.delayed(const Duration(seconds: 2));

    final prefs = await SharedPreferences.getInstance();
    final now = DateTime.now();
    await prefs.setString('last_backup', now.toIso8601String());

    setState(() {
      _lastBackup = now;
      _isLoading = false;
    });

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('✓ Backup completed successfully'),
          backgroundColor: Colors.green,
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  Future<void> _restoreBackup() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Restore Backup'),
        content: const Text(
          'This will restore your data from the last backup. Current data will be replaced. Continue?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            style: TextButton.styleFrom(foregroundColor: Colors.orange),
            child: const Text('Restore'),
          ),
        ],
      ),
    );

    if (confirmed != true) return;

    setState(() {
      _isLoading = true;
    });

    // Simulate restore process
    await Future.delayed(const Duration(seconds: 2));

    setState(() {
      _isLoading = false;
    });

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('✓ Backup restored successfully'),
          backgroundColor: Colors.green,
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  Future<void> _syncWithCloud() async {
    setState(() {
      _isLoading = true;
    });

    // Simulate cloud sync
    await Future.delayed(const Duration(seconds: 2));

    setState(() {
      _isLoading = false;
    });

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('✓ Synced with cloud successfully'),
          backgroundColor: Colors.green,
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.backupAndSync),
        elevation: 0,
      ),
      body: _isLoading
          ? Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(
              color: theme.colorScheme.primary,
            ),
            const SizedBox(height: 16),
            Text(
              'Processing...',
              style: theme.textTheme.bodyLarge,
            ),
          ],
        ),
      )
          : SingleChildScrollView(
        child: Column(
          children: [
            // Backup Status Card
            CustomCard(
              margin: const EdgeInsets.all(16),
              child: Column(
                children: [
                  Icon(
                    Icons.cloud_done,
                    size: 64,
                    color: theme.colorScheme.primary.withValues(alpha: 0.7),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    l10n.backupStatus,
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    _lastBackup != null
                        ? l10n.lastBackup + ': ${_formatDate(_lastBackup!)}'
                        : l10n.noBackupsYet,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                    ),
                  ),
                ],
              ),
            ),

            // Quick Actions
            _buildSection(
              context,
              title: l10n.quickActions,
              children: [
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      CustomButton(
                        text: l10n.backupNow,
                        type: ButtonType.primary,
                        icon: Icons.backup,
                        width: double.infinity,
                        onPressed: _performBackup,
                      ),
                      const SizedBox(height: 12),
                      CustomButton(
                        text: l10n.restoreBackup,
                        type: ButtonType.outlined,
                        icon: Icons.restore,
                        width: double.infinity,
                        onPressed: _restoreBackup,
                      ),
                      const SizedBox(height: 12),
                      CustomButton(
                        text: l10n.syncWithCloud,
                        type: ButtonType.outlined,
                        icon: Icons.cloud_sync,
                        width: double.infinity,
                        onPressed: _syncWithCloud,
                      ),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 8),

            // Backup Settings
            _buildSection(
              context,
              title: l10n.backupSettings,
              children: [
                SwitchListTile(
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 8,
                  ),
                  secondary: Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: theme.colorScheme.primary.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(
                      Icons.autorenew,
                      color: theme.colorScheme.primary,
                      size: 22,
                    ),
                  ),
                  title: Text(l10n.autoBackup),
                  subtitle: Text(l10n.autoBackupDaily),
                  value: _autoBackup,
                  onChanged: (value) {
                    setState(() {
                      _autoBackup = value;
                    });
                    _saveSettings();
                  },
                ),
                const Divider(height: 1, indent: 72),
                SwitchListTile(
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 8,
                  ),
                  secondary: Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: theme.colorScheme.primary.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(
                      Icons.cloud_upload,
                      color: theme.colorScheme.primary,
                      size: 22,
                    ),
                  ),
                  title: Text(l10n.cloudSync),
                  subtitle: Text(l10n.syncAcrossDevices),
                  value: _cloudSync,
                  onChanged: (value) {
                    setState(() {
                      _cloudSync = value;
                    });
                    _saveSettings();
                  },
                ),
                const Divider(height: 1, indent: 72),
                SwitchListTile(
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 8,
                  ),
                  secondary: Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: theme.colorScheme.primary.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(
                      Icons.lock,
                      color: theme.colorScheme.primary,
                      size: 22,
                    ),
                  ),
                  title: Text(l10n.encryptData),
                  subtitle: Text(l10n.secureBackups),
                  value: _encryptData,
                  onChanged: (value) {
                    setState(() {
                      _encryptData = value;
                    });
                    _saveSettings();
                  },
                ),
              ],
            ),

            const SizedBox(height: 8),

            // Privacy Settings
            _buildSection(
              context,
              title: l10n.privacy,
              children: [
                _buildListItem(
                  context,
                  icon: Icons.delete_outline,
                  title: l10n.clearCache,
                  subtitle: l10n.freeUpStorage,
                  onTap: () {
                    _showClearCacheDialog(context);
                  },
                ),
                const Divider(height: 1, indent: 72),
                _buildListItem(
                  context,
                  icon: Icons.delete_forever,
                  title: l10n.deleteAllData,
                  subtitle: l10n.permanentlyRemove,
                  isDangerous: true,
                  onTap: () {
                    _showDeleteDataDialog(context);
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

  Widget _buildListItem(
      BuildContext context, {
        required IconData icon,
        required String title,
        required String subtitle,
        bool isDangerous = false,
        VoidCallback? onTap,
      }) {
    final theme = Theme.of(context);
    final color = isDangerous ? Colors.red : theme.colorScheme.primary;

    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      leading: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(
          icon,
          color: color,
          size: 22,
        ),
      ),
      title: Text(
        title,
        style: theme.textTheme.titleMedium?.copyWith(
          fontWeight: FontWeight.w600,
          color: isDangerous ? Colors.red : null,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: theme.textTheme.bodySmall?.copyWith(
          color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
        ),
      ),
      trailing: Icon(
        Icons.chevron_right,
        color: theme.colorScheme.onSurface.withValues(alpha: 0.4),
      ),
      onTap: onTap,
    );
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inMinutes < 1) {
      return 'Just now';
    } else if (difference.inHours < 1) {
      return '${difference.inMinutes} minutes ago';
    } else if (difference.inDays < 1) {
      return '${difference.inHours} hours ago';
    } else if (difference.inDays < 7) {
      return '${difference.inDays} days ago';
    } else {
      return '${date.day}/${date.month}/${date.year}';
    }
  }

  Future<void> _clearCache() async {
    try {
      // Clear Firestore persistence
      await FirebaseFirestore.instance.clearPersistence();

      // Clear temporary directory
      final tempDir = await getTemporaryDirectory();
      if (tempDir.existsSync()) {
        tempDir.deleteSync(recursive: true);
      }

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('✓ Cache cleared successfully'),
            backgroundColor: Colors.green,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to clear cache: $e'),
            backgroundColor: Colors.red,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    }
  }

  Future<void> _deleteAllData() async {
    try {
      // Clear local database
      final taskRepository = context.read<TaskRepository>();
      taskRepository.localDb.clearAllData();

      // Clear SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      await prefs.clear();

      // Clear Firestore persistence
      await FirebaseFirestore.instance.clearPersistence();

      // Sign out if logged in
      final authService = FirebaseAuthService();
      if (authService.isLoggedIn()) {
        await authService.logout();
      }

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('All data deleted'),
            backgroundColor: Colors.red,
            behavior: SnackBarBehavior.floating,
          ),
        );

        // Navigate to welcome screen
        Navigator.pushNamedAndRemoveUntil(
          context,
          Routes.welcome,
          (route) => false,
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to delete data: $e'),
            backgroundColor: Colors.red,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    }
  }

  void _showClearCacheDialog(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.clearCache),
        content: Text(l10n.clearCacheConfirm),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(l10n.cancel),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _clearCache();
            },
            child: Text(l10n.clear),
          ),
        ],
      ),
    );
  }

  void _showDeleteDataDialog(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.deleteAllData),
        content: Text(
          l10n.deleteDataConfirm,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(l10n.cancel),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _deleteAllData();
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: Text(l10n.allDataDeleted),
          ),
        ],
      ),
    );
  }
}