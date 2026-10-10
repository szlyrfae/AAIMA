// lib/Aqidah/aqidah.dart
import 'package:flutter/material.dart';

// Sub-pages
import 'Rukun Iman/rukun_iman_pengenalan.dart';
import 'Rukun Iman/rukun-pertama-beriman-kepada-allah.dart';
import 'Rukun Iman/rukun-kedua-beriman-dengan-malaikat.dart';
import 'Rukun Iman/rukun-ketiga-beriman-dengan-kitab.dart';
import 'Rukun Iman/rukun-keempat-beriman-dengan-rasul.dart';
import 'Rukun Iman/rukun-kelima-beriman-dengan-hari-akhirat.dart';
import 'Rukun Iman/rukun-keenam-beriman-dengan-qadar.dart';
import 'Rukun Iman/perincian-hakikat-beriman-kepada-allah.dart';
import 'Rukun Iman/memahami-asmaul-husna.dart';

// Widgets & constants
import '../widgets/app_drawer.dart';
import '../widgets/app_bottomNavigationBar.dart';
import '../constants/app_colors.dart';

class AqidahPage extends StatefulWidget {
  const AqidahPage({super.key});

  @override
  State<AqidahPage> createState() => _AqidahPageState();
}

class _AqidahPageState extends State<AqidahPage> {
  int _selectedIndex = 2;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Aqidah'),
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
                'AQIDAH',
                style: TextStyle(
                  fontSize: 20,
                  fontFamily: 'Comic Sans MS',
                ),
              ),
            ),
            const SizedBox(height: 10),

            // ===== SUB-TAJUK =====
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                'Rukun Iman',
                style: TextStyle(
                  fontSize: 15,
                  fontFamily: 'Roboto',
                  fontWeight: FontWeight.bold,
                  color: AppColors.colourAaima2,
                ),
              ),
            ),
            const SizedBox(height: 10),

            // ===== SENARAI MENU =====
            Container(
              margin: const EdgeInsets.fromLTRB(20, 0, 20, 10),
              decoration: BoxDecoration(
                border: Border.all(color: AppColors.primaryText, width: 1),
              ),
              child: Column(
                children: [
                  // --- Pengenalan ---
                  _MenuItem(
                    title: 'Rukun Iman: Pengenalan',
                    onTap: () => _go(context, const RukunImanPengenalanPage()),
                  ),

                  // --- Rukun Pertama + Sub-menu ---
                  _MenuItem(
                    title: 'Rukun Pertama: Beriman Kepada Allah',
                    onTap: () => _go(context, const RukunImanPertamaPage()),
                  ),
                  _MenuItem(
                    title: '– Perincian Hakikat Beriman Kepada Allah',
                    indent: true,
                    onTap: () => _go(
                      context,
                      const Perincian_hakikat_beriman_kepada_allahPage(),
                    ),
                  ),
                  _MenuItem(
                    title: '– Memahami Asma\'ul Husna',
                    indent: true,
                    onTap: () => _go(context, const Memahami_Asmaul_HusnaPage()),
                  ),

                  // --- Rukun Kedua hingga Keenam ---
                  _MenuItem(
                    title: 'Rukun Kedua: Beriman Dengan Malaikat',
                    onTap: () => _go(context, const RukunImanKeduaPage()),
                  ),
                  _MenuItem(
                    title: 'Rukun Ketiga: Beriman Dengan Kitab',
                    onTap: () => _go(context, const RukunImanKetigaPage()),
                  ),
                  _MenuItem(
                    title: 'Rukun Keempat: Beriman Dengan Rasul',
                    onTap: () => _go(context, const RukunImanKeempatPage()),
                  ),
                  _MenuItem(
                    title: 'Rukun Kelima: Beriman Dengan Hari Akhirat',
                    onTap: () => _go(context, const RukunImanKelimaPage()),
                  ),
                  _MenuItem(
                    title: 'Rukun Keenam: Beriman Dengan Qadar',
                    onTap: () => _go(context, const RukunImanKeenamPage()),
                  ),

                  // --- Nota ringkas (belum ada page) ---
                  _MenuItem(
                    title: 'Nota-nota Ringkas Tentang Rukun Iman',
                    showDivider: false,
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Akan datang...')),
                      );
                    },
                  ),
                ],
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

  /// Helper: navigate ke page
  void _go(BuildContext context, Widget page) {
    Navigator.push(context, MaterialPageRoute(builder: (_) => page));
  }
}

// ============================================================================
// WIDGET: Menu Item
// ============================================================================
/// Satu baris menu dalam senarai Aqidah.
/// - [title]     : teks yang dipaparkan
/// - [onTap]     : apa jadi bila ditekan
/// - [indent]    : jika true, teks di-indent (untuk sub-menu)
/// - [showDivider]: jika false, tiada border bawah (untuk item terakhir)
class _MenuItem extends StatelessWidget {
  final String title;
  final VoidCallback onTap;
  final bool indent;
  final bool showDivider;

  const _MenuItem({
    required this.title,
    required this.onTap,
    this.indent = false,
    this.showDivider = true,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.only(
          left: indent ? 24 : 12,
          right: 12,
          top: 12,
          bottom: 12,
        ),
        decoration: BoxDecoration(
          border: showDivider
              ? Border(
            bottom: BorderSide(
              color: AppColors.primaryText,
              width: 1,
            ),
          )
              : null,
        ),
        child: Text(
          title,
          style: TextStyle(
            fontSize: indent ? 13 : 14,
            fontFamily: 'Roboto',
            color: indent ? AppColors.colourAaima5 : AppColors.colourAaima2,
          ),
        ),
      ),
    );
  }
}