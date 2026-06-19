# FindMySoccer (Flutter)

Flutter implementation of the FindMySoccer MVP described in the PRD: local soccer
league/tournament discovery with location, age and skill-level filtering.

## What's implemented

- **Onboarding** — role (player/parent/coach) → age group → skill level → location
  permission request, persisted with Hive.
- **Home** — search bar, nearby leagues, upcoming tournaments, personalized
  "recommended for you" section based on age/skill.
- **Search** — list and map views, text search, and a filter sheet (distance,
  age group, skill level, indoor/outdoor).
- **League & Tournament details** — description, schedule, cost, age groups,
  ratings, registration CTA.
- **Favorites ("My Soccer")** — save/unsave leagues, academies and tournaments;
  persisted with Hive.
- **Profile** — edit role/age/skill, reminders toggle, premium upsell stub.

State is managed with **Riverpod**, navigation with **GoRouter**, and local
persistence (profile + favorites) with **Hive**, per the PRD's technical
architecture.

## What's mocked / not wired up

The PRD calls for a NestJS + PostgreSQL + Elasticsearch backend, Firebase Auth,
Firebase Cloud Messaging, and Google Maps. None of those have credentials in
this environment, so:

- `lib/data/mock_data.dart` + `lib/data/soccer_repository.dart` stand in for the
  `/api/search`, `/api/leagues/{id}`, `/api/tournaments`, `/api/favorites`
  endpoints. The repository's method signatures already match the PRD's API
  shapes, so swapping the bodies for `http`/`dio` calls against a real backend
  shouldn't require touching the UI layer.
- Login screen (email/Google/Apple) and Firebase Auth are **not implemented** —
  the app currently goes straight from splash to onboarding. Add `firebase_auth`
  + a login screen once a Firebase project exists.
- Push notifications (registration reminders) are represented by a UI toggle on
  the Profile screen only; wiring real **Firebase Cloud Messaging** requires a
  Firebase project + `google-services.json` / `GoogleService-Info.plist`.
- `google_maps_flutter` is included and used in the Search screen's map view,
  but you must supply your own Maps API key:
  - Android: add the key to `android/app/src/main/AndroidManifest.xml`
    (`com.google.android.geo.API_KEY` meta-data).
  - iOS: add the key in `ios/Runner/AppDelegate.swift`.

## Running

This environment doesn't have the Flutter SDK installed, so the app hasn't been
built/run here. To run it locally:

```bash
cd flutter-app
flutter pub get
flutter run
```

You'll need standard Flutter platform folders (`android/`, `ios/`) — generate
them if missing with:

```bash
flutter create . --platforms=android,ios
```

(this won't overwrite the existing `lib/` and `pubspec.yaml`).

## Project structure

```
lib/
  models/        # League, Tournament, UserProfile, SearchFilters, enums
  data/          # mock_data.dart, soccer_repository.dart (API-shaped)
  providers/     # Riverpod providers (profile, filters, search, favorites)
  screens/       # splash, onboarding, home, search, league/tournament details,
                 # favorites, profile
  widgets/       # league_card, tournament_card, filter_sheet, nav scaffold
  router.dart    # GoRouter routes + onboarding redirect guard
  main.dart      # Hive init + app entrypoint
```
