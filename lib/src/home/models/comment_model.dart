import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class Comment extends Equatable {
  final String id;
  final String authorId;
  final String text;
  final DateTime timestamp;

  const Comment({
    required this.id,
    required this.authorId,
    required this.text,
    required this.timestamp,
  });

  @override
  List<Object?> get props => [id, authorId, text, timestamp];

  factory Comment.fromSnapshot(DocumentSnapshot snap) {
    final data = snap.data() as Map<String, dynamic>;
    return Comment(
      id: snap.id,
      authorId: data['authorId'] ?? '',
      text: data['text'] ?? '',
      timestamp: (data['timestamp'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'authorId': authorId,
      'text': text,
      'timestamp': timestamp,
    };
  }
}
