import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:YELO/src/core/providers/firbease_provider.dart';
import 'package:YELO/src/home/models/comment_model.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final commentProvider =
    StreamProvider.family<List<Comment>, String>((ref, opportunityId) {
  final firestore = ref.watch(firebaseFirestoreProvider);
  return firestore
      .collection('opportunities')
      .doc(opportunityId)
      .collection('comments')
      .orderBy('timestamp', descending: true)
      .snapshots()
      .map((snapshot) {
    return snapshot.docs.map((doc) => Comment.fromSnapshot(doc)).toList();
  });
});

final addCommentProvider = Provider((ref) {
  final firestore = ref.watch(firebaseFirestoreProvider);
  final auth = ref.watch(firebaseAuthProvider);
  return AddCommentProvider(firestore, auth.currentUser!.uid);
});

class AddCommentProvider {
  final FirebaseFirestore _firestore;
  final String _userId;

  AddCommentProvider(this._firestore, this._userId);

  Future<void> addComment(String opportunityId, String text) async {
    await _firestore
        .collection('opportunities')
        .doc(opportunityId)
        .collection('comments')
        .add({
      'authorId': _userId,
      'text': text,
      'timestamp': Timestamp.now(),
    });
  }
}
