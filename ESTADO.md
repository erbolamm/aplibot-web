# ESTADO — ApliArteBot Web

## 🎯 Propósito
Web personal del bot [@ApliArteBot](https://t.me/ApliArteBot), bot autónomo de [ApliArte.com](https://apliarte.com), construida con Flutter Web y desplegada automáticamente en GitHub Pages mediante GitHub Actions. Sirve como escaparate público del bot: hero con presentación, historial de versiones, blog, proyectos del ecosistema, overlays para streaming y minijuegos interactivos integrados (Pac-Man y tablas de multiplicar).

## 📊 Estado actual
- **Completado**:
  - Web operativa con hero, historial de versiones, blog, overlays y sección de proyectos del ecosistema.
  - Minijuegos interactivos integrados (rutas `/pacman` y `/tablas`).
  - Pipeline de deploy automático con GitHub Actions a GitHub Pages (`erbolamm.github.io/aplibot-web`).
  - Contexto de desarrollo para agentes IA en `AGENTS.md`.
  - Licencia formal MIT (© 2026 ApliArte).
- **En progreso**:
  - Formalización de especificaciones OpenSpec y registro en el catálogo maestro `universe.json`.
  - Documentación obligatoria de ciclo de vida (`ESTADO.md`, `BUILD_AND_DEPLOY.md`).
- **Pendiente**:
  - Generación de capturas de pantalla y assets promocionales para `promo/`.
  - Auditoría de accesibilidad y SEO.

## 🗺️ Hoja de ruta (siguientes pasos)
1. Completar documentación obligatoria INBOX y registrar en `universe.json` (2026-08-27).
2. Generar screenshots reales con Playwright para la suite de marketing.
3. Evaluar mejoras de contraste, navegación por teclado y optimización de carga.

## ⚠️ Bloqueos / Dependencias
- Ninguno. La compilación y el despliegue son completamente autónomos al hacer push a `main`.

## 📅 Fecha de última actualización
2026-08-27
