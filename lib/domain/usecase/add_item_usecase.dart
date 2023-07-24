import 'dart:io';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../base_usecase.dart';
import '../../data/model/item_model.dart';
import '../repo/database_repo.dart';

class AddItemUsecase extends BaseUseCase<void, AddItemParams> {
  DatabaseRepo databaseRepo;
  AddItemUsecase(this.databaseRepo);
  @override
  Future<Either<Exception, void>> call(AddItemParams parameters) async {
    final res =
        await databaseRepo.addItem(parameters.itemModel, parameters.file);
    return res;
  }
}

class AddItemParams extends Equatable {
  final ItemModel itemModel;
  final File file;
  const AddItemParams(this.file, this.itemModel);
  @override
  List<Object?> get props => [file, itemModel];
}
