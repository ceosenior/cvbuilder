import 'dart:typed_data';
import 'package:file_picker/file_picker.dart';

class FileService {
  Future<bool> savePdf(Uint8List bytes, String filename) async {
    final location = await FilePicker.saveFile(
      dialogTitle: 'PDFni saqlash',
      fileName: filename,
      type: FileType.custom,
      allowedExtensions: ['pdf'],
      bytes: bytes,
      mimeType: 'application/pdf',
    );
    return location != null;
  }
}
