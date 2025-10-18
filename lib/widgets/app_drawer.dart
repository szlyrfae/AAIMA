import 'package:aaima/main.dart';
import 'package:flutter/material.dart';
import '../constants/app_colors.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary,
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Theme.of(context).colorScheme.primary,
                  Theme.of(context).colorScheme.primary.withOpacity(0.8),
                ],
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CircleAvatar(
                  radius: 30,
                  backgroundColor: AppColors.textOnDark,
                  child: Icon(
                    Icons.mosque,
                    size: 35,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
                const SizedBox(height: 10),
                const Text(
                  'Asas-Asas Islam',
                  style: TextStyle(
                    color: AppColors.textOnDark,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Text(
                  'Islamic Learning App',
                  style: TextStyle(
                    color: AppColors.secondaryTextOnDark,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
          ListTile(
            leading: const Icon(Icons.home),
            title: const Text('Home'),
            selected: true,
            onTap: () {
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => const MyHomePage(title: 'Asas-Asas Islam Home Page')),
                    (route) => false,
              );
            },
          ),
          const Divider(),
          ExpansionTile(
            leading: const Icon(Icons.people_alt),
            title: const Text('Aqidah'),
            children: [
              ListTile(
                title: const Text('Rukun Iman'),
                onTap: () {
                  Navigator.pop(context);
                },
              ),
              ListTile(
                title: const Text('Asas-Asas Aqidah Islam (Fiqh Akbar'),
                onTap: () {
                  Navigator.pop(context);
                },
              ),
              ListTile(
                title: const Text('Pembatal Aqidah'),
                onTap: () {
                  Navigator.pop(context);
                  // Navigate to Sifat Allah
                },
              ),
              ListTile(
                title: const Text('Aqidah dan Tauhid (Berdasarkan Hadis)'),
                onTap: () {
                  Navigator.pop(context);
                  // Navigate to Sifat Allah
                },
              ),
              ListTile(
                title: const Text('Kenabian (Berdasarkan Hadis)'),
                onTap: () {
                  Navigator.pop(context);
                  // Navigate to Sifat Allah
                },
              ),
              ListTile(
                title: const Text('Hari Kiamat (Berdasarkan Hadis)'),
                onTap: () {
                  Navigator.pop(context);
                  // Navigate to Sifat Allah
                },
              ),
              ListTile(
                title: const Text('Qadha & Qadar (Berdasarkan Hadis)'),
                onTap: () {
                  Navigator.pop(context);
                  // Navigate to Sifat Allah
                },
              ),
              ListTile(
                title: const Text('Dosa-dosa Besar'),
                onTap: () {
                  Navigator.pop(context);
                  // Navigate to Sifat Allah
                },
              ),
              ListTile(
                title: const Text('Perkara-Perkara Baik'),
                onTap: () {
                  Navigator.pop(context);
                  // Navigate to Sifat Allah
                },
              ),
              ListTile(
                title: const Text('Kelompok Sesat'),
                onTap: () {
                  Navigator.pop(context);
                  // Navigate to Sifat Allah
                },
              ),
              ListTile(
                title:
                    const Text('Peringatan-Peringatan Untuk Menjaga Aqidah'),
                onTap: () {
                  Navigator.pop(context);
                  // Navigate to Sifat Allah
                },
              ),
            ],
          ),
          ExpansionTile(
            leading: const Icon(Icons.account_balance_outlined),
            title: const Text('Syariat (Fiqh)'),
            children: [
              ListTile(
                title: const Text('Rukun Islam'),
                onTap: () {
                  Navigator.pop(context);
                  // Navigate to Rukun Islam
                },
              ),
              ListTile(
                title: const Text('Bersuci (Thaharah) Berdasarkan Hadis'),
                onTap: () {
                  Navigator.pop(context);
                  // Navigate to Solat
                },
              ),
              ListTile(
                title: const Text('Ibadat Solat Berdasarkan Hadis'),
                onTap: () {
                  Navigator.pop(context);
                  // Navigate to Puasa
                },
              ),
              ListTile(
                title: const Text('Ibadat Puasa Berdasarkan Hadis'),
                onTap: () {
                  Navigator.pop(context);
                  // Navigate to Zakat
                },
              ),
              ListTile(
                title: const Text('Ibadat Zakat Berdasarkan Hadis'),
                onTap: () {
                  Navigator.pop(context);
                  // Navigate to Haji
                },
              ),
              ListTile(
                title: const Text('Ibadat Haji Berdasarkan Hadis'),
                onTap: () {
                  Navigator.pop(context);
                  // Navigate to Haji
                },
              ),
              ListTile(
                title: const Text('Hadis-Hadis Berkenaan Nikah dan Thalaq'),
                onTap: () {
                  Navigator.pop(context);
                  // Navigate to Haji
                },
              ),
              ListTile(
                title: const Text('Meningkatkan Kualiti Ibadat'),
                onTap: () {
                  Navigator.pop(context);
                  // Navigate to Haji
                },
              ),
            ],
          ),
          ExpansionTile(
            leading: const Icon(Icons.record_voice_over),
            title: const Text('Syariat (Hukum Syarak)'),
            children: [
              ListTile(
                title: const Text('Sunnah & Bidaah'),
                onTap: () {
                  Navigator.pop(context);
                  // Navigate to Halal & Haram
                },
              ),
              ListTile(
                title: const Text('Masyarakat & Sosial'),
                onTap: () {
                  Navigator.pop(context);
                  // Navigate to Muamalat
                },
              ),
              ListTile(
                title: const Text('Kewangan & Ekonomi'),
                onTap: () {
                  Navigator.pop(context);
                  // Navigate to Nikah
                },
              ),
              ListTile(
                title: const Text('Makanan & Minuman'),
                onTap: () {
                  Navigator.pop(context);
                  // Navigate to Nikah
                },
              ),
            ],
          ),
          ExpansionTile(
            leading: const Icon(Icons.accessibility),
            title: const Text('Adab, Akhlak & Urusan Hati'),
            children: [
              ListTile(
                title: const Text('Amalan Membatalkan Pahala'),
                onTap: () {
                  Navigator.pop(context);
                  // Navigate to Halal & Haram
                },
              ),
              ListTile(
                title: const Text('Amalan Hati yang Dituntut (Mahmudah)'),
                onTap: () {
                  Navigator.pop(context);
                  // Navigate to Muamalat
                },
              ),
              ListTile(
                title: const Text('Sifat-Sifat Tercela (Mazmumah)'),
                onTap: () {
                  Navigator.pop(context);
                  // Navigate to Nikah
                },
              ),
              ListTile(
                title: const Text('Melembutkan Hati'),
                onTap: () {
                  Navigator.pop(context);
                  // Navigate to Nikah
                },
              ),
            ],
          ),
          ExpansionTile(
            leading: const Icon(Icons.directions_walk),
            title: const Text('Memahami Islam Secara Ringkas'),
            children: [
              ListTile(
                title: const Text(
                    'Panduan Ringkas Untuk Memahami Islam - Ebook'),
                onTap: () {
                  Navigator.pop(context);
                  // Navigate to Sejarah Islam
                },
              ),
              ListTile(
                title: const Text(
                    'Panduan Ringkas Untuk Memahami Islam - Ebook (B. Inggeris)'),
                onTap: () {
                  Navigator.pop(context);
                  // Navigate to Keutamaan Islam
                },
              ),
            ],
          ),
          ExpansionTile(
            leading: const Icon(Icons.assignment),
            title: const Text('Umum'),
            children: [
              ListTile(
                title: const Text(
                    'Doa, Zikir dan Amalan Ringkas yang Sahih & Besar Ganjarannya'),
                onTap: () {
                  Navigator.pop(context);
                  // Navigate to Doa Harian
                },
              ),
              ListTile(
                title: const Text(
                    'Segala Amalan Adalah Berdasarkan Kepada Niat'),
                onTap: () {
                  Navigator.pop(context);
                  // Navigate to Zikir
                },
              ),
              ListTile(
                title: const Text('Pengertian Islam, Iman dan Ihsan'),
                onTap: () {
                  Navigator.pop(context);
                  // Navigate to Doa Harian
                },
              ),
              ListTile(
                title: const Text('Panduan'),
                onTap: () {
                  Navigator.pop(context);
                  // Navigate to Zikir
                },
              ),
              ListTile(
                title: const Text('Menilai Keutamaan Dalam Hidup'),
                onTap: () {
                  Navigator.pop(context);
                  // Navigate to Kalendar Islam
                },
              ),
              ListTile(
                title: const Text('Perbandingan Agama'),
                onTap: () {
                  Navigator.pop(context);
                  // Navigate to Kalendar Islam
                },
              ),
            ],
          ),
          const ListTile(
            leading: Icon(Icons.settings),
            title: Text('Sisipan'),
          ),
        ],
      ),
    );
  }
}
