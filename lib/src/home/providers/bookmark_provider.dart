import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:YELO/src/core/providers/firbease_provider.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final bookmarkProvider = Provider((ref) {
  final firestore = ref.watch(firebaseFirestoreProvider);
  final auth = ref.watch(firebaseAuthProvider);
  return BookmarkProvider(firestore, auth.currentUser!.uid);
});

final isBookmarkedProvider = FutureProvider.family<bool, String>((ref, opportunityId) {
  final bookmarkProv = ref.watch(bookmarkProvider);
  return bookmarkProv.isBookmarked(opportunityId);
});

class BookmarkProvider {
  final FirebaseFirestore _firestore;
  final String _userId;

  BookmarkProvider(this._firestore, this._userId);

  Future<void> toggleBookmark(String opportunityId) async {
    final bookmarkDoc = _firestore
        .collection('users')
        .doc(_userId)
        .collection('bookmarks')
        .doc(opportunityId);

    final snapshot = await bookmarkDoc.get();

    if (snapshot.exists) {
      await bookmarkDoc.delete();
    } else {
      await bookmarkDoc.set({'bookmarkedAt': Timestamp.now()});
    }
  }

  Future<bool> isBookmarked(String opportunityId) async {
    final bookmarkDoc = await _firestore
        .collection('users')
        .doc(_userId)
        .collection('bookmarks')
        .doc(opportunityId)
        .get();
    return bookmarkDoc.exists;
  }
}
