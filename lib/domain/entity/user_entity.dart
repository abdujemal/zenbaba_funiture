// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:equatable/equatable.dart';

class UserEntity extends Equatable {
  final String email;
  final String? id;
  final String? image;
  final String name;
  final String priority;
  final String phoneNumber;
  const UserEntity({
    required this.email,
    required this.id,
    required this.image,
    required this.name,
    required this.priority,
    required this.phoneNumber,
  });
  @override
  List<Object?> get props => [id, image, name, priority, email, phoneNumber];
}
