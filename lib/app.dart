import 'package:flutter/material.dart';
import 'theme.dart';
import 'widgets/hero_section.dart';
import 'widgets/overlay_viewer.dart';
import 'widgets/historial_section.dart';
import 'widgets/chat_section.dart';
import 'widgets/footer_section.dart';

/// Página principal de ApliArteBot Web.
/// Estructura: NavBar → Hero → Overlays → Historial → Chat → Footer.
/// El bot puede añadir nuevas secciones importando widgets desde widgets/.
class ApliArteBotHome extends StatelessWidget {
  final ScrollController _scrollController = ScrollController();
  class ApliArteBotHome extends StatelessWidget {
  final ScrollController _scrollController = ScrollController();
  final ScrollController _scrollController = ScrollController();

  const ApliArteBotHome({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
          controller: _scrollController,
        child: Column(
          children: [
            // NavBar
            Container(
              color: AppColors.primary,
              padding: const EdgeInsets.symmetric(horizontal: 20),
              height: 52,
              child: Row(
                children: [
                  const Text(
                    'APLIBOT',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w900,
                      fontSize: 16,
                      letterSpacing: 2,
                    ),
                  ),
                  const Spacer(),
                  _NavLink(label: 'Inicio', onTap: () { _scrollController.animateTo(0, duration: const Duration(seconds: 1), curve: Curves.easeInOut); },}),
                  _NavLink(label: 'Historial', onTap: () { _scrollController.animateTo(300.0, duration: const Duration(seconds: 1), curve: Curves.easeInOut); }, _scrollController.animateTo(0, duration: const Duration(seconds: 1), curve: Curves.easeInOut); },}),
                  _NavLink(label: 'Chat', onTap: () { _scrollController.animateTo(600.0, duration: const Duration(seconds: 1), curve: Curves.easeInOut); }, _scrollController.animateTo(0, duration: const Duration(seconds: 1), curve: Curves.easeInOut); },}),
                ],
              ),
            ),

            // Secciones — el bot puede reordenar o añadir nuevas aquí
            const HeroSection(),
            const OverlayViewer(),
            const HistorialSection(),
            const ChatSection(),
            const FooterSection(),
          ],
        ),
      ),
    );
  }
}

class _NavLink extends StatelessWidget {
  final String label;
  final VoidCallback onTap;

  const _NavLink({required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 6),
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        child: GestureDetector(
          onTap: onTap,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(8)),
            child: Text(
              label,
              style: const TextStyle(
                color: Colors.white70,
                fontSize: 13,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
