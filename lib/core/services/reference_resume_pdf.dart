import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

import '../../features/resume/domain/entities/resume.dart';
import '../../features/templates/domain/entities/resume_template.dart';

/// Editable layouts adapted from the three supplied visual references.
class ReferenceResumePdf {
  ReferenceResumePdf(this.resume, this.template);

  final Resume resume;
  final ResumeTemplate template;
  PdfColor get accent => PdfColor.fromInt(template.color);
  bool get beam => template.layout == ResumeLayout.beam;
  bool get timeline => template.layout == ResumeLayout.timeline;
  String value(String key) => (resume.details[key] ?? '').trim();

  pw.TextStyle style({double size = 9, bool bold = false, PdfColor? color}) =>
      pw.TextStyle(
        fontSize: size,
        fontWeight: bold ? pw.FontWeight.bold : pw.FontWeight.normal,
        color: color ?? PdfColors.grey800,
        lineSpacing: 2,
      );

  // Keep each block small enough to flow independently onto the next page,
  // including long descriptions and unusually long unbroken input.
  List<pw.Widget> text(String content, {bool bold = false, PdfColor? color}) {
    final chunks = <String>[];
    for (final line in content.trim().split('\n')) {
      for (var start = 0; start < line.length;) {
        var end = (start + 140).clamp(0, line.length);
        if (end < line.length) {
          final space = line.lastIndexOf(' ', end);
          if (space > start) end = space;
          if (end > start &&
              line.codeUnitAt(end - 1) >= 0xD800 &&
              line.codeUnitAt(end - 1) <= 0xDBFF) {
            end--;
          }
        }
        chunks.add(line.substring(start, end).trim());
        start = end;
      }
    }
    return [
      for (final chunk in chunks)
        pw.Text(chunk, style: style(bold: bold, color: color)),
    ];
  }

  pw.Widget heading(String title) => pw.Container(
    margin: const pw.EdgeInsets.only(top: 17, bottom: 8),
    padding: const pw.EdgeInsets.only(bottom: 5),
    decoration: pw.BoxDecoration(
      border: beam || timeline
          ? null
          : pw.Border(bottom: pw.BorderSide(color: accent, width: .6)),
    ),
    child: pw.Row(children: [
      if (!timeline) ...[
        pw.Container(
          width: 15,
          height: 15,
          alignment: pw.Alignment.center,
          decoration: pw.BoxDecoration(
            color: beam ? const PdfColor.fromInt(0xFFFFD1D2) : PdfColors.white,
            border: pw.Border.all(color: accent, width: .5),
          ),
          child: pw.Text('+', style: style(bold: true, color: accent)),
        ),
        pw.SizedBox(width: 7),
      ],
      pw.Expanded(
        child: pw.Text(title.toUpperCase(), style: style(size: 10, bold: true)),
      ),
    ]),
  );

  List<pw.Widget> identity() => [
    pw.Text(value('name'), style: style(size: beam ? 23 : 25, bold: true)),
    pw.SizedBox(height: 6),
    if (value('customSpecialty').isNotEmpty || value('specialty').isNotEmpty)
      pw.Container(
        padding: pw.EdgeInsets.all(beam ? 5 : 0),
        color: beam ? const PdfColor.fromInt(0xFFFFD1D2) : null,
        child: pw.Text(
          value('customSpecialty').isNotEmpty
              ? value('customSpecialty')
              : value('specialty'),
          style: style(size: 11, bold: true, color: accent),
        ),
      ),
    pw.SizedBox(height: 10),
  ];

  List<pw.Widget> contacts({bool white = false}) => [
    for (final key in ['phone', 'address', 'email', 'github', 'linkedin'])
      if (value(key).isNotEmpty) ...[
        ...text(value(key), color: white ? PdfColors.white : accent),
        pw.SizedBox(height: 4),
      ],
  ];

  List<pw.Widget> profile() => value('bio').isEmpty
      ? []
      : [heading('Tarjimai hol'), ...text(value('bio'))];

  List<pw.Widget> skills() => resume.skills.isEmpty
      ? []
      : [
          heading('Ko‘nikmalar'),
          for (final skill in resume.skills)
            for (final line in text(skill))
              pw.Container(
                margin: const pw.EdgeInsets.only(bottom: 5),
                padding: const pw.EdgeInsets.symmetric(horizontal: 5, vertical: 3),
                decoration: pw.BoxDecoration(
                  border: beam || timeline
                      ? null
                      : pw.Border.all(color: accent, width: .5),
                ),
                child: line,
              ),
        ];

  List<pw.Widget> section(String title) {
    final rows = resume.entries[title] ?? [];
    if (rows.isEmpty) return [];
    return [
      heading(title),
      for (final row in rows) ...entry(row),
    ];
  }

  List<pw.Widget> entry(Map<String, String> row) {
    final fields = row.entries.where((e) => e.value.trim().isNotEmpty).toList();
    final date = (row['period'] ?? row['date'] ?? '').trim();
    final lines = <pw.Widget>[
      for (final field in fields)
        if (!timeline || (field.key != 'period' && field.key != 'date'))
          ...text(
            field.value,
            bold: ['role', 'name', 'degree', 'language'].contains(field.key),
            color: ['role', 'company', 'school'].contains(field.key) ? accent : null,
          ),
    ];
    return [
      for (var i = 0; i < lines.length; i++)
        if (timeline)
          pw.Row(crossAxisAlignment: pw.CrossAxisAlignment.start, children: [
            pw.SizedBox(
              width: 115,
              child: i == 0 ? pw.Text(date, style: style(size: 8)) : null,
            ),
            pw.Expanded(
              child: pw.Container(
                padding: const pw.EdgeInsets.only(left: 14, bottom: 3),
                decoration: const pw.BoxDecoration(
                  border: pw.Border(left: pw.BorderSide(color: PdfColors.grey500)),
                ),
                child: lines[i],
              ),
            ),
          ])
        else
          lines[i],
      if (timeline && lines.isEmpty && date.isNotEmpty) ...text(date),
      pw.SizedBox(height: 11),
    ];
  }

  pw.Widget background(pw.Context context) => pw.Stack(children: [
    if (beam)
      pw.Positioned(
        left: 0, top: 0, bottom: 0, right: 202,
        child: pw.Container(color: const PdfColor.fromInt(0xFFFFF4F5)),
      ),
    if (!beam && !timeline)
      for (var row = 0; row < 4; row++)
        for (var col = row > 1 ? row - 1 : 0; col < 4; col++)
          if (!(row == 1 && col == 2))
            pw.Positioned(
              right: (3 - col) * 20, top: row * 20,
              child: pw.Container(
                width: 19, height: 19,
                color: accent.shade((row + col).isEven ? .55 : .78),
              ),
            ),
  ]);

  void addTo(pw.Document document) {
    document.addPage(pw.MultiPage(
      pageTheme: pw.PageTheme(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(24),
        buildBackground: background,
      ),
      maxPages: 200,
      footer: (context) => pw.Align(
        alignment: pw.Alignment.centerRight,
        child: pw.Text('${context.pageNumber} / ${context.pagesCount}',
            style: style(size: 7)),
      ),
      build: (_) {
        if (timeline) {
          return [
            pw.Row(crossAxisAlignment: pw.CrossAxisAlignment.start, children: [
              pw.Container(
                width: 100, height: 110, color: accent,
                alignment: pw.Alignment.center,
                child: pw.Container(
                  width: 60, height: 60,
                  alignment: pw.Alignment.center,
                  decoration: const pw.BoxDecoration(
                    color: PdfColors.white, shape: pw.BoxShape.circle,
                  ),
                  child: pw.Text(
                    value('name').split(RegExp(r'\s+')).where((s) => s.isNotEmpty)
                        .take(2).map((s) => String.fromCharCode(s.runes.first)).join(),
                    style: style(size: 22, bold: true),
                  ),
                ),
              ),
              pw.SizedBox(width: 22),
              pw.Expanded(child: pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: identity(),
              )),
            ]),
            for (final line in contacts(white: true))
              pw.Container(width: double.infinity, color: accent,
                  padding: const pw.EdgeInsets.symmetric(horizontal: 12, vertical: 2),
                  child: line),
            ...profile(), ...section('Ish tajribasi'), ...section('Loyihalar'),
            ...section('Ta’lim'), ...skills(), ...section('Tillar'),
            ...section('Sertifikatlar'),
          ];
        }
        final main = <pw.Widget>[
          ...profile(), ...section('Ish tajribasi'), ...section('Loyihalar'),
        ];
        final side = <pw.Widget>[
          if (beam) ...identity(),
          if (beam) heading('Aloqa'),
          ...contacts(), ...section('Ta’lim'), ...skills(),
          ...section('Tillar'), ...section('Sertifikatlar'),
        ];
        pw.Partition column(List<pw.Widget> children, int flex) => pw.Partition(
          flex: flex,
          child: pw.Column(crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: children),
        );
        return [
          if (!beam) ...identity(),
          pw.Partitions(children: [
            column(beam ? side : main, beam ? 31 : 64),
            pw.Partition(width: 28, child: pw.Column(children: [])),
            column(beam ? main : side, beam ? 64 : 36),
          ]),
        ];
      },
    ));
  }
}
