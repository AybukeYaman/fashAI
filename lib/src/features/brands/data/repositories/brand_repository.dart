import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fashai/src/core/firestore/firestore_operation.dart';
import 'package:fashai/src/core/firestore/firestore_providers.dart';
import 'package:fashai/src/core/result/result.dart';
import 'package:fashai/src/features/brands/data/models/brand.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

abstract interface class BrandRepository {
  Stream<AppResult<List<Brand>>> watchActiveBrands({int limit});
  Future<AppResult<Brand?>> getBrand(String brandId);
}

final brandRepositoryProvider = Provider<BrandRepository>((ref) {
  return FirestoreBrandRepository(ref.watch(firebaseFirestoreProvider));
});

class FirestoreBrandRepository implements BrandRepository {
  const FirestoreBrandRepository(this._firestore);

  final FirebaseFirestore _firestore;

  CollectionReference<Brand> get _brandsRef {
    return _firestore
        .collection('brands')
        .withConverter<Brand>(
          fromFirestore: Brand.fromFirestore,
          toFirestore: (brand, _) => brand.toFirestore(),
        );
  }

  @override
  Stream<AppResult<List<Brand>>> watchActiveBrands({int limit = 100}) {
    return guardFirestoreStream(() {
      return _brandsRef
          .where('isActive', isEqualTo: true)
          .orderBy('name')
          .limit(limit)
          .snapshots()
          .map(_queryBrands);
    });
  }

  @override
  Future<AppResult<Brand?>> getBrand(String brandId) {
    return guardFirestore(() async {
      final snapshot = await _brandsRef.doc(brandId).get();
      return snapshot.data();
    });
  }

  List<Brand> _queryBrands(QuerySnapshot<Brand> snapshot) {
    return snapshot.docs.map((doc) => doc.data()).toList(growable: false);
  }
}
