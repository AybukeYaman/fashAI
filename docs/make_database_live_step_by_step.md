# Make The Database Live: Step By Step

Use this runbook to make Combime's Firestore backend live safely. The recommended path is staging first, then production.

## Current Status

The database layer is implemented locally, but it is not live until you deploy Firebase resources.

Local files already exist:

- `firestore.rules`
- `firestore.indexes.json`
- `storage.rules`
- `firebase.json`
- `functions/`
- Dart Firestore models and repositories under `lib/src/features/.../data/`

## 1. Decide Environments

Use two Firebase projects:

- Staging: for testing real auth, Firestore rules, Storage, and Functions.
- Production: for real users.

Do not test first on production.

Example aliases:

```powershell
firebase.cmd use --add
# choose your staging Firebase project
# alias: staging

firebase.cmd use --add
# choose your production Firebase project
# alias: prod
```

Check the active project before every deploy:

```powershell
firebase.cmd use
```

## 2. Create Firestore In The Right Region

In Firebase Console or Google Cloud Console:

1. Open the staging project.
2. Go to Firestore Database.
3. Create the database.
4. Choose production mode.
5. Choose location `eur3` / Europe multi-region.

Repeat later for production.

Important: Firestore location cannot be changed after database creation. If you create it in the wrong region, create a new project/database before real data exists.

## 3. Enable Required Firebase Services

In the staging project, enable:

- Firebase Authentication
- Cloud Firestore
- Cloud Storage
- Cloud Functions
- Cloud Scheduler
- Eventarc
- Cloud Run
- Secret Manager, if you later migrate secrets from dotenv to managed secrets

For Authentication, confirm the providers already used by the app:

- Email/password
- Google

Cloud Functions usually requires the project to be on the Blaze billing plan.

## 4. Install Local Tooling

From the project root:

```powershell
firebase.cmd login
firebase.cmd --version
flutter --version
node --version
```

Install Functions dependencies if they are not already installed:

```powershell
cd functions
npm.cmd install
cd ..
```

## 5. Configure Function Environment Variables

The Functions code reads environment variables from `process.env`.

Firebase Functions supports dotenv files in `functions/`, including project-specific files like `.env.staging` and `.env.prod`. See the official Firebase docs: https://firebase.google.com/docs/functions/config-env

Create this file locally:

```powershell
notepad functions\.env.staging
```

Add staging values:

```env
REVENUECAT_WEBHOOK_TOKEN=replace_with_staging_token
# Or use this instead of bearer token if you configure HMAC verification:
# REVENUECAT_WEBHOOK_SIGNATURE_SECRET=replace_with_staging_signature_secret

SMTP_HOST=replace_with_smtp_host
SMTP_PORT=587
SMTP_SECURE=false
SMTP_USER=replace_with_smtp_user
SMTP_PASS=replace_with_smtp_password
SMTP_FROM=Combime <no-reply@your-domain.com>
```

For production later:

```powershell
notepad functions\.env.prod
```

Do not commit `.env`, `.env.staging`, or `.env.prod`. They are ignored by `functions/.gitignore`.

## 6. Run Local Validation

From the project root:

```powershell
flutter analyze
```

Build Functions:

```powershell
cd functions
npm.cmd run build
cd ..
```

Optional production dependency audit:

```powershell
cd functions
npm.cmd audit --omit=dev
cd ..
```

Note: the current lockfile may report moderate transitive vulnerabilities through Firebase/Google Cloud packages. Do not run `npm audit fix --force` unless you are ready to handle breaking dependency changes.

## 7. Deploy Staging Firestore And Storage Rules

Switch to staging:

```powershell
firebase.cmd use staging
```

Deploy Firestore rules and indexes:

```powershell
firebase.cmd deploy --only firestore
```

Deploy Storage rules:

```powershell
firebase.cmd deploy --only storage
```

If indexes take time to build, wait until Firebase Console shows them as ready before relying on indexed queries.

## 8. Deploy Staging Functions

Deploy Functions:

```powershell
firebase.cmd deploy --only functions
```

Confirm the deploy log says it loaded environment variables from `.env.staging`.

List deployed functions:

```powershell
firebase.cmd functions:list
```

You should see:

- `onUserCreate`
- `onWardrobeItemWrite`
- `onFeedbackCreate`
- `onSubscriptionWebhook`
- `onAccountDelete`
- `exportUserData`
- `dailyRecommendationGenerator`
- `archiveOldRecommendations`

## 9. Configure RevenueCat Webhook

After Functions deploy, find the HTTPS URL for:

```text
onSubscriptionWebhook
```

In RevenueCat staging:

1. Add the webhook URL.
2. Configure the same bearer token or HMAC secret used in `functions/.env.staging`.
3. Send a test event.
4. Confirm `users/{uid}.subscription` updates in Firestore.

## 10. Point The App At Staging Firebase

If your local `lib/firebase_options.dart` currently points only to one Firebase project, run FlutterFire configuration for the staging project before testing staging builds.

Example:

```powershell
flutterfire configure --project your-staging-project-id
```

Then run the app:

```powershell
flutter run
```

## 11. Staging Test Checklist

Create at least two test users.

Auth and profile:

- Sign up with email/password.
- Sign in with Google.
- Confirm `users/{uid}` is created by `onUserCreate`.
- Confirm another user cannot read or write this user's data.

Wardrobe:

- Add a wardrobe item.
- Confirm Storage path is under `users/{uid}/...`.
- Confirm `users/{uid}/wardrobe/{itemId}` is created.
- Confirm `users/{uid}.aggregates.totalWardrobeItems` updates.
- Turn off network and confirm wardrobe remains browsable from cache.

Recommendations:

- Manually create a test `users/{uid}/recommendations/{YYYY-MM-DD}` doc or wait for the scheduled stub.
- Confirm the Today screen can read the date-keyed doc.

Feedback:

- Create feedback.
- Confirm feedback cannot be updated or deleted from the client.
- Confirm `training_signals/{uid}_{feedbackId}` is created by the function.

Cycle phase:

- Try writing `private/cycle_phase` without `consents.cycleSync`; it should fail.
- Enable `consents.cycleSync`.
- Write only the phase label, not raw cycle logs.

Calendar:

- Try writing `calendar_cache` without Pro or consent; it should fail.
- Set Pro via backend/RevenueCat and enable `consents.calendarSync`.
- Confirm calendar cache writes work.

Subscription:

- Send RevenueCat test webhook.
- Confirm client cannot write `users/{uid}.subscription`.
- Confirm function can update subscription state.

KVKK:

- Call `exportUserData`.
- Confirm ZIP is created under `users/{uid}/exports/...`.
- Confirm signed link works.
- Confirm email is sent if SMTP is configured.
- Call `onAccountDelete` for a test user.
- Confirm user subtree, user Storage files, affiliate clicks, training signals, challenge submissions, and Auth user are deleted.

Public data:

- Confirm clients can read `trends`, `brands`, `capsule_collections`, and `style_challenges`.
- Confirm clients cannot write those root public collections.

## 12. Production Readiness Checklist

Do not deploy production until all are true:

- Firestore production database is created in `eur3`.
- Staging checklist passes.
- Rules have been tested with at least two users.
- RevenueCat production webhook is ready.
- SMTP production sender is configured.
- App UI uses repositories instead of mock data for the flows you are launching.
- Privacy policy explains Firestore, Storage, RevenueCat, notifications, export, deletion, and cycle phase sync.
- Cycle feature has explicit opt-in UI.
- Account deletion and data export are reachable from app settings or support flow.
- You have a rollback plan.

## 13. Deploy Production

Switch project:

```powershell
firebase.cmd use prod
```

Validate again:

```powershell
flutter analyze
cd functions
npm.cmd run build
cd ..
```

Deploy rules first:

```powershell
firebase.cmd deploy --only firestore,storage
```

Deploy Functions:

```powershell
firebase.cmd deploy --only functions
```

Deploy web hosting only if you are shipping Flutter web:

```powershell
flutter build web
firebase.cmd deploy --only hosting
```

## 14. Post-Deploy Checks

Immediately after production deploy:

```powershell
firebase.cmd functions:list
firebase.cmd functions:log
```

In Firebase Console:

- Confirm Firestore rules are the expected version.
- Confirm Storage rules are the expected version.
- Confirm indexes are building or ready.
- Confirm scheduled functions exist.
- Confirm no function is error-looping.

Create one internal production test account:

- Sign in.
- Confirm profile creation.
- Add one wardrobe item.
- Submit one feedback doc.
- Trigger export.
- Delete the internal test account.

## 15. Rollback

If rules block users unexpectedly:

```powershell
git revert <bad_commit>
firebase.cmd deploy --only firestore,storage
```

If a function breaks:

```powershell
git revert <bad_commit>
firebase.cmd deploy --only functions
```

If production data is affected:

- Disable the related UI remotely if you have a feature flag.
- Disable the RevenueCat webhook if subscription writes are faulty.
- Pause scheduled functions in Google Cloud Console if recommendation jobs are faulty.
- Preserve logs and affected document IDs for investigation.

## Recommended Timeline

1. Make staging live now.
2. Wire app screens to repositories.
3. Complete staging checklist.
4. Deploy production only after export, deletion, subscription, consent, and rules tests pass.
