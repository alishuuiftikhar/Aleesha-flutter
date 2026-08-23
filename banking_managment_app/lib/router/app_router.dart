import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../features/auth/login_page.dart';
import '../features/auth/signup_page.dart';
import '../features/dashboard/dashboard_page.dart';
import '../features/splash/splash_page.dart';
import '../features/transfer/transfer_page.dart';
import '../features/beneficiaries/beneficiaries_page.dart';
import '../features/profile/profile_page.dart';
import '../features/notifications/notifications_page.dart';

class AppRouter {
  static final router = GoRouter(
    initialLocation: '/',
    redirect: (context, state) {
      final session = Supabase.instance.client.auth.currentSession;
      final isLoggingIn = state.matchedLocation == '/login' || 
                         state.matchedLocation == '/signup' || 
                         state.matchedLocation == '/';

      if (session == null && !isLoggingIn) {
        return '/login';
      }
      
      if (session != null && isLoggingIn && state.matchedLocation != '/') {
        return '/dashboard';
      }
      
      return null;
    },
    routes: [
      GoRoute(
        path: '/',
        builder: (context, state) => const SplashPage(),
      ),
      GoRoute(
        path: '/login',
        builder: (context, state) => const LoginPage(),
      ),
      GoRoute(
        path: '/signup',
        builder: (context, state) => const SignupPage(),
      ),
      GoRoute(
        path: '/dashboard',
        builder: (context, state) => const DashboardPage(),
      ),
      GoRoute(
        path: '/transfer',
        builder: (context, state) => const TransferPage(),
      ),
      GoRoute(
        path: '/beneficiaries',
        builder: (context, state) => const BeneficiariesPage(),
      ),
      GoRoute(
        path: '/profile',
        builder: (context, state) => const ProfilePage(),
      ),
      GoRoute(
        path: '/notifications',
        builder: (context, state) => const NotificationsPage(),
      ),
    ],
  );
}
