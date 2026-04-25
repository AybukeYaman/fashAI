# FashAI — Authentication System

**Implemented:** 2026-03-01
**Status:** Complete (pending native config for Facebook & X)

---

## Overview

Full authentication system built on top of Firebase Auth + Riverpod + GoRouter. Supports email/password with email verification, Google, Apple (iOS only), Facebook, and X (Twitter).

---

## Architecture

```
lib/
├── core/
│   └── providers/
│       └── shared_preferences_provider.dart   ← SharedPreferences singleton
└── features/
    └── auth/
        ├── services/
        │   └── auth_service.dart              ← All Firebase/social auth logic
        ├── providers/
        │   └── auth_providers.dart            ← Riverpod providers
        └── screens/
            ├── login_screen.dart
            ├── signup_screen.dart
            └── verify_email_screen.dart
```

---

## Packages Added

| Package | Version | Purpose |
|---------|---------|---------|
| `google_sign_in` | ^6.2.1 | Google OAuth |
| `sign_in_with_apple` | ^6.1.1 | Apple OAuth (iOS) |
| `crypto` | ^3.0.3 | SHA-256 nonce hashing for Apple sign-in |
| `flutter_facebook_auth` | ^7.0.1 | Facebook OAuth |
| `twitter_login` | ^4.4.2 | X (Twitter) OAuth |

---

## Providers (`auth_providers.dart`)

```dart
// AuthService singleton — the single instance used across the app
final authServiceProvider = Provider<AuthService>((ref) => AuthService());

// Live Firebase auth stream — rebuilds whenever user logs in/out
final authStateProvider = StreamProvider<User?>((ref) { ... });

// Reads 'has_seen_onboarding' from SharedPreferences
final hasSeenOnboardingProvider = FutureProvider<bool>((ref) async { ... });
```

---

## AuthService (`auth_service.dart`)

| Method | Description |
|--------|-------------|
| `signUpWithEmail(email, password)` | Creates account + auto-sends verification email |
| `signInWithEmail(email, password)` | Standard email/password login |
| `signInWithGoogle()` | Google OAuth — returns `null` if cancelled |
| `signInWithApple()` | Apple OAuth with SHA-256 nonce |
| `signInWithFacebook()` | Facebook OAuth — returns `null` if cancelled |
| `signInWithX()` | X (Twitter) OAuth — returns `null` if cancelled |
| `sendEmailVerification()` | Resends verification email |
| `reloadUser()` | Refreshes local `User` object from Firebase |
| `sendPasswordResetEmail(email)` | Sends password reset email |
| `signOut()` | Signs out from Firebase + Google + Facebook |
| `authStateChanges` | `Stream<User?>` — the live auth stream |
| `currentUser` | `User?` — current logged-in user |

---

## Router (`router.dart`)

Converted from a static `AppRouter` class to a Riverpod `routerProvider`.

### Redirect Logic

```
user == null && !hasSeenOnboarding  →  /onboarding
user == null && hasSeenOnboarding   →  /login  (if not already on an auth screen)
user != null && !emailVerified      →  /verify-email
user != null && emailVerified       →  /home   (if currently on an auth screen)
```

### How GoRouter stays in sync with Riverpod

```dart
class _AuthChangeNotifier extends ChangeNotifier {
  _AuthChangeNotifier(Ref ref) {
    ref.listen(authStateProvider, (_, __) => notifyListeners());
    ref.listen(hasSeenOnboardingProvider, (_, __) => notifyListeners());
  }
}
```

Whenever Firebase emits a new user (login/logout/reload) or the onboarding flag changes, `notifyListeners()` triggers GoRouter to re-evaluate the `redirect` callback.

### Routes

| Path | Screen |
|------|--------|
| `/onboarding` | `OnboardingScreen` |
| `/login` | `LoginScreen` |
| `/signup` | `SignupScreen` |
| `/verify-email` | `VerifyEmailScreen` |
| `/home` | `HomeScreen` (inside `AppShell`) |
| `/wardrobe` | `WardrobeScreen` (inside `AppShell`) |
| `/stylist` | `AiStylistScreen` (inside `AppShell`) |
| `/profile` | `ProfileScreen` (inside `AppShell`) |

---

## Screens

### LoginScreen (`/login`)
- Email + password fields with form validation
- Toggleable password visibility
- "Forgot password?" → `sendPasswordResetEmail()` + SnackBar
- Social buttons: Google, Facebook, X, Apple (iOS only)
- `FirebaseAuthException` codes mapped to human-readable messages
- Link to `/signup` via `context.push`

### SignupScreen (`/signup`)
- Fields: Full Name, Email, Password, Confirm Password
- Real-time password strength indicator (`LinearProgressIndicator`)
  - Weak (red) → Fair (orange) → Good (gold) → Strong (green)
- On success: Firebase creates user → `sendEmailVerification()` called automatically → router redirects to `/verify-email`
- Link back to login via `context.pop()`

### VerifyEmailScreen (`/verify-email`)
- Shows the user's email address
- **"I've verified my email"** button → `reloadUser()` → if verified, router auto-navigates to `/home`
- **Resend** button with 60-second cooldown timer
- **Sign out** text button → `signOut()`
- Google/Apple/Facebook/X users never land here (emails are pre-verified)

---

## Email Verification Flow

```
signUpWithEmail()
  └─ Firebase creates user
  └─ sendEmailVerification() ← called immediately, automatically
       └─ Firebase sends email with tokenized link
            └─ User taps link in email client
                 └─ Firebase marks email as verified on their servers
                      └─ User returns to app, taps "I've verified my email"
                           └─ reloadUser() ← refreshes local User object
                                └─ authStateChanges emits updated user
                                     └─ _AuthChangeNotifier fires
                                          └─ GoRouter redirect runs
                                               └─ emailVerified == true → /home
```

No deep links or custom URL schemes required.

---

## Complete User Flow

```
App Launch
├── First launch (hasSeenOnboarding = false)
│     └─ /onboarding → swipe pages → "Get Started"
│           └─ SharedPreferences.setBool('has_seen_onboarding', true)
│           └─ invalidate hasSeenOnboardingProvider
│           └─ /login
│
├── Returning, not logged in (hasSeenOnboarding = true, user = null)
│     └─ /login
│           ├─ Email/password → /home
│           ├─ Sign up → /signup → create account → /verify-email → verify → /home
│           ├─ Google → /home  (pre-verified, skips /verify-email)
│           ├─ Facebook → /home  (pre-verified)
│           ├─ X → /home  (pre-verified)
│           └─ Apple (iOS) → /home  (pre-verified)
│
└── Returning, logged in + verified
      └─ /home  (directly, no onboarding, no login)
```

---

## Native Configuration Required

### Google Sign-In (Android)
1. Firebase Console → Project Settings → Android → Download `google-services.json`
2. Place it at `android/app/google-services.json`
3. Add your app's SHA-1 fingerprint in Firebase Console

### Facebook
1. Create an app at [developers.facebook.com](https://developers.facebook.com)
2. Create `android/app/src/main/res/values/strings.xml`:
```xml
<resources>
  <string name="facebook_app_id">YOUR_APP_ID</string>
  <string name="fb_login_protocol_scheme">fbYOUR_APP_ID</string>
  <string name="facebook_client_token">YOUR_CLIENT_TOKEN</string>
</resources>
```
3. Add to `AndroidManifest.xml` inside `<application>`:
```xml
<meta-data android:name="com.facebook.sdk.ApplicationId"
    android:value="@string/facebook_app_id"/>
<meta-data android:name="com.facebook.sdk.ClientToken"
    android:value="@string/facebook_client_token"/>
```
4. Firebase Console → Authentication → Facebook → enable + paste App ID & Secret

### X (Twitter)
1. Create an app at [developer.twitter.com](https://developer.twitter.com)
2. Get API Key and API Secret Key
3. Set redirect URI to `fashai://` in the Twitter app settings
4. Fill in `auth_service.dart`:
```dart
static const _twitterApiKey    = 'YOUR_TWITTER_API_KEY';
static const _twitterApiSecret = 'YOUR_TWITTER_API_SECRET';
```
5. Firebase Console → Authentication → Twitter → enable + paste API Key & Secret

### Apple Sign-In (iOS only)
1. Apple Developer Portal → Certificates, IDs & Profiles → enable Sign in with Apple for your App ID
2. Xcode → Signing & Capabilities → add "Sign in with Apple"
3. Firebase Console → Authentication → Apple → enable

---

## Files Modified

| File | What changed |
|------|-------------|
| `pubspec.yaml` | Added 5 new packages |
| `lib/main.dart` | `StatelessWidget` → `ConsumerWidget`, watches `routerProvider` |
| `lib/app/router.dart` | Full rewrite: static class → `routerProvider` with redirect guards |
| `lib/features/onboarding/screens/onboarding_screen.dart` | Wired "I already have an account" → `/login`; `onComplete` is now `async` |

## Files Created

| File | Purpose |
|------|---------|
| `lib/core/providers/shared_preferences_provider.dart` | SharedPreferences Riverpod provider |
| `lib/features/auth/services/auth_service.dart` | Auth business logic |
| `lib/features/auth/providers/auth_providers.dart` | Riverpod providers for auth state |
| `lib/features/auth/screens/login_screen.dart` | Login UI |
| `lib/features/auth/screens/signup_screen.dart` | Sign-up UI |
| `lib/features/auth/screens/verify_email_screen.dart` | Email verification UI |
