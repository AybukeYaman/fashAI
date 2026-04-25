import 'package:fashai/src/core/firestore/firestore_model_utils.dart';

const Object _unset = Object();

class CyclePhaseSync {
  const CyclePhaseSync({
    this.id = 'cycle_phase',
    required this.phase,
    required this.syncedAt,
    required this.updatedAt,
    this.consentVersion,
    this.source,
  });

  static const validPhases = <String>[
    'menstrual',
    'follicular',
    'ovulation',
    'luteal',
  ];

  final String id;
  final String phase;
  final DateTime syncedAt;
  final DateTime updatedAt;
  final String? consentVersion;
  final String? source;

  factory CyclePhaseSync.fromFirestore(
    FirestoreSnapshot snapshot,
    Object? options,
  ) {
    final data = snapshotData(snapshot);
    return CyclePhaseSync(
      id: snapshot.id,
      phase: readString(data, 'phase'),
      syncedAt: readDateTime(data, 'syncedAt'),
      updatedAt: readDateTime(data, 'updatedAt'),
      consentVersion: readOptionalString(data, 'consentVersion'),
      source: readOptionalString(data, 'source'),
    );
  }

  FirestoreJson toFirestore() {
    return <String, Object?>{
      'phase': phase,
      'syncedAt': timestampFromDate(syncedAt),
      'updatedAt': timestampFromDate(updatedAt),
      'consentVersion': consentVersion,
      'source': source,
    };
  }

  CyclePhaseSync copyWith({
    String? id,
    String? phase,
    DateTime? syncedAt,
    DateTime? updatedAt,
    Object? consentVersion = _unset,
    Object? source = _unset,
  }) {
    return CyclePhaseSync(
      id: id ?? this.id,
      phase: phase ?? this.phase,
      syncedAt: syncedAt ?? this.syncedAt,
      updatedAt: updatedAt ?? this.updatedAt,
      consentVersion: identical(consentVersion, _unset)
          ? this.consentVersion
          : consentVersion as String?,
      source: identical(source, _unset) ? this.source : source as String?,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is CyclePhaseSync &&
            other.id == id &&
            other.phase == phase &&
            other.syncedAt == syncedAt &&
            other.updatedAt == updatedAt &&
            other.consentVersion == consentVersion &&
            other.source == source;
  }

  @override
  int get hashCode =>
      Object.hash(id, phase, syncedAt, updatedAt, consentVersion, source);
}
