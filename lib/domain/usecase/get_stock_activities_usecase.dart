// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import 'package:zenbaba_funiture/base_usecase.dart';
import 'package:zenbaba_funiture/domain/repo/database_repo.dart';

import '../../data/model/item_history_model.dart';

class GetStockActivitiesUsecase
    extends BaseUseCase<List<ItemHistoryModel>, GetStockActivityParams> {
  final DatabaseRepo databaseRepo;
  GetStockActivitiesUsecase(this.databaseRepo);
  @override
  Future<Either<Exception, List<ItemHistoryModel>>> call(
      GetStockActivityParams parameters) async {
    final res = await databaseRepo.getStockActivities(
        parameters.quantity, parameters.isNew);
    return res;
  }
}

class GetStockActivityParams extends Equatable {
  final int quantity;
  final bool isNew;
  const GetStockActivityParams({
    required this.quantity,
    required this.isNew,
  });

  @override
  List<Object?> get props => [quantity, isNew];
}
