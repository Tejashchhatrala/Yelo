import 'package:equatable/equatable.dart';
import 'package:YELO/src/core/enum/auth_type.dart';

class CustomUserModel extends Equatable {
  final String uid;
  final String name;
  final String email;
  final String? phoneNumber;
  final String location;
  final int? createdAt;
  final int updatedAt;
  final bool isMerchant;
  final List<String>? documents;
  final AuthType? authType;
  final String role;

  const CustomUserModel({
    required this.uid,
    required this.name,
    required this.email,
    this.phoneNumber,
    required this.location,
    this.createdAt,
    required this.updatedAt,
    this.isMerchant = false,
    this.documents,
    this.authType,
    this.role = 'user',
  });

  @override
  List<Object?> get props => [
        uid,
        name,
        email,
        phoneNumber,
        location,
        createdAt,
        updatedAt,
        isMerchant,
        documents,
        authType,
        role,
      ];

  factory CustomUserModel.fromJson(Map<String, dynamic> json) {
    return CustomUserModel(
      uid: json['uid'] ?? '',
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      phoneNumber: json['phone_number'],
      location: json['location'] ?? '',
      createdAt: json['created_at'],
      updatedAt: json['updated_at'] ?? 0,
      isMerchant: json['is_merchant'] ?? false,
      documents: json['documents'] != null
          ? List<String>.from(json['documents'])
          : null,
      authType: json['auth_type'] != null
          ? AuthType.values.firstWhere(
              (e) => e.toString() == 'AuthType.${json['auth_type']}')
          : null,
      role: json['role'] ?? 'user',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'uid': uid,
      'name': name,
      'email': email,
      'phone_number': phoneNumber,
      'location': location,
      'created_at': createdAt,
      'updated_at': updatedAt,
      'is_merchant': isMerchant,
      'documents': documents,
      'auth_type': authType?.toString().split('.').last,
      'role': role,
    };
  }
}
