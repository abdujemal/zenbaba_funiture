import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../base_usecase.dart';
import '../../data/model/item_history_model.dart';
import '../repo/database_repo.dart';

class AddItemHistoryUsecase extends BaseUseCase<void, AddItemHistoryParams>{
  DatabaseRepo databaseRepo;
  AddItemHistoryUsecase(this.databaseRepo);
  @override
  Future<Either<Exception, void>> call(AddItemHistoryParams parameters) async {
    final res = await databaseRepo.addItemHistory(parameters.itemHistoryModel, parameters.itemId);
    return res;
  }

}

class AddItemHistoryParams extends Equatable {
  final ItemHistoryModel itemHistoryModel;
  final String itemId;
  const AddItemHistoryParams(this.itemHistoryModel, this.itemId);
  @override
  List<Object?> get props => [itemHistoryModel, itemId];
}
