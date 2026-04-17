/// Datos del pipeline YouTube → Obsidian.
/// El bot actualiza esta lista automáticamente cada noche tras transcribir.

class YoutubeVideo {
  final String titulo;
  final String youtubeId;
  final String fechaTranscripcion;
  final String extracto;

  const YoutubeVideo({
    required this.titulo,
    required this.youtubeId,
    required this.fechaTranscripcion,
    required this.extracto,
  });

  String get url => 'https://www.youtube.com/watch?v=$youtubeId';
  String get thumbnail => 'https://img.youtube.com/vi/$youtubeId/mqdefault.jpg';
}

const List<YoutubeVideo> videosTranscritos = [
  YoutubeVideo(
    titulo: 'Mi primer stop motions',
    youtubeId: 'xmjiulu6HIw',
    fechaTranscripcion: '16-Abr-2026',
    extracto: 'Primer vídeo procesado por el pipeline automático YouTube → Whisper → Obsidian.',
  ),
];

const int totalPendientes = 391;
