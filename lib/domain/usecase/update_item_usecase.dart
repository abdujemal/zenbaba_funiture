import 'dart:io';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../base_usecase.dart';
import '../../data/model/item_model.dart';
import '../repo/database_repo.dart';

class UpdateItemUsecase extends BaseUseCase<void, UpdateItemParams> {
  DatabaseRepo databaseRepo;
  UpdateItemUsecase(this.databaseRepo);
  @override
  Future<Either<Exception, void>> call(UpdateItemParams parameters) async {
    final res = await databaseRepo
        .updateItem(parameters.itemModel, parameters.file, quantity: parameters.quantity);
    return res;
  }
}

class UpdateItemParams extends Equatable {
  final ItemModel itemModel;
  final dynamic file;
  final int? quantity;
  const UpdateItemParams(this.file, this.itemModel, {this.quantity});
  @override
  List<Object?> get props => [file, itemModel, quantity];
}
