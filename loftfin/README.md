# loftfin

A new Flutter application.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://flutter.dev/docs/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://flutter.dev/docs/cookbook)

For help getting started with Flutter, view our
[online documentation](https://flutter.dev/docs), which offers tutorials,
samples, guidance on mobile development, and a full API reference.


## Deploy on firebase
 - firebase init

 - Choice(options)
    - Which Firebase features do you want to set up for this directory? Press Space to select features, then Enter to confirm your choices. Hosting: Configure files for Firebase Hosting and (optionally) set up GitHub Action deploys.
    - What do you want to use as your public directory? build/web
    - Configure as a single-page app (rewrite all urls to /index.html)? Yes
    - Set up automatic builds and deploys with GitHub? No
    - File build/web/index.html already exists. Overwrite? Yes

 - flutter build web --web-renderer html --release

 - firebase deploy

## Deployed firebase Url

https://loftfin-dev.web.app

https://loftfin-prod.web.app


## Run Web App
flutter run -d chrome --web-port=64604
