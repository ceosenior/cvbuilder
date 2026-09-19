import 'package:cvbuild/core/services/storage_service.dart';
import 'package:cvbuild/features/resume/domain/entities/resume.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  setUp(() => SharedPreferences.setMockInitialValues({}));

  test(
    'Fresh service restores all sections and the latest queued edit',
    () async {
      final storage = StorageService();
      final resume = Resume(
        details: {
          'name': 'Ali',
          'bio': 'Tarjimai hol',
          'email': 'ali@example.com',
        },
        skills: {'Dart', 'Flutter'},
        entries: {
          'Tillar': [
            {'language': 'Ingliz', 'level': 'B2'},
          ],
          'Sertifikatlar': [
            {'name': 'Certificate', 'date': '2026'},
          ],
          'Ish tajribasi': [
            {'company': 'Company', 'role': 'Developer'},
          ],
          'Loyihalar': [
            {'name': 'CV', 'description': 'App'},
          ],
          'Ta’lim': [
            {'school': 'University', 'period': '2020–2024'},
          ],
        },
      );
      final first = storage.saveDraft('new', ResumeDraft(resume: resume));
      resume.details['name'] = 'Vali';
      final latest = storage.saveDraft(
        'new',
        ResumeDraft(resume: resume, step: 8),
      );
      await Future.wait([first, latest]);
      final restored = await StorageService().loadDraft('new');
      expect(restored!.resume.toJson(), resume.toJson());
      expect(restored.step, 8);

      resume.entries['Tillar']!.clear();
      resume.skills.remove('Dart');
      await storage.saveDraft('new', ResumeDraft(resume: resume));
      expect(
        (await StorageService().loadDraft('new'))!.resume.toJson(),
        resume.toJson(),
      );
    },
  );

  test(
    'Completing a resume clears only its draft and preserves other edits',
    () async {
      final storage = StorageService();
      final resume = Resume(details: {'name': 'Ali'});
      await storage.saveDraft('new', ResumeDraft(resume: resume));
      await storage.saveDraft('resume_0', ResumeDraft(resume: resume, step: 3));
      await storage.saveResumes([resume], draftId: 'new');
      final restored = StorageService();
      expect((await restored.loadResumes()).single.details['name'], 'Ali');
      expect(await restored.loadDraft('new'), isNull);
      expect((await restored.loadDraft('resume_0'))!.step, 3);
    },
  );

  test('Invalid cache is reported without overwriting it', () async {
    SharedPreferences.setMockInitialValues({
      StorageService.cacheKey: '{invalid',
    });
    final storage = StorageService();
    await expectLater(storage.loadResumes(), throwsFormatException);
    await expectLater(
      storage.saveDraft('new', ResumeDraft(resume: Resume())),
      throwsFormatException,
    );
    final preferences = await SharedPreferences.getInstance();
    expect(preferences.getString(StorageService.cacheKey), '{invalid');
  });
}
