import 'package:flutter/material.dart';
import '../../../app/router/app_router.dart';
import 'widgets/empty_resumes.dart';
import 'widgets/resume_card.dart';
import '../../../core/services/storage_service.dart';
import '../../resume/domain/entities/resume.dart';
import '../../resume/presentation/pages/resume_form_page.dart';
import '../../templates/presentation/pages/template_selection_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final List<Resume> _resumes = [];
  bool _loading = true;
  String? _loadError;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    try {
      final resumes = await StorageService.instance.loadResumes();
      if (!mounted) return;
      setState(() {
        _resumes
          ..clear()
          ..addAll(resumes);
        _loading = false;
        _loadError = null;
      });
    } catch (_) {
      if (mounted) setState(() => _loadError = 'Rezyumelarni yuklab bo‘lmadi.');
    }
  }

  Future<void> _open({int? index}) async {
    final draftId = index == null ? 'new' : 'resume_$index';
    final result = await Navigator.of(context).push<Resume>(
      MaterialPageRoute(
        builder: (_) => ResumeFormPage(
          initial: index == null ? null : _resumes[index],
          draftId: draftId,
        ),
      ),
    );
    if (!mounted || result == null) return;
    final updated = List<Resume>.of(_resumes);
    if (index == null) {
      updated.add(result);
    } else {
      updated[index] = result;
    }
    try {
      await StorageService.instance.saveResumes(updated, draftId: draftId);
    } catch (_) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'Saqlab bo‘lmadi. Formani qayta ochib urinib ko‘ring.',
            ),
          ),
        );
      }
      return;
    }
    if (!mounted) return;
    setState(
      () => _resumes
        ..clear()
        ..addAll(updated),
    );
    if (mounted) await _templates(result);
  }

  Future<void> _templates(Resume resume) => Navigator.of(context).push<void>(
    MaterialPageRoute(
      builder: (_) => TemplateSelectionPage(resume: resume.copy()),
    ),
  );

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('Mening CV larim')),
    body: _loading
        ? Center(
            child: _loadError == null
                ? const CircularProgressIndicator()
                : TextButton(
                    onPressed: _load,
                    child: Text('$_loadError Qayta urinish'),
                  ),
          )
        : SafeArea(
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 600),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (_resumes.isEmpty) ...[
                        const EmptyResumes(),
                      ] else ...[
                        for (var i = 0; i < _resumes.length; i++)
                          ResumeCard(
                            resume: _resumes[i],
                            onEdit: () => _open(index: i),
                            onTemplates: () => _templates(_resumes[i]),
                          ),
                      ],
                      const SizedBox(height: 24),
                      FilledButton.icon(
                        onPressed: _open,
                        icon: const Icon(Icons.add),
                        label: const Text('Rezyume yaratish'),
                      ),
                      const SizedBox(height: 12),
                      const Text(
                        'Ma’lumotlaringiz qurilmada avtomatik saqlanadi. Tugallanmagan rezyumeni “Rezyume yaratish” orqali davom ettiring.',
                        textAlign: TextAlign.center,
                      ),
                      TextButton.icon(
                        onPressed: () => Navigator.of(
                          context,
                        ).pushNamed(AppRouter.onboarding),
                        icon: const Icon(Icons.replay_rounded),
                        label: const Text('Tanishtiruvni qayta ko‘rish'),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
  );
}
