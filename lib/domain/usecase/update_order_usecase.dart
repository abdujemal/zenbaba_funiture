import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../base_usecase.dart';
import '../../data/model/order_model.dart';
import '../repo/database_repo.dart';

class UpdateOrderUsecase extends BaseUseCase<void, UpdateOrderParams> {
  DatabaseRepo databaseRepo;
  UpdateOrderUsecase(this.databaseRepo);
  @override
  Future<Either<Exception, void>> call(UpdateOrderParams parameters) async {
    final res = await databaseRepo.updateOrder(parameters.orderModel, parameters.prevState);
    return res;
  }
}

class UpdateOrderParams extends Equatable {
  final OrderModel orderModel;
  final String prevState;
  const UpdateOrderParams(this.orderModel, this.prevState);

  @override
  List<Object?> get props => [orderModel, prevState];
}
