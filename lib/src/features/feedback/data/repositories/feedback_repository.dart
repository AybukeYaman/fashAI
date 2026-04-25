import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fashai/src/core/firestore/firestore_operation.dart';
import 'package:fashai/src/core/firestore/firestore_providers.dart';
import 'package:fashai/src/core/result/result.dart';
import 'package:fashai/src/features/feedback/data/models/outfit_feedback.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

abstract interface class FeedbackRepository {
  Stream<AppResult<List<OutfitFeedback>>> watchFeedback(
    String uid, {
    int limit,
  });
  Future<AppResult<List<OutfitFeedback>>> getFeedback(String uid, {int limit});
  Future<AppResult<String>> createFeedback(String uid, OutfitFeedback feedback);
}

final feedbackRepositoryProvider = Provider<FeedbackRepository>((ref) {
  return FirestoreFeedbackRepository(ref.watch(firebaseFirestoreProvider));
});

class FirestoreFeedbackRepository implements FeedbackRepository {
  const FirestoreFeedbackRepository(this._firestore);

  final FirebaseFirestore _firestore;

  CollectionReference<OutfitFeedback> _feedbackRef(String uid) {
    return _firestore
        .collection('users')
        .doc(uid)
        .collection('feedback')
        .withConverter<OutfitFeedback>(
          fromFirestore: OutfitFeedback.fromFirestore,
          toFirestore: (feedback, _) => feedback.toFirestore(),
        );
  }

  @override
  Stream<AppResult<List<OutfitFeedback>>> watchFeedback(
    String uid, {
    int limit = 50,
  }) {
    return guardFirestoreStream(() {
      return _feedbackRef(uid)
          .orderBy('createdAt', descending: true)
          .limit(limit)
          .snapshots()
          .map(_queryFeedback);
    });
  }

  @override
  Future<AppResult<List<OutfitFeedback>>> getFeedback(
    String uid, {
    int limit = 50,
  }) {
    return guardFirestore(() async {
      final snapshot = await _feedbackRef(
        uid,
      ).orderBy('createdAt', descending: true).limit(limit).get();
      return _queryFeedback(snapshot);
    });
  }

  @override
  Future<AppResult<String>> createFeedback(
    String uid,
    OutfitFeedback feedback,
  ) {
    return guardFirestore(() async {
      final doc = await _feedbackRef(uid).add(feedback);
      return doc.id;
    });
  }

  List<OutfitFeedback> _queryFeedback(QuerySnapshot<OutfitFeedback> snapshot) {
    return snapshot.docs.map((doc) => doc.data()).toList(growable: false);
  }
}
