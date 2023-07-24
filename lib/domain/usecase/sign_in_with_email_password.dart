import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../base_usecase.dart';
import '../../data/model/user_model.dart';
import '../repo/auth_repo.dart';

class SignInWithEmailPasswordUSecase extends BaseUseCase<UserModel, SignInWithEmailPAsswordPArams> {
  AuthRepo authRepo;
  SignInWithEmailPasswordUSecase(this.authRepo);
  @override
  Future<Either<Exception, UserModel>> call(SignInWithEmailPAsswordPArams parameters) async {
    final res = await authRepo.signInWithEmailnPassword(parameters.email, parameters.password);
    return res;
  }

}

class SignInWithEmailPAsswordPArams extends Equatable{
  final String email;
  final String password;
  const SignInWithEmailPAsswordPArams(this.email, this.password);
  
  @override
  List<Object?> get props => [email, password];


}