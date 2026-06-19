# Disaster AIDvisor

A boutique disaster preparedness advisor built by [BuildSOS](https://buildsos.com). Live on the App Store and Google Play. Serves homeowners, renters, and small-business owners across the United States preparing for, living through, or recovering from natural disasters.

This repo contains the Flutter mobile app. The AI chat backend (which holds the Anthropic API key) lives in a separate repo, [`disaster-aidvisor-proxy`](#related-repos).

---

## Architecture

```
┌─────────────┐   HTTPS + Firebase ID token   ┌──────────────────────┐   x-api-key   ┌──────────────┐
│ Flutter app │ ─────────────────────────────▶│  Vercel proxy         │ ─────────────▶│  Anthropic   │
│ (iOS+Android)│ {messages, languageCode}     │  auth + ratelimit +   │               │  (Sonnet 4.6)│
└─────────────┘                                │  Sonnet-pinned        │               └──────────────┘
       │                                       └──────────────────────┘
       │ user sign-in / sign-up
       ▼
┌──────────────────────┐
│  Firebase Auth       │
│  Firestore (user docs)│
└──────────────────────┘
```

- **Flutter mobile app** — this repo. Renders chat, manages auth state, persists locale + What's New state, owns all UI.
- **Vercel proxy** — separate repo. Verifies the user's Firebase ID token, rate-limits per user, calls Anthropic on the user's behalf. The Anthropic key never touches the device.
- **Firebase** — Auth for sign-in/sign-up, Firestore for user profile documents. Project ID: `disasterbuddy-9f1ee`.
- **Anthropic Claude Sonnet 4.6** — the AI advisor. Model name is hardcoded in the proxy, not configurable from the client.

---

## ⚠️ API key handling — important

**Do NOT embed the Anthropic API key in the app binary.**

The original architecture passed the key via `flutter build --dart-define=ANTHROPIC_API_KEY=...`, which compiled the value as a plaintext constant into the IPA / AAB. On 2026-06-18 this key was extracted from the published binary by an unknown third party and abused for $150.11 of Opus usage in 24 hours. Anthropic accounts are not refundable for extracted-key abuse.

The fix shipped in v1.1.3: a Vercel-hosted proxy holds the key in server-side environment variables. The Flutter app authenticates with Firebase, sends its Firebase ID token to the proxy, and the proxy makes the Anthropic call on behalf of the user. The app binary contains no Anthropic credentials.

**Forward-looking rules for this repo:**

1. Never use `--dart-define` for any secret value. Treat it as compiling the value as plaintext into the binary — because that's what it does.
2. Before any release, run the [binary-secret audit](#release-process) — `strings | grep "sk-ant-"` against the built IPA and AAB. Both must return zero matches.
3. The proxy URL is *not* a secret — it's a public HTTPS endpoint. Safe to hardcode in `lib/services/chat_service.dart`.
4. Firebase API keys *are* shipped in the binary. This is intentional and per Firebase's design — the keys identify the project, they don't authorize anything. Real authz is enforced by Firebase Security Rules + Auth tokens.

---

## Repository structure

```
disaster-aidvisor/
├── disasterbuddy/                    # Flutter app source
│   ├── lib/
│   │   ├── main.dart                 # App entry
│   │   ├── firebase_options.dart     # Per-platform Firebase config (auto-generated)
│   │   ├── data/release_notes.dart   # What's New copy + kCurrentVersion
│   │   ├── services/chat_service.dart # POST to the proxy
│   │   ├── views/                    # Screens
│   │   └── l10n/                     # ARB localization files (en, es)
│   ├── test/                         # Unit tests (incl. release_notes_version_test.dart)
│   ├── ios/                          # Xcode project
│   ├── android/                      # Gradle project
│   ├── pubspec.yaml                  # Version + dependencies
│   └── RELEASE_CHECKLIST.md          # Per-release checklist (see also "Release process" below)
└── README.md                         # this file
```

---

## Related repos

- **`disaster-aidvisor-proxy`** — Vercel-hosted Node.js function that fronts Anthropic. Holds the API key, enforces Sonnet-only + per-user rate limits, owns the system prompt. Currently local on Joseph's machine; not yet pushed to GitHub.
  - Production URL: `https://disaster-aidvisor-proxy.vercel.app/api/chat`
  - Endpoint: `POST /api/chat` with `Authorization: Bearer <Firebase ID token>`

---

## Development setup

**Prerequisites:**

- Flutter SDK 3.5+ (see `disasterbuddy/pubspec.yaml` for the exact pinned version)
- Xcode 26+ for iOS builds (with the iOS simulator runtime — see [Xcode 26.5 simulator runtime note](#known-toolchain-gotchas) below)
- Android Studio + Java 17+ for Android builds
- CocoaPods (`sudo gem install cocoapods`)
- Firebase CLI (optional, for config regeneration)

**Clone + install:**

```bash
git clone https://github.com/joevetoe/disaster-aidvisor.git
cd disaster-aidvisor/disasterbuddy
flutter pub get
cd ios && pod install && cd ..
```

**Run on iOS simulator** (the default development surface):

```bash
flutter run -d <simulator-id>
```

**Run on a physical iOS device:** signing is via Build SOS Inc. (Apple team `C99Z88ARBS`).

---

## Building for release

The v1.1.3+ build command is just:

```bash
flutter build ipa          # iOS
flutter build appbundle    # Android (.aab)
```

**No `--dart-define` flags.** The Anthropic key is not embedded; the proxy URL is hardcoded in `lib/services/chat_service.dart`.

---

## Release process

1. **Bump version in two places (must match):**
   - `disasterbuddy/pubspec.yaml` — e.g., `version: 1.1.3+13`
   - `disasterbuddy/lib/data/release_notes.dart` — `kCurrentVersion = '1.1.3'`

2. **Add a release note entry** at the top of `releaseNotes` in `release_notes.dart`. Keep tone boutique-advisor: warm, concise, user-facing.

3. **Run the version-parity unit test:**

   ```bash
   cd disasterbuddy
   flutter test test/release_notes_version_test.dart
   ```

4. **Build:**

   ```bash
   flutter build ipa
   flutter build appbundle
   ```

5. **Binary-secret audit (non-negotiable gate):**

   ```bash
   # iOS
   unzip -o build/ios/ipa/disasterbuddy.ipa -d /tmp/new-ipa
   strings /tmp/new-ipa/Payload/Runner.app/Runner | grep -iE "sk-ant|anthropic.com|x-api-key"
   # Expected: zero output

   # Android
   unzip -o build/app/outputs/bundle/release/app-release.aab -d /tmp/new-aab
   find /tmp/new-aab -name "*.so" -o -name "*.dex" -o -name "classes*" | xargs strings 2>/dev/null | grep -iE "sk-ant|anthropic.com|x-api-key"
   # Expected: zero output
   ```

   If either returns hits, **STOP**. Investigate before uploading.

6. **Upload:**
   - iOS: `xcrun altool --upload-app --type ios --file build/ios/ipa/disasterbuddy.ipa --apiKey ... --apiIssuer ...` (or use Transporter.app)
   - Android: upload the AAB via Play Console → Production → Create release

7. **Tag the release** on the commit that shipped:

   ```bash
   git tag -a v1.1.X <sha> -m "Release v1.1.X — short description"
   git push origin v1.1.X
   ```

---

## Localization

The app supports English (`en`) and Spanish (`es`). Pattern:

- ARB files: `lib/l10n/app_en.arb`, `lib/l10n/app_es.arb`
- Config: `l10n.yaml` at project root
- Locale switcher: `LocaleController` singleton (`lib/services/locale_controller.dart` or similar) persists user override via `SharedPreferences`
- The proxy receives a `languageCode` parameter and appends a language instruction to the system prompt (Spanish uses the formal *usted* register)
- NWS / NOAA alert event names are deliberately NOT translated — they're official text with legal accuracy

---

## Knowledge base

`disasterbuddy/lib/views/chatting_screen.dart` contains a hardcoded fuzzy-match knowledge base of ~1,114 canned response pairs (`KB_PAIRS` map). The chat pipeline checks the KB first for a close match; if none is found, it falls through to the proxy → Anthropic. This is intentional — it keeps common questions instant and free, and only reaches Anthropic for novel queries.

If you're adjusting prompts or the AI's behavior, remember to consider whether the same change should be reflected in canned KB responses.

---

## Vendor accounts / dashboards

| System | URL | Owner |
|---|---|---|
| Apple Developer + App Store Connect | https://appstoreconnect.apple.com | Andy (Build SOS Inc., team `C99Z88ARBS`) |
| Google Play Console | https://play.google.com/console | Andy |
| Anthropic Console | https://console.anthropic.com | Andy (Admin) + Joseph (Developer) |
| Firebase Console | https://console.firebase.google.com/project/disasterbuddy-9f1ee | Andy (Owner) + Joseph (Editor) |
| Vercel (proxy hosting) | https://vercel.com/joevetoe-7309s-projects/disaster-aidvisor-proxy | Joseph |
| Upstash (proxy rate-limit Redis) | Accessed via Vercel Marketplace | Joseph |

Anthropic key rotation: see the proxy repo's README. Rotating the key does NOT require an app release — update the Vercel env var, redeploy the proxy.

---

## Known toolchain gotchas

- **Xcode 26.5 ships the SDK but not the iOS 26.5 simulator runtime.** Run `xcodebuild -downloadPlatform iOS` to install the runtime separately, or simulator targets won't appear.
- **Play 16 KB native-lib alignment** — production AABs require AGP 8.5.1+ (8.7 is safer) and Gradle 8.7+. Set in `android/settings.gradle` and `android/gradle/wrapper/gradle-wrapper.properties`. v1.1.2 fixed this; current configuration is good.
- **Flutter HTTP UTF-8 decode** — always `utf8.decode(response.bodyBytes)`, never `response.body`, for any JSON response containing non-ASCII characters.

---

## License

Proprietary — © BuildSOS Inc. All rights reserved.
