import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../base_usecase.dart';
import '../../data/model/product_model.dart';
import '../repo/database_repo.dart';

class UpdateProductUsecase extends BaseUseCase<void, UpdateProductParams> {
  DatabaseRepo databaseRepo;
  UpdateProductUsecase(this.databaseRepo);

  @override
  Future<Either<Exception, void>> call(UpdateProductParams parameters) async {
    final res = await databaseRepo.updateProduct(
      parameters.productModel,
      parameters.files,
      parameters.pdfFile,
      parameters.names,
    );
    return res;
  }
}

class UpdateProductParams extends Equatable {
  final ProductModel productModel;
  final List files;
  final pdfFile;
  final List<String> names;
  const UpdateProductParams(
      this.files, this.productModel, this.pdfFile, this.names);
  @override
  List<Object?> get props => [files, productModel, pdfFile, names];
}
