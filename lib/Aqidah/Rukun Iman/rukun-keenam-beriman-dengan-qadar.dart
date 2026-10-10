import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../widgets/app_drawer.dart';
import '../../widgets/app_bottomNavigationBar.dart';
import '../../widgets/content_renderer.dart';
import '../../constants/app_colors.dart';
import '../../services/content_service.dart';
import '../../services/pdf_downloader.dart';

class RukunImanKeenamPage extends StatefulWidget {
  const RukunImanKeenamPage({super.key});

  @override
  State<RukunImanKeenamPage> createState() => _RukunImanKeenamPageState();
}

class _RukunImanKeenamPageState extends State<RukunImanKeenamPage> {
  int _selectedIndex = 2;

  List<YoutubePlayerController> _controllers = [];
  List<Map<String, dynamic>> _videos = [];
  List<Map<String, dynamic>> _videoLinks = [];
  bool _isLoading = true;
  final ContentService _contentService = ContentService();

  static const String _pdfAssetPath =
      'assets/files/aqidah/7.-rukun-iman-keenam-beriman-dengan-qadar.pdf';
  static const String _pdfFileName =
      '7.-rukun-iman-keenam-beriman-dengan-qadar.pdf';

  final ScrollController _scrollController = ScrollController();
  final ValueNotifier<bool> _showBackToTop = ValueNotifier(false);

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    _loadData();
  }

  void _onScroll() {
    if (!_scrollController.hasClients) return;
    _showBackToTop.value = _scrollController.offset > 300;
  }

  Future<void> _loadData() async {
    try {
      final videos = await _contentService.getRukunVideos('keenam');
      final links = await _contentService.getVideoLinks('keenam');

      final controllers = videos.map((video) {
        return YoutubePlayerController(
          initialVideoId: video['id']!,
          flags: const YoutubePlayerFlags(
            autoPlay: false,
            mute: false,
            enableCaption: false,
          ),
        );
      }).toList();

      if (!mounted) {
        for (final c in controllers) c.dispose();
        return;
      }

      setState(() {
        _controllers = controllers;
        _videos = videos;
        _videoLinks = links;
        _isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() => _isLoading = false);
      debugPrint('Error loading data: $e');
    }
  }

  void _scrollToTop() {
    _scrollController.animateTo(
      0,
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeOutCubic,
    );
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    _showBackToTop.dispose();
    for (final controller in _controllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Rukun Iman Keenam'),
      ),
      drawer: const AppDrawer(),
      body: InteractiveViewer(
        minScale: 1.0,
        maxScale: 4.0,
        panEnabled: false,
        scaleEnabled: true,
        child: SingleChildScrollView(
          controller: _scrollController,
          physics: const ClampingScrollPhysics(),
          child: _isLoading
              ? const SizedBox(
            height: 400,
            child: Center(child: CircularProgressIndicator()),
          )
              : Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 10),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Text(
                  'RUKUN KEENAM: BERIMAN DENGAN QADAR',
                  style: TextStyle(
                    fontSize: 20,
                    fontFamily: 'Comic Sans MS',
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(
                    left: 20, right: 20, top: 6),
                child: GestureDetector(
                  onTap: () => PdfDownloader.download(
                    context: context,
                    assetPath: _pdfAssetPath,
                    fileName: _pdfFileName,
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.picture_as_pdf,
                          size: 16, color: Colors.blue.shade700),
                      const SizedBox(width: 4),
                      Text(
                        'Muat turun PDF',
                        style: TextStyle(
                          fontSize: 13,
                          fontFamily: 'Roboto',
                          color: Colors.blue.shade700,
                          decoration: TextDecoration.underline,
                          decorationColor: Colors.blue.shade700,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 8),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
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
              const SizedBox(height: 10),
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
                            padding: const EdgeInsets.symmetric(
                                horizontal: 20),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: player,
                            ),
                          );
                        },
                      ),
                      const SizedBox(height: 8),
                      Padding(
                        padding:
                        const EdgeInsets.symmetric(horizontal: 20),
                        child: Text(
                          _videos[index]['title'] ?? '',
                          style: const TextStyle(
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
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Divider(),
              ),
              const SizedBox(height: 10),
              ..._videoLinks.map((link) {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: RichText(
                    text: TextSpan(
                      style: const TextStyle(
                        fontSize: 13,
                        fontFamily: 'Roboto',
                        color: Colors.black,
                        fontStyle: FontStyle.italic,
                      ),
                      children: [
                        TextSpan(text: link['title'] ?? ''),
                        WidgetSpan(
                          child: GestureDetector(
                            onTap: () async {
                              final uri = Uri.parse(link['url']!);
                              if (await canLaunchUrl(uri)) {
                                await launchUrl(uri,
                                    mode:
                                    LaunchMode.externalApplication);
                              }
                            },
                            child: Text(
                              link['urlText'] ?? '',
                              style: const TextStyle(
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
                );
              }).toList(),
              const SizedBox(height: 10),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Divider(),
              ),
              const SizedBox(height: 10),
              const Center(
                child: Text(
                  'BERIMAN DENGAN QADAR',
                  style: TextStyle(
                    fontSize: 15,
                    fontFamily: 'Roboto',
                    color: AppColors.colourAaima3,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Container(
                margin: const EdgeInsets.fromLTRB(20, 10, 20, 10),
                child: ContentRenderer.renderRukunImanKeenam(),
              ),
              const SizedBox(height: 100),
            ],
          ),
        ),
      ),
      bottomNavigationBar: AppBottomNavigationBar(currentIndex: _selectedIndex),
      floatingActionButton: ValueListenableBuilder<bool>(
        valueListenable: _showBackToTop,
        builder: (context, show, child) {
          return AnimatedSlide(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeOut,
            offset: show ? Offset.zero : const Offset(0, 2),
            child: AnimatedOpacity(
              duration: const Duration(milliseconds: 300),
              opacity: show ? 1.0 : 0.0,
              child: IgnorePointer(ignoring: !show, child: child),
            ),
          );
        },
        child: FloatingActionButton(
          mini: true,
          heroTag: 'rukun6_scroll_top',
          backgroundColor: AppColors.colourAaima1,
          onPressed: _scrollToTop,
          tooltip: 'Kembali ke atas',
          child: const Icon(Icons.keyboard_arrow_up),
        ),
      ),
    );
  }
}