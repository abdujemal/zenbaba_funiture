// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:zenbaba_funiture/domain/entity/user_entity.dart';

class UserModel extends UserEntity {
  final String? id;
  final String email;
  final String? image;
  final String name;
  final String priority;
  final String phoneNumber;
  const UserModel({
    required this.id,
    required this.image,
    required this.name,
    required this.priority,
    required this.email,
    required this.phoneNumber,
  }) : super(
          id: id,
          image: image,
          name: name,
          priority: priority,
          email: email,
          phoneNumber: phoneNumber,
        );

  factory UserModel.fromFirebase(DocumentSnapshot snapshot) {
    final data = snapshot.data() as Map<String, dynamic>;
    return UserModel(
        id: snapshot.id,
        image: data['image'],
        email: data['email'],
        name: data['name'],
        priority: data['priority'],
        phoneNumber: data['phoneNumber']??"");
  }

  Map<String, dynamic> toMap() {
    return {
      'image': image,
      'name': name,
      'priority': priority,
      'email': email,
      'phoneNumber': phoneNumber,
    };
  }

  UserModel copyWith({
    String? id,
    String? email,
    String? image,
    String? name,
    String? priority,
    String? phoneNumber
  }) {
    return UserModel(
      id: id ?? this.id,
      email: email ?? this.email,
      image: image ?? this.image,
      name: name ?? this.name,
      priority: priority ?? this.priority,
      phoneNumber: phoneNumber  ?? this.phoneNumber,
    );
  }
}
