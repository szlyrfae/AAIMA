import 'package:flutter/material.dart';
import '../../widgets/app_drawer.dart';
import '../../widgets/app_bottomNavigationBar.dart';
import '../../constants/app_colors.dart';

class Perincian_hakikat_beriman_kepada_allahPage extends StatefulWidget {
  const Perincian_hakikat_beriman_kepada_allahPage({super.key});

  @override
  State<Perincian_hakikat_beriman_kepada_allahPage> createState() =>
      _Perincian_hakikat_beriman_kepada_allahPageState();
}

class _Perincian_hakikat_beriman_kepada_allahPageState
    extends State<Perincian_hakikat_beriman_kepada_allahPage> {
  int _selectedIndex = 2;

  final List<String> _topics = [
    'I\'tiqad Ahlu As-Sunnah Tentang Allah',
    'Persoalan Tentang DI Mana Allah – Allah Di Atas Arasy',
    'Sifat Dua Mata',
    'Wajah Allah',
    'Dua Tangan',
    'Aqidah terhadap "Nama-Nama Allah Yang Indah"',
    'Sifat Ilmu',
    'Sifat "Mendengar dan Melihat"',
    'Kekuatan Semua Milik Allah',
  ];

  /// TODO: Tambah navigation di sini bila page setiap topik dah siap.
  /// Contoh:
  /// Navigator.push(context, MaterialPageRoute(
  ///   builder: (context) => const ItiqadAhluSunnahPage(),
  /// ));
  void _onTopicTap(int index) {
    debugPrint('Tapped topic index: $index → ${_topics[index]}');
    // Belum ada page untuk setiap topik.
    // Bila dah ada, tukar di sini.
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Perincian Hakikat Beriman Kepada Allah'),
      ),
      drawer: const AppDrawer(),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 10),

            // ===== TAJUK =====
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                'Perincian Hakikat Beriman Kepada Allah',
                style: TextStyle(
                  fontSize: 20,
                  fontFamily: 'Comic Sans MS',
                ),
              ),
            ),
            const SizedBox(height: 10),

            // ===== SENARAI TOPIK =====
            Container(
              margin: const EdgeInsets.fromLTRB(20, 0, 20, 10),
              decoration: BoxDecoration(
                border: Border.all(color: AppColors.primaryText, width: 1),
              ),
              child: Column(
                children: List.generate(_topics.length, (index) {
                  final isLast = index == _topics.length - 1;
                  return GestureDetector(
                    onTap: () => _onTopicTap(index),
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        border: isLast
                            ? null
                            : Border(
                          bottom: BorderSide(
                            color: AppColors.primaryText,
                            width: 1,
                          ),
                        ),
                      ),
                      child: Text(
                        _topics[index],
                        style: const TextStyle(
                          fontSize: 14,
                          fontFamily: 'Roboto',
                          color: AppColors.colourAaima2,
                        ),
                      ),
                    ),
                  );
                }),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: AppBottomNavigationBar(
        currentIndex: _selectedIndex,
      ),
    );
  }
}