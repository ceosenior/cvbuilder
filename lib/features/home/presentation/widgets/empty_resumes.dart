import 'package:flutter/material.dart';
import '../../../../app/theme/app_colors.dart';

class EmptyResumes extends StatelessWidget {
  const EmptyResumes({super.key});

  @override
  Widget build(BuildContext context) => Column(
    children: [
      const CircleAvatar(
        radius: 42,
        backgroundColor: AppColors.lime,
        child: Icon(
          Icons.description_outlined,
          size: 38,
          color: AppColors.primary,
        ),
      ),
      const SizedBox(height: 24),
      Text(
        'Birinchi rezyumengizni yarating',
        textAlign: TextAlign.center,
        style: Theme.of(context).textTheme.headlineLarge,
      ),
      const SizedBox(height: 16),
      const Text(
        'Ma’lumotlaringizni bosqichma-bosqich kiriting va yakunda tekshiring.',
        textAlign: TextAlign.center,
      ),
    ],
  );
}
