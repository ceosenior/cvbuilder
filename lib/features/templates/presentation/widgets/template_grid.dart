import 'package:flutter/material.dart';
import '../../domain/entities/resume_template.dart';
import 'template_card.dart';

class TemplateGrid extends StatelessWidget {
  const TemplateGrid({
    super.key,
    required this.selected,
    required this.busy,
    required this.onSelected,
  });
  final ResumeTemplate selected;
  final bool busy;
  final ValueChanged<ResumeTemplate> onSelected;
  @override
  Widget build(BuildContext context) => SingleChildScrollView(
    padding: const EdgeInsets.all(16),
    child: LayoutBuilder(
      builder: (context, constraints) {
        final columns = constraints.maxWidth < 420
            ? 1
            : constraints.maxWidth < 750
            ? 2
            : 3;
        final width = (constraints.maxWidth - (columns - 1) * 12) / columns;
        return Wrap(
          spacing: 12,
          runSpacing: 12,
          children: [
            for (final template in ResumeTemplate.all)
              SizedBox(
                width: width,
                child: TemplateCard(
                  template: template,
                  selected: template == selected,
                  onTap: busy ? null : () => onSelected(template),
                ),
              ),
          ],
        );
      },
    ),
  );
}
