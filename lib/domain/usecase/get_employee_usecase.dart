import 'package:dartz/dartz.dart';
import 'package:zenbaba_funiture/base_usecase.dart';
import 'package:zenbaba_funiture/data/model/employee_model.dart';
import 'package:zenbaba_funiture/domain/repo/database_repo.dart';

class GetEmployeeUsecase
    extends BaseUseCase<List<EmployeeModel>, NoParameters> {
  final DatabaseRepo databaseRepo;
  GetEmployeeUsecase(this.databaseRepo);
  @override
  Future<Either<Exception, List<EmployeeModel>>> call(
      NoParameters parameters) async {
    final res = await databaseRepo.getEmployees();
    return res;
  }
}
