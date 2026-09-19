import 'package:flutter/material.dart';
import '../models/resume_form_config.dart';

class ResumeStepHeader extends StatelessWidget {
  const ResumeStepHeader({super.key, required this.step});
  final int step;
  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.fromLTRB(24, 12, 24, 0),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('${step + 1} / ${resumeStepTitles.length} bosqich'),
        const SizedBox(height: 10),
        LinearProgressIndicator(
          value: (step + 1) / resumeStepTitles.length,
          minHeight: 6,
          borderRadius: BorderRadius.circular(8),
        ),
        const SizedBox(height: 20),
        Text(
          resumeStepTitles[step],
          style: Theme.of(context).textTheme.headlineMedium,
        ),
      ],
    ),
  );
}
