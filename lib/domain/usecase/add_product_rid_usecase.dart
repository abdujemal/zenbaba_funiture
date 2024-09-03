import 'package:dartz/dartz.dart';
import 'package:zenbaba_funiture/domain/usecase/add_product_usecase.dart';
import '../../base_usecase.dart';
import '../repo/database_repo.dart';

class AddProductRIDUsecase extends BaseUseCase<String?, AddProductsParams> {
  DatabaseRepo databaseRepo;
  AddProductRIDUsecase(this.databaseRepo);
  @override
  Future<Either<Exception, String?>> call(AddProductsParams parameters) async {
    final res = await databaseRepo.addProductReturnId(
      parameters.productModel,
      parameters.files,
      parameters.pdfFile,
      parameters.names,
    );
    return res;
  }
}

// class AddProductsParams extends Equatable {
//   final ProductModel productModel;
//   final List files;
//   final dynamic pdfFile;
//   final List<String> names;
//   const AddProductsParams(
//       this.productModel, this.files, this.pdfFile, this.names);
//   @override
//   List<Object?> get props => [productModel, files, pdfFile, names];
// }
