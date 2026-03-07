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

## Reglas — OBLIGATORIAS

> ⚠️ LEER ANTES DE ACTUAR. Estas reglas previenen errores graves.

### ❌ PROHIBIDO

1. **NUNCA crees archivos `.md` para guardar logros, notas o datos del usuario.**
   El usuario NO ve los `.md` en la web. Si creas `logros.md` — NO SIRVE.
2. **NUNCA edites archivos que no sean `.dart`** para mostrar contenido en la web.
3. **NUNCA hagas `git push --force`**.
4. **NUNCA borres `_legacy/`** — contiene las versiones HTML originales.

### ✅ OBLIGATORIO

5. Para mostrar contenido en la web → SIEMPRE edita `lib/data/historial_data.dart` o `lib/data/overlays_data.dart`.
6. Después de CADA cambio → `git add -A && git commit -m "..." && git push`.
7. GitHub Actions compila y despliega automáticamente tras el push (~2 min).
8. Si hay conflicto en `git push` → haz `git pull --rebase` luego `git push`.

## Archivos protegidos

- `_legacy/` — Historia, NO borrar
- `.github/workflows/deploy.yml` — Pipeline CI/CD
- `AGENTS.md` — Este archivo
