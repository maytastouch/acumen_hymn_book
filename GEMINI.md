# Acumen Hymn Book

## Project Overview

Acumen Hymn Book is a Flutter-based mobile/desktop application that serves as a comprehensive hymn book for Adventist churches. It provides a user-friendly interface for browsing, searching, and viewing hymns in multiple languages.

**Key Technologies:**

*   **Flutter:** The application is built using the Flutter framework, allowing for cross-platform development (iOS, Android, and desktop).
*   **Bloc:** The app uses the `flutter_bloc` package for state management, which helps to separate business logic from the UI.
*   **Markdown:** The hymn content is stored in Markdown files, making it easy to format and manage.

**Architecture:**

The project is structured by feature, with each language having its own dedicated folder containing its data, domain, and presentation layers. The app uses a `MultiBlocProvider` to provide the different Blocs to the widget tree. The UI is composed of different screens for each language, with a bottom navigation bar to switch between the home, favorites, and settings screens.

## Building and Running

### Prerequisites

*   Flutter SDK: Make sure you have the Flutter SDK installed on your system.
*   Dependencies: Run `flutter pub get` to install the project's dependencies.

### Running the App

*   **Mobile:**
    *   `flutter run`
*   **Desktop (macOS):**
    *   `flutter run -d macos`
*   **Desktop (Windows):**
    *   `flutter run -d windows`
*   **Desktop (Linux):**
    *   `flutter run -d linux`

### Building the App

*   **Android:**
    *   `flutter build apk`
    *   `flutter build appbundle`
*   **iOS:**
    *   `flutter build ios`
*   **macOS:**
    *   `flutter build macos`
*   **Windows:**
    *   `flutter build windows`
*   **Linux:**
    *   `flutter build linux`

### Testing

*   Run `flutter test` to execute the unit and widget tests.

## Development Conventions

*   **State Management:** The project uses the Bloc pattern for state management. When adding new features, it's recommended to follow this pattern.
*   **File Structure:** The project is organized by feature, with each feature having its own `data`, `domain`, and `presentation` layers. This separation of concerns should be maintained when adding new features.
*   **Styling:** The app uses a custom theme defined in `lib/core/app_themes.dart`. When adding new widgets, make sure to use the theme's colors and text styles to maintain a consistent look and feel.
*   **Linting:** The project uses `flutter_lints` for code analysis. Make sure to run `flutter analyze` to check for any linting issues before submitting a pull request.
