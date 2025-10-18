import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';

class SimplePDFService {
  // PDF file mappings for different pages
  static const Map<String, String> pdfFiles = {
    'rukun_iman_pengenalan': '2.-rukun-iman-pertama-beriman-kepada-allah.pdf',
  };

  static Future<bool> downloadPDF(BuildContext context, String pageKey, {String? customFileName}) async {
    try {
      // Get PDF filename for the page
      String? pdfFileName = pdfFiles[pageKey];
      if (pdfFileName == null) {
        _showErrorSnackBar(context, 'PDF file not found for page: $pageKey');
        return false;
      }

      // Load PDF from assets
      String assetPath = 'assets/files/aqidah/$pdfFileName';
      ByteData pdfData = await rootBundle.load(assetPath);
      
      // Get application documents directory
      Directory appDocDir = await getApplicationDocumentsDirectory();
      
      // Create destination file path
      String fileName = customFileName ?? '${pageKey}_${DateTime.now().millisecondsSinceEpoch}.pdf';
      String destinationPath = '${appDocDir.path}/$fileName';
      
      // Write PDF file to documents directory
      File destinationFile = File(destinationPath);
      await destinationFile.writeAsBytes(pdfData.buffer.asUint8List());
      
      _showSuccessSnackBar(context, 'File saved to Documents: $fileName\nPath: $destinationPath');
      return true;
      
    } catch (e) {
      _showErrorSnackBar(context, 'Error downloading PDF: $e');
      return false;
    }
  }

  static void _showSuccessSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.green,
        duration: const Duration(seconds: 5),
      ),
    );
  }

  static void _showErrorSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
        duration: const Duration(seconds: 3),
      ),
    );
  }
}
