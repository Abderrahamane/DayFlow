// lib/pages/settings_page.dart (LOCALIZED VERSION)
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:dayflow/widgets/ui_kit.dart';
import 'package:dayflow/blocs/language/language_cubit.dart';
import 'package:dayflow/blocs/theme/theme_cubit.dart';
import '../utils/settings_localizations.dart';
import '../utils/auth_localizations.dart';
import 'package:dayflow/utils/app_localizations.dart';
import 'package:dayflow/services/firebase_auth_service.dart';
import 'package:dayflow/utils/routes.dart';
import 'package:country_flags/country_flags.dart';


class SettingsPage extends StatefulWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  final _authService = FirebaseAuthService();

  String userName = "";
  String userEmail = "";
  bool isLoggedIn = false;
  bool _isLoading = true;
  bool _notificationsEnabled = true;

  static const String _keyNotificationsEnabled = 'notifications_enabled';

  // Language options with codes
  final Map<String, Map<String, String>> languages = {
    'English': {
      'code': 'en',
      'country': 'GB', // UK ISO code
    },
    'Français': {
      'code': 'fr',
      'country': 'FR', // France ISO code
    },
    'العربية': {
      'code': 'ar',
      'country': 'DZ', // Algeria ISO code
    },
  };

  @override
  void initState() {
    super.initState();
    _loadUserData();
    _loadNotificationSettings();
  }

  Future<void> _loadUserData() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final loggedIn = _authService.isLoggedIn();

      if (loggedIn) {
        final currentUser = _authService.currentUser;

        if (currentUser != null) {
          try {
            final userData = await _authService.getCurrentUserData();

            if (userData != null) {
              setState(() {
                isLoggedIn = true;
                userName = userData['name'] ?? currentUser.displayName ?? 'User';
                userEmail = userData['email'] ?? currentUser.email ?? '';
                _isLoading = false;
              });
              return;
            }
          } catch (e) {
            print('Firestore fetch failed: $e');
          }

          setState(() {
            isLoggedIn = true;
            userName = currentUser.displayName ?? 'User';
            userEmail = currentUser.email ?? '';
            _isLoading = false;
          });
          return;
        }
      }

      setState(() {
        isLoggedIn = false;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoggedIn = false;
        _isLoading = false;
      });
    }
  }

  Future<void> _loadNotificationSettings() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _notificationsEnabled = prefs.getBool(_keyNotificationsEnabled) ?? true;
    });
  }

  Future<void> _toggleNotifications(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_keyNotificationsEnabled, value);

    setState(() {
      _notificationsEnabled = value;
    });

    if (mounted) {
      final l10n = AppLocalizations.of(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
              value ? l10n.notificationsEnabled : l10n.notificationsDisabled
          ),
          duration: const Duration(seconds: 2),
          behavior: SnackBarBehavior.floating,
          backgroundColor: value ? Colors.green : Colors.orange,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final themeCubit = context.watch<ThemeCubit>();
    final languageCubit = context.watch<LanguageCubit>();
    final settingsL10n = SettingsLocalizations.of(context);
    final authL10n = AuthLocalizations.of(context);
    final isDarkMode = themeCubit.isDarkMode;

    if (_isLoading) {
      return Scaffold(
        body: Center(
          child: CircularProgressIndicator(
            color: theme.colorScheme.primary,
          ),
        ),
      );
    }

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Profile Section
            _buildProfileSection(context, isDarkMode, settingsL10n, authL10n),

            const SizedBox(height: 8),

            // Appearance Section
            _buildSection(
              context,
              title: settingsL10n.appearance,
              children: [
                _buildThemeToggle(context, themeCubit, settingsL10n),
              ],
            ),

            const SizedBox(height: 8),

            // Language Section
            _buildSection(
              context,
              title: settingsL10n.language,
              children: [
                _buildLanguageSelector(context, languageCubit, settingsL10n),
              ],
            ),

            const SizedBox(height: 8),

            // Account Section
            _buildSection(
              context,
              title: settingsL10n.account,
              children: [
                _buildAccountOptions(context, settingsL10n, authL10n),
              ],
            ),

            const SizedBox(height: 8),

            // Preferences Section
            _buildSection(
              context,
              title: settingsL10n.preferences,
              children: [
                _buildNotificationsToggle(context, settingsL10n),
                _buildPreferenceItem(
                  context,
                  icon: Icons.backup_outlined,
                  title: settingsL10n.backupAndSync,
                  subtitle: settingsL10n.cloudBackup,
                  onTap: () {
                    Navigator.pushNamed(context, Routes.privacyBackup);
                  },
                ),
              ],
            ),

            const SizedBox(height: 8),

            // About Section
            _buildSection(
              context,
              title: settingsL10n.about,
              children: [
                _buildPreferenceItem(
                  context,
                  icon: Icons.info_outline,
                  title: settingsL10n.aboutDayFlow,
                  subtitle: settingsL10n.version,
                  onTap: () {
                    _showAboutDialog(context, settingsL10n);
                  },
                ),
                _buildPreferenceItem(
                  context,
                  icon: Icons.help_outline,
                  title: settingsL10n.helpAndSupport,
                  subtitle: settingsL10n.getHelp,
                  onTap: () {
                    Navigator.pushNamed(context, Routes.helpSupport);
                  },
                ),
                _buildPreferenceItem(
                  context,
                  icon: Icons.description_outlined,
                  title: settingsL10n.termsAndPrivacy,
                  subtitle: settingsL10n.legalInfo,
                  onTap: () {
                    Navigator.pushNamed(context, Routes.termsPrivacy);
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

  Widget _buildProfileSection(BuildContext context, bool isDarkMode, SettingsLocalizations settingsL10n, AuthLocalizations authL10n) {
    final theme = Theme.of(context);

    return CustomCard(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(20),
      child: isLoggedIn ? _buildLoggedInProfile(theme, settingsL10n) : _buildLoggedOutProfile(theme, authL10n),
    );
  }

  Widget _buildLoggedInProfile(ThemeData theme, SettingsLocalizations settingsL10n) {
    return Column(
      children: [
        Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: LinearGradient(
              colors: [
                theme.colorScheme.primary,
                theme.colorScheme.secondary,
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Center(
            child: Text(
              _getInitials(userName),
              style: theme.textTheme.headlineMedium?.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        const SizedBox(height: 16),
        Text(
          userName,
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          userEmail,
          style: theme.textTheme.bodyMedium?.copyWith(
            color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
          ),
        ),
        const SizedBox(height: 20),
        CustomButton(
          text: settingsL10n.editProfile,
          type: ButtonType.outlined,
          size: ButtonSize.small,
          icon: Icons.edit_outlined,
          onPressed: () {
            _showEditProfileDialog(context, settingsL10n);
          },
        ),
      ],
    );
  }

  Widget _buildLoggedOutProfile(ThemeData theme, AuthLocalizations authL10n) {
    return Column(
      children: [
        Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: theme.colorScheme.primary.withValues(alpha: 0.1),
          ),
          child: Icon(
            Icons.account_circle_outlined,
            size: 48,
            color: theme.colorScheme.primary.withValues(alpha: 0.6),
          ),
        ),
        const SizedBox(height: 16),
        Text(
          authL10n.signIn,
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          authL10n.signInToContinueDesc,
          textAlign: TextAlign.center,
          style: theme.textTheme.bodySmall?.copyWith(
            color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
          ),
        ),
      ],
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

  Widget _buildThemeToggle(
      BuildContext context, ThemeCubit themeCubit, SettingsLocalizations settingsL10n) {
    final theme = Theme.of(context);
    final isDarkMode = themeCubit.isDarkMode;

    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      leading: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: theme.colorScheme.primary.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(
          isDarkMode ? Icons.dark_mode : Icons.light_mode,
          color: theme.colorScheme.primary,
          size: 22,
        ),
      ),
      title: Text(
        settingsL10n.theme,
        style: theme.textTheme.titleMedium?.copyWith(
          fontWeight: FontWeight.w600,
        ),
      ),
      subtitle: Text(
        isDarkMode ? settingsL10n.darkMode : settingsL10n.lightMode,
        style: theme.textTheme.bodySmall?.copyWith(
          color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
        ),
      ),
      trailing: Switch(
        value: isDarkMode,
        onChanged: (value) {
          themeCubit.toggleTheme();
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('${settingsL10n.themeChanged} ${value ? settingsL10n.darkMode : settingsL10n.lightMode}'),
              duration: const Duration(seconds: 2),
              behavior: SnackBarBehavior.floating,
            ),
          );
        },
        activeThumbColor: theme.colorScheme.primary,
      ),
    );
  }

  Widget _buildNotificationsToggle(BuildContext context, SettingsLocalizations settingsL10n) {
    final theme = Theme.of(context);

    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      leading: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: theme.colorScheme.primary.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(
          _notificationsEnabled
              ? Icons.notifications_active
              : Icons.notifications_off,
          color: theme.colorScheme.primary,
          size: 22,
        ),
      ),
      title: Text(
        settingsL10n.notifications,
        style: theme.textTheme.titleMedium?.copyWith(
          fontWeight: FontWeight.w600,
        ),
      ),
      subtitle: Text(
        _notificationsEnabled
            ? settingsL10n.receiveTaskAlerts
            : settingsL10n.noNotifications,
        style: theme.textTheme.bodySmall?.copyWith(
          color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
        ),
      ),
      trailing: Switch(
        value: _notificationsEnabled,
        onChanged: _toggleNotifications,
        activeThumbColor: theme.colorScheme.primary,
      ),
    );
  }

  Widget _buildLanguageSelector(
      BuildContext context, LanguageCubit languageCubit, SettingsLocalizations settingsL10n) {
    final theme = Theme.of(context);

    // Get current language country code
    String currentCountry = 'GB'; // Default
    for (var entry in languages.entries) {
      if (entry.value['code'] == languageCubit.state.languageCode) {
        currentCountry = entry.value['country']!;
        break;
      }
    }

    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      leading: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: theme.colorScheme.primary.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(10),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: CountryFlag.fromCountryCode(
            currentCountry,
            width: 32,
            height: 24,
          ),
        ),
      ),
      title: Text(
        settingsL10n.language,
        style: theme.textTheme.titleMedium?.copyWith(
          fontWeight: FontWeight.w600,
        ),
      ),
      subtitle: Text(
        languageCubit.languageName,
        style: theme.textTheme.bodySmall?.copyWith(
          color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
        ),
      ),
      trailing: Icon(
        Icons.chevron_right,
        color: theme.colorScheme.onSurface.withValues(alpha: 0.4),
      ),
      onTap: () {
        _showLanguageSelector(context, languageCubit, settingsL10n);
      },
    );
  }

  Widget _buildAccountOptions(BuildContext context, SettingsLocalizations settingsL10n, AuthLocalizations authL10n) {
    final theme = Theme.of(context);

    return Column(
      children: [
        if (isLoggedIn) ...[
          _buildPreferenceItem(
            context,
            icon: Icons.sync,
            title: settingsL10n.syncStatus,
            subtitle: settingsL10n.lastSynced,
            trailing: const Icon(
              Icons.check_circle,
              color: Colors.green,
              size: 20,
            ),
          ),
          const Divider(height: 1, indent: 72),
          _buildPreferenceItem(
            context,
            icon: Icons.security,
            title: settingsL10n.changePassword,
            subtitle: settingsL10n.updatePassword,
            onTap: () {
              _showChangePasswordDialog(context, settingsL10n);
            },
          ),
          const Divider(height: 1, indent: 72),
          ListTile(
            contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
            leading: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: Colors.red.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(
                Icons.logout,
                color: Colors.red,
                size: 22,
              ),
            ),
            title: Text(
              authL10n.logout,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
                color: Colors.red,
              ),
            ),
            onTap: () {
              _showLogoutDialog(context, authL10n);
            },
          ),
        ] else ...[
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                CustomButton(
                  text: authL10n.signup,
                  type: ButtonType.primary,
                  icon: Icons.person_add,
                  width: double.infinity,
                  onPressed: () {
                    Navigator.pushNamed(context, Routes.signup);
                  },
                ),
                const SizedBox(height: 12),
                CustomButton(
                  text: authL10n.login,
                  type: ButtonType.outlined,
                  icon: Icons.login,
                  width: double.infinity,
                  onPressed: () {
                    Navigator.pushNamed(context, Routes.login);
                  },
                ),
              ],
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildPreferenceItem(
      BuildContext context, {
        required IconData icon,
        required String title,
        required String subtitle,
        Widget? trailing,
        VoidCallback? onTap,
      }) {
    final theme = Theme.of(context);

    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      leading: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: theme.colorScheme.primary.withValues(alpha: 0.1),
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
          color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
        ),
      ),
      trailing: trailing ?? Icon(
        Icons.chevron_right,
        color: theme.colorScheme.onSurface.withValues(alpha: 0.4),
      ),
      onTap: onTap,
    );
  }

  String _getInitials(String name) {
    if (name.isEmpty) return '?';
    List<String> names = name.split(' ');
    if (names.length >= 2) {
      return '${names[0][0]}${names[1][0]}'.toUpperCase();
    }
    return name.substring(0, 1).toUpperCase();
  }

  void _showLanguageSelector(
      BuildContext context, LanguageCubit languageCubit, SettingsLocalizations settingsL10n) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (BuildContext context) {
        return Container(
          padding: const EdgeInsets.symmetric(vertical: 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Text(
                  settingsL10n.selectLanguage,
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              ...languages.entries.map((entry) {
                final languageName = entry.key;
                final languageCode = entry.value['code']!;
                final countryCode = entry.value['country']!;
                final isSelected = languageCubit.state.languageCode == languageCode;

                return ListTile(
                  leading: Container(
                    width: 56,
                    height: 40,
                    decoration: BoxDecoration(
                      color: isSelected
                          ? Theme.of(context).colorScheme.primary.withValues(alpha: 0.1)
                          : Colors.transparent,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: isSelected
                            ? Theme.of(context).colorScheme.primary
                            : Colors.grey.shade300,
                        width: 2,
                      ),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(6),
                      child: CountryFlag.fromCountryCode(
                        countryCode,
                        width: 52,
                        height: 36,
                      ),
                    ),
                  ),
                  title: Text(
                    languageName,
                    style: TextStyle(
                      fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                      color: isSelected
                          ? Theme.of(context).colorScheme.primary
                          : null,
                    ),
                  ),
                  trailing: isSelected
                      ? Icon(
                    Icons.check_circle,
                    color: Theme.of(context).colorScheme.primary,
                  )
                      : null,
                  onTap: () async {
                    await languageCubit.changeLanguage(languageCode);
                    if (!context.mounted) return;
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('${settingsL10n.languageChanged} $languageName'),
                        duration: const Duration(seconds: 2),
                        behavior: SnackBarBehavior.floating,
                      ),
                    );
                  },
                );
              }).toList(),
              const SizedBox(height: 10),
            ],
          ),
        );
      },
    );
  }

  void _showEditProfileDialog(BuildContext context, SettingsLocalizations settingsL10n) {
    final nameController = TextEditingController(text: userName);
    final emailController = TextEditingController(text: userEmail);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (BuildContext context) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: Container(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Center(
                  child: Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  settingsL10n.editProfile,
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 24),
                CustomInput(
                  label: settingsL10n.enterName,
                  hint: settingsL10n.enterName,
                  controller: nameController,
                  prefixIcon: Icons.person_outline,
                ),
                const SizedBox(height: 16),
                CustomInput(
                  label: settingsL10n.enterEmail,
                  hint: settingsL10n.enterEmail,
                  controller: emailController,
                  type: InputType.email,
                  prefixIcon: Icons.email_outlined,
                ),
                const SizedBox(height: 24),
                Row(
                  children: [
                    Expanded(
                      child: CustomButton(
                        text: settingsL10n.close, // Using close as cancel
                        type: ButtonType.outlined,
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: CustomButton(
                        text: settingsL10n.save,
                        type: ButtonType.primary,
                        onPressed: () async {
                          final result = await _authService.updateProfile(
                            name: nameController.text,
                            email: emailController.text,
                          );

                          if (result['success']) {
                            setState(() {
                              userName = nameController.text;
                              userEmail = emailController.text;
                            });
                          }

                          if (!mounted) return;
                          Navigator.pop(context);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(result['message']),
                              backgroundColor: result['success'] ? Colors.green : Colors.red,
                              behavior: SnackBarBehavior.floating,
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showLogoutDialog(BuildContext context, AuthLocalizations authL10n) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(authL10n.logoutConfirmation),
          content: Text(authL10n.areYouSureLogout),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text(authL10n.cancel),
            ),
            TextButton(
              onPressed: () async {
                await _authService.logout();
                if (!mounted) return;
                Navigator.pop(context);
                setState(() {
                  isLoggedIn = false;
                });
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(authL10n.logoutSuccess),
                    duration: const Duration(seconds: 2),
                    behavior: SnackBarBehavior.floating,
                  ),
                );
              },
              style: TextButton.styleFrom(
                foregroundColor: Colors.red,
              ),
              child: Text(authL10n.logout),
            ),
          ],
        );
      },
    );
  }

  void _showChangePasswordDialog(BuildContext context, SettingsLocalizations settingsL10n) {
    final currentPasswordController = TextEditingController();
    final newPasswordController = TextEditingController();
    final confirmPasswordController = TextEditingController();
    final formKey = GlobalKey<FormState>();
    bool isLoading = false;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Padding(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom,
              ),
              child: Container(
                padding: const EdgeInsets.all(20),
                child: Form(
                  key: formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Center(
                        child: Container(
                          width: 40,
                          height: 4,
                          decoration: BoxDecoration(
                            color: Colors.grey.shade300,
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      Text(
                        settingsL10n.changePassword,
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 24),
                      CustomInput(
                        label: settingsL10n.currentPassword,
                        hint: settingsL10n.enterCurrentPassword,
                        controller: currentPasswordController,
                        type: InputType.password,
                        prefixIcon: Icons.lock_outline,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return settingsL10n.pleaseEnterCurrentPassword;
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      CustomInput(
                        label: settingsL10n.newPassword,
                        hint: settingsL10n.enterNewPassword,
                        controller: newPasswordController,
                        type: InputType.password,
                        prefixIcon: Icons.lock_outline,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return settingsL10n.pleaseEnterNewPassword;
                          }
                          if (value.length < 6) {
                            // Assuming passwordTooShort is in SettingsLocalizations or hardcoded for now as it was in AppLocalizations
                            return 'Password too short';
                          }
                          if (value == currentPasswordController.text) {
                            return settingsL10n.passwordMustBeDifferent;
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      CustomInput(
                        label: settingsL10n.confirmNewPassword,
                        hint: settingsL10n.enterNewPassword, // Reusing enterNewPassword as hint or create reEnterPassword
                        controller: confirmPasswordController,
                        type: InputType.password,
                        prefixIcon: Icons.lock_outline,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please confirm password';
                          }
                          if (value != newPasswordController.text) {
                            return 'Passwords do not match';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 24),
                      Row(
                        children: [
                          Expanded(
                            child: CustomButton(
                              text: settingsL10n.close, // Using close as cancel
                              type: ButtonType.outlined,
                              onPressed: isLoading ? null : () {
                                Navigator.pop(context);
                              },
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: CustomButton(
                              text: settingsL10n.change,
                              type: ButtonType.primary,
                              isLoading: isLoading,
                              onPressed: isLoading ? null : () async {
                                if (!formKey.currentState!.validate()) {
                                  return;
                                }

                                setModalState(() {
                                  isLoading = true;
                                });

                                final result = await _authService.changePassword(
                                  currentPassword: currentPasswordController.text,
                                  newPassword: newPasswordController.text,
                                );

                                setModalState(() {
                                  isLoading = false;
                                });

                                if (!context.mounted) return;
                                Navigator.pop(context);

                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(result['message']),
                                    backgroundColor: result['success']
                                        ? Colors.green
                                        : Colors.red,
                                    behavior: SnackBarBehavior.floating,
                                  ),
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }



  void _showAboutDialog(BuildContext context, SettingsLocalizations settingsL10n) {
    final theme = Theme.of(context);

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      theme.colorScheme.primary,
                      theme.colorScheme.secondary,
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Icon(
                  Icons.calendar_today,
                  color: Colors.white,
                  size: 40,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                settingsL10n.aboutDayFlow,
                style: theme.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                settingsL10n.version,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                settingsL10n.appDescription,
                textAlign: TextAlign.center,
                style: theme.textTheme.bodySmall,
              ),
              const SizedBox(height: 24),
              Text(
                settingsL10n.developedBy,
                style: theme.textTheme.bodySmall?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                settingsL10n.teamMembers,
                textAlign: TextAlign.center,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                  height: 1.5,
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text(settingsL10n.close),
            ),
          ],
        );
      },
    );
  }
}

