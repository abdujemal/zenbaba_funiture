import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../base_usecase.dart';
import '../../data/model/expense_model.dart';
import '../repo/database_repo.dart';

class UpdateExpenseUsecase extends BaseUseCase<void, UpdateExpenseParams> {
  DatabaseRepo databaseRepo;
  UpdateExpenseUsecase(this.databaseRepo);
  @override
  Future<Either<Exception, void>> call(UpdateExpenseParams parameters) async {
    final res = await databaseRepo.updateExpense(parameters.expenseModel);
    return res;
  }
}

class UpdateExpenseParams extends Equatable {
  final ExpenseModel expenseModel;
  const UpdateExpenseParams(this.expenseModel);

  @override
  List<Object?> get props => [expenseModel];
}
