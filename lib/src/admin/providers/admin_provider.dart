import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:YELO/src/core/providers/firbease_provider.dart';
import 'package:YELO/src/home/models/opportunity_model.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final adminProvider = Provider((ref) {
  final firestore = ref.watch(firebaseFirestoreProvider);
  return AdminProvider(firestore);
});

final pendingOpportunitiesProvider = StreamProvider<List<Opportunity>>((ref) {
  final firestore = ref.watch(firebaseFirestoreProvider);
  return firestore
      .collection('pending_opportunities')
      .where('status', isEqualTo: 'pending')
      .snapshots()
      .map((snapshot) {
    return snapshot.docs.map((doc) => Opportunity.fromSnapshot(doc)).toList();
  });
});

class AdminProvider {
  final FirebaseFirestore _firestore;

  AdminProvider(this._firestore);

  Future<void> approveOpportunity(String opportunityId) async {
    final pendingDocRef =
        _firestore.collection('pending_opportunities').doc(opportunityId);
    final opportunityDocRef =
        _firestore.collection('opportunities').doc(opportunityId);

    final snapshot = await pendingDocRef.get();
    if (snapshot.exists) {
      final data = snapshot.data()!;
      await opportunityDocRef.set(data..['status'] = 'approved');
      await pendingDocRef.delete();
    }
  }

  Future<void> rejectOpportunity(String opportunityId) async {
    await _firestore
        .collection('pending_opportunities')
        .doc(opportunityId)
        .delete();
  }
}
