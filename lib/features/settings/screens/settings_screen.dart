import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_radius.dart';
import '../../../core/services/snackbar_service.dart';
import '../../../core/services/theme_provider.dart';
import '../../../shared/widgets/gradient_button.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = context.watch<ThemeProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        backgroundColor: Colors.transparent,
      ),
      backgroundColor: AppColors.background,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: AppRadius.lg,
                boxShadow: const [
                  BoxShadow(
                    color: Color.fromRGBO(0, 0, 0, 0.05),
                    blurRadius: 20,
                    offset: Offset(0, 12),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Appearance',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
                  ),
                  const SizedBox(height: 18),
                  SwitchListTile.adaptive(
                    activeThumbColor: AppColors.primaryPink,
                    activeTrackColor: AppColors.primaryPink.withAlpha(
                      (0.28 * 255).round(),
                    ),
                    title: const Text('Dark mode'),
                    subtitle: const Text(
                      'Use a soft, polished palette at night.',
                    ),
                    value: themeProvider.isDarkMode,
                    onChanged: themeProvider.toggleTheme,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: AppRadius.lg,
                boxShadow: const [
                  BoxShadow(
                    color: Color.fromRGBO(0, 0, 0, 0.05),
                    blurRadius: 20,
                    offset: Offset(0, 12),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Backup & restore',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
                  ),
                  const SizedBox(height: 18),
                  GradientButton(
                    title: 'Backup notes',
                    onPressed: () {
                      SnackbarService.showMessage(
                        'Backup created successfully.',
                      );
                    },
                  ),
                  const SizedBox(height: 12),
                  OutlinedButton(
                    onPressed: () {
                      SnackbarService.showMessage(
                        'Restore completed. All notes are up to date.',
                      );
                    },
                    style: OutlinedButton.styleFrom(
                      minimumSize: const Size.fromHeight(56),
                      shape: RoundedRectangleBorder(
                        borderRadius: AppRadius.pill,
                      ),
                      side: const BorderSide(color: AppColors.border),
                    ),
                    child: const Text('Restore notes'),
                  ),
                ],
              ),
            ),
            const Spacer(),
            Text(
              'Notely • Version 1.0.0',
              style: const TextStyle(
                color: AppColors.textSecondary,
                fontSize: 13,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 14),
            Text(
              'A polished note workspace with glassmorphism and elegant motion.',
              style: const TextStyle(
                color: AppColors.textSecondary,
                fontSize: 12,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 18),
          ],
        ),
      ),
    );
  }
}
