import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'services/workout_provider.dart';
import 'utils/constants.dart';
import 'screens/splash_screen.dart';
import 'screens/onboarding_screen.dart';
import 'screens/main_shell.dart';
import 'screens/workout_details_screen.dart';
import 'screens/exercise_details_screen.dart';
import 'screens/active_workout_screen.dart';
import 'screens/workout_completed_screen.dart';
import 'screens/create_workout_screen.dart';
import 'screens/settings_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final workoutProvider = WorkoutProvider();
  await workoutProvider.init();
  
  runApp(
    ChangeNotifierProvider(
      create: (context) => workoutProvider,
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Workout Planner',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: AppColors.mainBackground,
        primaryColor: AppColors.primary,
        colorScheme: const ColorScheme.dark(
          primary: AppColors.primary,
          secondary: AppColors.secondary,
          surface: AppColors.secondaryBackground,
          onPrimary: AppColors.mainText,
          onSecondary: AppColors.mainText,
          onSurface: AppColors.mainText,
        ),
        textTheme: GoogleFonts.poppinsTextTheme(
          ThemeData.dark().textTheme,
        ).apply(
          bodyColor: AppColors.mainText,
          displayColor: AppColors.mainText,
        ),
        appBarTheme: AppBarTheme(
          backgroundColor: AppColors.mainBackground,
          elevation: 0,
          titleTextStyle: GoogleFonts.poppins(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: AppColors.mainText,
          ),
        ),
        bottomNavigationBarTheme: const BottomNavigationBarThemeData(
          backgroundColor: AppColors.secondaryBackground,
          selectedItemColor: AppColors.primary,
          unselectedItemColor: AppColors.secondaryText,
          type: BottomNavigationBarType.fixed,
        ),
        cardTheme: CardThemeData(
          color: AppColors.cardBackground,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppConstants.borderRadius),
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primary,
            foregroundColor: AppColors.mainText,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppConstants.borderRadius),
            ),
            padding: const EdgeInsets.symmetric(vertical: 16),
            textStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
        ),
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const SplashScreen(),
        '/onboarding': (context) => const OnboardingScreen(),
        '/home': (context) => const MainShell(),
        '/workout-details': (context) => const WorkoutDetailsScreen(),
        '/exercise-details': (context) => const ExerciseDetailsScreen(),
        '/active-workout': (context) => const ActiveWorkoutScreen(),
        '/workout-completed': (context) => const WorkoutCompletedScreen(),
        '/create-workout': (context) => const CreateWorkoutScreen(),
        '/settings': (context) => const SettingsScreen(),
      },
    );
  }
}
