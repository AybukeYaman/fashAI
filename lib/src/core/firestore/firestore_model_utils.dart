import 'package:cloud_firestore/cloud_firestore.dart';

// Firestore's Flutter SDK exposes decoded document maps as Map<String, dynamic>.
// Keep that unavoidable dynamic boundary here; model fields are parsed to typed values.
typedef FirestoreSnapshot = DocumentSnapshot<Map<String, dynamic>>;
typedef FirestoreJson = Map<String, Object?>;

FirestoreJson snapshotData(FirestoreSnapshot snapshot) {
  final data = snapshot.data();
  if (data == null) {
    throw StateError(
      'Firestore document ${snapshot.reference.path} has no data.',
    );
  }
  return data.cast<String, Object?>();
}

FirestoreJson mapFromObject(Object? value, {String? fieldName}) {
  if (value == null) {
    return <String, Object?>{};
  }
  if (value is Map<String, Object?>) {
    return value;
  }
  if (value is Map) {
    final entries = value.cast<Object?, Object?>().entries;
    return <String, Object?>{
      for (final entry in entries) entry.key.toString(): entry.value,
    };
  }
  throw StateError('${fieldName ?? 'Firestore field'} must be a map.');
}

List<FirestoreJson> mapListFromObject(Object? value, {String? fieldName}) {
  if (value == null) {
    return const <FirestoreJson>[];
  }
  if (value is! List) {
    throw StateError('${fieldName ?? 'Firestore field'} must be a list.');
  }
  return List<FirestoreJson>.unmodifiable(
    value.map((entry) => mapFromObject(entry, fieldName: fieldName)),
  );
}

String readString(FirestoreJson data, String field, {String? fallback}) {
  final value = data[field];
  if (value is String) {
    return value;
  }
  if (fallback != null) {
    return fallback;
  }
  throw StateError('Firestore field $field must be a string.');
}

String? readOptionalString(FirestoreJson data, String field) {
  final value = data[field];
  if (value == null) {
    return null;
  }
  if (value is String) {
    return value;
  }
  throw StateError('Firestore field $field must be a string when present.');
}

int readInt(FirestoreJson data, String field, {int defaultValue = 0}) {
  final value = data[field];
  if (value == null) {
    return defaultValue;
  }
  if (value is int) {
    return value;
  }
  if (value is num) {
    return value.toInt();
  }
  throw StateError('Firestore field $field must be an integer.');
}

int? readOptionalInt(FirestoreJson data, String field) {
  final value = data[field];
  if (value == null) {
    return null;
  }
  if (value is int) {
    return value;
  }
  if (value is num) {
    return value.toInt();
  }
  throw StateError('Firestore field $field must be an integer when present.');
}

double? readOptionalDouble(FirestoreJson data, String field) {
  final value = data[field];
  if (value == null) {
    return null;
  }
  if (value is num) {
    return value.toDouble();
  }
  throw StateError('Firestore field $field must be a number when present.');
}

bool readBool(FirestoreJson data, String field, {bool defaultValue = false}) {
  final value = data[field];
  if (value == null) {
    return defaultValue;
  }
  if (value is bool) {
    return value;
  }
  throw StateError('Firestore field $field must be a boolean.');
}

DateTime readDateTime(FirestoreJson data, String field, {DateTime? fallback}) {
  final value = readOptionalDateTime(data, field);
  if (value != null) {
    return value;
  }
  if (fallback != null) {
    return fallback.toUtc();
  }
  throw StateError('Firestore field $field must be a timestamp.');
}

DateTime? readOptionalDateTime(FirestoreJson data, String field) {
  final value = data[field];
  if (value == null) {
    return null;
  }
  if (value is Timestamp) {
    return value.toDate().toUtc();
  }
  if (value is DateTime) {
    return value.toUtc();
  }
  throw StateError('Firestore field $field must be a timestamp when present.');
}

List<String> readStringList(FirestoreJson data, String field) {
  final value = data[field];
  if (value == null) {
    return const <String>[];
  }
  if (value is! List) {
    throw StateError('Firestore field $field must be a string list.');
  }
  return List<String>.unmodifiable(value.map((entry) => entry.toString()));
}

Map<String, String> readStringMap(FirestoreJson data, String field) {
  final map = mapFromObject(data[field], fieldName: field);
  return Map<String, String>.unmodifiable(
    map.map((key, value) => MapEntry(key, value?.toString() ?? '')),
  );
}

Map<String, bool> readBoolMap(FirestoreJson data, String field) {
  final map = mapFromObject(data[field], fieldName: field);
  return Map<String, bool>.unmodifiable(
    map.map((key, value) => MapEntry(key, value == true)),
  );
}

Map<String, int> readIntMap(FirestoreJson data, String field) {
  final map = mapFromObject(data[field], fieldName: field);
  return Map<String, int>.unmodifiable(
    map.map((key, value) {
      if (value is int) {
        return MapEntry(key, value);
      }
      if (value is num) {
        return MapEntry(key, value.toInt());
      }
      return MapEntry(key, 0);
    }),
  );
}

Timestamp timestampFromDate(DateTime value) {
  return Timestamp.fromDate(value.toUtc());
}

Timestamp? optionalTimestampFromDate(DateTime? value) {
  if (value == null) {
    return null;
  }
  return timestampFromDate(value);
}
