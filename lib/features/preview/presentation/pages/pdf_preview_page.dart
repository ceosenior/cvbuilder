import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:printing/printing.dart';
import '../../../../core/services/file_service.dart';
import '../../../templates/domain/entities/resume_template.dart';

class PdfPreviewPage extends StatefulWidget {
  const PdfPreviewPage({
    super.key,
    required this.bytes,
    required this.template,
  });
  final Uint8List bytes;
  final ResumeTemplate template;
  @override
  State<PdfPreviewPage> createState() => PdfPreviewPageState();
}

class PdfPreviewPageState extends State<PdfPreviewPage> {
  bool _saving = false;
  Future<void> _save() async {
    setState(() => _saving = true);
    try {
      await FileService().savePdf(
        widget.bytes,
        'rezyume-${widget.template.id}.pdf',
      );
    } catch (error, stackTrace) {
      debugPrint('PDF save failed: $error\n$stackTrace');
      final message = switch (error) {
        MissingPluginException() =>
          'Saqlash xizmati ishga tushmadi. Ilovani to‘liq yopib, qayta oching.',
        PlatformException(code: 'explorer_not_found') =>
          'Fayl saqlash oynasi topilmadi. Qurilmadagi Files (Fayllar) ilovasini yoqing.',
        _ => 'PDF saqlanmadi. Qayta urinib ko‘ring.',
      };
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(message)));
      }
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: Text('${widget.template.name} — PDF')),
    body: SafeArea(
      child: Column(
        children: [
          Expanded(
            child: PdfPreview(
              build: (_) => widget.bytes,
              canChangeOrientation: false,
              canChangePageFormat: false,
              canDebug: false,
              allowPrinting: false,
              allowSharing: false,
              onError: (_, error) => const Center(
                child: Text(
                  'PDFni ko‘rsatib bo‘lmadi. Yuklab olib ochishingiz mumkin.',
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: FilledButton.icon(
              onPressed: _saving ? null : _save,
              icon: const Icon(Icons.download),
              label: Text(_saving ? 'Saqlanmoqda…' : 'PDFni yuklab olish'),
            ),
          ),
        ],
      ),
    ),
  );
}
