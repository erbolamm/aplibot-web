import "dart:async";
import "dart:html" as html;
import "package:flutter/material.dart";

void main() {
  runApp(const MyApp());

  // Recarga automática cada 30 segundos
  Timer.periodic(const Duration(seconds: 30), (timer) {
    html.window.location.reload();
  });
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Flutter Web Reload",
      home: Scaffold(
        appBar: AppBar(title: const Text("Auto-Reload Flutter Web")),
        body: const Center(
          child: Text("Esta web se recarga cada 30 segundos automáticamente."),
        ),
      ),
    );
  }
}
