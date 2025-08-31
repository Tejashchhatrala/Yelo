import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class Opportunity extends Equatable {
  final String id;
  final String authorId;
  final String title;
  final String description;
  final String imageUrl;
  final DateTime timestamp;
  final GeoPoint location;

  const Opportunity({
    required this.id,
    required this.authorId,
    required this.title,
    required this.description,
    required this.imageUrl,
    required this.timestamp,
    required this.location,
  });

  @override
  List<Object?> get props =>
      [id, authorId, title, description, imageUrl, timestamp, location];

  factory Opportunity.fromSnapshot(DocumentSnapshot snap) {
    final data = snap.data() as Map<String, dynamic>;
    return Opportunity(
      id: snap.id,
      authorId: data['authorId'] ?? '',
      title: data['title'] ?? '',
      description: data['description'] ?? '',
      imageUrl: data['imageUrl'] ?? '',
      timestamp: (data['timestamp'] as Timestamp).toDate(),
      location: data['location'] ?? const GeoPoint(0, 0),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'authorId': authorId,
      'title': title,
      'description': description,
      'imageUrl': imageUrl,
      'timestamp': timestamp,
      'location': location,
    };
  }
}
