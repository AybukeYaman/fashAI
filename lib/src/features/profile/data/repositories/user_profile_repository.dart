import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fashai/src/core/firestore/firestore_operation.dart';
import 'package:fashai/src/core/firestore/firestore_providers.dart';
import 'package:fashai/src/core/firestore/firestore_model_utils.dart';
import 'package:fashai/src/core/result/result.dart';
import 'package:fashai/src/features/profile/data/models/user_profile.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

abstract interface class UserProfileRepository {
  Stream<AppResult<UserProfile?>> watchProfile(String uid);
  Future<AppResult<UserProfile?>> getProfile(String uid);
  Future<AppResult<void>> createProfile(UserProfile profile);
  Future<AppResult<void>> updateProfile(UserProfile profile);
  Future<AppResult<void>> updateConsents(String uid, UserConsents consents);
  Future<AppResult<void>> updateStylePreferences(
    String uid,
    List<String> stylePreferences,
  );
  Future<AppResult<void>> updateColorAnalysis(
    String uid,
    ColorAnalysis? colorAnalysis,
  );
}

final userProfileRepositoryProvider = Provider<UserProfileRepository>((ref) {
  return FirestoreUserProfileRepository(ref.watch(firebaseFirestoreProvider));
});

class FirestoreUserProfileRepository implements UserProfileRepository {
  const FirestoreUserProfileRepository(this._firestore);

  final FirebaseFirestore _firestore;

  DocumentReference<UserProfile> _profileRef(String uid) {
    return _firestore
        .collection('users')
        .doc(uid)
        .withConverter<UserProfile>(
          fromFirestore: UserProfile.fromFirestore,
          toFirestore: (profile, _) => profile.toFirestore(),
        );
  }

  DocumentReference<FirestoreJson> _rawProfileRef(String uid) {
    return _firestore.collection('users').doc(uid);
  }

  @override
  Stream<AppResult<UserProfile?>> watchProfile(String uid) {
    return guardFirestoreStream(() {
      return _profileRef(uid).snapshots().map((snapshot) => snapshot.data());
    });
  }

  @override
  Future<AppResult<UserProfile?>> getProfile(String uid) {
    return guardFirestore(() async {
      final snapshot = await _profileRef(uid).get();
      return snapshot.data();
    });
  }

  @override
  Future<AppResult<void>> createProfile(UserProfile profile) {
    return guardFirestore(() {
      return _rawProfileRef(profile.uid).set(_profileCreateData(profile));
    });
  }

  @override
  Future<AppResult<void>> updateProfile(UserProfile profile) {
    return guardFirestore(() {
      return _rawProfileRef(profile.uid).update(_profileUpdateData(profile));
    });
  }

  @override
  Future<AppResult<void>> updateConsents(String uid, UserConsents consents) {
    return guardFirestore(() {
      return _rawProfileRef(uid).update(<String, Object?>{
        'consents': consents.toMap(),
        'updatedAt': timestampFromDate(DateTime.now()),
      });
    });
  }

  @override
  Future<AppResult<void>> updateStylePreferences(
    String uid,
    List<String> stylePreferences,
  ) {
    return guardFirestore(() {
      return _rawProfileRef(uid).update(<String, Object?>{
        'stylePreferences': List<String>.unmodifiable(stylePreferences),
        'updatedAt': timestampFromDate(DateTime.now()),
      });
    });
  }

  @override
  Future<AppResult<void>> updateColorAnalysis(
    String uid,
    ColorAnalysis? colorAnalysis,
  ) {
    return guardFirestore(() {
      return _rawProfileRef(uid).update(<String, Object?>{
        'colorAnalysis': colorAnalysis?.toMap(),
        'updatedAt': timestampFromDate(DateTime.now()),
      });
    });
  }

  FirestoreJson _profileCreateData(UserProfile profile) {
    return <String, Object?>{
      'uid': profile.uid,
      'displayName': profile.displayName,
      'email': profile.email,
      'photoUrl': profile.photoUrl,
      'locale': profile.locale,
      'timezone': profile.timezone,
      'birthYear': profile.birthYear,
      'gender': profile.gender,
      'stylePreferences': profile.stylePreferences,
      'colorAnalysis': profile.colorAnalysis?.toMap(),
      'consents': profile.consents.toMap(),
      'notificationSettings': profile.notificationSettings.toMap(),
      'createdAt': timestampFromDate(profile.createdAt),
      'updatedAt': timestampFromDate(profile.updatedAt),
      'lastActiveAt': optionalTimestampFromDate(profile.lastActiveAt),
    };
  }

  FirestoreJson _profileUpdateData(UserProfile profile) {
    return <String, Object?>{
      'displayName': profile.displayName,
      'photoUrl': profile.photoUrl,
      'locale': profile.locale,
      'timezone': profile.timezone,
      'birthYear': profile.birthYear,
      'gender': profile.gender,
      'stylePreferences': profile.stylePreferences,
      'colorAnalysis': profile.colorAnalysis?.toMap(),
      'consents': profile.consents.toMap(),
      'notificationSettings': profile.notificationSettings.toMap(),
      'updatedAt': timestampFromDate(profile.updatedAt),
      'lastActiveAt': optionalTimestampFromDate(profile.lastActiveAt),
    };
  }
}
