// lib/main.dart (UPDATED)
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:dayflow/theme/app_theme.dart';
import 'package:dayflow/services/auth_service.dart';
import 'utils/routes.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const DayFlowApp());
}

class DayFlowApp extends StatelessWidget {
  const DayFlowApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ThemeProvider(),
      child: Consumer<ThemeProvider>(
        builder: (context, themeProvider, _) {
          return MaterialApp(
            title: 'DayFlow',
            debugShowCheckedModeBanner: false,
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            themeMode: themeProvider.themeMode,
            home: const AuthChecker(),
            routes: Routes.routes,
          );
        },
      ),
    );
  }
}

// Check authentication status on app launch
class AuthChecker extends StatefulWidget {
  const AuthChecker({Key? key}) : super(key: key);

  @override
  State<AuthChecker> createState() => _AuthCheckerState();
}

class _AuthCheckerState extends State<AuthChecker> {
  final _authService = AuthService();
  bool _isChecking = true;

  @override
  void initState() {
    super.initState();
    _checkAuthStatus();
  }

  Future<void> _checkAuthStatus() async {
    // Add a small delay for splash effect
    await Future.delayed(const Duration(milliseconds: 500));

    final isLoggedIn = await _authService.isLoggedIn();

    if (!mounted) return;

    if (isLoggedIn) {
      // User is logged in, go to home
      Navigator.pushReplacementNamed(context, Routes.home);
    } else {
      // User is not logged in, go to welcome page
      Navigator.pushReplacementNamed(context, Routes.welcome);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // App logo
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    theme.colorScheme.primary,
                    theme.colorScheme.secondary,
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(30),
              ),
              child: const Icon(
                Icons.calendar_today,
                color: Colors.white,
                size: 60,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'DayFlow',
              style: theme.textTheme.headlineLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 40),
            CircularProgressIndicator(
              color: theme.colorScheme.primary,
            ),
          ],
        ),
      ),
    );
  }
}