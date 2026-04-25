import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fashai/src/core/firestore/firestore_operation.dart';
import 'package:fashai/src/core/firestore/firestore_providers.dart';
import 'package:fashai/src/core/result/result.dart';
import 'package:fashai/src/features/wardrobe/data/models/wardrobe_item.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

abstract interface class WardrobeRepository {
  Stream<AppResult<List<WardrobeItem>>> watchItems(
    String uid, {
    String? category,
    bool? isFavorite,
    bool includeArchived,
    int limit,
  });
  Future<AppResult<List<WardrobeItem>>> getItems(
    String uid, {
    String? category,
    bool includeArchived,
    int limit,
  });
  Future<AppResult<WardrobeItem?>> getItem(String uid, String itemId);
  Future<AppResult<String>> createItem(String uid, WardrobeItem item);
  Future<AppResult<void>> setItem(String uid, WardrobeItem item);
  Future<AppResult<void>> updateItem(String uid, WardrobeItem item);
  Future<AppResult<void>> deleteItem(String uid, String itemId);
}

final wardrobeRepositoryProvider = Provider<WardrobeRepository>((ref) {
  return FirestoreWardrobeRepository(ref.watch(firebaseFirestoreProvider));
});

class FirestoreWardrobeRepository implements WardrobeRepository {
  const FirestoreWardrobeRepository(this._firestore);

  final FirebaseFirestore _firestore;

  CollectionReference<WardrobeItem> _itemsRef(String uid) {
    return _firestore
        .collection('users')
        .doc(uid)
        .collection('wardrobe')
        .withConverter<WardrobeItem>(
          fromFirestore: WardrobeItem.fromFirestore,
          toFirestore: (item, _) => item.toFirestore(),
        );
  }

  @override
  Stream<AppResult<List<WardrobeItem>>> watchItems(
    String uid, {
    String? category,
    bool? isFavorite,
    bool includeArchived = false,
    int limit = 100,
  }) {
    return guardFirestoreStream(() {
      return _buildItemsQuery(
        uid,
        category: category,
        isFavorite: isFavorite,
        includeArchived: includeArchived,
        limit: limit,
      ).snapshots().map(_queryItems);
    });
  }

  @override
  Future<AppResult<List<WardrobeItem>>> getItems(
    String uid, {
    String? category,
    bool includeArchived = false,
    int limit = 100,
  }) {
    return guardFirestore(() async {
      final snapshot = await _buildItemsQuery(
        uid,
        category: category,
        includeArchived: includeArchived,
        limit: limit,
      ).get();
      return _queryItems(snapshot);
    });
  }

  @override
  Future<AppResult<WardrobeItem?>> getItem(String uid, String itemId) {
    return guardFirestore(() async {
      final snapshot = await _itemsRef(uid).doc(itemId).get();
      return snapshot.data();
    });
  }

  @override
  Future<AppResult<String>> createItem(String uid, WardrobeItem item) {
    return guardFirestore(() async {
      final doc = await _itemsRef(uid).add(item);
      return doc.id;
    });
  }

  @override
  Future<AppResult<void>> setItem(String uid, WardrobeItem item) {
    return guardFirestore(() {
      return _itemsRef(uid).doc(item.id).set(item);
    });
  }

  @override
  Future<AppResult<void>> updateItem(String uid, WardrobeItem item) {
    return guardFirestore(() {
      return _itemsRef(uid).doc(item.id).set(item, SetOptions(merge: true));
    });
  }

  @override
  Future<AppResult<void>> deleteItem(String uid, String itemId) {
    return guardFirestore(() {
      return _itemsRef(uid).doc(itemId).delete();
    });
  }

  Query<WardrobeItem> _buildItemsQuery(
    String uid, {
    String? category,
    bool? isFavorite,
    required bool includeArchived,
    required int limit,
  }) {
    Query<WardrobeItem> query = _itemsRef(uid);
    if (!includeArchived) {
      query = query.where('isArchived', isEqualTo: false);
    }
    if (category != null) {
      query = query.where('category', isEqualTo: category);
    }
    if (isFavorite != null) {
      query = query.where('isFavorite', isEqualTo: isFavorite);
    }
    return query.orderBy('updatedAt', descending: true).limit(limit);
  }

  List<WardrobeItem> _queryItems(QuerySnapshot<WardrobeItem> snapshot) {
    return snapshot.docs.map((doc) => doc.data()).toList(growable: false);
  }
}
