// lib/main.dart (UPDATED WITH LOCALIZATION)
import 'package:dayflow/firebase_options.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'package:dayflow/theme/app_theme.dart';
import 'package:dayflow/providers/language_provider.dart';
import 'package:dayflow/providers/analytics_provider.dart';
import 'package:dayflow/providers/auth_provider.dart';
import 'package:dayflow/providers/tasks_provider.dart';
import 'package:dayflow/providers/habits_provider.dart';
import 'package:dayflow/utils/app_localizations.dart';
import 'package:dayflow/services/firebase_auth_service.dart';
import 'utils/routes.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:dayflow/services/task_service.dart';
import 'package:dayflow/services/habit_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Initialize Language Provider and load saved language
  final languageProvider = LanguageProvider();
  await languageProvider.loadSavedLanguage();

  // Initialize Analytics
  final analyticsProvider = AnalyticsProvider();
  // TODO: Replace with your actual Mixpanel token
  // Get your token from: https://mixpanel.com/project/[PROJECT_ID]/settings
  await analyticsProvider.initialize('YOUR_MIXPANEL_TOKEN_HERE');

  runApp(DayFlowApp(
    languageProvider: languageProvider,
    analyticsProvider: analyticsProvider,
  ));
}

class DayFlowApp extends StatelessWidget {
  final LanguageProvider languageProvider;
  final AnalyticsProvider analyticsProvider;

  const DayFlowApp({
    super.key,
    required this.languageProvider,
    required this.analyticsProvider,
  });

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ChangeNotifierProvider.value(value: languageProvider),
        ChangeNotifierProvider.value(value: analyticsProvider),

        // Auth Provider
        ChangeNotifierProvider(create: (_) => AuthProvider()),

        // Tasks Provider
        ChangeNotifierProvider(create: (_) => TasksProvider()),

        // Habits Provider
        ChangeNotifierProvider(create: (_) => HabitsProvider()),

        // Legacy services for backward compatibility
        ChangeNotifierProvider<TaskService>(
          create: (_) {
            final taskService = TaskService();
            final habitService = HabitService();
            taskService.linkHabitService(habitService);
            return taskService;
          },
        ),

        // Provide the same habitService instance
        ChangeNotifierProxyProvider<TaskService, HabitService>(
          create: (_) => HabitService(),
          update: (_, taskService, habitService) {
            // ensure both remain linked
            habitService ??= HabitService();
            taskService.linkHabitService(habitService);
            return habitService;
          },
        ),
      ],
      child: Consumer2<ThemeProvider, LanguageProvider>(
        builder: (context, themeProvider, langProvider, _) {
          return MaterialApp(
            title: 'DayFlow',
            debugShowCheckedModeBanner: false,

            // Localization delegates
            localizationsDelegates: const [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],

            // Supported locales
            supportedLocales: const [
              Locale('en'), // English
              Locale('fr'), // French
              Locale('ar'), // Arabic
            ],

            // Current locale from LanguageProvider
            locale: langProvider.locale,

            // Theme
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            themeMode: themeProvider.themeMode,

            // Routes
            home: const AuthChecker(),
            routes: Routes.routes,

            // RTL support for Arabic
            builder: (context, child) {
              return Directionality(
                textDirection: langProvider.isRTL
                    ? TextDirection.rtl
                    : TextDirection.ltr,
                child: child!,
              );
            },
          );
        },
      ),
    );
  }
}

// Check authentication status on app launch
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
    final l10n = AppLocalizations.of(context);

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
              l10n.appName,
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