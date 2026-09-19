import 'package:flutter/material.dart';
import '../../domain/entities/resume_template.dart';

// A schematic miniature; the following screen renders the actual PDF bytes.
class TemplatePainter extends CustomPainter {
  const TemplatePainter(this.template);
  final ResumeTemplate template;
  @override
  void paint(Canvas canvas, Size size) {
    final left = (size.width - 105) / 2;
    final paint = Paint()..color = Colors.white;
    canvas.drawRect(Rect.fromLTWH(left, 0, 105, 149), paint);
    final accent = Color(template.color);
    if (template.banner) {
      canvas.drawRect(
        Rect.fromLTWH(left + 7, 7, 91, 25),
        paint..color = accent,
      );
    }
    final x = left + (template.centered ? 25 : 13);
    canvas.drawRect(
      Rect.fromLTWH(x, 14, 55, 4),
      paint..color = template.banner ? Colors.white : accent,
    );
    canvas.drawRect(Rect.fromLTWH(x, 22, 38, 2), paint);
    for (var section = 0; section < 4; section++) {
      final y = 40.0 + section * 25;
      canvas.drawRect(
        Rect.fromLTWH(left + 13, y, template.boxed ? 79 : 35, 4),
        paint..color = accent.withValues(alpha: template.boxed ? .3 : .8),
      );
      for (var line = 0; line < (template.compact ? 4 : 3); line++) {
        canvas.drawRect(
          Rect.fromLTWH(left + 13, y + 7 + line * 4, line == 2 ? 55 : 79, 1.5),
          paint..color = Colors.blueGrey.shade200,
        );
      }
    }
  }

  @override
  bool shouldRepaint(TemplatePainter oldDelegate) =>
      oldDelegate.template != template;
}
