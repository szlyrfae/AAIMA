import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart' as sqflite;
import 'Aqidah/aqidah.dart';
import 'widgets/app_drawer.dart';
import 'widgets/app_bottomNavigationBar.dart';
import 'constants/app_colors.dart';
import 'database/database_helper.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize database before app starts
  try {
    final db = await DatabaseHelper().database;
    print('Database initialized successfully');

    // Check content
    await DatabaseHelper().getAllCategories();
  } catch (e) {
    print('Error initializing database: $e');
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Asas-Asas Islam',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: AppColors.colourAaima1),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Asas-Asas Islam Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _selectedIndex = 2;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      drawer: const AppDrawer(),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildHomeCard(
              'Aqidah',
              'assets/images/home/1_akidah.png',
              () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const AqidahPage()),
              ),
            ),
            _buildHomeCard(
              'Syariat (Fiqh)',
              'assets/images/home/2_syariat.png',
              () {},
            ),
            _buildHomeCard(
              'Syariat (Hukum Syarak)',
              'assets/images/home/3_syariat-2.png',
              () {},
            ),
            _buildHomeCard(
              'Adab, Akhlak & Urusan Hati',
              'assets/images/home/4_tasawwuf.png',
              () {},
            ),
            _buildHomeCard(
              'Islam Secara Ringkas',
              'assets/images/home/5_islam-ringkas.png',
              () {},
            ),
            _buildHomeCard(
              'Umum',
              'assets/images/home/6_umum.png',
              () {},
            ),
            _buildHomeCard(
              'Sisipan',
              'assets/images/home/sisipan.jpg',
              () {},
            ),
          ],
        ),
      ),
      bottomNavigationBar: AppBottomNavigationBar(
        currentIndex: _selectedIndex,
      ),
    );
  }

  Widget _buildHomeCard(String title, String imagePath, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.fromLTRB(20, 10, 20, 10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: Theme.of(context).colorScheme.primary.withOpacity(0.3),
            width: 2,
          ),
          boxShadow: [
            BoxShadow(
              color: AppColors.shadowColor,
              spreadRadius: 2,
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          children: [
            Container(
              width: double.infinity,
              height: 200,
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(10),
                  topRight: Radius.circular(10),
                ),
                image: DecorationImage(
                  image: AssetImage(imagePath),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.lightBackground,
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(10),
                  bottomRight: Radius.circular(10),
                ),
              ),
              child: Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: AppColors.secondaryText,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
