import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../base_usecase.dart';
import '../../data/model/order_model.dart';
import '../repo/database_repo.dart';

class AddOrderUsecase extends BaseUseCase<String, AddOrderParams> {
  DatabaseRepo databaseRepo;
  AddOrderUsecase(this.databaseRepo);
  @override
  Future<Either<Exception, String>> call(AddOrderParams parameters) async {
    final res = await databaseRepo.addOrder(parameters.orderModel);
    return res;
  }

}

class AddOrderParams extends Equatable {
  final OrderModel orderModel;
  const AddOrderParams(this.orderModel);
  @override
  List<Object?> get props => throw UnimplementedError();
}
