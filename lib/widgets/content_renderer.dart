 import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../services/content_service.dart';
import '../constants/app_colors.dart';
import 'action_bottom_sheet.dart';

class ContentRenderer extends StatelessWidget {
  final String category;
  final double fontSize;
  final double lineHeight;
  final double spacing;
  final ContentService _service = ContentService();

  ContentRenderer({
    super.key,
    required this.category,
    this.fontSize = 15,
    this.lineHeight = 1.6,
    this.spacing = 15,
  });

  // ============ STATIC RENDER METHODS ============
  static Widget renderRukunImanPengenalan() {
    return ContentRenderer(category: 'pengenalan');
  }

  static Widget renderRukunImanPertama() {
    return ContentRenderer(category: 'pertama');
  }

  static Widget renderRukunImanKedua() {
    return ContentRenderer(category: 'kedua');
  }

  static Widget renderRukunImanKetiga() {
    return ContentRenderer(category: 'ketiga');
  }

  static Widget renderRukunImanKeempat() {
    return ContentRenderer(category: 'keempat');
  }

  static Widget renderRukunImanKelima() {
    return ContentRenderer(category: 'kelima');
  }

  static Widget renderRukunImanKeenam() {
    return ContentRenderer(category: 'keenam');
  }

  // ============ BUILD METHOD ============
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Map<String, dynamic>>>(
      future: _service.getRukunContent(category),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: Padding(
              padding: EdgeInsets.all(20.0),
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(AppColors.colourAaima1),
              ),
            ),
          );
        }

        if (snapshot.hasError) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: [
                  Icon(Icons.error_outline, color: Colors.red.shade400, size: 48),
                  const SizedBox(height: 10),
                  Text(
                    'Error loading content',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.red.shade700,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    snapshot.error.toString(),
                    style: TextStyle(color: Colors.grey.shade600, fontSize: 14),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          );
        }

        final content = snapshot.data ?? [];

        if (content.isEmpty) {
          return const Center(
            child: Padding(
              padding: EdgeInsets.all(20.0),
              child: Text('No content available'),
            ),
          );
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: content.map((item) {
            final isBold = item['isBold'] == true;
            final isArabic = item['isArabic'] == true;
            final text = item['text'] ?? '';

            return Padding(
              padding: EdgeInsets.only(bottom: spacing),
              child: _buildTextWithLinks(
                context: context,      // ← PASS CONTEXT
                text: text,
                isBold: isBold,
                isArabic: isArabic,
              ),
            );
          }).toList(),
        );
      },
    );
  }

  // ============ BUILD TEXT WITH HYPERLINKS ============
  Widget _buildTextWithLinks({
    required BuildContext context,
    required String text,
    required bool isBold,
    required bool isArabic,
  }) {
    // Regex to detect: [text](url)
    final linkRegex = RegExp(r'\[([^\]]+)\]\(([^)]+)\)');

    // If no links found, return plain text
    if (!linkRegex.hasMatch(text)) {
      return Text(
        text,
        style: TextStyle(
          fontSize: isArabic ? fontSize + 1 : fontSize,
          fontFamily: isArabic ? 'Arabic' : 'Roboto',
          fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
          color: isArabic ? AppColors.colourAaima2 : AppColors.primaryText,
          height: lineHeight,
        ),
        textAlign: isArabic ? TextAlign.right : TextAlign.justify,
        textDirection: isArabic ? TextDirection.rtl : TextDirection.ltr,
      );
    }

    // Build rich text with tappable links
    final spans = <InlineSpan>[];
    int lastMatch = 0;

    for (final match in linkRegex.allMatches(text)) {
      // Add text before link
      if (match.start > lastMatch) {
        spans.add(TextSpan(text: text.substring(lastMatch, match.start)));
      }

      // Add the link
      final linkText = match.group(1)!;
      final linkUrl = match.group(2)!;

      spans.add(
        WidgetSpan(
          alignment: PlaceholderAlignment.baseline,
          baseline: TextBaseline.alphabetic,
          child: GestureDetector(
            onTap: () => _handleLinkTap(context, linkUrl),
            child: Text(
              linkText,
              style: TextStyle(
                fontSize: fontSize,
                fontFamily: 'Roboto',
                color: Colors.blue.shade700,
                decoration: TextDecoration.underline,
                decorationColor: Colors.blue.shade700,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      );

      lastMatch = match.end;
    }

    // Add remaining text
    if (lastMatch < text.length) {
      spans.add(TextSpan(text: text.substring(lastMatch)));
    }

    return RichText(
      text: TextSpan(
        style: TextStyle(
          fontSize: isArabic ? fontSize + 1 : fontSize,
          fontFamily: isArabic ? 'Arabic' : 'Roboto',
          fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
          color: isArabic ? AppColors.colourAaima2 : AppColors.primaryText,
          height: lineHeight,
        ),
        children: spans,
      ),
      textAlign: isArabic ? TextAlign.right : TextAlign.justify,
      textDirection: isArabic ? TextDirection.rtl : TextDirection.ltr,
    );
  }

  // ============ HANDLE LINK TAPS ============
  Future<void> _handleLinkTap(BuildContext context, String url) async {
    try {
      // PDF asset link (internal)
      if (url.startsWith('pdf://')) {
        final pdfPath = url.replaceFirst('pdf://', '');
        final fileName = pdfPath.split('/').last;

        if (context.mounted) {
          await ActionBottomSheet.show(
            context: context,
            pdfAssetPath: pdfPath,
            pdfFileName: fileName,
          );
        }
        return;
      }

      // External HTTP/HTTPS link
      if (url.startsWith('http://') || url.startsWith('https://')) {
        final uri = Uri.parse(url);
        if (await canLaunchUrl(uri)) {
          await launchUrl(uri, mode: LaunchMode.externalApplication);
        } else {
          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Tidak dapat membuka: $url')),
            );
          }
        }
        return;
      }

      // Unknown scheme
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Pautan tidak dikenali: $url')),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Ralat: $e')),
        );
      }
    }
  }
}