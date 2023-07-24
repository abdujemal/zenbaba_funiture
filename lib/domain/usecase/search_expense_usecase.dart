import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../base_usecase.dart';
import '../../data/model/expense_model.dart';
import '../repo/database_repo.dart';

class SearchExpenseUsecase
    extends BaseUseCase<List<ExpenseModel>, SearchExpenseParams> {
  DatabaseRepo databaseRepo;
  SearchExpenseUsecase(this.databaseRepo);
  @override
  Future<Either<Exception, List<ExpenseModel>>> call(
      SearchExpenseParams parameters) async {
    final res = await databaseRepo.searchExpense(parameters.sellerName);
    return res;
  }
}

class SearchExpenseParams extends Equatable {
  final String sellerName;
  const SearchExpenseParams(this.sellerName);

  @override
  List<Object?> get props => [sellerName];
}
