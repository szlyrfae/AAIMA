import 'package:flutter/material.dart';
import '../services/simple_pdf_service.dart';
import '../constants/app_colors.dart';

class PDFDownloadFAB extends StatelessWidget {
  final String pageKey;
  final String? customFileName;
  final String? tooltip;

  const PDFDownloadFAB({
    super.key,
    required this.pageKey,
    this.customFileName,
    this.tooltip,
  });

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: () => _downloadPDF(context),
      backgroundColor: AppColors.colourAaima1,
      child: const Icon(
        Icons.download,
        color: Colors.white,
      ),
      tooltip: tooltip ?? 'Download PDF',
    );
  }

  void _downloadPDF(BuildContext context) async {
    // Show loading indicator
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return const AlertDialog(
          content: Row(
            children: [
              CircularProgressIndicator(),
              SizedBox(width: 20),
              Text('Preparing download...'),
            ],
          ),
        );
      },
    );

    // Download the PDF
    bool success = await SimplePDFService.downloadPDF(context, pageKey, customFileName: customFileName);
    
    // Hide loading indicator
    Navigator.of(context).pop();
    
    if (success) {
      // Optional: Show additional success message
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Download completed successfully!'),
          backgroundColor: Colors.green,
          duration: Duration(seconds: 2),
        ),
      );
    }
  }
}
