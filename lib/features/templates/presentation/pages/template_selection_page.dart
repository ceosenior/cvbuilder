import 'package:flutter/material.dart';
import '../../../preview/presentation/pages/pdf_preview_page.dart';
import '../widgets/template_grid.dart';
import '../../../../core/services/pdf_service.dart';
import '../../../resume/domain/entities/resume.dart';
import '../../domain/entities/resume_template.dart';

class TemplateSelectionPage extends StatefulWidget {
  const TemplateSelectionPage({super.key, required this.resume});
  final Resume resume;

  @override
  State<TemplateSelectionPage> createState() => _TemplateSelectionPageState();
}

class _TemplateSelectionPageState extends State<TemplateSelectionPage> {
  ResumeTemplate _selected = ResumeTemplate.all.first;
  bool _busy = false;

  Future<void> _preview() async {
    setState(() => _busy = true);
    try {
      final bytes = await PdfService().generate(widget.resume, _selected);
      if (!mounted) return;
      await Navigator.of(context).push<void>(
        MaterialPageRoute(
          builder: (_) => PdfPreviewPage(bytes: bytes, template: _selected),
        ),
      );
    } catch (error, stackTrace) {
      debugPrint('PDF generation failed: $error\n$stackTrace');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('PDF yaratilmadi. Qayta urinib ko‘ring.'),
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('Shablon tanlash')),
    body: SafeArea(
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1000),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16),
                child: Text(
                  '${ResumeTemplate.all.length} ta shablondan birini tanlang. Ma’lumotlaringiz tanlangan PDFga joylanadi.',
                ),
              ),
              Expanded(
                child: TemplateGrid(
                  selected: _selected,
                  busy: _busy,
                  onSelected: (template) =>
                      setState(() => _selected = template),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16),
                child: FilledButton.icon(
                  onPressed: _busy ? null : _preview,
                  icon: _busy
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Icon(Icons.picture_as_pdf),
                  label: Text(
                    _busy
                        ? 'PDF tayyorlanmoqda…'
                        : 'PDFni ko‘rish va yuklab olish',
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    ),
  );
}
