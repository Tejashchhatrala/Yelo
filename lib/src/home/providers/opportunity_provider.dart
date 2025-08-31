import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geolocator/geolocator.dart';
import 'package:YELO/src/core/providers/firbease_provider.dart';
import 'package:YELO/src/core/providers/location_provider.dart';
import 'package:YELO/src/home/models/opportunity_model.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final opportunityProvider = StreamProvider<List<Opportunity>>((ref) {
  final firestore = ref.watch(firebaseFirestoreProvider);
  final userLocation = ref.watch(locationProvider);

  final opportunitiesStream = firestore
      .collection('opportunities')
      .orderBy('timestamp', descending: true)
      .snapshots()
      .map((snapshot) {
    return snapshot.docs.map((doc) => Opportunity.fromSnapshot(doc)).toList();
  });

  if (userLocation == null) {
    return opportunitiesStream;
  } else {
    return opportunitiesStream.map((opportunities) {
      opportunities.sort((a, b) {
        final distanceA = Geolocator.distanceBetween(
          userLocation.latitude,
          userLocation.longitude,
          a.location.latitude,
          a.location.longitude,
        );
        final distanceB = Geolocator.distanceBetween(
          userLocation.latitude,
          userLocation.longitude,
          b.location.latitude,
          b.location.longitude,
        );
        return distanceA.compareTo(distanceB);
      });
      return opportunities;
    });
  }
});
