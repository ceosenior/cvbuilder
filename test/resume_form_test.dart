import 'package:cvbuild/features/home/presentation/home_page.dart';
import 'package:cvbuild/features/resume/domain/entities/resume.dart';
import 'package:cvbuild/features/resume/presentation/pages/resume_form_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cvbuild/core/services/storage_service.dart';

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues({});
    StorageService.resetForTesting();
  });
  test('Editing a copy does not change the saved resume', () {
    final saved = Resume(
      details: {'name': 'Ali'},
      skills: {'Dart'},
      entries: {
        'Tillar': [
          {'language': 'Ingliz', 'level': 'B2'},
        ],
      },
    );
    final draft = saved.copy();
    draft.details['name'] = 'Vali';
    draft.skills.clear();
    draft.entries['Tillar']!.first['level'] = 'C1';
    expect(saved.details['name'], 'Ali');
    expect(saved.skills, {'Dart'});
    expect(saved.entries['Tillar']!.first['level'], 'B2');
  });

  testWidgets('Validates, retains data, saves and reopens a resume', (
    tester,
  ) async {
    await tester.pumpWidget(const MaterialApp(home: HomePage()));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Rezyume yaratish'));
    await tester.pumpAndSettle();

    Future<void> next() async {
      await tester.tap(find.text('Davom etish'));
      await tester.pumpAndSettle();
    }

    await next();
    expect(find.text('Bu maydonni to‘ldiring'), findsOneWidget);
    await tester.enterText(find.byType(TextFormField), 'Ali Valiyev');
    await next();
    await tester.tap(find.byType(DropdownButtonFormField<String>));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Flutter dasturchi').last);
    await tester.pumpAndSettle();
    await next();
    await tester.enterText(find.byType(TextFormField).at(0), 'invalid');
    await tester.enterText(find.byType(TextFormField).at(1), '+998901234567');
    await next();
    expect(find.text('Email manzilini to‘g‘ri kiriting'), findsOneWidget);
    await tester.enterText(find.byType(TextFormField).at(0), 'ali@example.com');
    await next();
    await tester.enterText(find.byType(TextFormField), 'Toshkent, O‘zbekiston');
    await next();
    await next();
    expect(find.text('Kamida bitta ko‘nikma tanlang'), findsOneWidget);
    await tester.tap(find.widgetWithText(FilterChip, 'Dart'));
    await tester.tap(find.widgetWithText(FilterChip, 'Flutter'));
    await next();
    await tester.tap(find.text('Qo‘shish'));
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextFormField).at(0), 'Ingliz tili');
    await tester.enterText(find.byType(TextFormField).at(1), 'B2');
    await next();
    await next(); // No certificates.
    await tester.enterText(
      find.byType(TextFormField),
      'Mobil ilovalar yarataman.',
    );
    await tester.tap(find.byType(BackButton));
    await tester.pumpAndSettle();
    await next();
    expect(find.text('Mobil ilovalar yarataman.'), findsOneWidget);
    await next();
    await next(); // No experience.
    await next(); // No projects.
    await next(); // No education.
    expect(find.text('Tekshirish'), findsOneWidget);
    expect(find.text('Ali Valiyev'), findsOneWidget);
    await tester.tap(find.text('Rezyumeni saqlash'));
    await tester.pumpAndSettle();
    expect(find.text('Shablon tanlash'), findsOneWidget);
    await tester.tap(find.byType(BackButton));
    await tester.pumpAndSettle();
    expect(find.text('Ali Valiyev'), findsOneWidget);
    await tester.pumpWidget(const SizedBox.shrink());
    await tester.pumpWidget(const MaterialApp(home: HomePage()));
    await tester.pumpAndSettle();
    expect(find.text('Ali Valiyev'), findsOneWidget);
    expect(await StorageService.instance.loadDraft('new'), isNull);
    await tester.tap(find.text('Ali Valiyev'));
    await tester.pumpAndSettle();
    expect(find.text('Ali Valiyev'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('Form fits a small screen with large text', (tester) async {
    tester.view.physicalSize = const Size(320, 568);
    tester.view.devicePixelRatio = 1;
    tester.platformDispatcher.textScaleFactorTestValue = 1.5;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    addTearDown(tester.platformDispatcher.clearTextScaleFactorTestValue);
    await tester.pumpWidget(const MaterialApp(home: ResumeFormPage()));
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);
  });

  testWidgets('Unfinished input and current step survive reopening', (
    tester,
  ) async {
    await tester.pumpWidget(const MaterialApp(home: ResumeFormPage()));
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextFormField), '  Ali Valiyev ');
    await tester.tap(find.text('Davom etish'));
    await tester.pumpAndSettle();
    await tester.pumpWidget(const SizedBox.shrink());
    await tester.pumpWidget(const MaterialApp(home: ResumeFormPage()));
    await tester.pumpAndSettle();
    expect(find.text('2 / 12 bosqich'), findsOneWidget);
    await tester.tap(find.byType(BackButton));
    await tester.pumpAndSettle();
    expect(find.text('  Ali Valiyev '), findsOneWidget);
  });

  testWidgets('Unsubmitted custom skill survives reopening', (tester) async {
    await StorageService.instance.saveDraft(
      'new',
      ResumeDraft(
        resume: Resume(
          details: {'specialty': 'Flutter dasturchi'},
          skills: {'Dart'},
        ),
        step: 4,
      ),
    );
    await tester.pumpWidget(const MaterialApp(home: ResumeFormPage()));
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextField), 'Testing');
    await tester.pumpWidget(const SizedBox.shrink());
    await tester.pumpWidget(const MaterialApp(home: ResumeFormPage()));
    await tester.pumpAndSettle();
    expect(find.text('Testing'), findsOneWidget);
    expect(
      tester
          .widget<FilterChip>(find.widgetWithText(FilterChip, 'Dart'))
          .selected,
      isTrue,
    );
  });
}
