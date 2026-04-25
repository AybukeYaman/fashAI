import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fashai/src/core/firestore/firestore_model_utils.dart';
import 'package:fashai/src/core/firestore/firestore_operation.dart';
import 'package:fashai/src/core/firestore/firestore_providers.dart';
import 'package:fashai/src/core/result/result.dart';
import 'package:fashai/src/features/calendar/data/models/cached_calendar_event.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

abstract interface class CalendarRepository {
  Stream<AppResult<List<CachedCalendarEvent>>> watchEvents(
    String uid, {
    required DateTime startAt,
    required DateTime endAt,
  });
  Future<AppResult<List<CachedCalendarEvent>>> getEvents(
    String uid, {
    required DateTime startAt,
    required DateTime endAt,
  });
  Future<AppResult<void>> setEvent(String uid, CachedCalendarEvent event);
  Future<AppResult<void>> deleteEvent(String uid, String eventId);
}

final calendarRepositoryProvider = Provider<CalendarRepository>((ref) {
  return FirestoreCalendarRepository(ref.watch(firebaseFirestoreProvider));
});

class FirestoreCalendarRepository implements CalendarRepository {
  const FirestoreCalendarRepository(this._firestore);

  final FirebaseFirestore _firestore;

  CollectionReference<CachedCalendarEvent> _eventsRef(String uid) {
    return _firestore
        .collection('users')
        .doc(uid)
        .collection('calendar_cache')
        .withConverter<CachedCalendarEvent>(
          fromFirestore: CachedCalendarEvent.fromFirestore,
          toFirestore: (event, _) => event.toFirestore(),
        );
  }

  @override
  Stream<AppResult<List<CachedCalendarEvent>>> watchEvents(
    String uid, {
    required DateTime startAt,
    required DateTime endAt,
  }) {
    return guardFirestoreStream(() {
      return _buildRangeQuery(
        uid,
        startAt: startAt,
        endAt: endAt,
      ).snapshots().map(_queryEvents);
    });
  }

  @override
  Future<AppResult<List<CachedCalendarEvent>>> getEvents(
    String uid, {
    required DateTime startAt,
    required DateTime endAt,
  }) {
    return guardFirestore(() async {
      final snapshot = await _buildRangeQuery(
        uid,
        startAt: startAt,
        endAt: endAt,
      ).get();
      return _queryEvents(snapshot);
    });
  }

  @override
  Future<AppResult<void>> setEvent(String uid, CachedCalendarEvent event) {
    return guardFirestore(() {
      return _eventsRef(uid).doc(event.id).set(event);
    });
  }

  @override
  Future<AppResult<void>> deleteEvent(String uid, String eventId) {
    return guardFirestore(() {
      return _eventsRef(uid).doc(eventId).delete();
    });
  }

  Query<CachedCalendarEvent> _buildRangeQuery(
    String uid, {
    required DateTime startAt,
    required DateTime endAt,
  }) {
    return _eventsRef(uid)
        .where('startAt', isLessThanOrEqualTo: timestampFromDate(endAt))
        .where('endAt', isGreaterThanOrEqualTo: timestampFromDate(startAt))
        .orderBy('startAt');
  }

  List<CachedCalendarEvent> _queryEvents(
    QuerySnapshot<CachedCalendarEvent> snapshot,
  ) {
    return snapshot.docs.map((doc) => doc.data()).toList(growable: false);
  }
}
