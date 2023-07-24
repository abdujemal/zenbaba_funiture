import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../base_usecase.dart';
import '../../data/model/cutomer_model.dart';
import '../repo/database_repo.dart';

class UpdateCustomerUsecase extends BaseUseCase<void, UpdateCustomerPArams> {
  DatabaseRepo databaseRepo;
  UpdateCustomerUsecase(this.databaseRepo);
  @override
  Future<Either<Exception, void>> call(UpdateCustomerPArams parameters) async {
    final res = await databaseRepo.updateCustomer(parameters.customerModel);
    return res;
  }
}

class UpdateCustomerPArams extends Equatable {
  final CustomerModel customerModel;
  const UpdateCustomerPArams(this.customerModel);
  @override
  List<Object?> get props => [customerModel];
}
