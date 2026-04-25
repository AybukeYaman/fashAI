import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fashai/src/core/firestore/firestore_model_utils.dart';
import 'package:fashai/src/core/firestore/firestore_operation.dart';
import 'package:fashai/src/core/firestore/firestore_providers.dart';
import 'package:fashai/src/core/result/result.dart';
import 'package:fashai/src/features/notifications/data/models/inbox_notification.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

abstract interface class NotificationRepository {
  Stream<AppResult<List<InboxNotification>>> watchInbox(
    String uid, {
    bool unreadOnly,
    int limit,
  });
  Future<AppResult<void>> markRead(String uid, String notificationId);
  Future<AppResult<void>> deleteNotification(String uid, String notificationId);
}

final notificationRepositoryProvider = Provider<NotificationRepository>((ref) {
  return FirestoreNotificationRepository(ref.watch(firebaseFirestoreProvider));
});

class FirestoreNotificationRepository implements NotificationRepository {
  const FirestoreNotificationRepository(this._firestore);

  final FirebaseFirestore _firestore;

  CollectionReference<InboxNotification> _notificationsRef(String uid) {
    return _firestore
        .collection('users')
        .doc(uid)
        .collection('notifications')
        .withConverter<InboxNotification>(
          fromFirestore: InboxNotification.fromFirestore,
          toFirestore: (notification, _) => notification.toFirestore(),
        );
  }

  @override
  Stream<AppResult<List<InboxNotification>>> watchInbox(
    String uid, {
    bool unreadOnly = false,
    int limit = 50,
  }) {
    return guardFirestoreStream(() {
      Query<InboxNotification> query = _notificationsRef(uid);
      if (unreadOnly) {
        query = query.where('isRead', isEqualTo: false);
      }
      return query
          .orderBy('createdAt', descending: true)
          .limit(limit)
          .snapshots()
          .map(_queryNotifications);
    });
  }

  @override
  Future<AppResult<void>> markRead(String uid, String notificationId) {
    return guardFirestore(() {
      final now = DateTime.now().toUtc();
      return _notificationsRef(
        uid,
      ).doc(notificationId).update(<String, Object?>{
        'isRead': true,
        'readAt': timestampFromDate(now),
        'updatedAt': timestampFromDate(now),
      });
    });
  }

  @override
  Future<AppResult<void>> deleteNotification(
    String uid,
    String notificationId,
  ) {
    return guardFirestore(() {
      return _notificationsRef(uid).doc(notificationId).delete();
    });
  }

  List<InboxNotification> _queryNotifications(
    QuerySnapshot<InboxNotification> snapshot,
  ) {
    return snapshot.docs.map((doc) => doc.data()).toList(growable: false);
  }
}
