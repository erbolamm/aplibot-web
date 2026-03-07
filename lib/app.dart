import 'package:flutter/material.dart';
import 'theme.dart';
import 'widgets/hero_section.dart';
import 'widgets/overlay_viewer.dart';
import 'widgets/historial_section.dart';
import 'widgets/chat_section.dart';
import 'widgets/footer_section.dart';

/// Página principal de ApliBot Web.
/// Estructura: NavBar → Hero → Overlays → Historial → Chat → Footer.
/// El bot puede añadir nuevas secciones importando widgets desde widgets/.
class ApliBotHome extends StatelessWidget {
  const ApliBotHome({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
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
                  _NavLink(label: 'Inicio', onTap: () {}),
                  _NavLink(label: 'Historial', onTap: () {}),
                  _NavLink(label: 'Chat', onTap: () {}),
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
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
            ),
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
