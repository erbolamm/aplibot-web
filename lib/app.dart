import 'package:flutter/material.dart';
import 'theme.dart';
import 'widgets/hero_section.dart';
import 'widgets/overlay_viewer.dart';
import 'widgets/activity_section.dart';
import 'widgets/footer_section.dart';
import 'widgets/blog_section.dart';

class ApliBotHome extends StatelessWidget {
  const ApliBotHome({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            _NavBar(),
            const HeroSection(),
            const BlogSection(),
            const OverlayViewer(),
            const ActivitySection(),
            const FooterSection(),
          ],
        ),
      ),
    );
  }
}

class _NavBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
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
          _NavLink(label: 'Blog', onTap: () => Navigator.pushNamed(context, '/blog')),
          _NavLink(label: 'GitHub', onTap: () {}),
          _NavLink(label: 'Telegram', onTap: () {}),
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
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.white24),
            ),
            child: Text(
              label,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 13,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
