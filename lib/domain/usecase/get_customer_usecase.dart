// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

import '../../base_usecase.dart';
import '../../data/model/cutomer_model.dart';
import '../repo/database_repo.dart';

class GetCustomerUsecase
    extends BaseUseCase<List<CustomerModel>, GetCustomersParam> {
  DatabaseRepo databaseRepo;
  GetCustomerUsecase(this.databaseRepo);
  @override
  Future<Either<Exception, List<CustomerModel>>> call(
      GetCustomersParam parameters) async {
    final res = await databaseRepo.getCustomers(
      parameters.start,
      parameters.end,
    );
    return res;
  }
}

@immutable
class GetCustomersParam extends Equatable {
  final int? start;
  final int? end;
  const GetCustomersParam({
    required this.start,
    required this.end,
  });
  @override
  List<Object?> get props => [start, end];
}
