# Combime Firestore Schema

Last updated: 2026-04-25

This document describes the Firestore data model, access patterns, KVKK handling, and MVP cost profile for Combime.

## Deployment Assumptions

- Firestore database location: `eur3` multi-region Europe for KVKK data residency.
- Cloud Functions region: `europe-west1`. Cloud Functions uses regional names, not Firestore multi-region names.
- Client field naming: `camelCase`.
- Timestamps: Firestore `Timestamp`, written in UTC.
- Max nesting: no path goes beyond one subcollection under a document.
- Client SDK: Flutter Firestore with offline persistence enabled in `lib/main.dart`.
- Firestore Rules: `firestore.rules`.
- Storage Rules: `storage.rules`.
- Indexes: `firestore.indexes.json`.

## Schema Tree

```text
users/{uid}
  wardrobe/{itemId}
  outfits/{outfitId}
  recommendations/{yyyy-MM-dd}
  feedback/{feedbackId}
  calendar_cache/{eventId}
  notifications/{notificationId}
  private/cycle_phase

style_challenges/{challengeId}
  submissions/{submissionId}

capsule_collections/{collectionId}
affiliate_clicks/{clickId}
trends/{trendId}
brands/{brandId}
training_signals/{signalId}
```

Storage paths:

```text
users/{uid}/...
capsule_collections/...
brands/...
```

## Access Model

- `users/{uid}` and all user subcollections are owner-only.
- `users/{uid}.subscription` and `users/{uid}.aggregates` are backend-managed.
- Public catalog collections are client read-only: `trends`, `brands`, `capsule_collections`, `style_challenges`.
- `style_challenges/{challengeId}/submissions` is public-read; authenticated users can create their own submission only.
- `feedback` is append-only from clients.
- `calendar_cache` writes require Pro subscription and `consents.calendarSync == true`.
- `private/cycle_phase` writes require `consents.cycleSync == true`.
- `affiliate_clicks` creation requires `consents.affiliateTracking == true`; clients cannot read these docs.
- `training_signals` is backend-only.

## Collection Reference

### `users/{uid}`

KVKK classification: personal. Contains direct identifiers, preferences, consent, subscription, and aggregate wardrobe counts.

Purpose: one direct profile read for app boot and Today screen personalization.

Access: owner can read; owner can update client-editable profile fields; Cloud Functions writes subscription and aggregates.

Fields:

| Field | Type | Nullable | Notes |
| --- | --- | --- | --- |
| `uid` | string | no | Must match document ID. |
| `displayName` | string | yes | Auth display name or user edit. |
| `email` | string | yes | Auth email. Client create only; backend source of truth is Auth. |
| `photoUrl` | string | yes | Profile image URL. |
| `locale` | string | yes | Example: `tr-TR`. |
| `timezone` | string | yes | Defaults to `Europe/Istanbul`. |
| `birthYear` | int | yes | Lower-risk age approximation, not full date of birth. |
| `gender` | string | yes | Optional profile field. |
| `stylePreferences` | list<string> | no | User-selected and feedback-adjusted style tags. |
| `colorAnalysis` | map | yes | Seasonal palette result. |
| `colorAnalysis.season` | string | yes | Example: `deepWinter`. |
| `colorAnalysis.undertone` | string | yes | Example: `cool`. |
| `colorAnalysis.contrast` | string | yes | Example: `high`. |
| `colorAnalysis.paletteHex` | list<string> | no | Recommended color swatches. |
| `colorAnalysis.analyzedAt` | timestamp | yes | UTC. |
| `consents` | map | no | Consent flags. |
| `consents.cycleSync` | bool | no | Required for cycle phase sync. |
| `consents.calendarSync` | bool | no | Required for calendar cache writes. |
| `consents.personalization` | bool | no | Required for scheduled recommendation generation. |
| `consents.marketing` | bool | no | Marketing opt-in. |
| `consents.affiliateTracking` | bool | no | Required for affiliate click writes. |
| `consents.notifications` | bool | no | Notification opt-in. |
| `subscription` | map | no | Backend-managed RevenueCat state. |
| `subscription.status` | string | no | `free`, `active`, `trialing`, `expired`, `billingIssue`. |
| `subscription.isPro` | bool | no | Pro entitlement flag. |
| `subscription.entitlementId` | string | yes | RevenueCat entitlement. |
| `subscription.productId` | string | yes | RevenueCat product ID. |
| `subscription.revenueCatCustomerId` | string | yes | Usually same as Firebase UID. |
| `subscription.currentPeriodEndsAt` | timestamp | yes | UTC. |
| `subscription.willRenew` | bool | yes | Renewal intent. |
| `subscription.updatedAt` | timestamp | yes | UTC. |
| `aggregates.totalWardrobeItems` | int | no | Backend-updated count. |
| `aggregates.itemsByCategory` | map<string,int> | no | Backend-updated category counts. |
| `aggregates.outfitCount` | int | no | Reserved aggregate. |
| `aggregates.feedbackCount` | int | no | Backend incremented on feedback create. |
| `notificationSettings` | map | no | Client-editable notification preferences. |
| `createdAt` | timestamp | no | UTC. |
| `updatedAt` | timestamp | no | UTC. |
| `lastActiveAt` | timestamp | yes | UTC. |

### `users/{uid}/wardrobe/{itemId}`

KVKK classification: personal. Clothing photos and metadata can reveal habits, body-related information, and lifestyle.

Purpose: offline-first digital wardrobe browsing and recommendation input.

Access: owner read/write/delete. Writes are validated by `isValidWardrobeItem()`.

Fields:

| Field | Type | Nullable | Notes |
| --- | --- | --- | --- |
| `name` | string | no | User-visible item name. |
| `category` | string | no | Example: `tops`, `bottoms`, `dresses`. |
| `colors` | list<string> | no | Hex colors or normalized color labels. |
| `tags` | list<string> | no | Style/material/occasion tags. |
| `imageUrl` | string | no | Storage download URL or CDN URL. |
| `storagePath` | string | no | Storage object path under `users/{uid}/...`. |
| `brand` | string | yes | Optional user-provided brand. |
| `size` | string | yes | Optional; personal data. |
| `material` | string | yes | Optional. |
| `season` | string | yes | Optional seasonal fit. |
| `notes` | string | yes | Optional private notes. |
| `detectedLabels` | list<string> | no | YOLO/computer vision labels. |
| `detectionConfidence` | number | yes | Model confidence. |
| `wearCount` | int | no | Incremented when worn. |
| `lastWornAt` | timestamp | yes | UTC. |
| `isFavorite` | bool | no | User flag. |
| `isArchived` | bool | no | Soft-hide flag. |
| `createdAt` | timestamp | no | UTC. |
| `updatedAt` | timestamp | no | UTC. |

Primary queries:

- Active wardrobe ordered by `updatedAt`.
- Active wardrobe by `category`.
- Active favorites.
- Active wardrobe by tag.
- Least-worn active items.

### `users/{uid}/outfits/{outfitId}`

KVKK classification: personal.

Purpose: saved/worn outfit history. Outfit docs embed item snapshots so historical outfits still render if wardrobe items are edited or deleted.

Access: owner read/write/delete.

Fields:

| Field | Type | Nullable | Notes |
| --- | --- | --- | --- |
| `title` | string | no | User-facing outfit title. |
| `description` | string | yes | Optional. |
| `occasion` | string | yes | Example: `office`, `dateNight`. |
| `wardrobeSnapshots` | list<map> | no | Embedded wardrobe item snapshots. |
| `wardrobeSnapshots[].id` | string | no | Original wardrobe item ID. |
| `wardrobeSnapshots[].name` | string | no | Captured item name. |
| `wardrobeSnapshots[].category` | string | no | Captured category. |
| `wardrobeSnapshots[].colors` | list<string> | no | Captured colors. |
| `wardrobeSnapshots[].tags` | list<string> | no | Captured tags. |
| `wardrobeSnapshots[].imageUrl` | string | no | Captured image URL. |
| `wardrobeSnapshots[].storagePath` | string | yes | Captured storage path. |
| `wardrobeSnapshots[].brand` | string | yes | Captured brand. |
| `wardrobeSnapshots[].size` | string | yes | Captured size. |
| `wardrobeSnapshots[].capturedAt` | timestamp | no | UTC snapshot time. |
| `itemIds` | list<string> | no | Back-reference IDs for analytics. |
| `imageUrl` | string | yes | Optional composite image. |
| `reason` | string | yes | Recommendation explanation. |
| `sourceRecommendationId` | string | yes | Date key or generated recommendation ID. |
| `localDate` | string | yes | `YYYY-MM-DD`. |
| `wornAt` | timestamp | yes | UTC. |
| `isFavorite` | bool | no | User flag. |
| `isArchived` | bool | no | Soft-hide flag. |
| `createdAt` | timestamp | no | UTC. |
| `updatedAt` | timestamp | no | UTC. |

### `users/{uid}/recommendations/{yyyy-MM-dd}`

KVKK classification: personal. Contains derived preferences and context snapshots.

Purpose: Today screen single direct read. The document ID is the user's local date key, for example `2026-04-25`.

Access: owner read-only from client; backend writes via scheduled generator.

Fields:

| Field | Type | Nullable | Notes |
| --- | --- | --- | --- |
| `dateKey` | string | no | Same as document ID. |
| `timezone` | string | no | User timezone used for date key. |
| `status` | string | no | `pending`, `generated`, or `failed`. |
| `outfits` | list<map> | no | Usually 3 generated outfits/day. |
| `outfits[].id` | string | no | Stable generated option ID. |
| `outfits[].title` | string | no | User-facing title. |
| `outfits[].description` | string | yes | Optional. |
| `outfits[].occasion` | string | yes | Occasion category. |
| `outfits[].itemIds` | list<string> | no | Wardrobe IDs used. |
| `outfits[].wardrobeSnapshots` | list<map> | no | Embedded snapshots for rendering. |
| `outfits[].reason` | string | no | LLM explanation. |
| `outfits[].imageUrl` | string | yes | Optional generated/composite image. |
| `outfits[].confidence` | number | yes | Engine confidence. |
| `outfits[].tags` | list<string> | no | Style tags. |
| `weather` | map | yes | Weather snapshot. |
| `weather.city` | string | yes | City label. |
| `weather.condition` | string | yes | Weather condition. |
| `weather.temperatureC` | number | yes | Celsius. |
| `weather.minTemperatureC` | number | yes | Celsius. |
| `weather.maxTemperatureC` | number | yes | Celsius. |
| `weather.precipitationChance` | number | yes | 0.0-1.0. |
| `weather.capturedAt` | timestamp | yes | UTC. |
| `context` | map | yes | Recommendation context. |
| `context.mood` | string | yes | Optional user mood. |
| `context.cyclePhase` | string | yes | Current synced phase only. |
| `context.calendarEventTypes` | list<string> | no | Event types, not raw event details. |
| `context.stylePreferences` | list<string> | no | Snapshot of style inputs. |
| `selectedOutfitId` | string | yes | Chosen outfit option. |
| `feedbackSubmitted` | bool | no | UI state. |
| `modelVersion` | string | yes | Engine version. |
| `failureReason` | string | yes | Backend-only failure reason. |
| `generatedAt` | timestamp | no | UTC. |
| `expiresAt` | timestamp | yes | Optional. |
| `createdAt` | timestamp | no | UTC. |
| `updatedAt` | timestamp | no | UTC. |

### `users/{uid}/feedback/{feedbackId}`

KVKK classification: personal.

Purpose: append-only audit trail for recommendation learning.

Access: owner read/create; no client update/delete.

Fields:

| Field | Type | Nullable | Notes |
| --- | --- | --- | --- |
| `userId` | string | yes | If present, must equal owner UID. |
| `outfitId` | string | no | Outfit or recommendation option ID. |
| `recommendationId` | string | yes | Related recommendation doc. |
| `recommendationDate` | string | yes | `YYYY-MM-DD`. |
| `rating` | int | no | 1-5. |
| `woreIt` | bool | no | Whether user wore it. |
| `selectedItemIds` | list<string> | no | Items included in feedback. |
| `notes` | string | yes | Optional private note. |
| `source` | string | yes | Example: `today`, `history`. |
| `createdAt` | timestamp | no | UTC. |

Backend effect: `onFeedbackCreate` writes `training_signals/{uid}_{feedbackId}` and increments `users/{uid}.aggregates.feedbackCount`.

### `users/{uid}/calendar_cache/{eventId}`

KVKK classification: sensitive when event title/location can reveal health, religion, union, political, or private-life context. Minimize stored title/location.

Purpose: Pro-only cached calendar context for recommendations.

Access: owner read; owner write only when Pro and `consents.calendarSync == true`.

Fields:

| Field | Type | Nullable | Notes |
| --- | --- | --- | --- |
| `calendarId` | string | yes | Provider calendar ID. |
| `externalEventId` | string | yes | Provider event ID. |
| `title` | string | yes | Store only if needed. Prefer event type. |
| `eventType` | string | no | Normalized type such as `work`, `date`, `gym`. |
| `startAt` | timestamp | no | UTC. |
| `endAt` | timestamp | no | UTC. |
| `isAllDay` | bool | no | All-day marker. |
| `locationLabel` | string | yes | Avoid exact addresses when possible. |
| `source` | string | no | Example: `googleCalendar`. |
| `createdAt` | timestamp | no | UTC. |
| `updatedAt` | timestamp | no | UTC. |

### `users/{uid}/notifications/{notificationId}`

KVKK classification: personal.

Purpose: in-app inbox with backend-created messages.

Access: owner read; backend create; owner may update read state or delete.

Fields:

| Field | Type | Nullable | Notes |
| --- | --- | --- | --- |
| `title` | string | no | User-facing text. Localize in backend/client before display where possible. |
| `body` | string | no | User-facing text. |
| `type` | string | no | Example: `dailyRecommendation`, `challenge`. |
| `deepLink` | string | yes | Internal route. |
| `imageUrl` | string | yes | Optional. |
| `payload` | map | no | Typed payload for navigation. |
| `isRead` | bool | no | Client-updatable. |
| `readAt` | timestamp | yes | UTC. |
| `createdAt` | timestamp | no | UTC. |
| `updatedAt` | timestamp | no | UTC. |

### `users/{uid}/private/cycle_phase`

KVKK classification: sensitive health-adjacent data. Raw cycle logs never sync to Firestore.

Purpose: opt-in current phase label for recommendations.

Access: owner read/write/delete only when `consents.cycleSync == true` for writes.

Fields:

| Field | Type | Nullable | Notes |
| --- | --- | --- | --- |
| `phase` | string | no | One of `menstrual`, `follicular`, `ovulation`, `luteal`. |
| `syncedAt` | timestamp | no | UTC. |
| `updatedAt` | timestamp | no | UTC. |
| `consentVersion` | string | yes | Version of consent text accepted. |
| `source` | string | yes | Example: `encryptedLocalSqlite`. |

### `style_challenges/{challengeId}`

KVKK classification: public.

Purpose: public challenge definitions for post-MVP social features.

Access: public read; backend/admin write.

Fields:

| Field | Type | Nullable | Notes |
| --- | --- | --- | --- |
| `title` | string | no | Public title. |
| `description` | string | yes | Public description. |
| `theme` | string | yes | Challenge theme. |
| `coverImageUrl` | string | yes | Public asset. |
| `tags` | list<string> | no | Public tags. |
| `startsAt` | timestamp | no | UTC. |
| `endsAt` | timestamp | no | UTC. |
| `isActive` | bool | no | Public listing filter. |
| `sortOrder` | int | no | Admin ordering. |
| `createdAt` | timestamp | no | UTC. |
| `updatedAt` | timestamp | no | UTC. |

### `style_challenges/{challengeId}/submissions/{submissionId}`

KVKK classification: personal/public. Submission content is public, but `userId` links it to a person.

Purpose: public social challenge submissions and leaderboards.

Access: public read; authenticated users create their own submission; no client update/delete.

Fields:

| Field | Type | Nullable | Notes |
| --- | --- | --- | --- |
| `userId` | string | no | Creator UID. |
| `outfitId` | string | yes | User outfit reference. |
| `outfitSnapshot` | map | no | Public snapshot for rendering. |
| `outfitSnapshot.title` | string | no | Captured outfit title. |
| `outfitSnapshot.imageUrl` | string | yes | Public submission image. |
| `outfitSnapshot.itemIds` | list<string> | no | Original item IDs. |
| `outfitSnapshot.wardrobeSnapshots` | list<map> | no | Captured item display data. |
| `caption` | string | yes | User caption. |
| `photoUrl` | string | yes | Public photo. |
| `score` | int | no | Backend-controlled. |
| `voteCount` | int | no | Backend-controlled. |
| `createdAt` | timestamp | no | UTC. |
| `updatedAt` | timestamp | no | UTC. |

### `capsule_collections/{collectionId}`

KVKK classification: public.

Purpose: branded capsule collections and affiliate inventory.

Access: public read; backend/admin write.

Fields:

| Field | Type | Nullable | Notes |
| --- | --- | --- | --- |
| `title` | string | no | Collection title. |
| `subtitle` | string | yes | Optional. |
| `description` | string | yes | Optional. |
| `brandId` | string | yes | Related brand. |
| `category` | string | yes | Public filter. |
| `region` | string | yes | Example: `TR`. |
| `coverImageUrl` | string | yes | Public asset. |
| `heroImageUrl` | string | yes | Public asset. |
| `tags` | list<string> | no | Public tags. |
| `items` | list<map> | no | Embedded capsule items for one-read rendering. |
| `items[].id` | string | no | Item ID. |
| `items[].brandId` | string | yes | Brand. |
| `items[].name` | string | no | Product name. |
| `items[].category` | string | no | Product category. |
| `items[].imageUrl` | string | yes | Public image. |
| `items[].productUrl` | string | yes | Affiliate target. |
| `items[].priceTry` | number | yes | TRY price snapshot. |
| `items[].currency` | string | no | Defaults to `TRY`. |
| `items[].affiliateEnabled` | bool | no | Click tracking eligibility. |
| `items[].colorHex` | string | yes | Color swatch. |
| `items[].tags` | list<string> | no | Public tags. |
| `itemCount` | int | no | Display count. |
| `isActive` | bool | no | Public filter. |
| `sortOrder` | int | no | Public ordering. |
| `publishedAt` | timestamp | yes | UTC. |
| `createdAt` | timestamp | no | UTC. |
| `updatedAt` | timestamp | no | UTC. |

### `affiliate_clicks/{clickId}`

KVKK classification: personal analytics.

Purpose: commission attribution and funnel analytics.

Access: authenticated create only when `consents.affiliateTracking == true`; client cannot read.

Fields:

| Field | Type | Nullable | Notes |
| --- | --- | --- | --- |
| `userId` | string | no | Must match caller UID. |
| `brandId` | string | no | Clicked brand. |
| `capsuleCollectionId` | string | yes | Related collection. |
| `itemId` | string | yes | Related capsule item. |
| `targetUrl` | string | no | Affiliate target. |
| `utm` | map<string,string> | no | Campaign metadata. |
| `deviceLocale` | string | yes | Example: `tr-TR`. |
| `createdAt` | timestamp | no | UTC. |

### `trends/{trendId}`

KVKK classification: public.

Purpose: regional fashion trend catalog.

Access: public read; backend/admin write.

Fields:

| Field | Type | Nullable | Notes |
| --- | --- | --- | --- |
| `title` | string | no | Public title. |
| `description` | string | yes | Optional. |
| `region` | string | no | Example: `TR`. |
| `season` | string | yes | Example: `spring2026`. |
| `category` | string | yes | Trend category. |
| `tags` | list<string> | no | Public tags. |
| `imageUrl` | string | yes | Public image. |
| `sourceUrl` | string | yes | Editorial/source URL. |
| `score` | number | yes | Ranking score. |
| `isActive` | bool | no | Public filter. |
| `publishedAt` | timestamp | yes | UTC. |
| `createdAt` | timestamp | no | UTC. |
| `updatedAt` | timestamp | no | UTC. |

### `brands/{brandId}`

KVKK classification: public.

Purpose: brand catalog for capsules and affiliate experiences.

Access: public read; backend/admin write.

Fields:

| Field | Type | Nullable | Notes |
| --- | --- | --- | --- |
| `name` | string | no | Brand name. |
| `slug` | string | yes | URL-safe slug. |
| `description` | string | yes | Public description. |
| `logoUrl` | string | yes | Public Storage asset. |
| `websiteUrl` | string | yes | Public website. |
| `country` | string | yes | Example: `TR`. |
| `categories` | list<string> | no | Product categories. |
| `isActive` | bool | no | Public filter. |
| `affiliateEnabled` | bool | no | Whether affiliate links are active. |
| `createdAt` | timestamp | no | UTC. |
| `updatedAt` | timestamp | no | UTC. |

### `training_signals/{signalId}`

KVKK classification: personal derived data.

Purpose: backend-only recommender training input derived from feedback.

Access: backend only.

Fields:

| Field | Type | Nullable | Notes |
| --- | --- | --- | --- |
| `userId` | string | no | UID. |
| `feedbackId` | string | no | Source feedback ID. |
| `signalType` | string | no | Example: `outfit_feedback`. |
| `outfitId` | string | no | Outfit ID. |
| `recommendationId` | string | yes | Source recommendation. |
| `recommendationDate` | string | yes | `YYYY-MM-DD`. |
| `rating` | int | no | 1-5. |
| `woreIt` | bool | no | Whether user wore it. |
| `selectedItemIds` | list<string> | no | Items involved. |
| `source` | string | yes | Feedback source. |
| `createdAt` | timestamp | no | Source feedback time. |
| `loggedAt` | timestamp | no | Backend write time. |

## Denormalization Decisions

- `users/{uid}.subscription` is embedded in the profile document so app boot and Pro gating need one profile read instead of a separate subscription read. Clients cannot write this map.
- `users/{uid}.aggregates` is embedded for profile dashboards and wardrobe counts without collection scans. Cloud Functions update these values.
- `recommendations/{yyyy-MM-dd}` uses a natural date key so the Today screen can load via one direct document read.
- `recommendations/{date}.outfits[]` embeds wardrobe snapshots so the Today screen needs no wardrobe reads.
- `outfits/{outfitId}.wardrobeSnapshots[]` embeds item snapshots so historical outfits survive item deletion or edits.
- `capsule_collections/{collectionId}.items[]` embeds public capsule items because collections are small editorial bundles and should render in one read.
- Root `affiliate_clicks` is denormalized with `userId`, `brandId`, and optional `capsuleCollectionId` for analytics queries without reading user subtrees.
- Root `training_signals` is denormalized for recommender jobs and is deleted during account deletion.

## KVKK Deletion Flow

Callable: `onAccountDelete`.

Deleted:

- `users/{uid}` recursively, including:
  - `wardrobe`
  - `outfits`
  - `recommendations`
  - `feedback`
  - `calendar_cache`
  - `notifications`
  - `private/cycle_phase`
- Storage files under `users/{uid}/`.
- Root `affiliate_clicks` where `userId == uid`.
- Root `training_signals` where `userId == uid`.
- `style_challenges/*/submissions` where `userId == uid`.
- Firebase Auth user record.

Anonymized:

- No Firestore user documents are anonymized in the current implementation. Personal root documents are deleted instead of retained.
- Aggregated business metrics outside this schema may be retained only if they are irreversibly aggregated and no longer identify the user.

Operational notes:

- Public catalog docs are not deleted because they do not contain user data.
- Challenge submissions are deleted rather than anonymized because outfit snapshots and photos may contain personal wardrobe data.
- Cloud logs are subject to Google Cloud log retention and should not include raw sensitive payloads.

## KVKK Export Flow

Callable: `exportUserData`.

Process:

1. Caller must be authenticated and must request their own UID unless they have an admin custom claim.
2. Backend collects Firestore documents into JSON.
3. Backend writes a ZIP archive to `users/{uid}/exports/export-{timestamp}.zip`.
4. Backend creates a signed Storage URL.
5. Backend emails the signed URL when SMTP environment variables are configured.

Exported data:

- `users/{uid}`
- `users/{uid}/wardrobe`
- `users/{uid}/outfits`
- `users/{uid}/recommendations`
- `users/{uid}/feedback`
- `users/{uid}/calendar_cache`
- `users/{uid}/notifications`
- `users/{uid}/private`
- `affiliate_clicks` where `userId == uid`
- `training_signals` where `userId == uid`
- `style_challenges/*/submissions` where `userId == uid`

Format:

- ZIP containing one JSON file named `combime-user-export-{uid}.json`.
- Firestore timestamps are serialized as ISO-8601 UTC strings.
- Document references are serialized as document paths.
- GeoPoints are serialized as `{latitude, longitude}`.

## Query and Index Map

The composite index file covers these query patterns:

| Query | Index fields |
| --- | --- |
| Active wardrobe by recent update | `isArchived ASC`, `createdAt DESC` or `updatedAt DESC` |
| Active wardrobe by category | `isArchived ASC`, `category ASC`, `updatedAt DESC` |
| Favorite wardrobe | `isArchived ASC`, `isFavorite ASC`, `updatedAt DESC` |
| Wardrobe tag filter | `isArchived ASC`, `tags ARRAY_CONTAINS`, `updatedAt DESC` |
| Least-worn wardrobe | `isArchived ASC`, `wearCount ASC` |
| Outfit history | `isArchived ASC`, `createdAt DESC` |
| Favorite outfits | `isArchived ASC`, `isFavorite ASC`, `createdAt DESC` |
| Feedback history | `recommendationDate DESC`, `createdAt DESC` |
| Outfit feedback lookup | `outfitId ASC`, `createdAt DESC` |
| Calendar range/type queries | `startAt ASC`, `endAt ASC`; `eventType ASC`, `startAt ASC` |
| Unread notifications | `isRead ASC`, `createdAt DESC` |
| Recommendation maintenance | collection group `dateKey ASC`, `generatedAt DESC` |
| Challenge submissions | `userId ASC`, `createdAt DESC`; `score DESC`, `createdAt DESC` |
| Active capsule collections | `isActive ASC`, `sortOrder ASC`; optional `category ASC` |
| Regional trends | `region ASC`, `isActive ASC`, `publishedAt DESC` |
| Active brands | `isActive ASC`, `name ASC` |
| Affiliate reporting | `userId ASC`, `createdAt DESC`; `brandId ASC`, `createdAt DESC` |

## Cost Estimate at 1k DAU

Pricing reference checked 2026-04-25:

- Firestore bills reads, writes, deletes, index entry reads, stored data, and network bandwidth.
- Free daily quota for the first/default database: 50,000 reads, 20,000 writes, 20,000 deletes, 1 GiB stored data, and 10 GiB/month outbound transfer.
- The Google Cloud Firestore pricing table for `eur3` lists default operation prices beyond free quota at approximately `$0.03/100k reads`, `$0.09/100k writes`, and `$0.01/100k deletes`.
- Sources: [Firebase Firestore pricing](https://firebase.google.com/docs/firestore/pricing), [Google Cloud Firestore pricing](https://cloud.google.com/firestore/pricing).

MVP usage assumptions per active user per day:

| Activity | Reads | Writes | Deletes |
| --- | ---: | ---: | ---: |
| App boot/profile cache refresh | 1 | 0 | 0 |
| Today screen direct recommendation read | 1 | 0 | 0 |
| Wardrobe browsing, average active docs returned | 20 | 0 | 0 |
| Outfit history/inbox/public catalog browsing | 13 | 0 | 0 |
| Rule-dependent consent/profile reads on gated writes | 2 | 0 | 0 |
| Daily recommendation backend write | 0 | 1 | 0 |
| Feedback create plus training signal and aggregate update | 0 | 3 | 0 |
| Wardrobe add/update amortized plus aggregate refresh | 0 | 1 | 0 |
| Notification read/update amortized | 0 | 0.5 | 0 |
| 90-day recommendation retention after system matures | 0 | 0 | 1 |
| Estimated total | 37 | 5.5 | 1 |

At 1,000 DAU:

| Metric | Daily volume | Free quota impact | Estimated Firestore operation cost |
| --- | ---: | --- | ---: |
| Reads | 37,000/day | Under 50,000/day | `$0.00/day` |
| Writes | 5,500/day | Under 20,000/day | `$0.00/day` |
| Deletes | 1,000/day | Under 20,000/day | `$0.00/day` |
| Stored Firestore data | About 250-500 MiB plus indexes | Under 1 GiB early MVP | `$0.00/month` while under free quota |

Marginal cost before free quota:

- Reads: `37 * $0.03 / 100,000 = $0.0000111` per DAU/day.
- Writes: `5.5 * $0.09 / 100,000 = $0.00000495` per DAU/day.
- Deletes: `1 * $0.01 / 100,000 = $0.00000010` per DAU/day.
- Total operation-only marginal cost: about `$0.000016` per DAU/day, or about `$0.016/day` at 1,000 DAU before free quota.

Exclusions:

- Cloud Storage media costs for wardrobe photos are separate and may dominate if full-resolution images are retained.
- Cloud Functions invocation/CPU/network costs are separate.
- Claude/LLM, weather API, calendar API, FCM, RevenueCat, email, and analytics costs are separate.
- Network egress beyond the monthly free allowance is separate.

Cost control decisions in this schema:

- Today screen is one direct recommendation read plus cached profile.
- Recommendation docs embed the three outfit options and item snapshots.
- Wardrobe browsing uses bounded queries with `limit`.
- No client collection scans for aggregates.
- Old recommendation docs are deleted after 90 days.
- Public capsule collections embed small item lists for one-read rendering.
