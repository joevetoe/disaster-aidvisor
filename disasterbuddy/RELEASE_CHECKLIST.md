# Release Checklist — Disaster AIDvisor

Pre-submission checklist for shipping an update to the App Store and Play Store over the existing `com.codeqo.disasteradvisor` listings.

The live store build is at tag `v1.0.0` (commit `072e75c` on `main`). The uploaded source is the zip at the repo root. All active development has happened on feature branches layered on top; the next release will come from the `fix/security-cleanup` branch (or whatever branch the release train ends up on).

## Compatibility invariants — verified 2026-04-24

These must not change or existing users lose access. All currently match the live build:

- [x] **Firebase project** — `disasterbuddy-9f1ee` (`firebase_options.dart` byte-identical with the zip). Existing users' Auth + Firestore + Realtime Database entries carry over.
- [x] **Bundle ID / Package name** — `com.codeqo.disasteradvisor` on iOS + Android. Store update installs on top of existing install; user data persists.
- [x] **Field reads are null-safe on old docs** — `firstName`, `lastName`, `zipCode`, `emailverified` all handle absent fields gracefully after the `ffba9ac` login hardening fix.

## Pre-submission tasks

### Code

- [x] Remove plaintext password writes (commit `1365377`)
- [x] Migrate chat backend to Anthropic Claude Sonnet 4.6 (commit `4d03d60`)
- [x] Live-switch chat screen text on locale change (commit `90fdcae`)
- [x] Harden login against missing `emailverified` field (commit `ffba9ac`)
- [x] Strip the demo alert toggle — internal sales aid only (commit `d42cf1f`)
- [ ] **Bump app version in `pubspec.yaml`.** Needs the current store version numbers from App Store Connect + Play Console to know the starting point. Must increment past both. Update `version: X.Y.Z+N` where `N` is the build number (iOS and Android both read this).

### External / account-level

- [ ] **Load Anthropic prepaid credit** (Andy). Account at `console.anthropic.com` → Billing → add payment method → purchase $5+ credit. The $50/month cap is already set but does not fund the API by itself. See `memory/reference_anthropic_billing.md`.
- [ ] **Rotate OpenAI key** *after* this build is live in both stores and adoption has caught up. The key is still in git history on feature branches; revoking it neutralizes that exposure. Revoking sooner breaks chat for every user on the currently-live (pre-Anthropic) build until they update.
- [ ] Delete the orphaned `key` collection in Firestore (console cleanup after the `setApiKey` listener was removed in `4d03d60`).
- [ ] Firestore password backfill — one-time Admin-SDK script to strip the plaintext `password` field from existing user docs. Run AFTER the new build is live so new writes have already stopped.

### Build + test

- [ ] Build iOS IPA with the Anthropic key injected:
  ```bash
  flutter build ipa --dart-define=ANTHROPIC_API_KEY=sk-ant-...
  ```
- [ ] Build Android App Bundle similarly:
  ```bash
  flutter build appbundle --dart-define=ANTHROPIC_API_KEY=sk-ant-...
  ```
- [ ] **Real-device upgrade test.** Install the current store build from TestFlight/internal track (or the live store), create or log in to a test account, use the app to create data, then sideload the new build over it. Verify:
  - Still logged in (no forced logout)
  - Profile / chat history intact
  - Can send a new chat message (Anthropic returns a response)
  - Language switcher works mid-session
- [ ] Submit to App Store Connect and Play Console. Fill out "What's new in this version" notes.

## Reference

- `memory/project_api_migration.md` — Anthropic migration decisions
- `memory/project_security_issues.md` — rotation strategy, backfill plan
- `memory/reference_anthropic_billing.md` — prepaid credit vs spend cap
- `memory/project_demo_toggle_internal.md` — why the demo toggle was stripped
