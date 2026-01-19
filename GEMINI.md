# Acumen Hymn Book

## Project Overview

Acumen Hymn Book is a Flutter-based cross-platform application (mobile and desktop) designed to serve as a digital hymn book for Adventist churches. It aggregates multiple hymnals into a single, user-friendly interface with features like searching, favorites, and dynamic theming.

**Supported Hymnals:**
*   **Christ in Song (English):** Content stored in individual Markdown (`.md`) files.
*   **SDA Hymnal:** Content stored in a single `meta.json` file.
*   **Keresete Mo Kopelong (Tswana)**
*   **Lozi Hymnal (Lozi)**
*   **u-Kristu Engomeni (Xhosa)**

**Key Technologies:**
*   **Flutter:** Core framework for cross-platform development.
*   **Bloc (`flutter_bloc`):** State management pattern used extensively throughout the app.
*   **Auto Updater (`auto_updater`):** For handling application updates on desktop platforms.
*   **Desktop Window (`desktop_window`):** For managing window sizing on desktop.
*   **JSON & Markdown:** Hybrid data storage for hymn content.

## Architecture

The project follows a **feature-first** architecture. Each hymnal (language) is treated as a separate feature with its own directory structure.

### Directory Structure (`lib/`)
*   **`main.dart`:** Application entry point. Sets up the `MultiBlocProvider`, `auto_updater`, and global theme.
*   **`core/`:** Shared resources, themes, and services (e.g., `HymnStorageService`).
*   **`general_bloc/`:** Global application state (e.g., `ThemeBloc`, `RouteBloc`).
*   **`christ_in_song/`, `sda/`, `lozi/`, etc.:** Feature directories for each hymnal.
    *   **`data/`:** Data sources and models.
    *   **`domain/`:** Entities (though often simplified or merged with models in this codebase).
    *   **`presentation/`:** Blocs specific to the feature, Screens/Pages, and Widgets.

### Data Handling
*   **SDA Hymnal:** Uses `SDALocalMethods` to read from `assets/hymns/sda/meta.json`. Editing writes back to this JSON file.
*   **Other Hymnals (e.g., Christ in Song):** Typically read metadata (titles) from a `meta.json` and load lyrics from individual `.md` files in `assets/hymns/<lang>/`.

## Building and Running

### Prerequisites
*   Flutter SDK (Version >=3.1.5 <4.0.0)
*   Dart SDK

### Commands

**Run the app:**
```bash
# Mobile (select device)
flutter run

# Desktop
flutter run -d macos
flutter run -d windows
flutter run -d linux
```

**Build for release:**
```bash
flutter build apk       # Android
flutter build ios       # iOS
flutter build macos     # macOS
flutter build windows   # Windows
flutter build linux     # Linux
```

**Testing:**
```bash
flutter test
```

**Code Analysis:**
```bash
flutter analyze
```

## Development Conventions

*   **State Management:** Strictly adhere to the **Bloc** pattern. Use `BlocBuilder` and `BlocProvider` for UI updates and state injection.
*   **Theme:** Use `Theme.of(context)` or `BlocBuilder<ThemeBloc, ...>` to support both light and dark modes. The app supports dynamic switching.
*   **Hymn Editing:**
    *   SDA hymns can be edited directly within the app. The changes are persisted to the local file system (overriding the asset).
    *   The `HymnEditScreen` handles the UI for editing, with a custom `onSave` callback for special handling (like JSON updates).
*   **Assets:** When adding new hymns, ensure `pubspec.yaml` is updated to include the new asset paths if they are not covered by existing directory globs.
*   **Formatting:** Run `dart format .` before committing.
