import 'dart:io';
import 'package:flutter/material.dart';
import '../../../widgets/app_drawer.dart';
import '../../../widgets/app_bottomNavigationBar.dart';
import '../../../constants/app_colors.dart';
import 'package:flutter/services.dart' show ByteData, rootBundle;
import 'package:path_provider/path_provider.dart';
import 'package:open_filex/open_filex.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../widgets/content_renderer.dart';

class RukunImanKeduaPage extends StatefulWidget {
  const RukunImanKeduaPage({super.key});

  @override
  State<RukunImanKeduaPage> createState() => _RukunImanKeduaPageState();
}

class _RukunImanKeduaPageState extends State<RukunImanKeduaPage> {
  int _selectedIndex = 2;

  final List<Map<String, String>> _videos = [
    {
      'id': 'gIithWfRpD0',
      'title':
      'VIDEO -[Durasi 8m 27s] – RUKUN IMAN KEDUA- Percaya Kepada Malaikat – Maulana Muhammad Asri Yusoff',
    },
    {
      'id': 'JSFrKLPCFvo',
      'title':
      'VIDEO -[Durasi 1j 23m 38s]- Rukun Iman Kedua BERIMAN DENGAN MALAIKAT – Dr Abdul Basit Abdul Rahman',
    },
  ];

  final List<Map<String, String>> _url = [
    {
      'id': 'gIithWfRpD0',
      'title': 'Tonton video “RUKUN IMAN KEDUA- Percaya Kepada Malaikat – Maulana Muhammad Asri Yusoff” melalui saluran YouTube – ',
      'url': 'https://youtu.be/gIithWfRpD0',
      'urlText': 'https://youtu.be/gIithWfRpD0',
    },
    {
      'id': 'JSFrKLPCFvo',
      'title': 'Tonton video “Rukun Iman Kedua BERIMAN DENGAN MALAIKAT – Dr Abdul Basit Abdul Rahman” melalui saluran YouTube – ',
      'url': 'https://youtu.be/JSFrKLPCFvo',
      'urlText': 'https://youtu.be/JSFrKLPCFvo',
    },
  ];

  late List<YoutubePlayerController> _controllers;

  @override
  void initState() {
    super.initState();

    _controllers = _videos.map((video) {
      return YoutubePlayerController(
        initialVideoId: video['id']!,
        flags: const YoutubePlayerFlags(
          autoPlay: false,
          mute: false,
          enableCaption: false,
        ),
      );
    }).toList();
  }

  @override
  void dispose() {
    for (var controller in _controllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Rukun Iman Kedua'),
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
            SizedBox(height: 10),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                'RUKUN KEDUA: BERIMAN KEPADA MALAIKAT',
                style: TextStyle(fontSize: 20, fontFamily: 'Comic Sans MS'),
              ),
            ),
            SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                'May 24, 2019',
                style: TextStyle(
                  fontSize: 13,
                  fontFamily: 'Roboto',
                  fontStyle: FontStyle.italic,
                  color: AppColors.colourAaima9,
                ),
              ),
            ),
            SizedBox(height: 10),
            ...List.generate(_videos.length, (index) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    YoutubePlayerBuilder(
                      player: YoutubePlayer(
                        controller: _controllers[index],
                        showVideoProgressIndicator: true,
                      ),
                      builder: (context, player) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: player,
                          ),
                        );
                      },
                    ),
                    SizedBox(height: 8),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Text(
                        _videos[index]['title']!,
                        style: TextStyle(
                          fontSize: 15,
                          fontFamily: 'Roboto',
                          color: AppColors.colourAaima3,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Divider(),
            ),
            SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: RichText(
                text: TextSpan(
                  style: TextStyle(
                    fontSize: 13,
                    fontFamily: 'Roboto',
                    color: Colors.black,
                    fontStyle: FontStyle.italic,
                  ),
                  children: [
                    TextSpan(text: _url[0]['title']),
                    WidgetSpan(
                      child: GestureDetector(
                        onTap: () async {
                          final uri = Uri.parse(_url[0]['url']!);
                          if (await canLaunchUrl(uri)) {
                            await launchUrl(uri, mode: LaunchMode.externalApplication);
                          }
                        },
                        child: Text(
                          _url[0]['urlText']!,
                          style: TextStyle(
                            fontSize: 13,
                            fontFamily: 'Roboto',
                            fontStyle: FontStyle.italic,
                            color: Colors.red,
                            decoration: TextDecoration.none,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: RichText(
                text: TextSpan(
                  style: TextStyle(
                    fontSize: 13,
                    fontFamily: 'Roboto',
                    color: Colors.black,
                    fontStyle: FontStyle.italic,
                  ),
                  children: [
                    TextSpan(text: _url[1]['title']),
                    WidgetSpan(
                      child: GestureDetector(
                        onTap: () async {
                          final uri = Uri.parse(_url[1]['url']!);
                          if (await canLaunchUrl(uri)) {
                            await launchUrl(uri, mode: LaunchMode.externalApplication);
                          }
                        },
                        child: Text(
                          _url[1]['urlText']!,
                          style: TextStyle(
                            fontSize: 13,
                            fontFamily: 'Roboto',
                            fontStyle: FontStyle.italic,
                            color: Colors.red,
                            decoration: TextDecoration.none,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Divider(),
            ),
            SizedBox(height: 10),
            Center(
              child: Text(
                'BERIMAN KEPADA MALAIKAT',
                style: TextStyle(
                  fontSize: 15,
                  fontFamily: 'Roboto',
                  color: AppColors.colourAaima3,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SizedBox(height: 10),
            Container(
              margin: const EdgeInsets.fromLTRB(20, 10, 20, 10),
              child: ContentRenderer.renderRukunImanKedua(),
            )
          ],
        ),
      ),
      bottomNavigationBar: AppBottomNavigationBar(currentIndex: _selectedIndex),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          try {
            final ByteData bytes = await rootBundle.load(
              'assets/files/aqidah/3.-rukun-iman-kedua-beriman-dengan-malaikat.pdf',
            );
            Directory? directory;
            if (Platform.isAndroid) {
              directory = await getExternalStorageDirectory();
            } else {
              directory = await getApplicationDocumentsDirectory();
            }
            if (directory == null) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                    content: Text('Unable to access storage directory')),
              );
              return;
            }
            final file = File(
                '${directory.path}/3.-rukun-iman-kedua-beriman-dengan-malaikat.pdf');
            await file.writeAsBytes(bytes.buffer.asUint8List());
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('PDF saved at ${file.path}')),
            );
            await OpenFilex.open(file.path);
          } catch (e) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Error: $e')),
            );
          }
        },
        child: const Icon(Icons.download),
      ),
    );
  }
}
