// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import 'package:zenbaba_funiture/base_usecase.dart';
import 'package:zenbaba_funiture/data/model/employee_activity_model.dart';
import 'package:zenbaba_funiture/domain/repo/database_repo.dart';

class SearchEmployeeUsecase
    extends BaseUseCase<List<EmployeeActivityModel>, SearchEmployeeParams> {
  final DatabaseRepo databaseRepo;
  SearchEmployeeUsecase(this.databaseRepo);
  @override
  Future<Either<Exception, List<EmployeeActivityModel>>> call(
      SearchEmployeeParams parameters) async {
    final res = await databaseRepo.searchEmployee(
      parameters.month,
      parameters.year,
      parameters.employeeId,
    );
    return res;
  }
}

class SearchEmployeeParams extends Equatable {
  final String employeeId;
  final String year;
  final String month;
  const SearchEmployeeParams({
    required this.employeeId,
    required this.year,
    required this.month,
  });
  @override
  List<Object?> get props => [employeeId, year, month];
}
