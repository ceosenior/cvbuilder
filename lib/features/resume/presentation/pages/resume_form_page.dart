import 'package:flutter/material.dart';

import '../../../../core/services/storage_service.dart';
import '../../domain/entities/resume.dart';
import '../models/resume_form_config.dart';
import '../widgets/resume_form_content.dart';
import '../widgets/resume_step_header.dart';

class ResumeFormPage extends StatefulWidget {
  const ResumeFormPage({super.key, this.initial, this.draftId = 'new'});
  final Resume? initial;
  final String draftId;

  @override
  State<ResumeFormPage> createState() => _ResumeFormPageState();
}

class _ResumeFormPageState extends State<ResumeFormPage> {
  late Resume _resume = widget.initial?.copy() ?? Resume();
  bool _loading = true;
  String? _cacheError;
  final _form = GlobalKey<FormState>();
  final _scroll = ScrollController();
  final _customSkill = TextEditingController();
  int _step = 0;

  @override
  void initState() {
    super.initState();
    _restore();
    _customSkill.addListener(_saveDraft);
  }

  Future<void> _restore() async {
    try {
      final draft = await StorageService.instance.loadDraft(widget.draftId);
      if (!mounted) return;
      setState(() {
        if (draft != null) {
          _resume = draft.resume;
          _step = draft.step.clamp(0, resumeStepTitles.length - 1);
          _customSkill.text = draft.customSkill;
        }
        _cacheError = null;
        _loading = false;
      });
    } catch (_) {
      if (mounted) {
        setState(() => _cacheError = 'Saqlangan ma’lumotlar yuklanmadi.');
      }
    }
  }

  Future<void> _saveDraft() async {
    if (_loading) return;
    try {
      await StorageService.instance.saveDraft(
        widget.draftId,
        ResumeDraft(
          resume: _resume,
          step: _step,
          customSkill: _customSkill.text,
        ),
      );
      if (mounted && _cacheError != null) setState(() => _cacheError = null);
    } catch (_) {
      if (mounted) {
        setState(() => _cacheError = 'Ma’lumotlarni saqlab bo‘lmadi.');
      }
    }
  }

  @override
  void dispose() {
    _scroll.dispose();
    _customSkill.dispose();
    super.dispose();
  }

  void _go(int step) {
    FocusScope.of(context).unfocus();
    setState(() => _step = step);
    _saveDraft();
    if (_scroll.hasClients) _scroll.jumpTo(0);
  }

  @override
  Widget build(BuildContext context) => PopScope<Resume>(
    canPop: _step == 0,
    onPopInvokedWithResult: (didPop, result) {
      if (!didPop) _go(_step - 1);
    },
    child: Scaffold(
      appBar: AppBar(
        title: const Text('Rezyume yaratish'),
        leading: BackButton(
          onPressed: () {
            if (_step > 0) {
              _go(_step - 1);
            } else {
              Navigator.pop(context);
            }
          },
        ),
      ),
      body: _loading
          ? Center(
              child: _cacheError == null
                  ? const CircularProgressIndicator()
                  : TextButton(
                      onPressed: _restore,
                      child: Text('$_cacheError Qayta urinish'),
                    ),
            )
          : SafeArea(
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 680),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      if (_cacheError != null)
                        TextButton(
                          onPressed: _saveDraft,
                          child: Text('$_cacheError Qayta urinish'),
                        ),
                      ResumeStepHeader(step: _step),
                      Expanded(
                        child: SingleChildScrollView(
                          controller: _scroll,
                          padding: const EdgeInsets.all(24),
                          child: Form(
                            key: _form,
                            child: KeyedSubtree(
                              key: ValueKey(_step),
                              child: ResumeFormContent(
                                resume: _resume,
                                step: _step,
                                customSkill: _customSkill,
                                onChanged: _saveDraft,
                                onGo: _go,
                              ),
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(24, 8, 24, 16),
                        child: FilledButton(
                          onPressed: () {
                            if (!_form.currentState!.validate()) return;
                            if (_step == resumeStepTitles.length - 1) {
                              Navigator.pop(context, _resume);
                            } else {
                              _go(_step + 1);
                            }
                          },
                          child: Text(
                            _step == resumeStepTitles.length - 1
                                ? 'Rezyumeni saqlash'
                                : 'Davom etish',
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
    ),
  );
}
