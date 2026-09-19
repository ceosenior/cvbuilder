import 'package:flutter/material.dart';
import '../../domain/entities/resume_template.dart';
import 'template_painter.dart';

class TemplateCard extends StatelessWidget {
  const TemplateCard({
    super.key,
    required this.template,
    required this.selected,
    this.onTap,
  });
  final ResumeTemplate template;
  final bool selected;
  final VoidCallback? onTap;
  @override
  Widget build(BuildContext context) => Semantics(
    selected: selected,
    button: true,
    child: Card(
      margin: EdgeInsets.zero,
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
        side: BorderSide(
          color: selected
              ? Theme.of(context).colorScheme.primary
              : Colors.black12,
          width: selected ? 2 : 1,
        ),
      ),
      child: InkWell(
        key: ValueKey('template-${template.id}'),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 150,
                width: double.infinity,
                child: CustomPaint(painter: TemplatePainter(template)),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: Text(
                      template.name,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  Icon(
                    selected
                        ? Icons.check_circle
                        : Icons.radio_button_unchecked,
                    color: Color(template.color),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Text(template.description),
            ],
          ),
        ),
      ),
    ),
  );
}
