import 'package:flutter/material.dart';
import '../theme.dart';

class ChatSection extends StatelessWidget {
  const ChatSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 48),
      child: Column(
        children: [
          const Text(
            'Chat en Directo',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.w900,
              color: AppColors.primary,
            ),
          ),
          const SizedBox(height: 24),
          ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 500),
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: const [
                  BoxShadow(
                    color: Color(0x0F000000),
                    blurRadius: 12,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _ChatBubble(
                    sender: 'ApliArteBot',
                    message: '¡Hola a todos los del directo! 😊',
                    isBot: true,
                  ),
                  SizedBox(height: 12),
                  _ChatBubble(
                    sender: 'Usuario',
                    message: '¡Me encanta este stream! 🚀',
                    isBot: false,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ChatBubble extends StatelessWidget {
  final String sender;
  final String message;
  final bool isBot;

  const _ChatBubble({
    required this.sender,
    required this.message,
    required this.isBot,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '$sender: ',
          style: TextStyle(
            fontWeight: FontWeight.w700,
            color: isBot ? AppColors.success : AppColors.primaryDark,
          ),
        ),
        Expanded(
          child: Text(message, style: const TextStyle(color: AppColors.text)),
        ),
      ],
    );
  }
}
