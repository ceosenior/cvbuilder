import 'package:flutter/material.dart';
import '../../domain/entities/resume.dart';
import '../models/resume_form_config.dart';

class ResumeSkillsSection extends StatefulWidget {
  const ResumeSkillsSection({
    super.key,
    required this.resume,
    required this.onChanged,
    required this.customSkill,
  });
  final Resume resume;
  final VoidCallback onChanged;
  final TextEditingController customSkill;
  @override
  State<ResumeSkillsSection> createState() => _ResumeSkillsSectionState();
}

class _ResumeSkillsSectionState extends State<ResumeSkillsSection> {
  Resume get _resume => widget.resume;
  void _saveDraft() => widget.onChanged();
  TextEditingController get _customSkill => widget.customSkill;
  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: [
      Text(
        '${_resume.details['specialty'] ?? ''} uchun ko‘nikmalarni tanlang yoki o‘zingiz qo‘shing.',
      ),
      const SizedBox(height: 16),
      FormField<bool>(
        validator: (_) =>
            _resume.skills.isEmpty ? 'Kamida bitta ko‘nikma tanlang' : null,
        builder: (state) => Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children:
                  {
                        ...?resumeSpecialties[_resume.details['specialty']],
                        ..._resume.skills,
                      }
                      .map(
                        (skill) => FilterChip(
                          label: Text(skill),
                          selected: _resume.skills.contains(skill),
                          onSelected: (selected) {
                            setState(() {
                              selected
                                  ? _resume.skills.add(skill)
                                  : _resume.skills.remove(skill);
                            });
                            state.didChange(true);
                            _saveDraft();
                          },
                        ),
                      )
                      .toList(),
            ),
            if (state.hasError)
              Text(
                state.errorText!,
                style: TextStyle(color: Theme.of(context).colorScheme.error),
              ),
          ],
        ),
      ),
      const SizedBox(height: 20),
      TextField(
        controller: _customSkill,
        decoration: InputDecoration(
          labelText: 'Qo‘shimcha ko‘nikma',
          border: const OutlineInputBorder(),
          suffixIcon: IconButton(
            tooltip: 'Ko‘nikma qo‘shish',
            onPressed: _addSkill,
            icon: const Icon(Icons.add),
          ),
        ),
        onSubmitted: (_) => _addSkill(),
      ),
    ],
  );

  void _addSkill() {
    final value = _customSkill.text.trim();
    if (value.isEmpty) return;
    setState(() => _resume.skills.add(value));
    _customSkill.clear();
  }
}
