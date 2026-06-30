import 'package:flutter/material.dart';

import '../widgets/gradient_button.dart';
import '../../app/theme/app_colors.dart';
import '../../app/theme/app_radius.dart';

class EmptyState extends StatelessWidget {
  final IconData icon;
  final String? imageAsset;
  final String title;
  final String description;
  final String buttonLabel;
  final VoidCallback onTap;

  const EmptyState({
    super.key,
    required this.icon,
    this.imageAsset,
    required this.title,
    required this.description,
    required this.buttonLabel,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [AppColors.primaryPink, AppColors.primaryOrange],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: AppRadius.xl,
              boxShadow: const [
                BoxShadow(
                  color: Color.fromRGBO(255, 77, 141, 0.25),
                  blurRadius: 26,
                  offset: Offset(0, 14),
                ),
              ],
            ),
            child: imageAsset == null
                ? Icon(
                    icon,
                    color: Colors.white,
                    size: 44,
                  )
                : ClipRRect(
                    borderRadius: AppRadius.xl,
                    child: Image.asset(
                      imageAsset!,
                      width: 100,
                      height: 100,
                      fit: BoxFit.cover,
                    ),
                  ),
          ),
          const SizedBox(height: 24),
          Text(
            title,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            description,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 14,
              color: AppColors.textSecondary,
              height: 1.5,
            ),
          ),
          const SizedBox(height: 24),
          SizedBox(
            width: 180,
            child: GradientButton(
              title: buttonLabel,
              onPressed: onTap,
            ),
          ),
        ],
      ),
    );
  }
}
