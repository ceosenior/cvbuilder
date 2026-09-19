import 'package:flutter/material.dart';
import '../../domain/entities/resume.dart';
import '../models/resume_form_config.dart';

class ResumeReviewSection extends StatelessWidget {
  const ResumeReviewSection({
    super.key,
    required this.resume,
    required this.onGo,
  });
  final Resume resume;
  final ValueChanged<int> onGo;
  @override
  Widget build(BuildContext context) => Column(
    children: [
      for (var i = 0; i < resumeStepTitles.length - 1; i++)
        Card(
          child: ListTile(
            title: Text(resumeStepTitles[i]),
            subtitle: Text(_summary(i)),
            isThreeLine: false,
            trailing: const Icon(Icons.edit_outlined),
            onTap: () => onGo(i),
          ),
        ),
    ],
  );

  String _summary(int step) {
    if (step == 4) return resume.skills.join(', ');
    if (resumeEntryFields.containsKey(step)) {
      final rows = resume.entries[resumeStepTitles[step]] ?? [];
      return rows.isEmpty
          ? 'Kiritilmagan'
          : rows.map((row) => row.values.join(' • ')).join('\n\n');
    }
    final keys = switch (step) {
      0 => ['name'],
      1 => ['specialty', 'customSpecialty'],
      2 => ['email', 'phone', 'github', 'linkedin'],
      3 => ['address'],
      7 => ['bio'],
      _ => <String>[],
    };
    return keys
        .map((key) => resume.details[key] ?? '')
        .where((v) => v.isNotEmpty)
        .join('\n');
  }
}
