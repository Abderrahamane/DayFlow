// lib/main.dart (Updated with Email Verification)
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:dayflow/theme/app_theme.dart';
import 'utils/routes.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
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

class AuthChecker extends StatelessWidget {
  const AuthChecker({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        // Show loading splash while checking auth
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const SplashScreen();
        }

        // Check if user is logged in
        if (snapshot.hasData && snapshot.data != null) {
          final user = snapshot.data!;

          // Check if email is verified
          if (!user.emailVerified) {
            // User logged in but email not verified
            Future.microtask(() {
              final currentRoute = ModalRoute.of(context)?.settings.name;
              if (currentRoute != Routes.emailVerification) {
                Navigator.pushReplacementNamed(
                  context,
                  Routes.emailVerification,
                );
              }
            });
            return const SplashScreen();
          }

          // User logged in and verified - go to home
          Future.microtask(() {
            final currentRoute = ModalRoute.of(context)?.settings.name;
            if (currentRoute != Routes.home) {
              Navigator.pushReplacementNamed(context, Routes.home);
            }
          });
          return const SplashScreen();
        }

        // No user logged in - go to welcome
        Future.microtask(() {
          final currentRoute = ModalRoute.of(context)?.settings.name;
          if (currentRoute != Routes.welcome) {
            Navigator.pushReplacementNamed(context, Routes.welcome);
          }
        });
        return const SplashScreen();
      },
    );
  }
}

class SplashScreen extends StatelessWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
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