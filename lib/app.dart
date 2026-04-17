import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'theme.dart';
import 'widgets/hero_section.dart';
import 'widgets/overlay_viewer.dart';
import 'widgets/activity_section.dart';
import 'widgets/footer_section.dart';
import 'widgets/blog_section.dart';
import 'widgets/historial_section.dart';
import 'widgets/projects_section.dart';
import 'widgets/youtube_section.dart';

final GlobalKey historialKey = GlobalKey();

class ApliBotHome extends StatelessWidget {
  const ApliBotHome({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            _NavBar(historialKey: historialKey),
            const HeroSection(),
            const BlogSection(),
            const ProjectsSection(),
            const YoutubeSection(),
            const OverlayViewer(),
            HistorialSection(key: historialKey),
            const ActivitySection(),
            const FooterSection(),
          ],
        ),
      ),
    );
  }
}

class _NavBar extends StatelessWidget {
  final GlobalKey historialKey;
  const _NavBar({required this.historialKey});

  void _scrollTo(GlobalKey key) {
    final ctx = key.currentContext;
    if (ctx != null) {
      Scrollable.ensureVisible(ctx, duration: const Duration(milliseconds: 500), curve: Curves.easeInOut);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.primary,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      height: 52,
      child: Row(
        children: [
          const Text('APLIBOT', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w900, fontSize: 16, letterSpacing: 2)),
          const Spacer(),
          _NavLink(label: 'Historial', onTap: () => _scrollTo(historialKey)),
          _NavLink(label: 'Avances', onTap: () => Navigator.pushNamed(context, '/blog')),
          _NavLink(label: 'GitHub', onTap: () => launchUrl(Uri.parse('https://github.com/erbolamm'))),
        ],
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
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(8), border: Border.all(color: Colors.white24)),
            child: Text(label, style: const TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w600)),
          ),
        ),
      ),
    );
  }
}
