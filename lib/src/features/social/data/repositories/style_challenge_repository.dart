import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fashai/src/core/firestore/firestore_operation.dart';
import 'package:fashai/src/core/firestore/firestore_providers.dart';
import 'package:fashai/src/core/result/result.dart';
import 'package:fashai/src/features/social/data/models/style_challenge.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

abstract interface class StyleChallengeRepository {
  Stream<AppResult<List<StyleChallenge>>> watchActiveChallenges({int limit});
  Future<AppResult<StyleChallenge?>> getChallenge(String challengeId);
  Stream<AppResult<List<StyleChallengeSubmission>>> watchSubmissions(
    String challengeId, {
    int limit,
  });
  Future<AppResult<String>> createSubmission(
    String challengeId,
    StyleChallengeSubmission submission,
  );
}

final styleChallengeRepositoryProvider = Provider<StyleChallengeRepository>((
  ref,
) {
  return FirestoreStyleChallengeRepository(
    ref.watch(firebaseFirestoreProvider),
  );
});

class FirestoreStyleChallengeRepository implements StyleChallengeRepository {
  const FirestoreStyleChallengeRepository(this._firestore);

  final FirebaseFirestore _firestore;

  CollectionReference<StyleChallenge> get _challengesRef {
    return _firestore
        .collection('style_challenges')
        .withConverter<StyleChallenge>(
          fromFirestore: StyleChallenge.fromFirestore,
          toFirestore: (challenge, _) => challenge.toFirestore(),
        );
  }

  CollectionReference<StyleChallengeSubmission> _submissionsRef(
    String challengeId,
  ) {
    return _challengesRef
        .doc(challengeId)
        .collection('submissions')
        .withConverter<StyleChallengeSubmission>(
          fromFirestore: StyleChallengeSubmission.fromFirestore,
          toFirestore: (submission, _) => submission.toFirestore(),
        );
  }

  @override
  Stream<AppResult<List<StyleChallenge>>> watchActiveChallenges({
    int limit = 20,
  }) {
    return guardFirestoreStream(() {
      return _challengesRef
          .where('isActive', isEqualTo: true)
          .orderBy('startsAt', descending: true)
          .limit(limit)
          .snapshots()
          .map(_queryChallenges);
    });
  }

  @override
  Future<AppResult<StyleChallenge?>> getChallenge(String challengeId) {
    return guardFirestore(() async {
      final snapshot = await _challengesRef.doc(challengeId).get();
      return snapshot.data();
    });
  }

  @override
  Stream<AppResult<List<StyleChallengeSubmission>>> watchSubmissions(
    String challengeId, {
    int limit = 50,
  }) {
    return guardFirestoreStream(() {
      return _submissionsRef(challengeId)
          .orderBy('score', descending: true)
          .orderBy('createdAt', descending: true)
          .limit(limit)
          .snapshots()
          .map(_querySubmissions);
    });
  }

  @override
  Future<AppResult<String>> createSubmission(
    String challengeId,
    StyleChallengeSubmission submission,
  ) {
    return guardFirestore(() async {
      final doc = await _submissionsRef(challengeId).add(submission);
      return doc.id;
    });
  }

  List<StyleChallenge> _queryChallenges(
    QuerySnapshot<StyleChallenge> snapshot,
  ) {
    return snapshot.docs.map((doc) => doc.data()).toList(growable: false);
  }

  List<StyleChallengeSubmission> _querySubmissions(
    QuerySnapshot<StyleChallengeSubmission> snapshot,
  ) {
    return snapshot.docs.map((doc) => doc.data()).toList(growable: false);
  }
}
