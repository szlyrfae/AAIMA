import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show ByteData, rootBundle;
import 'package:path_provider/path_provider.dart';
import 'package:open_filex/open_filex.dart';
import '../constants/app_colors.dart';

class ActionBottomSheet {
  static Future<void> show({
    required BuildContext context,
    required String pdfAssetPath,
    required String pdfFileName,
    VoidCallback? onShare,
    VoidCallback? onZoomInfo,
  }) async {
    await showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) {
        return Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
          ),
          child: SafeArea(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Drag handle
                Container(
                  width: 40,
                  height: 4,
                  margin: const EdgeInsets.only(top: 12, bottom: 8),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.all(12),
                  child: Text(
                    'Pilihan',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primaryText,
                    ),
                  ),
                ),
                const Divider(height: 1),

                // Download PDF
                _tile(
                  icon: Icons.download_rounded,
                  title: 'Muat Turun PDF',
                  subtitle: 'Simpan fail PDF ke peranti',
                  onTap: () async {
                    Navigator.pop(context);
                    await _downloadPdf(
                      context: context,
                      assetPath: pdfAssetPath,
                      fileName: pdfFileName,
                    );
                  },
                ),

                // Share
                if (onShare != null)
                  _tile(
                    icon: Icons.share_rounded,
                    title: 'Kongsi',
                    subtitle: 'Kongsi ke aplikasi lain',
                    onTap: () {
                      Navigator.pop(context);
                      onShare();
                    },
                  ),

                // Zoom info
                _tile(
                  icon: Icons.zoom_in_rounded,
                  title: 'Zoom In / Out',
                  subtitle: 'Cubit skrin atau guna butang di kanan',
                  onTap: () {
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text(
                          'Cubit skrin dengan 2 jari untuk zoom, atau guna butang + / - di kanan bawah',
                        ),
                        duration: Duration(seconds: 3),
                      ),
                    );
                  },
                ),

                const SizedBox(height: 8),
              ],
            ),
          ),
        );
      },
    );
  }

  static Widget _tile({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: AppColors.colourAaima1.withOpacity(0.15),
        child: Icon(icon, color: AppColors.colourAaima1),
      ),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
      subtitle: Text(subtitle, style: const TextStyle(fontSize: 12)),
      trailing: const Icon(Icons.arrow_forward_ios, size: 14),
      onTap: onTap,
    );
  }

  static Future<void> _downloadPdf({
    required BuildContext context,
    required String assetPath,
    required String fileName,
  }) async {
    try {
      final ByteData bytes = await rootBundle.load(assetPath);
      Directory? directory;

      if (Platform.isAndroid) {
        directory = await getExternalStorageDirectory();
      } else {
        directory = await getApplicationDocumentsDirectory();
      }

      if (directory == null) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Tidak dapat akses storan')),
          );
        }
        return;
      }

      final file = File('${directory.path}/$fileName');
      await file.writeAsBytes(bytes.buffer.asUint8List());

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('PDF disimpan di ${file.path}')),
        );
      }

      await OpenFilex.open(file.path);
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Ralat: $e')),
        );
      }
    }
  }
}