import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../base_usecase.dart';
import '../../data/model/user_model.dart';
import '../repo/database_repo.dart';

class UpdateUserUsecase extends BaseUseCase<void, UpdateUserParams> {
  DatabaseRepo databaseRepo;
  UpdateUserUsecase(this.databaseRepo);
  @override
  Future<Either<Exception, void>> call(UpdateUserParams parameters) async {
    final res = await databaseRepo.updateUser(parameters.userModel);
    return res;
  }
}

class UpdateUserParams extends Equatable {
  final UserModel userModel;
  const UpdateUserParams(this.userModel);

  @override
  List<Object?> get props => [userModel];
}
