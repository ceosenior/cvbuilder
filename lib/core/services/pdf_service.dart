import 'package:flutter/services.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import '../../features/resume/domain/entities/resume.dart';
import '../../features/templates/domain/entities/resume_template.dart';
import 'reference_resume_pdf.dart';

class PdfService {
  Future<Uint8List> generate(Resume resume, ResumeTemplate template) async {
    final regular = await rootBundle.load('assets/fonts/NotoSans-Regular.ttf');
    final bold = await rootBundle.load('assets/fonts/NotoSans-Bold.ttf');
    final document = pw.Document(
      theme: pw.ThemeData.withFont(
        base: pw.Font.ttf(regular),
        bold: pw.Font.ttf(bold),
      ),
    );
    if (template.layout != ResumeLayout.standard) {
      ReferenceResumePdf(resume, template).addTo(document);
      return document.save();
    }
    final accent = PdfColor.fromInt(template.color);
    final detail = resume.details;
    final size = template.compact ? 9.0 : 10.0;
    final body = pw.TextStyle(fontSize: size, lineSpacing: 3);
    // Small text blocks allow MultiPage to split even very long descriptions.
    List<pw.Widget> paragraphs(String value) {
      final words = value.trim().split(RegExp(r'\s+'));
      return [
        for (var i = 0; i < words.length; i += 45)
          pw.Text(
            words
                .sublist(i, i + 45 > words.length ? words.length : i + 45)
                .join(' '),
            style: body,
          ),
      ];
    }

    pw.Widget heading(String title) => pw.Container(
      margin: const pw.EdgeInsets.only(top: 14, bottom: 7),
      padding: pw.EdgeInsets.all(template.boxed ? 6 : 2),
      decoration: pw.BoxDecoration(
        color: template.boxed ? accent.shade(0.92) : null,
        border: pw.Border(bottom: pw.BorderSide(color: accent, width: 1)),
      ),
      child: pw.Text(
        title,
        style: pw.TextStyle(
          color: accent,
          fontSize: 12,
          fontWeight: pw.FontWeight.bold,
        ),
      ),
    );
    List<pw.Widget> skills() => resume.skills.isEmpty
        ? []
        : [heading('Ko‘nikmalar'), ...paragraphs(resume.skills.join(' • '))];
    document.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        maxPages: 200,
        margin: pw.EdgeInsets.all(template.compact ? 30 : 40),
        footer: (context) => pw.Align(
          alignment: pw.Alignment.centerRight,
          child: pw.Text(
            '${context.pageNumber} / ${context.pagesCount}',
            style: const pw.TextStyle(fontSize: 8, color: PdfColors.grey),
          ),
        ),
        build: (_) => [
          pw.Container(
            width: double.infinity,
            padding: pw.EdgeInsets.all(template.banner ? 18 : 0),
            color: template.banner ? accent : null,
            child: pw.Column(
              crossAxisAlignment: template.centered
                  ? pw.CrossAxisAlignment.center
                  : pw.CrossAxisAlignment.start,
              children: [
                pw.Text(
                  detail['name'] ?? '',
                  textAlign: template.centered
                      ? pw.TextAlign.center
                      : pw.TextAlign.left,
                  style: pw.TextStyle(
                    fontSize: 26,
                    fontWeight: pw.FontWeight.bold,
                    color: template.banner ? PdfColors.white : accent,
                  ),
                ),
                pw.SizedBox(height: 6),
                pw.Text(
                  detail['customSpecialty'] ?? detail['specialty'] ?? '',
                  style: pw.TextStyle(
                    fontSize: 13,
                    color: template.banner ? PdfColors.white : accent,
                  ),
                ),
              ],
            ),
          ),
          pw.SizedBox(height: 12),
          for (final key in ['email', 'phone', 'github', 'linkedin', 'address'])
            if ((detail[key] ?? '').isNotEmpty) ...paragraphs(detail[key]!),
          if (template.skillsFirst) ...skills(),
          if ((detail['bio'] ?? '').isNotEmpty) ...[
            heading('Tarjimai hol'),
            ...paragraphs(detail['bio']!),
          ],
          for (final section
              in (template.id == 'academic'
                  ? [
                      'Ta’lim',
                      'Ish tajribasi',
                      'Loyihalar',
                      'Sertifikatlar',
                      'Tillar',
                    ]
                  : [
                      'Ish tajribasi',
                      'Loyihalar',
                      'Ta’lim',
                      'Sertifikatlar',
                      'Tillar',
                    ]))
            if ((resume.entries[section] ?? []).isNotEmpty) ...[
              heading(section),
              for (final row in resume.entries[section]!) ...[
                for (final field in row.entries)
                  if (field.value.trim().isNotEmpty) ...paragraphs(field.value),
                pw.SizedBox(height: 8),
              ],
            ],
          if (!template.skillsFirst) ...skills(),
        ],
      ),
    );
    return document.save();
  }
}
