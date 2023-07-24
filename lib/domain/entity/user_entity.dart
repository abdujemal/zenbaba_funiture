// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:equatable/equatable.dart';

class UserEntity extends Equatable {
  final String email;
  final String? id;
  final String? image;
  final String name;
  final String priority;
  const UserEntity({
    required this.email,
    required this.id,
    required this.image,
    required this.name,
    required this.priority,
  });
  @override
  List<Object?> get props => [id, image, name, priority, email];
}
