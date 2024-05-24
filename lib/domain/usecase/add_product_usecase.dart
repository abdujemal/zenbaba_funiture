import 'dart:io';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../base_usecase.dart';
import '../../data/model/product_model.dart';
import '../repo/database_repo.dart';

class AddProductUsecase extends BaseUseCase<List<String>?, AddProductsParams> {
  DatabaseRepo databaseRepo;
  AddProductUsecase(this.databaseRepo);
  @override
  Future<Either<Exception, List<String>?>> call(AddProductsParams parameters) async {
    final res = await databaseRepo.addProduct(
      parameters.productModel,
      parameters.files,
      parameters.pdfFile,
      parameters.names,
    );
    return res;
  }
}

class AddProductsParams extends Equatable {
  final ProductModel productModel;
  final List files;
  final dynamic pdfFile;
  final List<String> names;
  const AddProductsParams(
      this.productModel, this.files, this.pdfFile, this.names);
  @override
  List<Object?> get props => [productModel, files, pdfFile, names];
}
