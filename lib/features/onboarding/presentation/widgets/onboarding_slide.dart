import 'package:flutter/material.dart';
import '../../../../app/theme/app_colors.dart';
import 'resume_illustration.dart';

class OnboardingSlide extends StatelessWidget {
  const OnboardingSlide({
    super.key,
    required this.index,
    required this.label,
    required this.title,
    required this.description,
  });
  final int index;
  final String label;
  final String title;
  final String description;
  @override
  Widget build(BuildContext context) => LayoutBuilder(
    builder: (context, constraints) => SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 28),
      child: Column(
        children: [
          SizedBox(height: constraints.maxHeight > 580 ? 28 : 12),
          SizedBox(
            height: (constraints.maxHeight * .53).clamp(220.0, 370.0),
            child: ResumeIllustration(step: index),
          ),
          const SizedBox(height: 24),
          Text(
            label,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 10,
              letterSpacing: 1.8,
              fontWeight: FontWeight.w800,
              color: AppColors.primary,
            ),
          ),
          const SizedBox(height: 14),
          Text(
            title,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.headlineLarge,
          ),
          const SizedBox(height: 16),
          Text(
            description,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyLarge,
          ),
          const SizedBox(height: 24),
        ],
      ),
    ),
  );
}
