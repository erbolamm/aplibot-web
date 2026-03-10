import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../theme.dart';

/// Muestra los últimos commits del repo aplibot-web en GitHub.
/// Si la API falla (sin internet, rate limit, error) → invisible. No rompe nada.
class ActivitySection extends StatefulWidget {
  const ActivitySection({super.key});

  @override
  State<ActivitySection> createState() => _ActivitySectionState();
}

class _ActivitySectionState extends State<ActivitySection> {
  late Future<List<_CommitEntry>> _future;

  @override
  void initState() {
    super.initState();
    _future = _fetchCommits();
  }

  Future<List<_CommitEntry>> _fetchCommits() async {
    try {
      final response = await http
          .get(
            Uri.parse(
              'https://api.github.com/repos/erbolamm/aplibot-web/commits?per_page=8',
            ),
            headers: {'User-Agent': 'aplibot-web/2.0'},
          )
          .timeout(const Duration(seconds: 6));

      if (response.statusCode != 200) return [];

      final data = jsonDecode(response.body) as List<dynamic>;
      return data.map((c) {
        final commit = c['commit'] as Map<String, dynamic>;
        final author = commit['author'] as Map<String, dynamic>;
        return _CommitEntry(
          sha: (c['sha'] as String).substring(0, 7),
          message: (commit['message'] as String).split('\n').first,
          date: DateTime.tryParse(author['date'] as String) ?? DateTime.now(),
          authorName: author['name'] as String,
        );
      }).toList();
    } catch (_) {
      return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<_CommitEntry>>(
      future: _future,
      builder: (context, snapshot) {
        final commits = snapshot.data;
        if (commits == null || commits.isEmpty) return const SizedBox.shrink();
        return _buildContent(commits);
      },
    );
  }

  Widget _buildContent(List<_CommitEntry> commits) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
      color: AppColors.backgroundSoft,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 4,
                height: 22,
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(width: 10),
              const Text(
                'Actividad Reciente del Bot',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: AppColors.text,
                ),
              ),
              const SizedBox(width: 12),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: Color(0x1A005FA9),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Color(0x4D005FA9)),
                ),
                child: const Text(
                  'aplibot-web · GitHub',
                  style: TextStyle(
                    fontSize: 11,
                    color: AppColors.primary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          ...commits.map((c) => _CommitCard(entry: c)),
        ],
      ),
    );
  }
}

class _CommitCard extends StatelessWidget {
  final _CommitEntry entry;

  const _CommitCard({super.key, required this.entry});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: const Color(0xFFE5E7EB)),
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 4,
              offset: Offset(0, 1),
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: Color(0x1A005FA9),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(
                Icons.commit_rounded,
                size: 16,
                color: AppColors.primary,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    entry.message,
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: AppColors.text,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 5),
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 6,
                          vertical: 1,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.backgroundSoft,
                          borderRadius: BorderRadius.circular(4),
                          border: Border.all(color: const Color(0xFFE5E7EB)),
                        ),
                        child: Text(
                          entry.sha,
                          style: const TextStyle(
                            fontFamily: 'monospace',
                            fontSize: 11,
                            color: AppColors.textMuted,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        _formatDate(entry.date),
                        style: const TextStyle(
                          fontSize: 11,
                          color: AppColors.textMuted,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Flexible(
                        child: Text(
                          '— ${entry.authorName}',
                          style: const TextStyle(
                            fontSize: 11,
                            color: AppColors.textMuted,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatDate(DateTime d) {
    final now = DateTime.now().toUtc();
    final diff = now.difference(d.toUtc());
    if (diff.inMinutes < 1) return 'ahora mismo';
    if (diff.inMinutes < 60) return 'hace ${diff.inMinutes} min';
    if (diff.inHours < 24) return 'hace ${diff.inHours} h';
    if (diff.inDays == 1) return 'ayer';
    if (diff.inDays < 7) return 'hace ${diff.inDays} días';
    return '${d.day.toString().padLeft(2, '0')}-${d.month.toString().padLeft(2, '0')}-${d.year}';
  }
}

class _CommitEntry {
  final String sha;
  final String message;
  final DateTime date;
  final String authorName;

  const _CommitEntry({
    required this.sha,
    required this.message,
    required this.date,
    required this.authorName,
  });
}
