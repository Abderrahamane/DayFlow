// lib/pages/settings_page.dart (UPDATED VERSION)
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:dayflow/widgets/ui_kit.dart';
import 'package:dayflow/theme/app_theme.dart';
import 'package:dayflow/services/auth_service.dart';
import 'package:dayflow/utils/routes.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  final _authService = AuthService();

  // User data
  String userName = "";
  String userEmail = "";

  // Language selection state
  String selectedLanguage = "English";
  final List<String> languages = [
    "English",
    "Français",
    "العربية",
    "Español",
  ];

  // Login state
  bool isLoggedIn = false;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    setState(() {
      _isLoading = true;
    });

    final loggedIn = await _authService.isLoggedIn();

    if (loggedIn) {
      final user = await _authService.getCurrentUser();
      if (user != null) {
        setState(() {
          isLoggedIn = true;
          userName = user['name'] ?? '';
          userEmail = user['email'] ?? '';
          _isLoading = false;
        });
        return;
      }
    }

    setState(() {
      isLoggedIn = false;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDarkMode = themeProvider.isDarkMode;

    if (_isLoading) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Settings'),
          elevation: 0,
        ),
        body: Center(
          child: CircularProgressIndicator(
            color: theme.colorScheme.primary,
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Profile Section
            _buildProfileSection(context, isDarkMode),

            const SizedBox(height: 8),

            // Appearance Section
            _buildSection(
              context,
              title: 'Appearance',
              children: [
                _buildThemeToggle(context, themeProvider),
              ],
            ),

            const SizedBox(height: 8),

            // Language Section
            _buildSection(
              context,
              title: 'Language & Region',
              children: [
                _buildLanguageSelector(context),
              ],
            ),

            const SizedBox(height: 8),

            // Account Section
            _buildSection(
              context,
              title: 'Account',
              children: [
                _buildAccountOptions(context),
              ],
            ),

            const SizedBox(height: 8),

            // Preferences Section
            _buildSection(
              context,
              title: 'Preferences',
              children: [
                _buildPreferenceItem(
                  context,
                  icon: Icons.notifications_outlined,
                  title: 'Notifications',
                  subtitle: 'Manage notification preferences',
                  onTap: () {
                    _showComingSoonDialog(context);
                  },
                ),
                _buildPreferenceItem(
                  context,
                  icon: Icons.lock_outline,
                  title: 'Privacy',
                  subtitle: 'Control your privacy settings',
                  onTap: () {
                    _showComingSoonDialog(context);
                  },
                ),
                _buildPreferenceItem(
                  context,
                  icon: Icons.backup_outlined,
                  title: 'Backup & Sync',
                  subtitle: 'Cloud backup settings',
                  onTap: () {
                    _showComingSoonDialog(context);
                  },
                ),
              ],
            ),

            const SizedBox(height: 8),

            // About Section
            _buildSection(
              context,
              title: 'About',
              children: [
                _buildPreferenceItem(
                  context,
                  icon: Icons.info_outline,
                  title: 'About DayFlow',
                  subtitle: 'Version 1.0.0',
                  onTap: () {
                    _showAboutDialog(context);
                  },
                ),
                _buildPreferenceItem(
                  context,
                  icon: Icons.help_outline,
                  title: 'Help & Support',
                  subtitle: 'Get help with DayFlow',
                  onTap: () {
                    _showComingSoonDialog(context);
                  },
                ),
                _buildPreferenceItem(
                  context,
                  icon: Icons.description_outlined,
                  title: 'Terms & Privacy Policy',
                  subtitle: 'Legal information',
                  onTap: () {
                    _showComingSoonDialog(context);
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

  Widget _buildProfileSection(BuildContext context, bool isDarkMode) {
    final theme = Theme.of(context);

    return CustomCard(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(20),
      child: isLoggedIn ? _buildLoggedInProfile(theme) : _buildLoggedOutProfile(theme),
    );
  }

  Widget _buildLoggedInProfile(ThemeData theme) {
    return Column(
      children: [
        // Avatar
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

        // User Name
        Text(
          userName,
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),

        const SizedBox(height: 4),

        // User Email
        Text(
          userEmail,
          style: theme.textTheme.bodyMedium?.copyWith(
            color: theme.colorScheme.onSurface.withOpacity(0.6),
          ),
        ),

        const SizedBox(height: 20),

        // Edit Profile Button
        CustomButton(
          text: 'Edit Profile',
          type: ButtonType.outlined,
          size: ButtonSize.small,
          icon: Icons.edit_outlined,
          onPressed: () {
            _showEditProfileDialog(context);
          },
        ),
      ],
    );
  }

  Widget _buildLoggedOutProfile(ThemeData theme) {
    return Column(
      children: [
        // Empty account icon
        Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: theme.colorScheme.primary.withOpacity(0.1),
          ),
          child: Icon(
            Icons.account_circle_outlined,
            size: 48,
            color: theme.colorScheme.primary.withOpacity(0.6),
          ),
        ),

        const SizedBox(height: 16),

        // Title
        Text(
          'Sign in to continue',
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),

        const SizedBox(height: 8),

        // Subtitle
        Text(
          'Access your tasks, notes, and reminders\nacross all your devices',
          textAlign: TextAlign.center,
          style: theme.textTheme.bodySmall?.copyWith(
            color: theme.colorScheme.onSurface.withOpacity(0.6),
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

  Widget _buildThemeToggle(BuildContext context, ThemeProvider themeProvider) {
    final theme = Theme.of(context);
    final isDarkMode = themeProvider.isDarkMode;

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
          isDarkMode ? Icons.dark_mode : Icons.light_mode,
          color: theme.colorScheme.primary,
          size: 22,
        ),
      ),
      title: Text(
        'Theme',
        style: theme.textTheme.titleMedium?.copyWith(
          fontWeight: FontWeight.w600,
        ),
      ),
      subtitle: Text(
        isDarkMode ? 'Dark Mode' : 'Light Mode',
        style: theme.textTheme.bodySmall?.copyWith(
          color: theme.colorScheme.onSurface.withOpacity(0.6),
        ),
      ),
      trailing: Switch(
        value: isDarkMode,
        onChanged: (value) {
          Provider.of<ThemeProvider>(context, listen: false).toggleTheme();
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Theme changed to ${value ? 'Dark' : 'Light'} Mode'),
              duration: const Duration(seconds: 2),
              behavior: SnackBarBehavior.floating,
            ),
          );
        },
        activeColor: theme.colorScheme.primary,
      ),
    );
  }

  Widget _buildLanguageSelector(BuildContext context) {
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
          Icons.language,
          color: theme.colorScheme.primary,
          size: 22,
        ),
      ),
      title: Text(
        'Language',
        style: theme.textTheme.titleMedium?.copyWith(
          fontWeight: FontWeight.w600,
        ),
      ),
      subtitle: Text(
        selectedLanguage,
        style: theme.textTheme.bodySmall?.copyWith(
          color: theme.colorScheme.onSurface.withOpacity(0.6),
        ),
      ),
      trailing: Icon(
        Icons.chevron_right,
        color: theme.colorScheme.onSurface.withOpacity(0.4),
      ),
      onTap: () {
        _showLanguageSelector(context);
      },
    );
  }

  Widget _buildAccountOptions(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      children: [
        if (isLoggedIn) ...[
          _buildPreferenceItem(
            context,
            icon: Icons.sync,
            title: 'Sync Status',
            subtitle: 'Last synced just now',
            trailing: Icon(
              Icons.check_circle,
              color: Colors.green,
              size: 20,
            ),
          ),
          Divider(height: 1, indent: 72),
          _buildPreferenceItem(
            context,
            icon: Icons.security,
            title: 'Change Password',
            subtitle: 'Update your password',
            onTap: () {
              _showComingSoonDialog(context);
            },
          ),
          Divider(height: 1, indent: 72),
          ListTile(
            contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
            leading: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: Colors.red.withOpacity(0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                Icons.logout,
                color: Colors.red,
                size: 22,
              ),
            ),
            title: Text(
              'Logout',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
                color: Colors.red,
              ),
            ),
            onTap: () {
              _showLogoutDialog(context);
            },
          ),
        ] else ...[
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                CustomButton(
                  text: 'Sign Up',
                  type: ButtonType.primary,
                  icon: Icons.person_add,
                  width: double.infinity,
                  onPressed: () {
                    Navigator.pushNamed(context, Routes.signup);
                  },
                ),
                const SizedBox(height: 12),
                CustomButton(
                  text: 'Login',
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
      trailing: trailing ?? Icon(
        Icons.chevron_right,
        color: theme.colorScheme.onSurface.withOpacity(0.4),
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

  void _showLanguageSelector(BuildContext context) {
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
                  'Select Language',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              ...languages.map((language) {
                final isSelected = language == selectedLanguage;
                return ListTile(
                  leading: Icon(
                    Icons.language,
                    color: isSelected
                        ? Theme.of(context).colorScheme.primary
                        : Theme.of(context).colorScheme.onSurface.withOpacity(0.5),
                  ),
                  title: Text(
                    language,
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
                  onTap: () {
                    setState(() {
                      selectedLanguage = language;
                    });
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Language changed to $language'),
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

  void _showEditProfileDialog(BuildContext context) {
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
                  'Edit Profile',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 24),
                CustomInput(
                  label: 'Full Name',
                  hint: 'Enter your name',
                  controller: nameController,
                  prefixIcon: Icons.person_outline,
                ),
                const SizedBox(height: 16),
                CustomInput(
                  label: 'Email',
                  hint: 'Enter your email',
                  controller: emailController,
                  type: InputType.email,
                  prefixIcon: Icons.email_outlined,
                ),
                const SizedBox(height: 24),
                Row(
                  children: [
                    Expanded(
                      child: CustomButton(
                        text: 'Cancel',
                        type: ButtonType.outlined,
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: CustomButton(
                        text: 'Save',
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

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Logout'),
          content: const Text('Are you sure you want to logout?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Cancel'),
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
                  const SnackBar(
                    content: Text('Logged out successfully'),
                    duration: Duration(seconds: 2),
                    behavior: SnackBarBehavior.floating,
                  ),
                );
              },
              style: TextButton.styleFrom(
                foregroundColor: Colors.red,
              ),
              child: const Text('Logout'),
            ),
          ],
        );
      },
    );
  }

  void _showComingSoonDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Coming Soon'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.hourglass_empty,
                size: 64,
                color: Theme.of(context).colorScheme.primary.withOpacity(0.5),
              ),
              const SizedBox(height: 16),
              const Text(
                'This feature is under development',
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                'We\'re working hard to bring you this feature soon!',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Got it'),
            ),
          ],
        );
      },
    );
  }

  void _showAboutDialog(BuildContext context) {
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
                'DayFlow',
                style: theme.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Version 1.0.0',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurface.withOpacity(0.6),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'A smart daily planner to help you manage your tasks, notes, and reminders efficiently.',
                textAlign: TextAlign.center,
                style: theme.textTheme.bodySmall,
              ),
              const SizedBox(height: 24),
              Text(
                'Developed by Team DayFlow',
                style: theme.textTheme.bodySmall?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Abderrahmane Houri\nMohamed Al Amin Saàd\nLina Selma Ouadah',
                textAlign: TextAlign.center,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurface.withOpacity(0.6),
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
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }
}