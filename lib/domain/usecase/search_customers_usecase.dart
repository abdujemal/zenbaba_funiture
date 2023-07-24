// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../base_usecase.dart';
import '../../data/model/cutomer_model.dart';
import '../repo/database_repo.dart';


class SearchCustomersUsecase
    extends BaseUseCase<List<CustomerModel>, SearchParams> {
  DatabaseRepo databaseRepo;
  SearchCustomersUsecase(this.databaseRepo);
  @override
  Future<Either<Exception, List<CustomerModel>>> call(
      SearchParams parameters) async {
    final res =
        await databaseRepo.searchCustomers(parameters.key, parameters.value, parameters.length);
    return res;
  }
}

class SearchParams extends Equatable {
  final String key;
  final String value;
  final int length;
  const SearchParams({
    required this.key,
    required this.value,
    required this.length
  });
  @override
  List<Object?> get props => [key, value];
}
