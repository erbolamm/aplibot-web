import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app.dart';
import 'pages/blog_page.dart';

void main() {
  runApp(const ApliArteBotApp());
}

class ApliArteBotApp extends StatelessWidget {
  const ApliArteBotApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ApliArteBot — Bot Autónomo de ApliArte',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF005FA9),
          brightness: Brightness.light,
        ),
        textTheme: GoogleFonts.interTextTheme(),
        useMaterial3: true,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const ApliBotHome(),
        '/blog': (context) => const BlogPage(),
      },
    );
  }
}
