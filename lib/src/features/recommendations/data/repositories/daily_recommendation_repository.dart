import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fashai/src/core/firestore/firestore_operation.dart';
import 'package:fashai/src/core/firestore/firestore_providers.dart';
import 'package:fashai/src/core/result/result.dart';
import 'package:fashai/src/features/recommendations/data/models/daily_recommendation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

abstract interface class DailyRecommendationRepository {
  Stream<AppResult<DailyRecommendation?>> watchForDate(
    String uid,
    String dateKey,
  );
  Future<AppResult<DailyRecommendation?>> getForDate(
    String uid,
    String dateKey,
  );
  Future<AppResult<List<DailyRecommendation>>> getRecent(
    String uid, {
    int limit,
  });
}

final dailyRecommendationRepositoryProvider =
    Provider<DailyRecommendationRepository>((ref) {
      return FirestoreDailyRecommendationRepository(
        ref.watch(firebaseFirestoreProvider),
      );
    });

class FirestoreDailyRecommendationRepository
    implements DailyRecommendationRepository {
  const FirestoreDailyRecommendationRepository(this._firestore);

  final FirebaseFirestore _firestore;

  CollectionReference<DailyRecommendation> _recommendationsRef(String uid) {
    return _firestore
        .collection('users')
        .doc(uid)
        .collection('recommendations')
        .withConverter<DailyRecommendation>(
          fromFirestore: DailyRecommendation.fromFirestore,
          toFirestore: (recommendation, _) => recommendation.toFirestore(),
        );
  }

  @override
  Stream<AppResult<DailyRecommendation?>> watchForDate(
    String uid,
    String dateKey,
  ) {
    return guardFirestoreStream(() {
      return _recommendationsRef(
        uid,
      ).doc(dateKey).snapshots().map((snapshot) => snapshot.data());
    });
  }

  @override
  Future<AppResult<DailyRecommendation?>> getForDate(
    String uid,
    String dateKey,
  ) {
    return guardFirestore(() async {
      final snapshot = await _recommendationsRef(uid).doc(dateKey).get();
      return snapshot.data();
    });
  }

  @override
  Future<AppResult<List<DailyRecommendation>>> getRecent(
    String uid, {
    int limit = 14,
  }) {
    return guardFirestore(() async {
      final snapshot = await _recommendationsRef(
        uid,
      ).orderBy('dateKey', descending: true).limit(limit).get();
      return snapshot.docs.map((doc) => doc.data()).toList(growable: false);
    });
  }
}
