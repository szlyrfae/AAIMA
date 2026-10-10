import 'package:flutter/material.dart';
import '../../widgets/app_drawer.dart';
import '../../widgets/app_bottomNavigationBar.dart';
import '../../widgets/content_renderer.dart';
import '../../constants/app_colors.dart';
import '../../services/content_service.dart';
import '../../services/pdf_downloader.dart';

class RukunImanPengenalanPage extends StatefulWidget {
  const RukunImanPengenalanPage({super.key});

  @override
  State<RukunImanPengenalanPage> createState() =>
      _RukunImanPengenalanPageState();
}

class _RukunImanPengenalanPageState extends State<RukunImanPengenalanPage> {
  int _selectedIndex = 2;
  bool _isLoading = true;
  final ContentService _contentService = ContentService();

  static const String _pdfAssetPath =
      'assets/files/aqidah/1.-rukun-iman-pengenalan-1.pdf';
  static const String _pdfFileName = '1.-rukun-iman-pengenalan-1.pdf';

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
    // Pengenalan tak ada video, so cuma simulate load
    await Future.delayed(const Duration(milliseconds: 100));
    if (!mounted) return;
    setState(() => _isLoading = false);
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
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Rukun Iman: Pengenalan'),
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
                  'RUKUN IMAN: PENGENALAN',
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
              const Center(
                child: Text(
                  'بسم الله الرحمن الرحيم',
                  style: TextStyle(
                    fontSize: 18,
                    fontFamily: 'Roboto',
                    color: AppColors.colourAaima3,
                  ),
                ),
              ),
              const SizedBox(height: 10),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Text(
                  'Rukun Iman ialah: Beriman kepada Allah, Malaikat-malaikat-Nya, Kitab-kitab-Nya, Rasul-rasul-Nya dan Hari Akhirat serta Qadar (untung) baik mahupun buruk.',
                  style: TextStyle(
                    fontSize: 15,
                    fontFamily: 'Roboto',
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.justify,
                ),
              ),
              const SizedBox(height: 10),
              Container(
                margin: const EdgeInsets.fromLTRB(20, 10, 20, 10),
                child: ContentRenderer.renderRukunImanPengenalan(),
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
          heroTag: 'rukun_pengenalan_scroll_top',
          backgroundColor: AppColors.colourAaima1,
          onPressed: _scrollToTop,
          tooltip: 'Kembali ke atas',
          child: const Icon(Icons.keyboard_arrow_up),
        ),
      ),
    );
  }
}