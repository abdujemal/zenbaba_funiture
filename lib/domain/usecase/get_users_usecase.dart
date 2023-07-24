import 'package:dartz/dartz.dart';

import '../../base_usecase.dart';
import '../../data/model/user_model.dart';
import '../repo/database_repo.dart';

class GetUsersUsecase extends BaseUseCase<List<UserModel>, NoParameters>{
  DatabaseRepo databaseRepo;
  GetUsersUsecase(this.databaseRepo);
  @override
  Future<Either<Exception, List<UserModel>>> call(NoParameters parameters) async {
    final res = await databaseRepo.getUsers();
    return res;
  }

}