# Auth Setup Required

The app now has the Firebase Auth/Riverpod/GoRouter auth flow wired in code, but
real sign-in is disabled until credentials are added.

## Required For Any Real Authentication

### Firebase project

Needs a Firebase project.

Use it for:
- Email/password auth
- Email verification
- Password reset emails
- Routing based on logged-in user state
- Google/X/Apple provider connection

Code switch:
- Fill Firebase options in `lib/src/core/config/auth_config.dart`
- Set `AuthConfig.firebaseEnabled = true`

Platform files:
- Android: `android/app/google-services.json`
- iOS/macOS: Firebase plist files from the Firebase console
- Web: Firebase web app options in `AuthConfig.firebaseOptions`

## Developer Accounts Needed

### Google

Needs a Firebase project. A separate Google Cloud setup may be needed if you use
custom OAuth consent settings.

Required:
- Enable Google in Firebase Authentication providers
- Add Android SHA-1/SHA-256 fingerprints in Firebase for Android login
- Add the Firebase platform config files

### X / Twitter

Needs an X Developer account and app.

Required:
- API key
- API secret key
- Redirect URI, currently `fashai://`
- Enable Twitter/X provider in Firebase Authentication
- Fill `twitterApiKey` and `twitterApiSecret` in `AuthConfig`

### Apple

Needs an Apple Developer account for iOS production use.

Required:
- Enable "Sign in with Apple" on the Apple App ID
- Add the capability in Xcode
- Enable Apple provider in Firebase Authentication

## No Extra Developer Account

Email/password auth only needs Firebase. It does not need Google, X, or Apple
developer accounts. Facebook auth was removed from the app.
