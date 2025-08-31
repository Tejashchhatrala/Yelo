import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:YELO/src/core/providers/firbease_provider.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final likeProvider = Provider((ref) {
  final firestore = ref.watch(firebaseFirestoreProvider);
  final auth = ref.watch(firebaseAuthProvider);
  return LikeProvider(firestore, auth.currentUser!.uid);
});

final isLikedProvider = FutureProvider.family<bool, String>((ref, opportunityId) {
  final likeProv = ref.watch(likeProvider);
  return likeProv.isLiked(opportunityId);
});

class LikeProvider {
  final FirebaseFirestore _firestore;
  final String _userId;

  LikeProvider(this._firestore, this._userId);

  Future<void> toggleLike(String opportunityId) async {
    final likeDoc = _firestore
        .collection('users')
        .doc(_userId)
        .collection('likes')
        .doc(opportunityId);

    final snapshot = await likeDoc.get();

    if (snapshot.exists) {
      await likeDoc.delete();
    } else {
      await likeDoc.set({'likedAt': Timestamp.now()});
    }
  }

  Future<bool> isLiked(String opportunityId) async {
    final likeDoc = await _firestore
        .collection('users')
        .doc(_userId)
        .collection('likes')
        .doc(opportunityId)
        .get();
    return likeDoc.exists;
  }
}
