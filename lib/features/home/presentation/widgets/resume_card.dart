import 'package:flutter/material.dart';
import '../../../resume/domain/entities/resume.dart';

class ResumeCard extends StatelessWidget {
  const ResumeCard({
    super.key,
    required this.resume,
    required this.onEdit,
    required this.onTemplates,
  });
  final Resume resume;
  final VoidCallback onEdit;
  final VoidCallback onTemplates;
  @override
  Widget build(BuildContext context) => Card(
    child: ListTile(
      leading: const Icon(Icons.description_outlined),
      title: Text(resume.details['name'] ?? ''),
      subtitle: Text(
        resume.details['customSpecialty'] ?? resume.details['specialty'] ?? '',
      ),
      trailing: IconButton(
        tooltip: 'Shablon va PDF',
        icon: const Icon(Icons.picture_as_pdf_outlined),
        onPressed: onTemplates,
      ),
      onTap: onEdit,
    ),
  );
}
