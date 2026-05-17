import 'dart:io';
import 'package:flutter/material.dart';
import '../../widgets/app_drawer.dart';
import '../../widgets/app_bottomNavigationBar.dart';
import '../../widgets/content_renderer.dart';
import '../../constants/app_colors.dart';
import 'package:flutter/services.dart' show ByteData, rootBundle;
import 'package:path_provider/path_provider.dart';
import 'package:open_filex/open_filex.dart';

class RukunImanPengenalanPage extends StatefulWidget {
  const RukunImanPengenalanPage({super.key});

  @override
  State<RukunImanPengenalanPage> createState() =>
      _RukunImanPengenalanPageState();
}

class _RukunImanPengenalanPageState extends State<RukunImanPengenalanPage> {
  int _selectedIndex = 2;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          title: const Text('Rukun Iman'),
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
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                          'Rukun Iman ialah: Beriman kepada Allah, Malaikat-malaikat-Nya, Kitab-kitab-Nya, Rasul-rasul-Nya dan Hari Akhirat serta Qadar (untung) baik mahupun buruk.',
                          style: TextStyle(
                            fontSize: 15,
                            fontFamily: 'Roboto',
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.justify),
                    ),
                  ],
                ),
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
            try {
              // Request storage permission (only needed for Android 9 and below)
              // if (Platform.isAndroid && !await Permission.storage.isGranted) {
              //   final status = await Permission.storage.request();
              //   if (!status.isGranted) {
              //     ScaffoldMessenger.of(context).showSnackBar(
              //       const SnackBar(content: Text('Storage permission denied')),
              //     );
              //     return;
              //   }
              // }

              // Load PDF from assets
              final ByteData bytes = await rootBundle.load(
                'assets/files/aqidah/1.-rukun-iman-pengenalan-1.pdf',
              );

              // Use app-specific external directory (safe for Android 10+)
              Directory? directory;
              if (Platform.isAndroid) {
                directory = await getExternalStorageDirectory();
              } else {
                directory = await getApplicationDocumentsDirectory();
              }

              if (directory == null) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Unable to access storage directory')),
                );
                return;
              }

              // Save the file
              final file = File('${directory.path}/1.-rukun-iman-pengenalan-1.pdf');
              await file.writeAsBytes(bytes.buffer.asUint8List());

              // Show success message
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('PDF saved successfully at ${file.path}')),
              );

              // Open the file
              await OpenFilex.open(file.path);
            } catch (e) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Error: $e')),
              );
            }
          },
          child: const Icon(Icons.download),
        )
    );
  }
}
