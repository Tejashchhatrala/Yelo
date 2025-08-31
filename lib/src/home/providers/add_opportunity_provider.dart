import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:YELO/src/core/providers/firbease_provider.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final addOpportunityProvider = Provider((ref) {
  final firestore = ref.watch(firebaseFirestoreProvider);
  final storage = ref.watch(firebaseStorageProvider);
  final auth = ref.watch(firebaseAuthProvider);
  return AddOpportunityProvider(
      firestore, storage, auth.currentUser!.uid);
});

class AddOpportunityProvider {
  final FirebaseFirestore _firestore;
  final FirebaseStorage _storage;
  final String _userId;

  AddOpportunityProvider(this._firestore, this._storage, this._userId);

  Future<void> addOpportunity({
    required String title,
    required String description,
    required File image,
    required GeoPoint location,
  }) async {
    final imageRef =
        _storage.ref().child('opportunity_images').child('${DateTime.now()}.jpg');
    await imageRef.putFile(image);
    final imageUrl = await imageRef.getDownloadURL();

    await _firestore.collection('pending_opportunities').add({
      'authorId': _userId,
      'title': title,
      'description': description,
      'imageUrl': imageUrl,
      'location': location,
      'timestamp': Timestamp.now(),
      'status': 'pending',
    });
  }
}
