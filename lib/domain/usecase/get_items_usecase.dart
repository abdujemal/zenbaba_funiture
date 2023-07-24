import 'package:dartz/dartz.dart';

import '../../base_usecase.dart';
import '../../data/model/item_model.dart';
import '../repo/database_repo.dart';

class GetItemUsecase extends BaseUseCase<List<ItemModel>, NoParameters>{
  DatabaseRepo databaseRepo;
  GetItemUsecase(this.databaseRepo);
  @override
  Future<Either<Exception, List<ItemModel>>> call(NoParameters parameters) async {
    final res = await databaseRepo.getItems();
    return res;
  }

}