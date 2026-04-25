import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fashai/src/core/firestore/firestore_operation.dart';
import 'package:fashai/src/core/firestore/firestore_providers.dart';
import 'package:fashai/src/core/result/result.dart';
import 'package:fashai/src/features/trends/data/models/trend.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

abstract interface class TrendRepository {
  Stream<AppResult<List<Trend>>> watchActiveTrends({String region, int limit});
  Future<AppResult<Trend?>> getTrend(String trendId);
}

final trendRepositoryProvider = Provider<TrendRepository>((ref) {
  return FirestoreTrendRepository(ref.watch(firebaseFirestoreProvider));
});

class FirestoreTrendRepository implements TrendRepository {
  const FirestoreTrendRepository(this._firestore);

  final FirebaseFirestore _firestore;

  CollectionReference<Trend> get _trendsRef {
    return _firestore
        .collection('trends')
        .withConverter<Trend>(
          fromFirestore: Trend.fromFirestore,
          toFirestore: (trend, _) => trend.toFirestore(),
        );
  }

  @override
  Stream<AppResult<List<Trend>>> watchActiveTrends({
    String region = 'TR',
    int limit = 20,
  }) {
    return guardFirestoreStream(() {
      return _trendsRef
          .where('region', isEqualTo: region)
          .where('isActive', isEqualTo: true)
          .orderBy('publishedAt', descending: true)
          .limit(limit)
          .snapshots()
          .map(_queryTrends);
    });
  }

  @override
  Future<AppResult<Trend?>> getTrend(String trendId) {
    return guardFirestore(() async {
      final snapshot = await _trendsRef.doc(trendId).get();
      return snapshot.data();
    });
  }

  List<Trend> _queryTrends(QuerySnapshot<Trend> snapshot) {
    return snapshot.docs.map((doc) => doc.data()).toList(growable: false);
  }
}
