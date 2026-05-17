import 'rukun-pertama-beriman-kepada-allah.dart';
import 'rukun_iman_pengenalan.dart';
import 'package:aaima/main.dart';
import 'package:flutter/material.dart';
import '../../widgets/app_drawer.dart';
import '../../widgets/app_bottomNavigationBar.dart';
import '../../constants/app_colors.dart';

class Memahami_Asmaul_HusnaPage extends StatefulWidget {
  const Memahami_Asmaul_HusnaPage({super.key});

  @override
  State<Memahami_Asmaul_HusnaPage> createState() => _Memahami_Asmaul_HusnaPageState();
}

class _Memahami_Asmaul_HusnaPageState extends State<Memahami_Asmaul_HusnaPage> {
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
            onPressed: () {
              Navigator.pop(context);
            },
            tooltip: 'Back',
          ),
        ],
      ),
      drawer: const AppDrawer(),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Column(
              children: [
                const SizedBox(height: 10),
                const Row(
                  children: [
                    SizedBox(width: 20),
                    Text(
                      'Memahami Asma’ul Husna',
                      style: TextStyle(
                        fontSize: 20,
                        fontFamily: 'Comic Sans MS',
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Container(
                  margin: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                  decoration: BoxDecoration(
                    border: Border.all(color: AppColors.primaryText, width: 1),
                  ),
                  child: Column(
                    children: [
                      GestureDetector(
                        onTap: () {
                          print('Tapped on Rukun Iman: Pengenalan'); // Debug print
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const RukunImanPengenalanPage()),
                          );
                        },
                        child: Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            border: Border(
                              bottom: BorderSide(
                                  color: AppColors.primaryText, width: 1),
                            ),
                          ),
                          child: Text(
                            '(MUQADDIMAH) – Sesi 1 – Tentang Penulis (Sheikh Abdurrazzaq) & Kata Aluan – [FIQH ASMA’UL HUSNA] –',
                            style: TextStyle(
                              fontSize: 14,
                              fontFamily: 'Roboto',
                              color: AppColors.colourAaima2,
                            ),
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: (){
                        },
                        child: Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            border: Border(
                              bottom: BorderSide(
                                  color: AppColors.primaryText, width: 1),
                            ),
                          ),
                          child: Text(
                            '(MUQADDIMAH) – Sesi 2 – [MUQADDIMAH] Muqaddimah Ilmu Tentang Asma’ul Husna',
                            style: TextStyle(
                              fontSize: 14,
                              fontFamily: 'Roboto',
                              color: AppColors.colourAaima2,
                            ),
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: (){},
                        child: Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            border: Border(
                              bottom: BorderSide(
                                  color: AppColors.primaryText, width: 1),
                            ),
                          ),
                          child: Text(
                            '(MUQADDIMAH) – Sesi 3 – [MUQADDIMAH] Muqaddimah Ilmu Tentang Asma’ul Husna',
                            style: TextStyle(
                              fontSize: 14,
                              fontFamily: 'Roboto',
                              color: AppColors.colourAaima2,
                            ),
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: (){},
                        child: Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            border: Border(
                              bottom: BorderSide(
                                  color: AppColors.primaryText, width: 1),
                            ),
                          ),
                          child: Text(
                            '(MUQADDIMAH) – Sesi 4 – Keutamaan Memahami Tentang Asma’ul Husna Dan Sifat-Sifat Allah',
                            style: TextStyle(
                              fontSize: 14,
                              fontFamily: 'Roboto',
                              color: AppColors.colourAaima2,
                            ),
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: (){},
                        child: Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            border: Border(
                              bottom: BorderSide(
                                  color: AppColors.primaryText, width: 1),
                            ),
                          ),
                          child: Text(
                            '(MUQADDIMAH) – Sesi 5 – Keutamaan Memahami Tentang Asma’ul Husna Dan Sifat-Sifat Allah',
                            style: TextStyle(
                              fontSize: 14,
                              fontFamily: 'Roboto',
                              color: AppColors.colourAaima2,
                            ),
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: (){},
                        child: Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            border: Border(
                              bottom: BorderSide(
                                  color: AppColors.primaryText, width: 1),
                            ),
                          ),
                          child: Text(
                            '(MUQADDIMAH) – Sesi 6 – Keutamaan Memahami Tentang Asma’ul Husna Dan Sifat-Sifat Allah',
                            style: TextStyle(
                              fontSize: 14,
                              fontFamily: 'Roboto',
                              color: AppColors.colourAaima2,
                            ),
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: (){},
                        child: Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            border: Border(
                              bottom: BorderSide(
                                  color: AppColors.primaryText, width: 1),
                            ),
                          ),
                          child: Text(
                            '(MUQADDIMAH) – Sesi 7 – Keutamaan Memahami Tentang Asma’ul Husna Dan Sifat-Sifat Allah',
                            style: TextStyle(
                              fontSize: 14,
                              fontFamily: 'Roboto',
                              color: AppColors.colourAaima2,
                            ),
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: (){},
                        child: Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            border: Border(
                              bottom: BorderSide(
                                  color: AppColors.primaryText, width: 1),
                            ),
                          ),
                          child: Text(
                            '(MUQADDIMAH) – Sesi 8 – Keutamaan Memahami Tentang Asma’ul Husna Dan Sifat-Sifat Allah',
                            style: TextStyle(
                              fontSize: 14,
                              fontFamily: 'Roboto',
                              color: AppColors.colourAaima2,
                            ),
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: (){},
                        child: Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            border: Border(
                              bottom: BorderSide(
                                  color: AppColors.primaryText, width: 1),
                            ),
                          ),
                          child: Text(
                            '(MUQADDIMAH) – Sesi 9 – Pengaruh Asma’ ul-Husna Pada Penciptaan Manusia & Alam',
                            style: TextStyle(
                              fontSize: 14,
                              fontFamily: 'Roboto',
                              color: AppColors.colourAaima2,
                            ),
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: (){},
                        child: Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            border: Border(
                              bottom: BorderSide(
                                  color: AppColors.primaryText, width: 1),
                            ),
                          ),
                          child: Text(
                            '(MUQADDIMAH) – Sesi 10 – Pengaruh Asma’ ul-Husna Pada Penciptaan Manusia & Alam',
                            style: TextStyle(
                              fontSize: 14,
                              fontFamily: 'Roboto',
                              color: AppColors.colourAaima2,
                            ),
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: (){},
                        child: Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            border: Border(
                              bottom: BorderSide(
                                  color: AppColors.primaryText, width: 1),
                            ),
                          ),
                          child: Text(
                            '(MUQADDIMAH) – Sesi 11 – Semua Nama-Nama Allah Adalah al-Husna (Yang Terbaik)',
                            style: TextStyle(
                              fontSize: 14,
                              fontFamily: 'Roboto',
                              color: AppColors.colourAaima2,
                            ),
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: (){},
                        child: Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            border: Border(
                              bottom: BorderSide(
                                  color: AppColors.primaryText, width: 1),
                            ),
                          ),
                          child: Text(
                            '(MUQADDIMAH) – Sesi 12 – Kesungguhan Ahli Sunnah Membicarakan Tentang Nama2 & Sifat2 Allah',
                            style: TextStyle(
                              fontSize: 14,
                              fontFamily: 'Roboto',
                              color: AppColors.colourAaima2,
                            ),
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: (){},
                        child: Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            border: Border(
                              bottom: BorderSide(
                                  color: AppColors.primaryText, width: 1),
                            ),
                          ),
                          child: Text(
                            '(MUQADDIMAH) – Sesi 13 – Kesungguhan Ahli Sunnah Membicarakan Tentang Nama2 & Sifat2 Allah',
                            style: TextStyle(
                              fontSize: 14,
                              fontFamily: 'Roboto',
                              color: AppColors.colourAaima2,
                            ),
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: (){},
                        child: Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(12),
                          child: Text(
                            '(MUQADDIMAH) – Sesi 14 – Pembahagian Asma’ Ul-Husna Dari Sudut Makna',
                            style: TextStyle(
                              fontSize: 14,
                              fontFamily: 'Roboto',
                              color: AppColors.colourAaima2,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
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
