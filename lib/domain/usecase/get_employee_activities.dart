import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:zenbaba_funiture/base_usecase.dart';
import 'package:zenbaba_funiture/data/model/employee_activity_model.dart';
import 'package:zenbaba_funiture/domain/repo/database_repo.dart';

class GetEmployeeActivitiesUsecase extends BaseUseCase<
    List<EmployeeActivityModel>, GetEmployeeActivityParams> {
  final DatabaseRepo databaseRepo;
  GetEmployeeActivitiesUsecase(this.databaseRepo);
  @override
  Future<Either<Exception, List<EmployeeActivityModel>>> call(
      GetEmployeeActivityParams parameters) async {
    final res = await databaseRepo.getEmployeeeActivities(
      parameters.employeeId,
      parameters.quantity,
      isNew: parameters.isNew ?? true,
    );

    return res;
  }
}

class GetEmployeeActivityParams extends Equatable {
  final String employeeId;
  final int? quantity;
  final bool? isNew;

  const GetEmployeeActivityParams(this.employeeId, this.quantity,
      {this.isNew = true});
  @override
  List<Object?> get props => [employeeId, quantity, isNew];
}
