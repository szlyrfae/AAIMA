import 'rukun-pertama-beriman-kepada-allah.dart';
import 'rukun_iman_pengenalan.dart';
import 'package:aaima/main.dart';
import 'package:flutter/material.dart';
import '../../widgets/app_drawer.dart';
import '../../widgets/app_bottomNavigationBar.dart';
import '../../constants/app_colors.dart';

class Perincian_hakikat_beriman_kepada_allahPage extends StatefulWidget {
  const Perincian_hakikat_beriman_kepada_allahPage({super.key});

  @override
  State<Perincian_hakikat_beriman_kepada_allahPage> createState() => _Perincian_hakikat_beriman_kepada_allahPageState();
}

class _Perincian_hakikat_beriman_kepada_allahPageState extends State<Perincian_hakikat_beriman_kepada_allahPage> {
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
                      'Perincian Hakikat Beriman Kepada Allah',
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
                            'I’tiqad Ahlu As-Sunnah Tentang Allah',
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
                            'Persoalan Tentang DI Mana Allah – Allah Di Atas Arasy',
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
                            'Sifat Dua Mata',
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
                            'Wajah Allah',
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
                            'Dua Tangan',
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
                            'Aqidah terhadap “Nama-Nama Allah Yang Indah”',
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
                            'Sifat Ilmu',
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
                            'Sifat "Mendengar dan Melihat"',
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
                            'Kekuatan Semua Milik Allah',
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
