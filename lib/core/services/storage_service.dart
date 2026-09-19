import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../features/resume/domain/entities/resume.dart';

class ResumeDraft {
  ResumeDraft({required this.resume, this.step = 0, this.customSkill = ''});

  final Resume resume;
  final int step;
  final String customSkill;
}

/// Serializes writes so an older keystroke cannot overwrite a newer edit.
class StorageService {
  static StorageService _instance = StorageService();
  static StorageService get instance => _instance;

  @visibleForTesting
  static void resetForTesting() => _instance = StorageService();
  static const cacheKey = 'resume_cache_v1';
  Future<void>? _pending;

  Future<Map<String, dynamic>> _read() async {
    final preferences = await SharedPreferences.getInstance();
    final value = preferences.getString(cacheKey);
    if (value == null) return {};
    return Map<String, dynamic>.from(jsonDecode(value) as Map);
  }

  Future<void> _write(void Function(Map<String, dynamic>) change) {
    final previous = _pending;
    final operation = () async {
      await previous;
      final data = await _read();
      change(data);
      final preferences = await SharedPreferences.getInstance();
      if (!await preferences.setString(cacheKey, jsonEncode(data))) {
        throw StateError('Could not save resume cache');
      }
    }();
    _pending = operation.then<void>(
      (_) {},
      onError: (Object _, StackTrace _) {},
    );
    return operation;
  }

  Future<List<Resume>> loadResumes() async {
    await _pending;
    final data = await _read();
    return [
      for (final value in data['resumes'] as List? ?? [])
        Resume.fromJson(Map<String, dynamic>.from(value as Map)),
    ];
  }

  Future<ResumeDraft?> loadDraft(String id) async {
    await _pending;
    final data = await _read();
    final value = (data['drafts'] as Map?)?[id] as Map?;
    if (value == null) return null;
    return ResumeDraft(
      resume: Resume.fromJson(
        Map<String, dynamic>.from(value['resume'] as Map),
      ),
      step: value['step'] as int? ?? 0,
      customSkill: value['customSkill'] as String? ?? '',
    );
  }

  Future<void> saveDraft(String id, ResumeDraft draft) {
    final snapshot = {
      'resume': draft.resume.toJson(),
      'step': draft.step,
      'customSkill': draft.customSkill,
    };
    return _write((data) {
      final drafts = Map<String, dynamic>.from(data['drafts'] as Map? ?? {});
      drafts[id] = snapshot;
      data['drafts'] = drafts;
    });
  }

  Future<void> saveResumes(List<Resume> resumes, {required String draftId}) {
    final snapshot = resumes.map((resume) => resume.toJson()).toList();
    return _write((data) {
      data['resumes'] = snapshot;
      final drafts = Map<String, dynamic>.from(data['drafts'] as Map? ?? {});
      drafts.remove(draftId);
      data['drafts'] = drafts;
    });
  }
}
