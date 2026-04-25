import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fashai/src/core/firestore/firestore_operation.dart';
import 'package:fashai/src/core/firestore/firestore_providers.dart';
import 'package:fashai/src/core/result/result.dart';
import 'package:fashai/src/features/capsules/data/models/capsule_collection.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

abstract interface class CapsuleCollectionRepository {
  Stream<AppResult<List<CapsuleCollection>>> watchActiveCollections({
    String? category,
    int limit,
  });
  Future<AppResult<CapsuleCollection?>> getCollection(String collectionId);
}

final capsuleCollectionRepositoryProvider =
    Provider<CapsuleCollectionRepository>((ref) {
      return FirestoreCapsuleCollectionRepository(
        ref.watch(firebaseFirestoreProvider),
      );
    });

class FirestoreCapsuleCollectionRepository
    implements CapsuleCollectionRepository {
  const FirestoreCapsuleCollectionRepository(this._firestore);

  final FirebaseFirestore _firestore;

  CollectionReference<CapsuleCollection> get _collectionsRef {
    return _firestore
        .collection('capsule_collections')
        .withConverter<CapsuleCollection>(
          fromFirestore: CapsuleCollection.fromFirestore,
          toFirestore: (collection, _) => collection.toFirestore(),
        );
  }

  @override
  Stream<AppResult<List<CapsuleCollection>>> watchActiveCollections({
    String? category,
    int limit = 20,
  }) {
    return guardFirestoreStream(() {
      Query<CapsuleCollection> query = _collectionsRef.where(
        'isActive',
        isEqualTo: true,
      );
      if (category != null) {
        query = query.where('category', isEqualTo: category);
      }
      return query
          .orderBy('sortOrder')
          .limit(limit)
          .snapshots()
          .map(_queryCollections);
    });
  }

  @override
  Future<AppResult<CapsuleCollection?>> getCollection(String collectionId) {
    return guardFirestore(() async {
      final snapshot = await _collectionsRef.doc(collectionId).get();
      return snapshot.data();
    });
  }

  List<CapsuleCollection> _queryCollections(
    QuerySnapshot<CapsuleCollection> snapshot,
  ) {
    return snapshot.docs.map((doc) => doc.data()).toList(growable: false);
  }
}
