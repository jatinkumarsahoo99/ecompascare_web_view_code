# ecompasscare

A new Flutter project.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.

<!-- source="$(readlink -f "${source}")" -->
<!-- export PATH="$PATH":"$HOME/.pub-cache/bin" -->

cmd:
flutter clean && flutter pub get && flutter build appbundle && open build/app/outputs/bundle/release
flutter clean && flutter pub get && flutter build apk && open build/app/outputs/flutter-apk
flutter clean && flutter pub get && flutter build ios && open ios
arch -x86_64 pod install
