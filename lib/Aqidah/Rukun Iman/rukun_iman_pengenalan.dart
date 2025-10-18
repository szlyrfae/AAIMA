import 'dart:io';

import 'package:flutter/material.dart';
import '../../widgets/app_drawer.dart';
import '../../widgets/app_bottomNavigationBar.dart';
import '../../widgets/content_renderer.dart';
import '../../widgets/pdf_download_fab.dart';
import '../../constants/app_colors.dart';
import 'package:flutter/services.dart' show ByteData, Uint8List, rootBundle;
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

class RukunImanPengenalanPage extends StatefulWidget {
  const RukunImanPengenalanPage({super.key});

  @override
  State<RukunImanPengenalanPage> createState() => _RukunImanPengenalanPageState();
}

class _RukunImanPengenalanPageState extends State<RukunImanPengenalanPage> {
  int _selectedIndex = 2;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Rukun Iman: Pengenalan'),
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
            SizedBox(height: 10),
            Row(
              children: [
                SizedBox(width: 20),
                Text(
                  'RUKUN IMAN: PENGENALAN',
                  style: TextStyle(
                    fontSize: 20,
                    fontFamily: 'Comic Sans MS',
                  ),
                ),
              ],
            ),
            SizedBox(height: 10),
            Row(
              children: [
                SizedBox(width: 20),
                Text(
                  'May 24, 2019',
                  style: TextStyle(
                    fontSize: 13,
                    fontFamily: 'Roboto',
                    fontStyle: FontStyle.italic,
                    color: AppColors.colourAaima9,
                  ),
                ),
              ],
            ),
            SizedBox(height: 10),
            Text(
              'بسم الله الرحمن الرحيم',
              style: TextStyle(
                fontSize: 15,
                fontFamily: 'Roboto',
                color: AppColors.colourAaima3,
              ),
            ),
            SizedBox(height: 10),
            Row(
              children: [
                SizedBox(width: 20),
                Expanded(
                  child: Text(
                  'Rukun Iman ialah: Beriman kepada Allah, Malaikat-malaikat-Nya, Kitab-kitab-Nya, Rasul-rasul-Nya dan Hari Akhirat serta Qadar (untung) baik mahupun buruk.',
                  style: TextStyle(
                      fontSize: 15,
                      fontFamily: 'Roboto',
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 10),
            Container(
              margin: const EdgeInsets.fromLTRB(20, 10, 20, 10),
              child: ContentRenderer.renderRukunImanPengenalan(),
            )
          ],
        ),
      ),
      bottomNavigationBar: AppBottomNavigationBar(
        currentIndex: _selectedIndex,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          // Ask for storage permission
          var status = await Permission.storage.request();
          if (!status.isGranted) return;

          final ByteData bytes = await rootBundle.load('assets/files/2.-rukun-iman-pertama-beriman-kepada-allah.pdf');
          final Uint8List list = bytes.buffer.asUint8List();

          // Get the Downloads folder
          Directory? directory = Directory('/storage/emulated/0/Download');
          final file = File('${directory.path}/2.-rukun-iman-pertama-beriman-kepada-allah.pdf');

          await file.writeAsBytes(list);
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('PDF downloaded to Downloads folder!')),
          );
        },
        child: const Icon(Icons.download),
      )
    );
  }

}
