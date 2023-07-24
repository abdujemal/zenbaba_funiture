import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../base_usecase.dart';
import '../../data/model/order_model.dart';
import '../repo/database_repo.dart';

class GetSingleOrderUsecase
    extends BaseUseCase<OrderModel, GetSingleOrderParams> {
  DatabaseRepo databaseRepo;
  GetSingleOrderUsecase(this.databaseRepo);
  @override
  Future<Either<Exception, OrderModel>> call(
      GetSingleOrderParams parameters) async {
    final res = await databaseRepo.getOrder(parameters.id);
    return res;
  }
}

class GetSingleOrderParams extends Equatable {
  final String id;
  const GetSingleOrderParams(this.id);

  @override
  List<Object?> get props => [id];
}
