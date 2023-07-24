// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import 'package:zenbaba_funiture/base_usecase.dart';

import '../../data/model/employee_model.dart';
import '../repo/database_repo.dart';

class AddUpdateEmployeeUsecase
    extends BaseUseCase<void, AddUpdateEmployeeParams> {
  DatabaseRepo databaseRepo;
  AddUpdateEmployeeUsecase({
    required this.databaseRepo,
  });
  @override
  Future<Either<Exception, void>> call(
      AddUpdateEmployeeParams parameters) async {
    final res = await databaseRepo.addUpdateEmpoloyee(parameters.employeeModel, parameters.file);
    return res;
  }
}

class AddUpdateEmployeeParams extends Equatable {
  final EmployeeModel employeeModel;
  final File? file;
  const AddUpdateEmployeeParams(this.employeeModel, this.file);

  @override
  List<Object?> get props => [employeeModel, file];
}
