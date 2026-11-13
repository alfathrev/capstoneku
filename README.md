# BulKu / PawPal prototype

Flutter prototype of the pet-care app designed in Figma. Auth, home, pet
management, Pet Health (symptom chat, skin scan, urgent care), nearby care,
demo booking and profile are all navigable. Everything is local demo data; no
backend, camera or maps are used.

## Run

```sh
flutter pub get
flutter run
```

## Replace drawn art with Figma exports (optional)

Export the illustration from Figma as PNG and save it as
`assets/images/event_grooming.png`; the Home "Event" banner uses it
automatically. Other illustrations (cats) are drawn in `lib/widgets/art.dart`.
