import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fashai/src/core/firestore/firestore_operation.dart';
import 'package:fashai/src/core/firestore/firestore_providers.dart';
import 'package:fashai/src/core/result/result.dart';
import 'package:fashai/src/features/affiliate/data/models/affiliate_click.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

abstract interface class AffiliateClickRepository {
  Future<AppResult<String>> recordClick(AffiliateClick click);
}

final affiliateClickRepositoryProvider = Provider<AffiliateClickRepository>((
  ref,
) {
  return FirestoreAffiliateClickRepository(
    ref.watch(firebaseFirestoreProvider),
  );
});

class FirestoreAffiliateClickRepository implements AffiliateClickRepository {
  const FirestoreAffiliateClickRepository(this._firestore);

  final FirebaseFirestore _firestore;

  CollectionReference<AffiliateClick> get _clicksRef {
    return _firestore
        .collection('affiliate_clicks')
        .withConverter<AffiliateClick>(
          fromFirestore: AffiliateClick.fromFirestore,
          toFirestore: (click, _) => click.toFirestore(),
        );
  }

  @override
  Future<AppResult<String>> recordClick(AffiliateClick click) {
    return guardFirestore(() async {
      final doc = await _clicksRef.add(click);
      return doc.id;
    });
  }
}
