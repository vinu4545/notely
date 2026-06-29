import 'package:flutter/material.dart';

import 'router/app_router.dart';
import 'router/app_routes.dart';
import 'theme/app_theme.dart';

class NotelyApp extends StatelessWidget {
  const NotelyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Notely',
      debugShowCheckedModeBanner: false,

      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.system,

      initialRoute: AppRoutes.splash,

      onGenerateRoute: AppRouter.onGenerateRoute,
    );
  }
}