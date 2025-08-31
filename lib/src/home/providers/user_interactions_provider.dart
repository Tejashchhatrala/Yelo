import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:YELO/src/core/providers/firbease_provider.dart';
import 'package:YELO/src/home/models/opportunity_model.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final likedOpportunitiesProvider = StreamProvider<List<Opportunity>>((ref) {
  final firestore = ref.watch(firebaseFirestoreProvider);
  final auth = ref.watch(firebaseAuthProvider);
  final userId = auth.currentUser!.uid;

  return firestore
      .collection('users')
      .doc(userId)
      .collection('likes')
      .snapshots()
      .asyncMap((snapshot) async {
    final opportunityIds = snapshot.docs.map((doc) => doc.id).toList();
    if (opportunityIds.isEmpty) {
      return [];
    }
    final opportunitySnapshots = await Future.wait(opportunityIds
        .map((id) => firestore.collection('opportunities').doc(id).get()));
    return opportunitySnapshots
        .map((doc) => Opportunity.fromSnapshot(doc))
        .toList();
  });
});

final bookmarkedOpportunitiesProvider = StreamProvider<List<Opportunity>>((ref) {
  final firestore = ref.watch(firebaseFirestoreProvider);
  final auth = ref.watch(firebaseAuthProvider);
  final userId = auth.currentUser!.uid;

  return firestore
      .collection('users')
      .doc(userId)
      .collection('bookmarks')
      .snapshots()
      .asyncMap((snapshot) async {
    final opportunityIds = snapshot.docs.map((doc) => doc.id).toList();
    if (opportunityIds.isEmpty) {
      return [];
    }
    final opportunitySnapshots = await Future.wait(opportunityIds
        .map((id) => firestore.collection('opportunities').doc(id).get()));
    return opportunitySnapshots
        .map((doc) => Opportunity.fromSnapshot(doc))
        .toList();
  });
});
