import 'package:dayflow/blocs/reminder/reminder_bloc.dart';
import 'package:dayflow/blocs/reminder/reminder_event.dart';
import 'package:dayflow/firebase_options.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'blocs/habit/habit_bloc.dart';
import 'blocs/language/language_cubit.dart';
import 'blocs/task/task_bloc.dart';
import 'blocs/theme/theme_cubit.dart';
import 'blocs/note/note_bloc.dart';
import 'blocs/calendar/calendar_bloc.dart';
import 'blocs/template/template_bloc.dart';
import 'blocs/habit_stats/habit_stats_bloc.dart';
import 'blocs/pomodoro/pomodoro_bloc.dart';
import 'data/local/app_database.dart';
import 'data/repositories/habit_repository.dart';
import 'data/repositories/task_repository.dart';
import 'data/repositories/reminder_repository.dart';
import 'data/repositories/note_repository.dart';
import 'data/repositories/task_template_repository.dart';
import 'data/repositories/pomodoro_repository.dart';
import 'theme/app_theme.dart';
import 'utils/app_localizations.dart';
import 'utils/routes.dart';
import 'package:dayflow/services/notification_servise.dart';

import 'package:dayflow/services/mixpanel_service.dart';
import 'blocs/navigation/navigation_cubit.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase
  //initialize mix panel
  await MixpanelService.init("03771de9ce682b349440c8df1886944e");

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Initialize notification service
  await NotificationService.initNotification();

  // Initialize language cubit
  final languageCubit = LanguageCubit();
  await languageCubit.loadSavedLanguage();

  // Initialize database and repositories
  final database = AppDatabase();
  await database.init();
  final taskRepository = TaskRepository(database);
  final habitRepository = HabitRepository(database);
  final reminderRepository = ReminderRepository(database);
  final noteRepository = NoteRepository(database);
  final templateRepository = TaskTemplateRepository(database);
  final pomodoroRepository = PomodoroRepository(database);

  runApp(
    MultiRepositoryProvider(
      providers: [
        RepositoryProvider.value(value: taskRepository),
        RepositoryProvider.value(value: habitRepository),
        RepositoryProvider.value(value: reminderRepository),
        RepositoryProvider.value(value: noteRepository),
        RepositoryProvider.value(value: templateRepository),
        RepositoryProvider.value(value: pomodoroRepository),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (_) => ThemeCubit(),
          ),
          BlocProvider(
            create: (_) => NavigationCubit(),
          ),
          BlocProvider<LanguageCubit>(create: (_) => languageCubit),
          BlocProvider(
            create: (_) => TaskBloc(taskRepository)..add(LoadTasks()),
          ),
          BlocProvider(
            create: (_) => HabitBloc(habitRepository)..add(LoadHabits()),
          ),
          BlocProvider(
            create: (_) => ReminderBloc(reminderRepository)..add(LoadReminders()),
          ),
          BlocProvider(
            create: (_) => NoteBloc(noteRepository)..add(LoadNotes()),
          ),
          BlocProvider(
            create: (_) => CalendarBloc(
              taskRepository: taskRepository,
              habitRepository: habitRepository,
            )..add(LoadCalendarData()),
          ),
          BlocProvider(
            create: (_) => TemplateBloc(templateRepository)..add(LoadTemplates()),
          ),
          BlocProvider(
            create: (_) => HabitStatsBloc(habitRepository)..add(LoadHabitStats()),
          ),
          BlocProvider(
            create: (_) => PomodoroBloc(pomodoroRepository)..add(LoadPomodoroData()),
          ),
        ],
        child: const DayFlowApp(),
      ),
    ),
  );
}

class DayFlowApp extends StatelessWidget {
  const DayFlowApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeCubit, ThemeMode>(
      builder: (context, themeMode) {
        return BlocBuilder<LanguageCubit, Locale>(
          builder: (context, locale) {
            return MaterialApp(
              title: 'DayFlow',
              debugShowCheckedModeBanner: false,
              localizationsDelegates: const [
                AppLocalizations.delegate,
                GlobalMaterialLocalizations.delegate,
                GlobalWidgetsLocalizations.delegate,
                GlobalCupertinoLocalizations.delegate,
              ],
              supportedLocales: const [
                Locale('en'),
                Locale('fr'),
                Locale('ar'),
              ],
              locale: locale,
              theme: AppTheme.lightTheme,
              darkTheme: AppTheme.darkTheme,
              themeMode: themeMode,
              home: const AuthChecker(),
              routes: Routes.routes,
              builder: (context, child) {
                final isRtl = locale.languageCode == 'ar';
                return Directionality(
                  textDirection: isRtl ? TextDirection.rtl : TextDirection.ltr,
                  child: child!,
                );
              },
            );
          },
        );
      },
    );
  }
}

class AuthChecker extends StatefulWidget {
  const AuthChecker({Key? key}) : super(key: key);

  @override
  State<AuthChecker> createState() => _AuthCheckerState();
}

class _AuthCheckerState extends State<AuthChecker> {
  bool _isLoading = true;
  bool _hasCompletedOnboarding = false;

  @override
  void initState() {
    super.initState();
    _checkOnboarding();
  }

  Future<void> _checkOnboarding() async {
    final prefs = await SharedPreferences.getInstance();
    if (mounted) {
      setState(() {
        _hasCompletedOnboarding = prefs.getBool('hasCompletedQuestionFlow') ?? false;
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const SplashScreen();
    }

    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const SplashScreen();
        }

        if (snapshot.hasData && snapshot.data != null) {
          final user = snapshot.data!;

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

          Future.microtask(() {
            final currentRoute = ModalRoute.of(context)?.settings.name;
            if (currentRoute != Routes.home) {
              Navigator.pushReplacementNamed(context, Routes.home);
            }
          });
          return const SplashScreen();
        }

        // Not logged in
        Future.microtask(() {
          final currentRoute = ModalRoute.of(context)?.settings.name;
          if (_hasCompletedOnboarding) {
            if (currentRoute != Routes.home) {
              Navigator.pushReplacementNamed(context, Routes.home);
            }
          } else {
            if (currentRoute != Routes.welcome) {
              Navigator.pushReplacementNamed(context, Routes.welcome);
            }
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