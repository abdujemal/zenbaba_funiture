import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../base_usecase.dart';
import '../../data/model/order_model.dart';
import '../repo/database_repo.dart';

class GetORderUsecase extends BaseUseCase<List<OrderModel>, GetOrderParams> {
  DatabaseRepo databaseRepo;
  GetORderUsecase(this.databaseRepo);
  @override
  Future<Either<Exception, List<OrderModel>>> call(
      GetOrderParams parameters) async {
    final res = await databaseRepo.getOrders(
      parameters.quantity,
      parameters.status,
      parameters.date,
      parameters.isNew,
    );
    return res;
  }
}

class GetOrderParams extends Equatable {
  final int? quantity;
  final String? status;
  final String? date;
  final bool isNew;
  const GetOrderParams({
    required this.quantity,
    required this.status,
    this.date,
    required this.isNew,
  });
  @override
  List<Object?> get props => [quantity, status, date];
}
