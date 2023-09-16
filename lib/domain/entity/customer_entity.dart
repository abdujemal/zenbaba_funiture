// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:equatable/equatable.dart';

class CustomerEntity extends Equatable {
  final String name;
  final String? id;
  final String phone;
  final String sefer;
  final String kk;
  final String location;
  final String gender;
  final String source;
  final String date;
  const CustomerEntity( {
    required this.date,
    required this.gender,
    required this.name,
    required this.id,
    required this.phone,
    required this.sefer,
    required this.kk,
    required this.location,
    required this.source,
  });

  @override
  List<Object?> get props =>
      [name, id, phone, sefer, kk, location, gender, source, date];
}
