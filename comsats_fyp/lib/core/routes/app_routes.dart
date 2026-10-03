import 'package:flutter/material.dart';

import '../../screens/splash_screen.dart';
import '../../screens/auth/login_screen.dart';
import '../../screens/auth/register_screen.dart';
import '../../screens/auth/forgot_password_screen.dart';
import '../../screens/home/home_shell.dart';
import '../../screens/ideas/idea_detail_screen.dart';
import '../../screens/team/create_team_screen.dart';
import '../../screens/submissions/submission_upload_screen.dart';
import '../../screens/resources/resource_hub_screen.dart';
import '../../screens/resources/documentation_screen.dart';
import '../../screens/resources/faq_screen.dart';
import '../../screens/resources/guidelines_screen.dart';
import '../../screens/help/contact_screen.dart';
import '../../models/project_idea_model.dart';

class AppRoutes {
  static const String splash = '/';
  static const String login = '/login';
  static const String register = '/register';
  static const String forgotPassword = '/forgot-password';
  static const String home = '/home';
  static const String ideaDetail = '/idea-detail';
  static const String createTeam = '/create-team';
  static const String submissionUpload = '/submission-upload';
  static const String resourceHub = '/resources';
  static const String documentation = '/documentation';
  static const String faq = '/faq';
  static const String guidelines = '/guidelines';
  static const String contact = '/contact';

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case splash:
        return MaterialPageRoute(builder: (_) => const SplashScreen());
      case login:
        return MaterialPageRoute(builder: (_) => const LoginScreen());
      case register:
        return MaterialPageRoute(builder: (_) => const RegisterScreen());
      case forgotPassword:
        return MaterialPageRoute(builder: (_) => const ForgotPasswordScreen());
      case home:
        return MaterialPageRoute(builder: (_) => const HomeShell());
      case ideaDetail:
        final idea = settings.arguments as ProjectIdea;
        return MaterialPageRoute(builder: (_) => IdeaDetailScreen(idea: idea));
      case createTeam:
        return MaterialPageRoute(builder: (_) => const CreateTeamScreen());
      case submissionUpload:
        return MaterialPageRoute(builder: (_) => const SubmissionUploadScreen());
      case resourceHub:
        return MaterialPageRoute(builder: (_) => const ResourceHubScreen());
      case documentation:
        return MaterialPageRoute(builder: (_) => const DocumentationScreen());
      case faq:
        return MaterialPageRoute(builder: (_) => const FaqScreen());
      case guidelines:
        return MaterialPageRoute(builder: (_) => const GuidelinesScreen());
      case contact:
        return MaterialPageRoute(builder: (_) => const ContactScreen());
      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(child: Text('No route defined for ${settings.name}')),
          ),
        );
    }
  }
}
