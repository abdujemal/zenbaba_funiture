import 'dart:io';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../base_usecase.dart';
import '../../data/model/product_model.dart';
import '../repo/database_repo.dart';

class AddProductUsecase extends BaseUseCase<void, AddProductsParams> {
  DatabaseRepo databaseRepo;
  AddProductUsecase(this.databaseRepo);
  @override
  Future<Either<Exception, void>> call(AddProductsParams parameters) async {
    final res =
        await databaseRepo.addProduct(parameters.productModel, parameters.files);
    return res;
  }
}

class AddProductsParams extends Equatable {
  final ProductModel productModel;
  final List files;
  const AddProductsParams(this.productModel, this.files);
  @override
  List<Object?> get props => [productModel, files];
}
