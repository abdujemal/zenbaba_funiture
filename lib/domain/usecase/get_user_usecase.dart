import 'package:dartz/dartz.dart';

import '../../base_usecase.dart';
import '../../data/model/user_model.dart';
import '../repo/auth_repo.dart';

class GetUserUsecase extends BaseUseCase<UserModel, NoParameters>{
  AuthRepo authRepo;
  GetUserUsecase(this.authRepo);
  @override
  Future<Either<Exception, UserModel>> call(NoParameters parameters) async {
    final res = await authRepo.getUser();
    return res;
  }

}