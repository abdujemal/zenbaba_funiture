import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../base_usecase.dart';
import '../../data/model/user_model.dart';
import '../repo/auth_repo.dart';

class SetUserUsecase extends BaseUseCase<void, SetUserParams> {
  AuthRepo authRepo;
  SetUserUsecase(this.authRepo);
  @override
  Future<Either<Exception, void>> call(
      SetUserParams parameters) async {
    final res = await authRepo.setUser(parameters.userModel);
    return res;
  }
}

class SetUserParams extends Equatable {
  final UserModel userModel;
  const SetUserParams(this.userModel);
  @override
  List<Object?> get props => [userModel];
}
