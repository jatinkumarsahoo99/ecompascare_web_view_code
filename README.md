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
flutter clean && flutter pub get && flutter build ios && cd ios && xed . && cd ..
cd ios && arch -x86_64 pod install && cd ..

<key>NSAppTransportSecurity</key>
<dict>
<key>NSAllowsLocalNetworking</key>
<true/>
</dict>

I/flutter (15224): --------------------------
D/CCodec (15224): allocate(c2.goldfish.h264.decoder)
I/chromium(15224): [INFO:CONSOLE(14)] "Warning: Each child in a list should have a unique "key" prop.%s%s See https://reactjs.org/link/warning-keys for more information.%s
I/chromium(15224):
I/chromium(15224): Check the render method of `MyApp`.
I/chromium(15224): at div
I/chromium(15224): at MyApp (<anonymous>:41:31)", source: https://sterlingaccuris.com/static-assets/js/unpkg/react.development.js (14)
I/CCodec (15224): setting up 'default' as default (vendor) store
I/flutter (15224): calling init noti
I/flutter (15224): WebView is loading (progress : 100%)
I/CCodec (15224): Created component [c2.goldfish.h264.decoder]
