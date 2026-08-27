# Change: aplibot-web-init-docs

## Why
El proyecto `aplibot-web` ya se encuentra operativo y desplegado en GitHub Pages, pero carecía de la suite obligatoria de gobernanza y trazabilidad del ecosistema ErBolamm (LICENSE, ESTADO.md, BUILD_AND_DEPLOY.md, especificaciones OpenSpec y registro en universe.json).

## What Changes
- Añadir licencia formal MIT (© 2026 ApliArte).
- Crear `ESTADO.md` con hoja de ruta y estado actual del proyecto según el protocolo INBOX paso 3.9.
- Crear `BUILD_AND_DEPLOY.md` documentando el pipeline Flutter Web → GitHub Pages (paso 3.10).
- Actualizar el cierre de `README.md` con el Bloque de Cierre Oficial (Paso 3.5, 6 idiomas).
- Inicializar `openspec/` con `config.yaml`, especificación base y registro de este cambio.
- Registrar el proyecto en `universe.json`.

## Rollback Plan
Si se requiere revertir, todos los archivos añadidos son de documentación y especificación; el código fuente funcional (`lib/`, `web/`) permanece intacto.
