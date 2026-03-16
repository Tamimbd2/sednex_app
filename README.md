# Sednex App

A new Flutter project built with GetX and Poppins font.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.

## Runtime Secrets

Google OAuth server client ID must be provided at runtime and should not be
hardcoded in source files.

Example run command:

```bash
flutter run --dart-define=GOOGLE_SERVER_CLIENT_ID=your_client_id_here
```

Example build command:

```bash
flutter build apk --dart-define=GOOGLE_SERVER_CLIENT_ID=your_client_id_here
```
