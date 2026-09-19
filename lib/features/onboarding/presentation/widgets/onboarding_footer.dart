import 'package:flutter/material.dart';
import '../../../../app/theme/app_colors.dart';

class OnboardingFooter extends StatelessWidget {
  const OnboardingFooter({
    super.key,
    required this.index,
    required this.count,
    required this.onNext,
  });
  final int index;
  final int count;
  final VoidCallback onNext;
  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.fromLTRB(28, 12, 28, 20),
    child: Column(
      children: [
        Semantics(
          label: '${index + 1} / $count bosqich',
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(
              count,
              (dotIndex) => AnimatedContainer(
                duration: const Duration(milliseconds: 250),
                margin: const EdgeInsets.symmetric(horizontal: 4),
                height: 7,
                width: index == dotIndex ? 28 : 7,
                decoration: BoxDecoration(
                  color: index == dotIndex ? AppColors.primary : AppColors.line,
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 26),
        FilledButton(
          onPressed: onNext,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(index == count - 1 ? 'Boshlash' : 'Keyingi'),
              const SizedBox(width: 12),
              const Icon(Icons.arrow_forward_rounded, size: 20),
            ],
          ),
        ),
        const SizedBox(height: 16),
        const Text(
          'Yangi karyerangiz sari birinchi qadam',
          style: TextStyle(fontSize: 11, color: AppColors.muted),
        ),
      ],
    ),
  );
}
