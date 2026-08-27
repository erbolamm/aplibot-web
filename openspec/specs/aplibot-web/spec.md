# spec: aplibot-web

## Purpose
Definir la arquitectura funcional, componentes visuales y despliegue continuo de la web personal de ApliArteBot en Flutter Web.

## Requirements

### Requirement: Bot Showcase & Interactive Sections
La aplicación DEBE presentar las secciones del bot:
- Hero con identidad y enlaces a Telegram / Ecosistema.
- Historial de versiones y notas de actualización.
- Blog integrado y showcase de proyectos de ApliArte.
- Overlays para streaming.
- Rutas interactivas integradas para minijuegos (`/pacman` y `/tablas`).

#### Scenario: Acceso a la web pública
- **GIVEN** un usuario navegando a `https://erbolamm.github.io/aplibot-web/`
- **WHEN** la aplicación carga en el navegador
- **THEN** se renderizan la cabecera interactiva, el contenido de presentación y los accesos directos al ecosistema.

### Requirement: Automated CI/CD Deployment
El repositorio DEBE compilar y publicar automáticamente en GitHub Pages ante cada push a la rama `main`.

#### Scenario: Compilación de release web
- **GIVEN** un push confirmado a la rama `main`
- **WHEN** el workflow de GitHub Actions ejecuta `flutter build web --release --base-href "/aplibot-web/"`
- **THEN** los artefactos resultantes se publican en la rama de despliegue de GitHub Pages.
