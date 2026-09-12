import 'dart:ui_web' as ui_web;

import 'package:flutter/material.dart';
import 'package:web/web.dart' as web;

import '../theme.dart';

/// Página "Oficinas": comparativa de diseño del panel de la oficina virtual
/// de ErBolamm. Muestra la galería estática de `web/oficinas/index.html`
/// dentro de un iframe a pantalla completa.
///
/// La ruta relativa `oficinas/index.html` se resuelve contra la etiqueta
/// `<base href="$FLUTTER_BASE_HREF">` de `web/index.html`, no contra la URL
/// con hash (`#/oficinas`), así que funciona igual en local y en producción
/// bajo `--base-href "/aplibot-web/"`.
class OficinasPage extends StatefulWidget {
  const OficinasPage({super.key});

  @override
  State<OficinasPage> createState() => _OficinasPageState();
}

class _OficinasPageState extends State<OficinasPage> {
  static const _viewType = 'oficinas-iframe';
  static bool _viewFactoryRegistered = false;

  @override
  void initState() {
    super.initState();
    if (!_viewFactoryRegistered) {
      ui_web.platformViewRegistry.registerViewFactory(_viewType, (int viewId) {
        final iframe = web.HTMLIFrameElement()
          ..src = 'oficinas/index.html'
          ..style.border = 'none'
          ..style.width = '100%'
          ..style.height = '100%';
        return iframe;
      });
      _viewFactoryRegistered = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        title: const Text(
          'Oficinas — Comparativa de diseño',
          style: TextStyle(fontWeight: FontWeight.w900, color: Colors.white),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        elevation: 0,
      ),
      body: const HtmlElementView(viewType: _viewType),
    );
  }
}
