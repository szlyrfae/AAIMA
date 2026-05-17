import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../constants/content_texts.dart';

class ContentRenderer extends StatelessWidget {
  final List<Map<String, dynamic>> content;
  final double fontSize;
  final double lineHeight;
  final double spacing;

  const ContentRenderer({
    super.key,
    required this.content,
    this.fontSize = 15,
    this.lineHeight = 1.6,
    this.spacing = 15,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: content.map((item) {
        return Padding(
          padding: EdgeInsets.only(bottom: spacing),
          child: Text(
            item['text'],
            style: TextStyle(
              fontSize: fontSize,
              fontFamily: 'Roboto',
              fontWeight: item['isBold'] ? FontWeight.bold : FontWeight.normal,
              color: item['isArabic'] ? AppColors.colourAaima2 : AppColors.primaryText,
              height: lineHeight,
            ),
              textAlign: TextAlign.justify
          ),
        );
      }).toList(),
    );
  }

  // Static method to render Rukun Iman Pengenalan content
  static Widget renderRukunImanPengenalan() {
    return ContentRenderer(
      content: ContentTexts.getRukunImanPengenalanFormatted(),
    );
  }

  static Widget renderRukunImanPertama() {
    return ContentRenderer(
      content: ContentTexts.getRukunImanPertamaFormatted(),
    );
  }

  static Widget renderRukunImanKedua() {
    return ContentRenderer(
      content: ContentTexts.getRukunImanKeduaFormatted(),
    );
  }

  static Widget renderRukunImanKetiga() {
    return ContentRenderer(
      content: ContentTexts.getRukunImanKetigaFormatted(),
    );
  }

  // Static method to render simple text list
  static Widget renderSimpleText(List<String> texts) {
    return ContentRenderer(
      content: texts.map((text) => {
        'text': text,
        'isBold': false,
        'isArabic': false,
      }).toList(),
    );
  }
}

