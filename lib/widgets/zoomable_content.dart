// lib/widgets/zoomable_content.dart
import 'package:flutter/material.dart';
import '../constants/app_colors.dart';

class ZoomableContent extends StatefulWidget {
  final Widget child;
  final double initialFontSize;
  final double minFontSize;
  final double maxFontSize;

  const ZoomableContent({
    super.key,
    required this.child,
    this.initialFontSize = 13.0,
    this.minFontSize = 12.0,
    this.maxFontSize = 28.0,
  });

  @override
  State<ZoomableContent> createState() => _ZoomableContentState();
}

class _ZoomableContentState extends State<ZoomableContent> {
  late double _fontSize;
  final TransformationController _transformController =
      TransformationController();

  @override
  void initState() {
    super.initState();
    _fontSize = widget.initialFontSize;
  }

  @override
  void dispose() {
    _transformController.dispose();
    super.dispose();
  }

  void _zoomIn() {
    if (_fontSize < widget.maxFontSize) {
      setState(() => _fontSize += 1.0);
    }
  }

  void _zoomOut() {
    if (_fontSize > widget.minFontSize) {
      setState(() => _fontSize -= 1.0);
    }
  }

  void _resetZoom() {
    setState(() => _fontSize = widget.initialFontSize);
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Pinch-to-zoom + scrollable content
        InteractiveViewer(
          transformationController: _transformController,
          minScale: 0.5,
          maxScale: 3.0,
          panEnabled: false, // Let SingleChildScrollView handle panning
          scaleEnabled: true,
          child: MediaQuery(
            // Override text scale for children
            data: MediaQuery.of(context).copyWith(
              textScaler: TextScaler.linear(_fontSize / widget.initialFontSize),
            ),
            child: widget.child,
          ),
        ),
        // Zoom controls (floating)
        Positioned(
          right: 12,
          bottom: 80,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildZoomButton(
                icon: Icons.add,
                onTap: _zoomIn,
                tooltip: 'Zoom In',
              ),
              const SizedBox(height: 8),
              _buildZoomButton(
                icon: Icons.remove,
                onTap: _zoomOut,
                tooltip: 'Zoom Out',
              ),
              const SizedBox(height: 8),
              _buildZoomButton(
                icon: Icons.refresh,
                onTap: _resetZoom,
                tooltip: 'Reset',
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildZoomButton({
    required IconData icon,
    required VoidCallback onTap,
    required String tooltip,
  }) {
    return Tooltip(
      message: tooltip,
      child: Material(
        color: AppColors.colourAaima1,
        shape: const CircleBorder(),
        elevation: 3,
        child: InkWell(
          onTap: onTap,
          customBorder: const CircleBorder(),
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Icon(icon, color: Colors.white, size: 22),
          ),
        ),
      ),
    );
  }
}
