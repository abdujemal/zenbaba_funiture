import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../base_usecase.dart';
import '../../data/model/cutomer_model.dart';
import '../repo/database_repo.dart';

class AddCustomerUsecase extends BaseUseCase<String, AddCutomerParams> {
  DatabaseRepo databaseRepo;
  AddCustomerUsecase(this.databaseRepo);
  @override
  Future<Either<Exception, String>> call(AddCutomerParams parameters) async {
    final res = await databaseRepo.addCustomer(parameters.customerModel);
    return res;
  }
}

class AddCutomerParams extends Equatable {
  final CustomerModel customerModel;
  const AddCutomerParams(this.customerModel);
  @override
  List<Object?> get props => [customerModel];
}
