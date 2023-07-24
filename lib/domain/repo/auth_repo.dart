import 'dart:io';
import 'package:dartz/dartz.dart';

import '../../data/model/user_model.dart';

abstract class AuthRepo{
  Future<Either<Exception, UserModel>> signUpWithEmailnPassword(UserModel userModel, String password, File file);
  Future<Either<Exception, void>> signUpWithGoogle(UserModel? userModel, String priority);
  // Future<Either<Exception, void>> signUpWithFacebook(UserModel? userModel, String priority);
  Future<Either<Exception, UserModel>> signInWithEmailnPassword(String email, String password);
  Future<Either<Exception,void>> forgetPassword(String email);
  Future<Either<Exception, void>> signOut();
  Future<Either<Exception, UserModel>> getUser();
  Future<Either<Exception, void>> setUser(UserModel userModel);
}