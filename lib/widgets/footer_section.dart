import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../theme.dart';

class FooterSection extends StatelessWidget {
  const FooterSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
      color: AppColors.primaryDark,
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'ApliArteBot — Creado por ',
                style: TextStyle(color: Colors.white70, fontSize: 13),
              ),
              MouseRegion(
                cursor: SystemMouseCursors.click,
                child: GestureDetector(
                  onTap: () => launchUrl(Uri.parse('https://apliarte.com')),
                  child: const Text(
                    'ApliArte.com',
                    style: TextStyle(
                      color: AppColors.lightBlue,
                      fontSize: 13,
                      decoration: TextDecoration.underline,
                      decorationColor: AppColors.lightBlue,
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          const Text(
            'Corriendo en un YesTeL Note 30 Pro | Flutter Web v2.0',
            style: TextStyle(color: Colors.white38, fontSize: 11),
          ),
        ],
      ),
    );
  }
}
