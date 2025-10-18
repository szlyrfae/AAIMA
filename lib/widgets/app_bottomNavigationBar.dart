import 'package:flutter/material.dart';
import '../main.dart';
import '../Aqidah/aqidah.dart';

class AppBottomNavigationBar extends StatefulWidget {
  final int currentIndex;

  const AppBottomNavigationBar({
    super.key,
    required this.currentIndex,
  });

  @override
  State<AppBottomNavigationBar> createState() => _AppBottomNavigationBarState();
}

class _AppBottomNavigationBarState extends State<AppBottomNavigationBar> {
  late int _selectedIndex;

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.currentIndex;
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    switch (index) {
      case 0: // Terkini
        // Navigate to Terkini screen
        break;
      case 1: // Jaringan Web Darulkautsar
        // Navigate to Web Network screen
        break;
      case 2: // Home
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const MyHomePage(title: 'Asas-Asas Islam Home Page')),
          (route) => false,
        );
        break;
      case 3: // Kategori
        // Navigate to Categories screen
        break;
      case 4: // Arkib
        // Navigate to Archive screen
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed, // Required for more than 3 items
      currentIndex: _selectedIndex,
      onTap: _onItemTapped,
      selectedItemColor: Theme.of(context).colorScheme.primary,
      unselectedItemColor: Colors.grey,
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.newspaper),
          label: 'Terkini',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.language),
          label: 'Jaringan Web\nDarulkautsar',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.category),
          label: 'Kategori',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.archive),
          label: 'Arkib',
        ),
      ],
    );
  }
}