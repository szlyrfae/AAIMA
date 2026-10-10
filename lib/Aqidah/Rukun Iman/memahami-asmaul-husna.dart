import 'package:flutter/material.dart';
import '../../widgets/app_drawer.dart';
import '../../widgets/app_bottomNavigationBar.dart';
import '../../constants/app_colors.dart';

class Memahami_Asmaul_HusnaPage extends StatefulWidget {
  const Memahami_Asmaul_HusnaPage({super.key});

  @override
  State<Memahami_Asmaul_HusnaPage> createState() =>
      _Memahami_Asmaul_HusnaPageState();
}

class _Memahami_Asmaul_HusnaPageState extends State<Memahami_Asmaul_HusnaPage> {
  int _selectedIndex = 2;

  // Senarai topik untuk menu
  final List<String> _topics = [
    '(MUQADDIMAH) – Sesi 1 – Tentang Penulis (Sheikh Abdurrazzaq) & Kata Aluan – [FIQH ASMA\'UL HUSNA] –',
    '(MUQADDIMAH) – Sesi 2 – [MUQADDIMAH] Muqaddimah Ilmu Tentang Asma\'ul Husna',
    '(MUQADDIMAH) – Sesi 3 – [MUQADDIMAH] Muqaddimah Ilmu Tentang Asma\'ul Husna',
    '(MUQADDIMAH) – Sesi 4 – Keutamaan Memahami Tentang Asma\'ul Husna Dan Sifat-Sifat Allah',
    '(MUQADDIMAH) – Sesi 5 – Keutamaan Memahami Tentang Asma\'ul Husna Dan Sifat-Sifat Allah',
    '(MUQADDIMAH) – Sesi 6 – Keutamaan Memahami Tentang Asma\'ul Husna Dan Sifat-Sifat Allah',
    '(MUQADDIMAH) – Sesi 7 – Keutamaan Memahami Tentang Asma\'ul Husna Dan Sifat-Sifat Allah',
    '(MUQADDIMAH) – Sesi 8 – Keutamaan Memahami Tentang Asma\'ul Husna Dan Sifat-Sifat Allah',
    '(MUQADDIMAH) – Sesi 9 – Pengaruh Asma\' ul-Husna Pada Penciptaan Manusia & Alam',
    '(MUQADDIMAH) – Sesi 10 – Pengaruh Asma\' ul-Husna Pada Penciptaan Manusia & Alam',
    '(MUQADDIMAH) – Sesi 11 – Semua Nama-Nama Allah Adalah al-Husna (Yang Terbaik)',
    '(MUQADDIMAH) – Sesi 12 – Kesungguhan Ahli Sunnah Membicarakan Tentang Nama2 & Sifat2 Allah',
    '(MUQADDIMAH) – Sesi 13 – Kesungguhan Ahli Sunnah Membicarakan Tentang Nama2 & Sifat2 Allah',
    '(MUQADDIMAH) – Sesi 14 – Pembahagian Asma\' Ul-Husna Dari Sudut Makna',
  ];

  /// TODO: Tambah navigation di sini bila page setiap sesi dah siap.
  /// Contoh:
  /// Navigator.push(context, MaterialPageRoute(
  ///   builder: (context) => const AsmaulHusnaSesi1Page(),
  /// ));
  void _onTopicTap(int index) {
    debugPrint('Tapped topic index: $index → ${_topics[index]}');
    // Belum ada page untuk setiap sesi.
    // Bila dah ada, tukar di sini.
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Memahami Asma\'ul Husna'),
        actions: [
          IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => Navigator.pop(context),
            tooltip: 'Back',
          ),
        ],
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
                'Memahami Asma\'ul Husna',
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