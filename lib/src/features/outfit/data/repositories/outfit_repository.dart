import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fashai/src/core/firestore/firestore_operation.dart';
import 'package:fashai/src/core/firestore/firestore_providers.dart';
import 'package:fashai/src/core/result/result.dart';
import 'package:fashai/src/features/outfit/data/models/outfit.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

abstract interface class OutfitRepository {
  Stream<AppResult<List<Outfit>>> watchOutfits(
    String uid, {
    bool includeArchived,
    bool? isFavorite,
    int limit,
  });
  Future<AppResult<Outfit?>> getOutfit(String uid, String outfitId);
  Future<AppResult<String>> createOutfit(String uid, Outfit outfit);
  Future<AppResult<void>> setOutfit(String uid, Outfit outfit);
  Future<AppResult<void>> updateOutfit(String uid, Outfit outfit);
  Future<AppResult<void>> deleteOutfit(String uid, String outfitId);
}

final outfitRepositoryProvider = Provider<OutfitRepository>((ref) {
  return FirestoreOutfitRepository(ref.watch(firebaseFirestoreProvider));
});

class FirestoreOutfitRepository implements OutfitRepository {
  const FirestoreOutfitRepository(this._firestore);

  final FirebaseFirestore _firestore;

  CollectionReference<Outfit> _outfitsRef(String uid) {
    return _firestore
        .collection('users')
        .doc(uid)
        .collection('outfits')
        .withConverter<Outfit>(
          fromFirestore: Outfit.fromFirestore,
          toFirestore: (outfit, _) => outfit.toFirestore(),
        );
  }

  @override
  Stream<AppResult<List<Outfit>>> watchOutfits(
    String uid, {
    bool includeArchived = false,
    bool? isFavorite,
    int limit = 50,
  }) {
    return guardFirestoreStream(() {
      return _buildOutfitsQuery(
        uid,
        includeArchived: includeArchived,
        isFavorite: isFavorite,
        limit: limit,
      ).snapshots().map(_queryOutfits);
    });
  }

  @override
  Future<AppResult<Outfit?>> getOutfit(String uid, String outfitId) {
    return guardFirestore(() async {
      final snapshot = await _outfitsRef(uid).doc(outfitId).get();
      return snapshot.data();
    });
  }

  @override
  Future<AppResult<String>> createOutfit(String uid, Outfit outfit) {
    return guardFirestore(() async {
      final doc = await _outfitsRef(uid).add(outfit);
      return doc.id;
    });
  }

  @override
  Future<AppResult<void>> setOutfit(String uid, Outfit outfit) {
    return guardFirestore(() {
      return _outfitsRef(uid).doc(outfit.id).set(outfit);
    });
  }

  @override
  Future<AppResult<void>> updateOutfit(String uid, Outfit outfit) {
    return guardFirestore(() {
      return _outfitsRef(
        uid,
      ).doc(outfit.id).set(outfit, SetOptions(merge: true));
    });
  }

  @override
  Future<AppResult<void>> deleteOutfit(String uid, String outfitId) {
    return guardFirestore(() {
      return _outfitsRef(uid).doc(outfitId).delete();
    });
  }

  Query<Outfit> _buildOutfitsQuery(
    String uid, {
    required bool includeArchived,
    bool? isFavorite,
    required int limit,
  }) {
    Query<Outfit> query = _outfitsRef(uid);
    if (!includeArchived) {
      query = query.where('isArchived', isEqualTo: false);
    }
    if (isFavorite != null) {
      query = query.where('isFavorite', isEqualTo: isFavorite);
    }
    return query.orderBy('createdAt', descending: true).limit(limit);
  }

  List<Outfit> _queryOutfits(QuerySnapshot<Outfit> snapshot) {
    return snapshot.docs.map((doc) => doc.data()).toList(growable: false);
  }
}
