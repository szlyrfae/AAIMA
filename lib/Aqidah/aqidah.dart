import 'Rukun Iman/rukun_iman_pengenalan.dart';
import 'package:aaima/main.dart';
import 'package:flutter/material.dart';
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
                      'AQIDAH',
                      style: TextStyle(
                        fontSize: 20,
                        fontFamily: 'Comic Sans MS',
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                const Row(
                  children: [
                    SizedBox(width: 20),
                    Text(
                      'Rukun Iman',
                      style: TextStyle(
                        fontSize: 15,
                        fontFamily: 'Roboto',
                        fontWeight: FontWeight.bold,
                        color: AppColors.colourAaima2,
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
                              'Rukun Iman: Pengenalan',
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
                              'Rukun Pertama: Beriman Kepada Allah',
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
                              '– Perincian Hakikat Beriman Kepada Allah',
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
                              '– Memahami Asma’ul Husna',
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
                              'Rukun Kedua: Beriman Dengan Malaikat',
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
                              'Rukun Ketiga: Beriman Dengan Kitab',
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
                              'Rukun Keempat: Beriman Dengan Rasul',
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
                              'Rukun Kelima: Beriman Dengan Hari Akhirat',
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
                              'Rukun Keenam: Beriman Dengan Qadar',
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
                              'Nota-nota Ringkas Tentang Rukun Iman',
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
