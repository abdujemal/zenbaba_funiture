import 'package:dartz/dartz.dart';

import '../../base_usecase.dart';
import '../repo/auth_repo.dart';

class SignOutUsecase extends BaseUseCase<void, NoParameters>{
  AuthRepo authRepo;
  SignOutUsecase(this.authRepo);
  @override
  Future<Either<Exception, void>> call(NoParameters parameters) async {
    final res = await authRepo.signOut();
    return res;
  }
}