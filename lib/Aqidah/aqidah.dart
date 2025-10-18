import 'package:aaima/main.dart';
import 'package:flutter/material.dart';
import '../widgets/app_drawer.dart';
import '../widgets/app_bottomNavigationBar.dart';


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
            const Column(
              children: [
                SizedBox(height: 10),
                Row(
                  children: [
                    SizedBox(width: 20),
                    Text(
                      'Asas-Asas Islam',
                      style: TextStyle(
                        fontSize: 15,
                        fontFamily: 'Roboto',
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 10),
              ],
            ),
            // Content without photo containers
            Container(
              margin: const EdgeInsets.fromLTRB(20, 10, 20, 10),
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: Theme.of(context).colorScheme.primary.withOpacity(0.3),
                  width: 2,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.2),
                    spreadRadius: 2,
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Aqidah',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Aqidah adalah asas kepercayaan dalam Islam yang merangkumi kepercayaan kepada Allah, malaikat, kitab-kitab, rasul-rasul, hari akhirat, dan qadha qadar.',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.black54,
                      height: 1.5,
                    ),
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
}
