import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fashai/src/core/firestore/firestore_operation.dart';
import 'package:fashai/src/core/firestore/firestore_providers.dart';
import 'package:fashai/src/core/result/result.dart';
import 'package:fashai/src/features/profile/data/models/cycle_phase_sync.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

abstract interface class CyclePhaseRepository {
  Stream<AppResult<CyclePhaseSync?>> watchCyclePhase(String uid);
  Future<AppResult<CyclePhaseSync?>> getCyclePhase(String uid);
  Future<AppResult<void>> setCyclePhase(String uid, CyclePhaseSync phase);
  Future<AppResult<void>> deleteCyclePhase(String uid);
}

final cyclePhaseRepositoryProvider = Provider<CyclePhaseRepository>((ref) {
  return FirestoreCyclePhaseRepository(ref.watch(firebaseFirestoreProvider));
});

class FirestoreCyclePhaseRepository implements CyclePhaseRepository {
  const FirestoreCyclePhaseRepository(this._firestore);

  final FirebaseFirestore _firestore;

  DocumentReference<CyclePhaseSync> _phaseRef(String uid) {
    return _firestore
        .collection('users')
        .doc(uid)
        .collection('private')
        .doc('cycle_phase')
        .withConverter<CyclePhaseSync>(
          fromFirestore: CyclePhaseSync.fromFirestore,
          toFirestore: (phase, _) => phase.toFirestore(),
        );
  }

  @override
  Stream<AppResult<CyclePhaseSync?>> watchCyclePhase(String uid) {
    return guardFirestoreStream(() {
      return _phaseRef(uid).snapshots().map((snapshot) => snapshot.data());
    });
  }

  @override
  Future<AppResult<CyclePhaseSync?>> getCyclePhase(String uid) {
    return guardFirestore(() async {
      final snapshot = await _phaseRef(uid).get();
      return snapshot.data();
    });
  }

  @override
  Future<AppResult<void>> setCyclePhase(String uid, CyclePhaseSync phase) {
    return guardFirestore(() {
      return _phaseRef(uid).set(phase);
    });
  }

  @override
  Future<AppResult<void>> deleteCyclePhase(String uid) {
    return guardFirestore(() {
      return _phaseRef(uid).delete();
    });
  }
}
