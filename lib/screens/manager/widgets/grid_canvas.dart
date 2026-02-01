import 'package:flutter/material.dart';

class GridCanvas extends StatefulWidget {
  const GridCanvas({
    super.key,
    required this.placeholderEnabled,
    required this.placeholderText,
  });

  final bool placeholderEnabled;
  final String placeholderText;

  @override
  State<GridCanvas> createState() => _GridCanvasState();
}

class _GridCanvasState extends State<GridCanvas> {
  // ✅ Better grid: less noise + cleaner alignment
  static const double _minorGrid = 24.0; // was 18
  static const int _majorEvery = 5; // major line every 5 minors => 120px

  static const double _canvasWidth = 1200;
  static const double _canvasHeight = 780;

  final ScrollController _h = ScrollController();
  final ScrollController _v = ScrollController();

  @override
  void dispose() {
    _h.dispose();
    _v.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // ✅ Slightly soft background improves perceived grid quality
    final bg = const Color(0xFFF9FAFB);

    return Container(
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      clipBehavior: Clip.antiAlias,
      child: Scrollbar(
        controller: _v,
        thumbVisibility: true,
        child: SingleChildScrollView(
          controller: _v,
          scrollDirection: Axis.vertical,
          child: Scrollbar(
            controller: _h,
            thumbVisibility: true,
            notificationPredicate: (n) => n.metrics.axis == Axis.horizontal,
            child: SingleChildScrollView(
              controller: _h,
              scrollDirection: Axis.horizontal,
              child: SizedBox(
                width: _canvasWidth,
                height: _canvasHeight,
                child: Stack(
                  children: [
                    Positioned.fill(
                      child: CustomPaint(
                        painter: _GridPainter(
                          minorGrid: _minorGrid,
                          majorEvery: _majorEvery,
                          // ✅ If placeholder is enabled, grid is slightly lighter to reduce noise
                          minorColor: widget.placeholderEnabled
                              ? const Color(0xFFEAEFF5)
                              : const Color(0xFFE5E7EB),
                          majorColor: widget.placeholderEnabled
                              ? const Color(0xFFD7E0EA)
                              : const Color(0xFFD1DAE6),
                        ),
                      ),
                    ),
                    if (widget.placeholderEnabled)
                      Center(
                        child: _Placeholder(text: widget.placeholderText),
                      ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _Placeholder extends StatelessWidget {
  const _Placeholder({required this.text});
  final String text;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Icon(Icons.add, size: 44, color: Color(0xFFB6C0CD)),
        const SizedBox(height: 10),
        Text(
          text,
          textAlign: TextAlign.center,
          style: theme.textTheme.bodyMedium?.copyWith(
            color: const Color(0xFF94A3B8),
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}

class _GridPainter extends CustomPainter {
  _GridPainter({
    required this.minorGrid,
    required this.majorEvery,
    required this.minorColor,
    required this.majorColor,
  });

  final double minorGrid;
  final int majorEvery;
  final Color minorColor;
  final Color majorColor;

  @override
  void paint(Canvas canvas, Size size) {
    final minorPaint = Paint()
      ..color = minorColor
      ..strokeWidth = 1;

    final majorPaint = Paint()
      ..color = majorColor
      ..strokeWidth = 1.6;

    final majorStep = minorGrid * majorEvery;

    // Vertical lines
    for (double x = 0; x <= size.width; x += minorGrid) {
      final isMajor = (x % majorStep).abs() < 0.001;
      canvas.drawLine(
        Offset(x, 0),
        Offset(x, size.height),
        isMajor ? majorPaint : minorPaint,
      );
    }

    // Horizontal lines
    for (double y = 0; y <= size.height; y += minorGrid) {
      final isMajor = (y % majorStep).abs() < 0.001;
      canvas.drawLine(
        Offset(0, y),
        Offset(size.width, y),
        isMajor ? majorPaint : minorPaint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant _GridPainter oldDelegate) {
    return oldDelegate.minorGrid != minorGrid ||
        oldDelegate.majorEvery != majorEvery ||
        oldDelegate.minorColor != minorColor ||
        oldDelegate.majorColor != majorColor;
  }
}
