import 'package:flutter/material.dart';
import '../data/overlays_data.dart';

class OverlayViewer extends StatefulWidget {
  const OverlayViewer({super.key});

  @override
  State<OverlayViewer> createState() => _OverlayViewerState();
}

class _OverlayViewerState extends State<OverlayViewer> {
  int _current = 0;

  void _next() {
    setState(() {
      _current = (_current + 1) % overlaySlides.length;
    });
  }

  void _prev() {
    setState(() {
      _current = (_current - 1 + overlaySlides.length) % overlaySlides.length;
    });
  }

  @override
  Widget build(BuildContext context) {
    final slide = overlaySlides[_current];

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 48),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: slide.gradientColors,
        ),
      ),
      child: Column(
        children: [
          // Indicador
          Text(
            '${_current + 1} / ${overlaySlides.length}',
            style: const TextStyle(
              color: Colors.white38,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),

          // Barra de progreso
          ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 300),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: LinearProgressIndicator(
                value: (_current + 1) / overlaySlides.length,
                backgroundColor: Colors.white12,
                valueColor: const AlwaysStoppedAnimation<Color>(Colors.white54),
                minHeight: 3,
              ),
            ),
          ),
          const SizedBox(height: 32),

          // Icono
          Text(slide.icon, style: const TextStyle(fontSize: 56)),
          const SizedBox(height: 16),

          // Label
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.white30),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              slide.label,
              style: const TextStyle(
                color: Colors.white70,
                fontSize: 11,
                fontWeight: FontWeight.w700,
                letterSpacing: 2,
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Título
          Text(
            slide.title,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 32,
              fontWeight: FontWeight.w900,
              height: 1.15,
            ),
          ),
          const SizedBox(height: 12),

          // Descripción
          ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 580),
            child: Text(
              slide.description,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.white70,
                fontSize: 16,
                height: 1.7,
              ),
            ),
          ),
          const SizedBox(height: 20),

          // Details chips
          if (slide.details.isNotEmpty)
            Wrap(
              spacing: 8,
              runSpacing: 8,
              alignment: WrapAlignment.center,
              children: slide.details
                  .map(
                    (d) => Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: Colors.white.withValues(alpha: 0.15),
                        ),
                      ),
                      child: Text(
                        d,
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  )
                  .toList(),
            ),

          const SizedBox(height: 32),

          // Controles
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _NavButton(label: '◀ Anterior', onTap: _prev),
              const SizedBox(width: 12),

              // Dots
              ...List.generate(
                overlaySlides.length,
                (i) => GestureDetector(
                  onTap: () => setState(() => _current = i),
                  child: Container(
                    width: 10,
                    height: 10,
                    margin: const EdgeInsets.symmetric(horizontal: 3),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: i == _current ? Colors.white : Colors.white30,
                    ),
                  ),
                ),
              ),

              const SizedBox(width: 12),
              _NavButton(label: 'Siguiente ▶', onTap: _next),
            ],
          ),
        ],
      ),
    );
  }
}

class _NavButton extends StatelessWidget {
  final String label;
  final VoidCallback onTap;

  const _NavButton({required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.15),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: Colors.white.withValues(alpha: 0.2)),
          ),
          child: Text(
            label,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }
}
