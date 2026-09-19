import 'package:flutter/material.dart';
import '../../domain/entities/resume.dart';
import '../models/resume_form_config.dart';
import 'resume_text_field.dart';

class ResumeEntriesSection extends StatefulWidget {
  const ResumeEntriesSection({
    super.key,
    required this.resume,
    required this.step,
    required this.onChanged,
  });
  final Resume resume;
  final int step;
  final VoidCallback onChanged;

  @override
  State<ResumeEntriesSection> createState() => _ResumeEntriesSectionState();
}

class _ResumeEntriesSectionState extends State<ResumeEntriesSection> {
  Resume get _resume => widget.resume;
  int get _step => widget.step;
  void _saveDraft() => widget.onChanged();
  int _revision = 0;
  Widget _field(
    String key,
    String label, {
    Map<String, String>? row,
    int lines = 1,
  }) => ResumeTextField(
    fieldId:
        '$_step-$_revision-${row == null ? 'detail' : identityHashCode(row)}-$key',
    fieldName: key,
    label: label,
    values: row ?? _resume.details,
    onChanged: _saveDraft,
    lines: lines,
  );

  @override
  Widget build(BuildContext context) {
    final fields = resumeEntryFields[_step]!;
    final rows = _resume.entries.putIfAbsent(resumeStepTitles[_step], () => []);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Text(
          'Bir nechta ma’lumot qo‘shishingiz mumkin. Mavjud bo‘lmasa, keyingi bosqichga o‘ting.',
        ),
        const SizedBox(height: 16),
        for (var i = 0; i < rows.length; i++)
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text('${resumeStepTitles[_step]} ${i + 1}'),
                      ),
                      IconButton(
                        tooltip: 'O‘chirish',
                        icon: const Icon(Icons.delete_outline),
                        onPressed: () => setState(() {
                          rows.removeAt(i);
                          _revision++;
                          _saveDraft();
                        }),
                      ),
                    ],
                  ),
                  for (final field in fields.entries)
                    _field(
                      field.key,
                      field.value,
                      row: rows[i],
                      lines: field.key == 'description' ? 3 : 1,
                    ),
                ],
              ),
            ),
          ),
        OutlinedButton.icon(
          onPressed: () => setState(() {
            rows.add({});
            _saveDraft();
          }),
          icon: const Icon(Icons.add),
          label: const Text('Qo‘shish'),
        ),
      ],
    );
  }
}
