import 'package:flutter/material.dart';
import '../theme.dart';

class TablasPage extends StatefulWidget {
  const TablasPage({super.key});

  @override
  State<TablasPage> createState() => _TablasPageState();
}

class _TablasPageState extends State<TablasPage> {
  int selectedTable = 0;
  int correctCount = 0;
  int points = 0;
  int totalQuestions = 0;
  int currentMultiplier = 0;
  int correctAnswer = 0;
  List<int> options = [];
  String feedback = '';
  bool isCorrect = false;

  final List<String> emojis = ['🐻', '🐉', '🦊', '🐼', '🐸', '🐨'];
  String get mascot => emojis[(selectedTable - 1) % emojis.length];

  void startGame(int table) {
    setState(() {
      selectedTable = table;
      correctCount = 0;
      points = 0;
      totalQuestions = 0;
      feedback = '';
    });
    newQuestion();
  }

  void newQuestion() {
    currentMultiplier = DateTime.now().millisecondsSinceEpoch % 12 + 1;
    correctAnswer = selectedTable * currentMultiplier;

    final opts = <int>{correctAnswer};
    int s = DateTime.now().microsecondsSinceEpoch;
    while (opts.length < 4) {
      s = (s * 1103515245 + 12345) % 2147483648;
      int offset = (s % 24) - 12;
      int wrong = correctAnswer + (offset == 0 ? 1 : offset);
      if (wrong > 0 && wrong != correctAnswer) opts.add(wrong);
    }
    options = opts.toList()..shuffle();
    setState(() => totalQuestions++);
  }

  void checkAnswer(int selected) {
    final correct = selected == correctAnswer;
    setState(() {
      if (correct) {
        points += 20;
        correctCount++;
        isCorrect = true;
        feedback = '¡Correcto! $mascot';
      } else {
        isCorrect = false;
        feedback = 'Casi... era $correctAnswer';
      }
    });

    Future.delayed(const Duration(milliseconds: 1200), () {
      if (correctCount >= 10) {
        showDialog(
          context: context,
          builder: (_) => AlertDialog(
            backgroundColor: AppColors.background,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            title: const Text('¡Felicidades! 🎉',
              style: TextStyle(fontWeight: FontWeight.w900, color: AppColors.primary),
              textAlign: TextAlign.center),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(mascot, style: const TextStyle(fontSize: 48)),
                const SizedBox(height: 12),
                Text('Completaste la tabla del $selectedTable',
                  style: const TextStyle(fontSize: 18, color: AppColors.text),
                  textAlign: TextAlign.center),
                const SizedBox(height: 8),
                Text('Puntos: $points',
                  style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: AppColors.accent)),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  setState(() {
                    selectedTable = 0;
                    correctCount = 0;
                    points = 0;
                    totalQuestions = 0;
                    feedback = '';
                  });
                },
                child: const Text('Menú', style: TextStyle(fontSize: 18, color: AppColors.primary)),
              ),
            ],
          ),
        );
      } else {
        newQuestion();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        title: const Text('Tablas de Multiplicar',
          style: TextStyle(fontWeight: FontWeight.w900, color: Colors.white)),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        elevation: 0,
      ),
      body: selectedTable == 0 ? _buildMenu() : _buildGame(),
    );
  }

  Widget _buildMenu() {
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            const Text('🧮', style: TextStyle(fontSize: 64)),
            const SizedBox(height: 8),
            const Text('¿Qué tabla quieres practicar?',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.w900, color: AppColors.primary)),
            const SizedBox(height: 24),
            ...List.generate(4, (row) => Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Row(
                children: List.generate(3, (col) {
                  final table = row * 3 + col + 1;
                  return Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 6),
                      child: _TableBtn(number: table, onTap: () => startGame(table)),
                    ),
                  );
                }),
              ),
            )),
          ],
        ),
      ),
    );
  }

  Widget _buildGame() {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.06), blurRadius: 12)],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _Score(label: 'Puntos', value: '$points', color: AppColors.warning),
                  _Score(label: 'Tabla', value: '$selectedTable', color: AppColors.primary),
                  _Score(label: 'Aciertos', value: '$correctCount/10', color: AppColors.success),
                ],
              ),
            ),
            const SizedBox(height: 24),
            Expanded(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(mascot, style: const TextStyle(fontSize: 56)),
                    const SizedBox(height: 12),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(vertical: 28, horizontal: 24),
                      decoration: BoxDecoration(
                        color: AppColors.backgroundSoft,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        '$selectedTable × $currentMultiplier = ?',
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 36,
                          fontWeight: FontWeight.w900,
                          color: AppColors.primary,
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    ...List.generate(2, (row) => Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: Row(
                        children: List.generate(2, (col) {
                          final idx = row * 2 + col;
                          if (idx >= options.length) return const Expanded(child: SizedBox());
                          return Expanded(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 6),
                              child: _OptBtn(number: options[idx], onTap: () => checkAnswer(options[idx])),
                            ),
                          );
                        }),
                      ),
                    )),
                    if (feedback.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.only(top: 16),
                        child: Container(
                          padding: const EdgeInsets.all(14),
                          decoration: BoxDecoration(
                            color: isCorrect ? Colors.green.shade50 : AppColors.backgroundSoft,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(color: isCorrect ? AppColors.success : AppColors.accent, width: 2),
                          ),
                          child: Text(feedback,
                            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold,
                              color: isCorrect ? AppColors.success : AppColors.accentDark)),
                        ),
                      ),
                  ],
                ),
              ),
            ),
            Text('Pregunta $totalQuestions',
              style: const TextStyle(color: AppColors.textMuted, fontSize: 13)),
          ],
        ),
      ),
    );
  }
}

class _TableBtn extends StatelessWidget {
  final int number;
  final VoidCallback onTap;
  const _TableBtn({required this.number, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 24),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.primary.withValues(alpha: 0.2)),
          boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.06), blurRadius: 8)],
        ),
        child: Column(
          children: [
            Text('$number',
              style: const TextStyle(fontSize: 36, fontWeight: FontWeight.w900, color: AppColors.primary)),
            const SizedBox(height: 4),
            const Text('Tabla', style: TextStyle(fontSize: 13, color: AppColors.textMuted)),
          ],
        ),
      ),
    );
  }
}

class _OptBtn extends StatelessWidget {
  final int number;
  final VoidCallback onTap;
  const _OptBtn({required this.number, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 28),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.accent.withValues(alpha: 0.3), width: 2),
          boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.06), blurRadius: 8)],
        ),
        child: Center(
          child: Text('$number',
            style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: AppColors.primary)),
        ),
      ),
    );
  }
}

class _Score extends StatelessWidget {
  final String label;
  final String value;
  final Color color;
  const _Score({required this.label, required this.value, required this.color});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(label, style: const TextStyle(fontSize: 12, color: AppColors.textMuted)),
        const SizedBox(height: 4),
        Text(value, style: TextStyle(fontSize: 22, fontWeight: FontWeight.w900, color: color)),
      ],
    );
  }
}
