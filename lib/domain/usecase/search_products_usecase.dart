// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:dartz/dartz.dart';
import 'package:zenbaba_funiture/domain/usecase/search_customers_usecase.dart';

import '../../base_usecase.dart';
import '../../data/model/product_model.dart';
import '../repo/database_repo.dart';

class SearchProductsUsecase
    extends BaseUseCase<List<ProductModel>, SearchParams> {
  DatabaseRepo databaseRepo;
  SearchProductsUsecase(this.databaseRepo);

  @override
  Future<Either<Exception, List<ProductModel>>> call(
      SearchParams parameters) async {
    final res =
        await databaseRepo.searchProducts(parameters.key, parameters.value, parameters.length);
    return res;
  }
}
