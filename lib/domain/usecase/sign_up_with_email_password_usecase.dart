import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../base_usecase.dart';
import '../../data/model/user_model.dart';
import '../repo/auth_repo.dart';

class SignUpWithEmailPasswordUsecase
    extends BaseUseCase<void, SignUpWithEmailPasswordParams> {
  AuthRepo authRepo;
  SignUpWithEmailPasswordUsecase(this.authRepo);
  @override
  Future<Either<Exception, UserModel>> call(
      SignUpWithEmailPasswordParams parameters) async {
    final res = await authRepo.signUpWithEmailnPassword(
        parameters.userModel, parameters.password, parameters.file);
    return res;
  }
}

class SignUpWithEmailPasswordParams extends Equatable {
  final UserModel userModel;
  final String password;
  final File file;
  const SignUpWithEmailPasswordParams(this.password, this.userModel, this.file);
  @override
  List<Object?> get props => [userModel, password, file];
}
