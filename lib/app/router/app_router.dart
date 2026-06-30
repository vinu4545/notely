import 'package:flutter/material.dart';

import '../../features/archive/screens/archive_screen.dart';
import '../../features/editor/screens/editor_screen.dart';
import '../../features/history/screens/history_screen.dart';
import '../../features/home/screens/home_screen.dart';
import '../../features/onboarding/screens/onboarding_screen.dart';
import '../../features/profile/screens/profile_screen.dart';
import '../../features/search/screens/search_screen.dart';
import '../../features/settings/screens/settings_screen.dart';
import '../../features/trash/screens/trash_screen.dart';
import '../../features/notes/screens/note_list_screen.dart';
import '../../features/splash/screens/splash_screen.dart';
import 'app_routes.dart';

class AppRouter {
  AppRouter._();

  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case AppRoutes.onboarding:
        return _fadeRoute(const OnboardingScreen(), settings);
      case AppRoutes.home:
        return _fadeRoute(const HomeScreen(), settings);
      case AppRoutes.editor:
        return _fadeRoute(
          EditorScreen(note: settings.arguments as dynamic),
          settings,
        );
      case AppRoutes.search:
        return _fadeRoute(const SearchScreen(), settings);
      case AppRoutes.settings:
        return _fadeRoute(const SettingsScreen(), settings);
      case AppRoutes.archive:
        return _fadeRoute(const ArchiveScreen(), settings);
      case AppRoutes.trash:
        return _fadeRoute(const TrashScreen(), settings);
      case AppRoutes.history:
        return _fadeRoute(
          HistoryScreen(note: settings.arguments as dynamic),
          settings,
        );
      case AppRoutes.profile:
        return _fadeRoute(const ProfileScreen(), settings);
      case AppRoutes.notes:
        return _fadeRoute(const NoteListScreen(), settings);
      case AppRoutes.splash:
      default:
        return _fadeRoute(const SplashScreen(), settings);
    }
  }

  static PageRouteBuilder _fadeRoute(Widget child, RouteSettings settings) {
    return PageRouteBuilder(
      settings: settings,
      transitionDuration: const Duration(milliseconds: 420),
      reverseTransitionDuration: const Duration(milliseconds: 300),
      pageBuilder: (_, animation, secondaryAnimation) => child,
      transitionsBuilder: (_, animation, secondaryAnimation, child) {
        final curvedAnimation = CurvedAnimation(
          parent: animation,
          curve: Curves.easeOutCubic,
        );

        return SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(0.04, 0),
            end: Offset.zero,
          ).animate(curvedAnimation),
          child: FadeTransition(opacity: curvedAnimation, child: child),
        );
      },
    );
  }
}
