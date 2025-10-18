import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

class PDFService {
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

      // Source PDF file path
      String sourcePath = 'C:\\Users\\User\\OneDrive\\Desktop\\PROJECT\\ASAS ASAS ISLAM APP\\AAIMA\\assets\\files\\aqidah\\$pdfFileName';
      File sourceFile = File(sourcePath);
      
      // Check if source file exists
      if (!await sourceFile.exists()) {
        _showErrorSnackBar(context, 'Source PDF file not found: $pdfFileName');
        return false;
      }
      
      // Get application documents directory
      Directory? appDocDir = await getApplicationDocumentsDirectory();
      if (appDocDir == null) {
        _showErrorSnackBar(context, 'Could not access documents directory');
        return false;
      }
      
      // Create destination file path
      String fileName = customFileName ?? '${pageKey}_${DateTime.now().millisecondsSinceEpoch}.pdf';
      String destinationPath = '${appDocDir.path}/$fileName';
      
      // Copy PDF file
      await sourceFile.copy(destinationPath);
      
      _showSuccessSnackBar(context, 'File saved to Documents: $fileName');
      return true;
      
    } catch (e) {
      _showErrorSnackBar(context, 'Error downloading PDF: $e');
      return false;
    }
  }

  // Convenience method for Rukun Iman Pengenalan (backward compatibility)
  static Future<bool> downloadRukunImanPDF(BuildContext context) async {
    return downloadPDF(context, 'rukun_iman_pengenalan');
  }


  static void _showSuccessSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.green,
        duration: const Duration(seconds: 3),
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
