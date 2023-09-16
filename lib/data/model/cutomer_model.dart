// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:zenbaba_funiture/domain/entity/customer_entity.dart';

class CustomerModel extends CustomerEntity {
  final String name;
  final String? id;
  final String phone;
  final String sefer;
  final String kk;
  final String location;
  final String gender;
  final String source;
  final String date;
  const CustomerModel({
    required this.gender,
    required this.name,
    required this.id,
    required this.phone,
    required this.sefer,
    required this.kk,
    required this.location,
    required this.source,
    required this.date,
  }) : super(
          gender: gender,
          name: name,
          id: id,
          phone: phone,
          sefer: sefer,
          kk: kk,
          location: location,
          source: source,
          date: date,
        );

  factory CustomerModel.fromFirebase(DocumentSnapshot snapshot) {
    final data = snapshot.data() as Map<String, dynamic>;
    return CustomerModel(
      name: data['name'],
      id: snapshot.id,
      phone: data['phone'],
      date: data['date'] ?? "",
      sefer: data['sefer'],
      kk: data['kk'],
      gender: data['gender'],
      location: data['location'],
      source: data['source'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'phone': phone,
      'sefer': sefer,
      'date': date,
      'kk': kk,
      'gender': gender,
      'location': location,
      'source': source,
    };
  }

  CustomerModel copyWith({
    String? name,
    String? id,
    String? phone,
    String? sefer,
    String? kk,
    String? location,
    String? gender,
    String? source,
    String? date,
  }) {
    return CustomerModel(
      name: name ?? this.name,
      id: id ?? this.id,
      phone: phone ?? this.phone,
      sefer: sefer ?? this.sefer,
      kk: kk ?? this.kk,
      location: location ?? this.location,
      gender: gender ?? this.gender,
      source: source ?? this.source,
      date: date ?? this.date,
    );
  }
}
