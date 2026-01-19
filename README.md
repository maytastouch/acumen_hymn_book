# Acumen Hymn Book

Acumen Hymn Book is a Flutter-based mobile/desktop application designed to serve as a comprehensive hymn book for Adventist churches. It aims to enhance the congregation's singing experience by providing a user-friendly and intuitive user interface. This app is a unique amalgamation of hymns from different languages, making it a valuable resource for Adventist communities around the world.

## Features

- **Intuitive UI:** Acumen Hymn Book offers a user-friendly interface that is easy to navigate, ensuring that congregation members can quickly find and access their favorite hymns.

- **Multilingual Hymns:** With hymns available in various languages (English, Tswana, Xhosa, Lozi, etc.), this app caters to the diverse Adventist community, allowing users to sing their beloved hymns in their preferred language.

- **Comprehensive Collection:** Acumen Hymn Book brings together a vast collection of hymns, ensuring that churches have access to a wide range of songs for different occasions and worship services.

- **Customizable Home Screen:** Users can personalize the landing page by:
    - Uploading a custom background image.
    - Editing the welcome overlay text.
    - Toggling the visibility of controls for a distraction-free view.
    - *Settings are persisted locally.*

- **Cross-Platform Support:** Fully optimized for Android, iOS, macOS, Windows, and Linux.

## Getting Started

This project is a starting point for developing the Acumen Hymn Book app.

### Prerequisites
- [Flutter SDK](https://flutter.dev/docs/get-started/install)
- VS Code or Android Studio

### Installation
1. Clone the repository.
2. Run `flutter pub get` to install dependencies.
3. Run the app:
   ```bash
   flutter run
   ```

## Building and Deployment

### macOS
To build the release version for macOS:
```bash
flutter build macos --release
```
The application bundle will be located in `build/macos/Build/Products/Release/acumen_hymn_book.app`.

### Windows
To build the release version for Windows:

1.  **Build the Executable:**
    ```powershell
    flutter build windows --release
    ```
2.  **Create Installer (Inno Setup):**
    -   Ensure [Inno Setup](https://jrsoftware.org/isdl.php) is installed.
    -   Open `installers/windows/inno_setup.iss`.
    -   Run the script to generate `acumen_hymn_book_setup.exe` in the `installers/windows` directory.

## Contribution

We welcome contributions from the open-source community to improve and expand the Acumen Hymn Book app. Please feel free to submit issues, feature requests, or pull requests to help us enhance this valuable resource for Adventist churches worldwide.