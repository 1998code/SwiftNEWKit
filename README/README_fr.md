<img width="150" alt="SNK" src="https://github.com/user-attachments/assets/1121ae03-cf96-455e-8119-596f6f5eb58e" />

# SwiftNEW

![Stable](https://img.shields.io/github/v/release/1998code/SwiftNEWKit?color=03A791&label=Stable)
![Beta](https://img.shields.io/github/v/release/1998code/SwiftNEWKit?include_prereleases&color=3A59D1&label=Beta)
[![Validate JSON Files](https://github.com/1998code/SwiftNEWKit/actions/workflows/validate-json.yml/badge.svg)](https://github.com/1998code/SwiftNEWKit/actions/workflows/validate-json.yml)
![Swift Version](https://img.shields.io/badge/Swift-5.9/6.1-teal.svg)
![Platforms](https://img.shields.io/badge/Platforms-iOS%2015.0+%20|%20macOS%2014.0+%20|%20tvOS%2017.0+%20|%20visionOS%201.0+-15437D.svg)
![License](https://img.shields.io/badge/License-MIT-C8ECFE.svg)

[English](../README.md) · [繁中](README_tc.md) · [简中](README_zh.md) · [粵語](README_hc.md) · [日本語](README_ja.md) · [한국어](README_ko.md) · **Français** · [Español](README_es.md)

Un framework de présentation **« Quoi de neuf »** moderne et natif SwiftUI pour toutes les plateformes Apple — arrière-plans en dégradé animé, effets de verre, chargement de données à distance et prise en charge complète du RTL et de la localisation, prêts à l'emploi.

![image](https://github.com/user-attachments/assets/0a5de416-f4cd-41b5-8060-f839f2e7286a)

## 🎨 Galerie

| Clair | Sombre |
|:-----:|:----:|
| ![Light](https://user-images.githubusercontent.com/54872601/173187065-14d78119-47e7-4dcb-a3e6-c7fee4f0c67f.PNG) | ![Dark](https://user-images.githubusercontent.com/54872601/173187067-fe3b5cac-54b5-4482-b73f-42e6c500546f.PNG) |

## 🚀 Démarrage rapide

**1. Ajoutez le package** dans Xcode → *File → Add Package Dependencies…*

> [!IMPORTANT]
> **URL du package**
>
> ```
> https://github.com/1998code/SwiftNEWKit
> ```

**2. Ajoutez un `data.json`** au bundle de votre app :

> [!TIP]
> Exemple de notes de version en JSON
>
> ```json
> [
>   {
>     "version": "1.0",
>     "new": [
>       { "icon": "star.fill", "title": "Bienvenue", "subtitle": "Premiers pas", "body": "Merci d'avoir téléchargé notre app !" }
>     ]
>   }
> ]
> ```

**3. Intégrez-le dans votre vue :**

> [!NOTE]
> Intégration SwiftUI minimale
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

C'est tout — SwiftNEW se déclenche automatiquement quand la version de l'app change.

## ✨ Fonctionnalités

| Fonctionnalité | Depuis | Description |
|---------|:-----:|-------------|
| ⬆️ Écran de mise à jour à distance | 6.5.0 | Activez-le avec `checkForUpdates` ; si le JSON distant contient une version plus récente, SwiftNEW affiche un écran de mise à jour avec une action App Store personnalisable |
| 🔁 Boucle d'icônes animée | 6.4.0 | Fait défiler les SF Symbols avec des transitions de remplacement natives |
| 🧾 Schéma d'icônes flexible | 6.4.0 | Définissez les icônes avec `icon`, `toIcon` ou un tableau `icons` complet |
| 🎯 Badge en verre par défaut | 6.4.0 | Des badges d'icônes en verre arrondis donnent aux lignes un rendu plus doux |
| 🌈 Glyphes d'icônes en dégradé | 6.4.0 | Les glyphes d'icônes utilisent un dégradé de thème du coin supérieur gauche au coin inférieur droit |
| 🧩 Disposition des lignes affinée | 6.4.0 | Icônes plus grandes, lignes plus compactes et boutons d'action plus arrondis |
| ⬇️ Contrôles Continuer abaissés | 6.4.0 | Les contrôles Continuer sont plus proches du bas pour être plus accessibles |
| 🌊 Mouvement de maillage liquide | 6.4.0 | `meshStyle` : arrière-plans en maillage `.still` ou `.liquid` animés |
| 🏷️ Préfixe d'en-tête personnalisé | 6.4.0 | Personnalisez la ligne de titre de l'en-tête avec `headingPrefix` |
| 🔍 Recherche dans la feuille | 6.3.0 | Filtrez les notes de version actuelles par titre / sous-titre / corps |
| 🛡️ Chargement résilient | 6.3.0 | Gère les échecs de chargement avec un état de réessai intégré au lieu d'un spinner sans fin |
| 🏷️ En-tête personnalisable | 6.3.0 | `headingStyle` : `.version`, `.versionOnly` ou `.appName` |
| 🔢 Numéro de build optionnel | 6.3.0 | Masquez le numéro de build via `showBuild: false` |
| 🎨 Effet de particules flottantes | 6.3.0 | Nouvel effet spécial `.particles` (TimelineView + Canvas) |
| 🎯 Présentations flexibles | 6.2.0 | `.sheet`, `.fullScreenCover`, `.embed` |
| 🌈 Couleur de texte adaptative | 6.2.0 | Le texte des boutons contraste automatiquement avec l'arrière-plan |
| 🛠️ Initialiseur simplifié | 6.2.0 | Valeurs directes — plus besoin d'envelopper avec `.constant()` |
| 🪟 Glassmorphisme | 5.5.0 | Flou moderne avec transparence personnalisable |
| 🌈 Dégradés maillés et linéaires | 5.3.0 | Arrière-plans en dégradé animé |
| 🥽 Prise en charge de visionOS | 4.1.0 | Informatique spatiale native |
| 🔄 Déclenchement automatique | 4.0.0 | S'affiche automatiquement quand la version ou le build change |
| 🎄 Effets spéciaux | 3.9.0 | Chute de neige `.christmas`, arc-en-ciel `.particles` |
| 📱 Notifications Drop | 3.5.0 | Notifications bannière de style iOS |
| 🔥 Firebase Realtime DB | 3.0.0 | Mises à jour de contenu en direct |
| 🌐 JSON distant | 3.0.0 | Chargement depuis n'importe quel endpoint REST |
| 📚 Historique des versions | 2.0.0 | Parcourez toutes les versions précédentes |

### Vitrine des fonctionnalités

| Dégradé maillé (5.3+) | visionOS (4.1+) |
|:--------------------:|:---------------:|
| <img alt="Mesh" src="https://github.com/1998code/SwiftNEWKit/assets/54872601/a845c460-65d7-47a0-ae15-23897efd0508"> | ![visionOS](https://github.com/1998code/SwiftNEWKit/assets/54872601/12a8ab01-76e5-42a1-96b4-848ef5e5f36b) |

| Icône d'app (3.9.6+) | Historique (2.0+) |
|:-----------------:|:--------------:|
| <img height="400" alt="App Icon" src="https://user-images.githubusercontent.com/54872601/206886933-bc4d0d33-e0fc-4013-9456-f19679b10f5b.png"> | <img height="400" alt="History" src="https://user-images.githubusercontent.com/54872601/178129999-ad63b0ce-d65e-4d86-9882-37a5090e92bc.png"> |

## 📝 Notes

- Fournir `checkForUpdates: true` avec une URL `data` distante active la recherche de mises à jour. Si la valeur distante la plus élevée de `subVersion` (ou `version`) est plus récente que la version installée de l’app, SwiftNEW affiche l’écran de mise à jour à la place de Nouveautés et obtient la destination App Store via l’API iTunes Lookup d’Apple à partir de l’identifiant de bundle de l’app. L’action principale utilise par défaut le libellé localisé **Télécharger maintenant** ; utilisez `updateButtonTitle` pour afficher un texte personnalisé tel quel. Définissez `allowsSkippingUpdate: false` pour rendre l’écran de mise à jour impossible à ignorer.

## 📚 En savoir plus

| Guide | Contenu |
|-------|--------|
| [Configuration](CONFIGURATION.md) | Tous les paramètres, exemples, sources de données (locale / distante / Firebase), modèle de données |
| [Platform Support & Installation](PLATFORM.md) | Versions d'OS prises en charge, prérequis, matrice des fonctionnalités, configuration SPM |
| [Contributing](CONTRIBUTING.md) | Structure du projet, environnement de dev, consignes de PR, dépannage |

## 📄 Licence

SwiftNEW est publié sous la **licence MIT** — l'une des licences open source les plus permissives.

| | Détails |
|---|---------|
| ✅ **Vous pouvez** | L'utiliser dans des apps commerciales (y compris des apps payantes de l'App Store), la modifier, la redistribuer et l'intégrer dans un logiciel propriétaire |
| 📝 **Vous devez** | Conserver la mention de copyright et la notice de licence d'origine dans votre projet |
| ⚠️ **Sans garantie** | Le logiciel est fourni « tel quel » — l'auteur n'est pas responsable des problèmes liés à son utilisation |

Voir [LICENSE](../LICENSE) pour le texte complet.

## 💖 Soutenu par

| Sponsor | Ressource |
|---------|----------|
| <a href="https://m.do.co/c/ce873177d9ab"><img src="https://opensource.nyc3.cdn.digitaloceanspaces.com/attribution/assets/SVG/DO_Logo_horizontal_blue.svg" width="160px" alt="Digital Ocean"></a> | Infrastructure cloud |
| [![Ask DeepWiki](https://deepwiki.com/badge.svg)](https://deepwiki.com/1998code/SwiftNEWKit) | Q&R sur la documentation par IA |
