import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';
import '../theme.dart';

class GitHubRepo {
  final String name;
  final String description;
  final String language;
  final int stars;
  final String htmlUrl;
  final String pagesUrl;

  const GitHubRepo({
    required this.name,
    required this.description,
    required this.language,
    required this.stars,
    required this.htmlUrl,
    required this.pagesUrl,
  });
}

// Proyectos destacados con sus webs
const _featuredRepos = [
  ('apliarte-ai', 'Chat de IA 100% local para VS Code'),
  ('ClawMobil', 'Convierte cualquier móvil Android en un servidor IA'),
  ('apli-kids-asis', 'Asistente educativo Cleo para Alba. Flutter + VPS'),
  ('flutter-ai-template', 'Plantilla universal Flutter + IA'),
  ('ApliArteZenDash', 'Panel de control ligero y eficiente'),
  ('apliarte_faq', 'Paquete Flutter para FAQs publicado en pub.dev'),
  ('family-point-panel', 'Panel de puntos para la familia'),
];

class ProjectsSection extends StatefulWidget {
  const ProjectsSection({super.key});

  @override
  State<ProjectsSection> createState() => _ProjectsSectionState();
}

class _ProjectsSectionState extends State<ProjectsSection> {
  List<GitHubRepo> _repos = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadRepos();
  }

  Future<void> _loadRepos() async {
    try {
      final res = await http.get(
        Uri.parse('https://api.github.com/users/erbolamm/repos?per_page=50&type=public'),
        headers: {'Accept': 'application/vnd.github+json'},
      );
      if (res.statusCode == 200) {
        final List data = jsonDecode(res.body);
        final featured = _featuredRepos.map((f) => f.$1).toList();
        final repos = data
            .where((r) => featured.contains(r['name']) && r['has_pages'] == true)
            .map((r) {
              final name = r['name'] as String;
              final desc = _featuredRepos.firstWhere((f) => f.$1 == name).$2;
              return GitHubRepo(
                name: name,
                description: desc,
                language: r['language'] ?? 'N/A',
                stars: r['stargazers_count'] ?? 0,
                htmlUrl: r['html_url'] ?? '',
                pagesUrl: 'https://erbolamm.github.io/$name/',
              );
            })
            .toList();
        setState(() {
          _repos = repos;
          _loading = false;
        });
      }
    } catch (_) {
      setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 56),
      color: const Color(0xFFF8F9FF),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 4,
                height: 28,
                decoration: BoxDecoration(
                  color: AppColors.accent,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(width: 12),
              const Text(
                'Proyectos Open Source',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.w900,
                  color: AppColors.text,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          const Text(
            'Proyectos públicos de erbolamm en GitHub',
            style: TextStyle(color: AppColors.textMuted, fontSize: 14),
          ),
          const SizedBox(height: 40),
          if (_loading)
            const CircularProgressIndicator()
          else
            ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 960),
              child: Wrap(
                spacing: 16,
                runSpacing: 16,
                children: _repos
                    .map((r) => SizedBox(
                          width: 280,
                          child: _RepoCard(repo: r),
                        ))
                    .toList(),
              ),
            ),
        ],
      ),
    );
  }
}

class _RepoCard extends StatelessWidget {
  final GitHubRepo repo;
  const _RepoCard({required this.repo});

  Color _langColor(String lang) {
    switch (lang) {
      case 'Dart': return const Color(0xFF00B4AB);
      case 'JavaScript': return const Color(0xFFF7DF1E);
      case 'TypeScript': return const Color(0xFF3178C6);
      case 'Python': return const Color(0xFF3572A5);
      default: return const Color(0xFF8B949E);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(color: Color(0x0F000000), blurRadius: 16, offset: Offset(0, 4)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.code, size: 18, color: AppColors.primary),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  repo.name,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w800,
                    color: AppColors.primary,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            repo.description,
            style: const TextStyle(
              fontSize: 13,
              color: AppColors.textMuted,
              height: 1.5,
            ),
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              Container(
                width: 10,
                height: 10,
                decoration: BoxDecoration(
                  color: _langColor(repo.language),
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 6),
              Text(
                repo.language,
                style: const TextStyle(fontSize: 12, color: AppColors.textMuted),
              ),
              const Spacer(),
              const Icon(Icons.star_outline, size: 14, color: AppColors.textMuted),
              const SizedBox(width: 2),
              Text(
                '${repo.stars}',
                style: const TextStyle(fontSize: 12, color: AppColors.textMuted),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              Expanded(
                child: MouseRegion(
                  cursor: SystemMouseCursors.click,
                  child: GestureDetector(
                    onTap: () => launchUrl(Uri.parse(repo.htmlUrl)),
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      decoration: BoxDecoration(
                        border: Border.all(color: AppColors.primary.withValues(alpha: 0.3)),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Center(
                        child: Text(
                          'GitHub',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: AppColors.primary,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: MouseRegion(
                  cursor: SystemMouseCursors.click,
                  child: GestureDetector(
                    onTap: () => launchUrl(Uri.parse(repo.pagesUrl)),
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      decoration: BoxDecoration(
                        color: AppColors.primary,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Center(
                        child: Text(
                          'Ver web →',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
