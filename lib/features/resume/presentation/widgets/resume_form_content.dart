import 'package:flutter/material.dart';
import '../../domain/entities/resume.dart';
import '../models/resume_form_config.dart';
import 'resume_text_field.dart';
import 'resume_entries_section.dart';
import 'resume_skills_section.dart';
import 'resume_review_section.dart';

class ResumeFormContent extends StatefulWidget {
  const ResumeFormContent({
    super.key,
    required this.resume,
    required this.step,
    required this.customSkill,
    required this.onChanged,
    required this.onGo,
  });
  final Resume resume;
  final int step;
  final TextEditingController customSkill;
  final VoidCallback onChanged;
  final ValueChanged<int> onGo;
  @override
  State<ResumeFormContent> createState() => _ResumeFormContentState();
}

class _ResumeFormContentState extends State<ResumeFormContent> {
  Resume get _resume => widget.resume;
  int get _step => widget.step;
  void _saveDraft() => widget.onChanged();
  Widget _field(
    String key,
    String label, {
    bool required = true,
    int lines = 1,
    TextInputType? keyboard,
  }) => ResumeTextField(
    fieldId: '$_step-detail-$key',
    fieldName: key,
    label: label,
    values: _resume.details,
    onChanged: _saveDraft,
    isRequired: required,
    lines: lines,
    keyboard: keyboard,
  );

  @override
  Widget build(BuildContext context) {
    if (resumeEntryFields.containsKey(_step)) {
      return ResumeEntriesSection(
        resume: _resume,
        step: _step,
        onChanged: _saveDraft,
      );
    }
    return switch (_step) {
      0 => _field('name', 'Ism va familiya'),
      1 => Column(
        children: [
          DropdownButtonFormField<String>(
            initialValue: _resume.details['specialty'],
            isExpanded: true,
            decoration: const InputDecoration(
              labelText: 'Mutaxassislik',
              border: OutlineInputBorder(),
            ),
            items: resumeSpecialties.keys
                .map((s) => DropdownMenuItem(value: s, child: Text(s)))
                .toList(),
            validator: (value) =>
                value == null ? 'Mutaxassislikni tanlang' : null,
            onChanged: (value) => setState(() {
              _resume.details['specialty'] = value!;
              _resume.details.remove('customSpecialty');
              _saveDraft();
            }),
          ),
          const SizedBox(height: 18),
          if (_resume.details['specialty'] == 'Boshqa')
            _field('customSpecialty', 'Mutaxassisligingiz'),
        ],
      ),
      2 => Column(
        children: [
          _field('email', 'Email', keyboard: TextInputType.emailAddress),
          _field('phone', 'Telefon raqami', keyboard: TextInputType.phone),
          _field(
            'github',
            'GitHub havolasi',
            required: false,
            keyboard: TextInputType.url,
          ),
          _field(
            'linkedin',
            'LinkedIn havolasi',
            required: false,
            keyboard: TextInputType.url,
          ),
        ],
      ),
      3 => _field('address', 'Yashash manzili (shahar, mamlakat)', lines: 2),
      4 => ResumeSkillsSection(
        resume: _resume,
        customSkill: widget.customSkill,
        onChanged: _saveDraft,
      ),
      7 => _field('bio', 'O‘zingiz haqingizda qisqacha', lines: 6),
      _ => ResumeReviewSection(resume: _resume, onGo: widget.onGo),
    };
  }
}
