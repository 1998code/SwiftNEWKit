<img width="150" alt="SNK" src="https://github.com/user-attachments/assets/1121ae03-cf96-455e-8119-596f6f5eb58e" />

# SwiftNEW

![Stable](https://img.shields.io/github/v/release/1998code/SwiftNEWKit?color=03A791&label=Stable)
![Beta](https://img.shields.io/github/v/release/1998code/SwiftNEWKit?include_prereleases&color=3A59D1&label=Beta)
[![Validate JSON Files](https://github.com/1998code/SwiftNEWKit/actions/workflows/validate-json.yml/badge.svg)](https://github.com/1998code/SwiftNEWKit/actions/workflows/validate-json.yml)
![Swift Version](https://img.shields.io/badge/Swift-5.9/6.1-teal.svg)
![Platforms](https://img.shields.io/badge/Platforms-iOS%2015.0+%20|%20macOS%2014.0+%20|%20tvOS%2017.0+%20|%20visionOS%201.0+-15437D.svg)
![License](https://img.shields.io/badge/License-MIT-C8ECFE.svg)

[English](../README.md) · [繁中](README_tc.md) · [简中](README_zh.md) · [粵語](README_hc.md) · [日本語](README_ja.md) · [한국어](README_ko.md) · [Français](README_fr.md) · **Español**

Un framework de presentación **"Novedades"** moderno y nativo de SwiftUI para todas las plataformas Apple — fondos con degradados animados, efectos de vidrio, carga de datos remotos y soporte completo de RTL y localización listo para usar.

![image](https://github.com/user-attachments/assets/0a5de416-f4cd-41b5-8060-f839f2e7286a)

## 🎨 Galería

| Claro | Oscuro |
|:-----:|:----:|
| ![Light](https://user-images.githubusercontent.com/54872601/173187065-14d78119-47e7-4dcb-a3e6-c7fee4f0c67f.PNG) | ![Dark](https://user-images.githubusercontent.com/54872601/173187067-fe3b5cac-54b5-4482-b73f-42e6c500546f.PNG) |

## 🚀 Inicio rápido

**1. Añade el paquete** en Xcode → *File → Add Package Dependencies…*

> [!IMPORTANT]
> **URL del paquete**
>
> ```
> https://github.com/1998code/SwiftNEWKit
> ```

**2. Añade un `data.json`** al bundle de tu app:

> [!TIP]
> Ejemplo de notas de versión en JSON
>
> ```json
> [
>   {
>     "version": "1.0",
>     "new": [
>       { "icon": "star.fill", "title": "Bienvenido", "subtitle": "Primeros pasos", "body": "¡Gracias por descargar nuestra app!" }
>     ]
>   }
> ]
> ```

**3. Intégralo en tu vista:**

> [!NOTE]
> Integración mínima con SwiftUI
>
> ```swift
> import SwiftNEW
>
> struct ContentView: View {
>     @State private var showNew = false
>     var body: some View {
>         SwiftNEW(show: $showNew)
>     }
> }
> ```

Eso es todo — SwiftNEW se activa automáticamente cuando cambia la versión de la app.

## ✨ Funcionalidades

| Funcionalidad | Desde | Descripción |
|---------|:-----:|-------------|
| 🔁 Bucle de iconos animado | 6.4.0 | Recorre SF Symbols con transiciones de reemplazo nativas |
| 🧾 Esquema de iconos flexible | 6.4.0 | Define iconos con `icon`, `toIcon` o un arreglo `icons` completo |
| 🎯 Insignia de vidrio por defecto | 6.4.0 | Insignias de icono de vidrio redondeadas dan a las filas un aspecto más suave |
| 🌈 Glifos de icono con degradado | 6.4.0 | Los glifos de icono usan un degradado del tema de arriba-izquierda a abajo-derecha |
| 🧩 Diseño de filas refinado | 6.4.0 | Iconos más grandes, filas más compactas y botones de acción más redondeados |
| ⬇️ Controles de Continuar más bajos | 6.4.0 | Los controles de Continuar quedan más cerca del borde inferior para facilitar el alcance |
| 🌊 Movimiento de malla líquida | 6.4.0 | `meshStyle`: fondos de malla animados `.still` o `.liquid` |
| 🏷️ Prefijo de encabezado personalizado | 6.4.0 | Personaliza la línea de título del encabezado con `headingPrefix` |
| 🔍 Búsqueda dentro de la hoja | 6.3.0 | Filtra las notas de la versión actual por título / subtítulo / cuerpo |
| 🛡️ Carga resiliente | 6.3.0 | Maneja los fallos de carga con un estado de reintento integrado en lugar de un spinner infinito |
| 🏷️ Encabezado personalizable | 6.3.0 | `headingStyle`: `.version`, `.versionOnly` o `.appName` |
| 🔢 Número de build opcional | 6.3.0 | Oculta el número de build con `showBuild: false` |
| 🎨 Efecto de partículas flotantes | 6.3.0 | Nuevo efecto especial `.particles` (TimelineView + Canvas) |
| 🎯 Presentaciones flexibles | 6.2.0 | `.sheet`, `.fullScreenCover`, `.embed` |
| 🌈 Color de texto adaptativo | 6.2.0 | El texto de los botones contrasta automáticamente con el fondo |
| 🛠️ Inicializador simplificado | 6.2.0 | Valores directos — sin necesidad de envolver con `.constant()` |
| 🪟 Glassmorfismo | 5.5.0 | Desenfoque moderno con transparencia personalizable |
| 🌈 Degradados de malla y lineales | 5.3.0 | Fondos con degradados animados |
| 🥽 Soporte de visionOS | 4.1.0 | Computación espacial nativa |
| 🔄 Activación automática | 4.0.0 | Se muestra automáticamente cuando cambia la versión o el build |
| 🎄 Efectos especiales | 3.9.0 | Nevada `.christmas`, arcoíris `.particles` |
| 📱 Notificaciones Drop | 3.5.0 | Notificaciones de banner al estilo iOS |
| 🔥 Firebase Realtime DB | 3.0.0 | Actualizaciones de contenido en vivo |
| 🌐 JSON remoto | 3.0.0 | Carga desde cualquier endpoint REST |
| 📚 Historial de versiones | 2.0.0 | Explora todas las versiones anteriores |

### Muestra de funcionalidades

| Degradado de malla (5.3+) | visionOS (4.1+) |
|:--------------------:|:---------------:|
| <img alt="Mesh" src="https://github.com/1998code/SwiftNEWKit/assets/54872601/a845c460-65d7-47a0-ae15-23897efd0508"> | ![visionOS](https://github.com/1998code/SwiftNEWKit/assets/54872601/12a8ab01-76e5-42a1-96b4-848ef5e5f36b) |

| Icono de la app (3.9.6+) | Historial (2.0+) |
|:-----------------:|:--------------:|
| <img height="400" alt="App Icon" src="https://user-images.githubusercontent.com/54872601/206886933-bc4d0d33-e0fc-4013-9456-f19679b10f5b.png"> | <img height="400" alt="History" src="https://user-images.githubusercontent.com/54872601/178129999-ad63b0ce-d65e-4d86-9882-37a5090e92bc.png"> |

## 📚 Más información

| Guía | Contenido |
|-------|--------|
| [Configuration](CONFIGURATION.md) | Todos los parámetros, ejemplos, fuentes de datos (local / remota / Firebase), modelo de datos |
| [Platform Support & Installation](PLATFORM.md) | Versiones de SO compatibles, requisitos, matriz de funcionalidades, configuración de SPM |
| [Contributing](CONTRIBUTING.md) | Estructura del proyecto, entorno de desarrollo, pautas de PR, solución de problemas |

## 📄 Licencia

SwiftNEW se publica bajo la **licencia MIT** — una de las licencias de código abierto más permisivas.

| | Detalles |
|---|---------|
| ✅ **Puedes** | Usarlo en apps comerciales (incluidas apps de pago de la App Store), modificarlo, redistribuirlo e incluirlo en software de código cerrado |
| 📝 **Debes** | Mantener el aviso de copyright y de licencia original en tu proyecto |
| ⚠️ **Sin garantía** | El software se proporciona "tal cual" — el autor no se hace responsable de los problemas derivados de su uso |

Consulta [LICENSE](../LICENSE) para el texto completo.

## 💖 Con el apoyo de

| Patrocinador | Recurso |
|---------|----------|
| <a href="https://m.do.co/c/ce873177d9ab"><img src="https://opensource.nyc3.cdn.digitaloceanspaces.com/attribution/assets/SVG/DO_Logo_horizontal_blue.svg" width="160px" alt="Digital Ocean"></a> | Infraestructura en la nube |
| [![Ask DeepWiki](https://deepwiki.com/badge.svg)](https://deepwiki.com/1998code/SwiftNEWKit) | Preguntas y respuestas sobre la documentación con IA |
