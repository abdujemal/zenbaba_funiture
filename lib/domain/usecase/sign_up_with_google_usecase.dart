import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../base_usecase.dart';
import '../../data/model/user_model.dart';
import '../repo/auth_repo.dart';

class SignUpWithGoogleUsecase extends BaseUseCase<void, SignUpWithGoogleParams> {
  AuthRepo authRepo;
  SignUpWithGoogleUsecase(this.authRepo);
  @override
  Future<Either<Exception, void>> call(SignUpWithGoogleParams parameters) async {
    final res = await authRepo.signUpWithGoogle(parameters.userModel, parameters.priority);
    return res;
  }

}

class SignUpWithGoogleParams extends Equatable {
  final UserModel userModel;
  final String priority;
  const SignUpWithGoogleParams(this.priority, this.userModel);
  
  @override
  List<Object?> get props => [userModel, priority];
}
