import 'dart:convert';
import 'package:cvbuild/core/services/pdf_service.dart';
import 'package:cvbuild/features/resume/domain/entities/resume.dart';
import 'package:cvbuild/features/templates/domain/entities/resume_template.dart';
import 'package:cvbuild/features/templates/presentation/pages/template_selection_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  test(
    'All ten templates generate valid multipage PDFs with Unicode data',
    () async {
      final resume = Resume(
        details: {
          'name': 'Ali O‘rinov — Али',
          'specialty': 'Boshqa',
          'customSpecialty': 'Muhandis',
          'email': 'ali@example.com',
          'phone': '+998901234567',
          'github': 'https://github.com/ali',
          'linkedin': 'https://linkedin.com/in/ali',
          'address': 'Toshkent',
          'bio': List.filled(250, 'O‘zbekcha matn va tajriba.').join(' '),
        },
        skills: {'Dart', 'Flutter'},
        entries: {
          'Tillar': [
            {'language': 'O‘zbek', 'level': 'Ona tili'},
          ],
          'Sertifikatlar': [
            {'name': 'Sertifikat', 'issuer': 'Institut', 'date': '2025'},
          ],
          'Ish tajribasi': [
            {
              'company': 'Kompaniya',
              'role': 'Dasturchi',
              'period': '2020–2026',
              'description': 'Ilovalar yaratish',
            },
          ],
          'Loyihalar': [
            {
              'name': 'CV',
              'role': 'Lead',
              'period': '2026',
              'description': 'PDF yaratish',
            },
          ],
          'Ta’lim': [
            {
              'school': 'Universitet',
              'degree': 'Bakalavr',
              'period': '2016–2020',
            },
          ],
        },
      );
      expect(ResumeTemplate.all.length, 10);
      final outputs = <String>{};
      for (final template in ResumeTemplate.all) {
        final bytes = await PdfService().generate(resume, template);
        final content = latin1.decode(bytes);
        expect(content.startsWith('%PDF-'), isTrue, reason: template.id);
        expect(
          RegExp(r'/Type\s*/Page\b').allMatches(content).length,
          greaterThan(1),
          reason: template.id,
        );
        outputs.add(base64Encode(bytes));
      }
      expect(outputs.length, 10);
    },
  );

  testWidgets('All templates are selectable on a narrow screen', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(320, 568);
    tester.view.devicePixelRatio = 1;
    tester.platformDispatcher.textScaleFactorTestValue = 1.5;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    addTearDown(tester.platformDispatcher.clearTextScaleFactorTestValue);
    await tester.pumpWidget(
      MaterialApp(home: TemplateSelectionPage(resume: Resume())),
    );
    for (final template in ResumeTemplate.all) {
      final card = find.byKey(ValueKey('template-${template.id}'));
      await tester.ensureVisible(find.text(template.name));
      await tester.tap(find.text(template.name));
      await tester.pump();
      final semantics = tester.widget<Semantics>(
        find
            .ancestor(
              of: card,
              matching: find.byWidgetPredicate(
                (widget) =>
                    widget is Semantics && widget.properties.selected != null,
              ),
            )
            .first,
      );
      expect(semantics.properties.selected, isTrue);
      expect(tester.takeException(), isNull);
    }
  });
}
