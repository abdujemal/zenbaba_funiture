import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../base_usecase.dart';
import '../../data/model/expense_model.dart';
import '../repo/database_repo.dart';

class AddExpenseUsecase extends BaseUseCase<void, AddExpenseParams> {
  DatabaseRepo databaseRepo;
  AddExpenseUsecase(this.databaseRepo);
  @override
  Future<Either<Exception, void>> call(AddExpenseParams parameters) async {
    final res = await databaseRepo.addExpense(parameters.expenseModel);
    return res;
  }
}

class AddExpenseParams extends Equatable {
  final ExpenseModel expenseModel;
  const AddExpenseParams(this.expenseModel);
  @override
  List<Object?> get props => [expenseModel];
}
