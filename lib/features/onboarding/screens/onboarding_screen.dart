import 'package:flutter/material.dart';

import '../../../app/router/app_routes.dart';
import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_gradients.dart';
import '../../../shared/widgets/gradient_button.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _pageIndex = 0;

  void _nextPage() {
    if (_pageIndex == 2) {
      Navigator.pushReplacementNamed(context, AppRoutes.home);
      return;
    }

    _pageController.nextPage(
      duration: const Duration(milliseconds: 420),
      curve: Curves.easeOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: AppGradients.background,
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 30),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Welcome to Notely',
                      style: TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    Text(
                      '${_pageIndex + 1}/3',
                      style: const TextStyle(
                        fontSize: 14,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 34),
                Expanded(
                  child: PageView(
                    controller: _pageController,
                    onPageChanged: (index) {
                      setState(() {
                        _pageIndex = index;
                      });
                    },
                    children: const [
                      _OnboardingStep(
                        imageAsset: 'assets/onboarding_1.png',
                        title: 'A workspace that feels premium',
                        description:
                            'Modern gradients, glass panels, and thoughtful motion make every moment feel elevated.',
                      ),
                      _OnboardingStep(
                        imageAsset: 'assets/onboarding_2.png',
                        title: 'Write, organize, and review',
                        description:
                            'Create notes, pin your focus items, archive ideas, and search instantly with intelligent filters.',
                      ),
                      _OnboardingStep(
                        imageAsset: 'assets/onboarding_3.png',
                        title: 'Built for speed and clarity',
                        description:
                            'Minimal distractions, smooth navigation, and responsive layouts across mobile, desktop and tablet.',
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 30),
                GradientButton(
                  title: _pageIndex < 2 ? 'Next' : 'Let’s get started',
                  onPressed: _nextPage,
                ),
                const SizedBox(height: 18),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(
                    3,
                    (index) => AnimatedContainer(
                      duration: const Duration(milliseconds: 240),
                      width: _pageIndex == index ? 20 : 10,
                      height: 10,
                      margin: const EdgeInsets.symmetric(horizontal: 6),
                      decoration: BoxDecoration(
                        color: _pageIndex == index ? AppColors.primaryPink : AppColors.border,
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _OnboardingStep extends StatelessWidget {
  final String imageAsset;
  final String title;
  final String description;

  const _OnboardingStep({
    required this.imageAsset,
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        AnimatedContainer(
          duration: const Duration(milliseconds: 320),
          height: 220,
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [AppColors.primaryPink, AppColors.primaryOrange],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(32),
            boxShadow: const [
              BoxShadow(
                color: Color.fromRGBO(255, 77, 141, 0.18),
                blurRadius: 36,
                offset: Offset(0, 18),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(32),
            child: Image.asset(
              imageAsset,
              fit: BoxFit.cover,
              width: double.infinity,
              height: double.infinity,
            ),
          ),
        ),
        const SizedBox(height: 32),
        Text(
          title,
          style: const TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.w800,
          ),
        ),
        const SizedBox(height: 16),
        Text(
          description,
          style: const TextStyle(
            fontSize: 16,
            color: AppColors.textSecondary,
            height: 1.6,
          ),
        ),
      ],
    );
  }
}
