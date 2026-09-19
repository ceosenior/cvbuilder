import 'package:flutter/material.dart';

class ResumeTextField extends StatelessWidget {
  const ResumeTextField({
    super.key,
    required this.fieldId,
    required this.fieldName,
    required this.label,
    required this.values,
    required this.onChanged,
    this.isRequired = true,
    this.lines = 1,
    this.keyboard,
  });
  final String fieldId;
  final String fieldName;
  final String label;
  final Map<String, String> values;
  final VoidCallback onChanged;
  final bool isRequired;
  final int lines;
  final TextInputType? keyboard;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 18),
      child: TextFormField(
        key: ValueKey(fieldId),
        initialValue: values[fieldName],
        style: TextStyle(color: Colors.black),
        decoration: InputDecoration(
          labelText: label,
          helperText: isRequired ? null : 'Ixtiyoriy',
          border: const OutlineInputBorder(),
        ),
        minLines: lines,
        maxLines: lines,
        keyboardType:
            keyboard ??
            (lines > 1 ? TextInputType.multiline : TextInputType.text),
        onChanged: (value) {
          values[fieldName] = value;
          onChanged();
        },
        validator: (value) {
          final text = value?.trim() ?? '';
          if (isRequired && text.isEmpty) return 'Bu maydonni to‘ldiring';
          if (text.isEmpty) return null;
          if (fieldName == 'email' &&
              !RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]+$').hasMatch(text)) {
            return 'Email manzilini to‘g‘ri kiriting';
          }
          if (fieldName == 'phone' &&
              (!RegExp(r'^\+?[\d\s()\-]+$').hasMatch(text) ||
                  text.replaceAll(RegExp(r'\D'), '').length < 7)) {
            return 'Telefon raqamini to‘g‘ri kiriting';
          }
          if (fieldName == 'github' || fieldName == 'linkedin') {
            final uri = Uri.tryParse(text);
            final host = fieldName == 'github' ? 'github.com' : 'linkedin.com';
            if (uri == null ||
                uri.scheme != 'https' ||
                !(uri.host == host || uri.host == 'www.$host') ||
                uri.path.length < 2) {
              return 'https://$host/… ko‘rinishida kiriting';
            }
          }
          return null;
        },
      ),
    );
  }
}
