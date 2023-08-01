// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:zenbaba_funiture/data/model/employee_activity_model.dart';
import 'package:zenbaba_funiture/domain/repo/database_repo.dart';
import '../../base_usecase.dart';

class AddUpdateEmployeeActivityUsecase
    extends BaseUseCase<void, AddUpdateEmployeeActivityParams> {
  final DatabaseRepo databaseRepo;
  AddUpdateEmployeeActivityUsecase(this.databaseRepo);
  @override
  Future<Either<Exception, void>> call(
      AddUpdateEmployeeActivityParams parameters) async {
    final res = await databaseRepo
        .addUpdateEmployeeActivity(parameters.employeeActivityModel);

    return res;
  }
}

class AddUpdateEmployeeActivityParams extends Equatable {
  final EmployeeActivityModel employeeActivityModel;
  const AddUpdateEmployeeActivityParams({
    required this.employeeActivityModel,
  });

  @override
  List<Object?> get props => [employeeActivityModel];
}
