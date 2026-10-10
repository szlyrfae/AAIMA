import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show ByteData, rootBundle;
import 'package:path_provider/path_provider.dart';
import 'package:open_filex/open_filex.dart';

class PdfDownloader {
  /// Download PDF dari assets → simpan dalam storage → auto open
  static Future<void> download({
    required BuildContext context,
    required String assetPath,
    required String fileName,
    bool openAfterDownload = true,
  }) async {
    try {
      // 1. Load PDF dari assets
      final ByteData bytes = await rootBundle.load(assetPath);

      // 2. Tentukan folder simpanan
      Directory? directory;
      if (Platform.isAndroid) {
        directory = await getExternalStorageDirectory();
      } else {
        directory = await getApplicationDocumentsDirectory();
      }

      if (directory == null) {
        if (context.mounted) {
          _showSnack(context, 'Tidak dapat akses storan');
        }
        return;
      }

      // 3. Tulis fail ke storage
      final file = File('${directory.path}/$fileName');
      await file.writeAsBytes(bytes.buffer.asUint8List());

      // 4. Bagi tahu user
      if (context.mounted) {
        _showSnack(context, 'PDF disimpan di ${file.path}');
      }

      // 5. Auto buka fail (optional)
      if (openAfterDownload) {
        await OpenFilex.open(file.path);
      }
    } catch (e) {
      if (context.mounted) {
        _showSnack(context, 'Ralat: $e');
      }
    }
  }

  static void _showSnack(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(seconds: 3),
      ),
    );
  }
}