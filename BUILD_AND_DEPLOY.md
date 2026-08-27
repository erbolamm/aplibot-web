# 🚀 Guía de Build & Deploy — ApliArteBot Web

**Versión actual**: 2.0.0+1
**Última actualización**: 2026-08-27
**Mantenedor**: Javier Mateo (ApliArte / ErBolamm)

---

> ⚙️ **Modo agente**: Esta guía está diseñada para ser ejecutada por un agente de IA
> de principio a fin **sin confirmaciones intermedias**, salvo puntos explícitamente marcados.

---

## 1️⃣ Preparación General (Obligatorio)

```bash
# Limpieza y dependencias
flutter clean && flutter pub get

# Verificación de calidad
flutter analyze
```

> ℹ️ Este proyecto no requiere `build_runner` ni generación de código adicional.

---

## 2️⃣ Compilación Local (Flutter Web)

```bash
flutter build web --release --base-href "/aplibot-web/"
```

✅ **Output**: `build/web/`

> ⚠️ El parámetro `--base-href "/aplibot-web/"` es **obligatorio** para que los assets y rutas se resuelvan correctamente en GitHub Pages (`erbolamm.github.io/aplibot-web/`).

---

## 3️⃣ Despliegue Automático (GitHub Pages via GitHub Actions)

El despliegue está 100% automatizado mediante GitHub Actions:

1. Realizar los cambios necesarios y confirmar con git commit.
2. Hacer push a la rama `main`:
   ```bash
   git push origin main
   ```
3. El flujo de trabajo en `.github/workflows/deploy.yml` compilará la versión web y la publicará en GitHub Pages.

**URL en producción:**
https://erbolamm.github.io/aplibot-web/

---

## 📋 Referencia de Versiones

| Campo | Valor |
|-------|-------|
| Flutter SDK | 3.38.7 |
| Dart SDK | ^3.10.7 |
| Versión pubspec | 2.0.0+1 |
| Plataforma | Flutter Web |
| Hosting | GitHub Pages |
| CI/CD | GitHub Actions |
| Repositorio | `erbolamm/aplibot-web` |

---

## 📝 Notas Operativas

- No es obligatorio compilar localmente antes del commit; el pipeline remoto se encarga del build release.
- Para previsualizar en local: `flutter run -d chrome --web-port 8080`.
