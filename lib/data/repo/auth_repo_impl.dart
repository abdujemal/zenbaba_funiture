import 'dart:io';
import 'package:dartz/dartz.dart';

import '../../domain/repo/auth_repo.dart';
import '../data_src/auth_data_src.dart';
import '../model/user_model.dart';

class AuthRepoImpl extends AuthRepo {
  AuthDataSource authDataSource;
  AuthRepoImpl(this.authDataSource);
  @override
  Future<Either<Exception, void>> forgetPassword(String email) async {
    try {
      final res = await authDataSource.forgetPassword(email);
      return right(res);
    } on Exception catch (e) {
      return left(e);
    }
  }

  @override
  Future<Either<Exception, UserModel>> getUser() async {
    try {
      final res = await authDataSource.getUser();
      return right(res);
    } on Exception catch (e) {
      return left(e);
    }
  }

  @override
  Future<Either<Exception, void>> setUser(UserModel userModel) async {
    try {
      final res = await authDataSource.setUser(userModel);
      return right(res);
    } on Exception catch (e) {
      return left(e);
    }
  }

  @override
  Future<Either<Exception, UserModel>> signInWithEmailnPassword(
      String email, String password) async {
    try {
      final res =
          await authDataSource.signInWithEmailnPassword(email, password);
      return right(res);
    } on Exception catch (e) {
      return left(e);
    }
  }

  @override
  Future<Either<Exception, void>> signOut() async {
    try {
      final res = await authDataSource.signOut();
      return right(res);
    } on Exception catch (e) {
      return left(e);
    }
  }

  @override
  Future<Either<Exception, UserModel>> signUpWithEmailnPassword(
      UserModel userModel, String password, File file) async {
    try {
      final res =
          await authDataSource.signUpWithEmailnPassword(userModel, password, file);
      return right(res);
    } on Exception catch (e) {
      return left(e);
    }
  }

  // @override
  // Future<Either<Exception, void>> signUpWithFacebook(
  //     UserModel? userModel, String priority) async {
  //   try {
  //     final res = await authDataSource.signUpWithFacebook(userModel, priority);
  //     return right(res);
  //   } on Exception catch (e) {
  //     return left(e);
  //   }
  // }

  @override
  Future<Either<Exception, void>> signUpWithGoogle(
      UserModel? userModel, String priority) async {
    try {
      final res = await authDataSource.signUpWithGoogle(userModel, priority);
      return right(res);
    } on Exception catch (e) {
      return left(e);
    }
  }
}
