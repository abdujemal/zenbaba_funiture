import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../base_usecase.dart';
import '../repo/auth_repo.dart';

class ForgetPasswordUsecase extends BaseUseCase<void, ForegerPasswordParams> {
  AuthRepo authRepo;
  ForgetPasswordUsecase(this.authRepo);
  @override
  Future<Either<Exception, void>> call(ForegerPasswordParams parameters) async {
    final res = await authRepo.forgetPassword(parameters.email);
    return res;
  }
}

class ForegerPasswordParams extends Equatable {
  final String email;
  const ForegerPasswordParams(this.email);
  @override
  List<Object?> get props => [email];
}
