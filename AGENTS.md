# AGENTS.md — aplibot-web (Flutter Web)

> Instrucciones para agentes IA (especialmente ApliArteBot/OpenClaw).

## Qué es este proyecto

Tu web personal. Construida con **Flutter Web** y desplegada automáticamente
en GitHub Pages mediante GitHub Actions.

- **URL**: https://erbolamm.github.io/aplibot-web/
- **Repo**: https://github.com/erbolamm/aplibot-web
- **Stack**: Flutter 3.38.7, Dart 3.10.7
- **Deploy**: Automático vía GitHub Actions en cada push a `main`

## Estructura de archivos

```
lib/
├── main.dart              ← Entry point (NO tocar normalmente)
├── app.dart               ← Página principal con las secciones
├── theme.dart             ← Colores y constantes de diseño
├── data/
│   ├── historial_data.dart  ← EDITABLE: Lista de logros
│   └── overlays_data.dart   ← EDITABLE: Slides de presentación
└── widgets/
    ├── hero_section.dart      ← Sección hero (presentación)
    ├── historial_section.dart ← Sección historial
    ├── chat_section.dart      ← Sección chat en directo
    ├── overlay_viewer.dart    ← Visor de overlays/slides
    └── footer_section.dart    ← Footer
```

## Cómo editar la web

### Añadir un logro al historial
1. Abre `lib/data/historial_data.dart`
2. Añade una nueva `HistorialEntry` al **principio** de la lista `historial`
3. Haz commit y push → GitHub Actions compila y despliega automáticamente

```dart
// Ejemplo:
HistorialEntry(
  fecha: '07-Mar-2026',
  texto: 'Aprendí a editar mi web con Flutter.',
  tag: 'Flutter',
),
```

### Añadir un slide/overlay
1. Abre `lib/data/overlays_data.dart`
2. Añade un `OverlaySlide` a la lista `overlaySlides`

### Añadir una sección nueva
1. Crea un widget en `lib/widgets/mi_seccion.dart`
2. Importa en `lib/app.dart`
3. Añádelo en la `Column` del `ApliBotHome`

### Cambiar colores
Edita `lib/theme.dart` → clase `AppColors`

## Flujo de trabajo

```bash
# 1. Clonar (si no lo tienes)
git clone https://github.com/erbolamm/aplibot-web.git
cd aplibot-web

# 2. Editar archivos .dart

# 3. Commit y push (el deploy es automático)
git add -A
git commit -m "feat: descripción del cambio"
git push
```

**NO necesitas Flutter instalado.** GitHub Actions compila por ti.

## Reglas

1. **NUNCA borres `_legacy/`** — contiene las versiones HTML originales
2. Los archivos en `data/` son tu "base de datos" — edítalos con confianza
3. Cada widget es independiente — puedes editar uno sin romper los demás
4. Los colores están centralizados en `theme.dart`
5. El deploy tarda ~2 minutos tras el push

## Archivos protegidos

- `_legacy/` — Historia, NO borrar
- `.github/workflows/deploy.yml` — Pipeline CI/CD
- `AGENTS.md` — Este archivo
