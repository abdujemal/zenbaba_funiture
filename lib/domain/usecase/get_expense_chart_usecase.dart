// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:dartz/dartz.dart';

import '../../base_usecase.dart';
import '../../data/model/expense_chart_model.dart';
import '../repo/database_repo.dart';

class GetExpenseChartUsecase extends BaseUseCase<List<ExpenseChartModel>, NoParameters> {
  DatabaseRepo databaseRepo;
  GetExpenseChartUsecase(this.databaseRepo);

  @override
  Future<Either<Exception, List<ExpenseChartModel>>> call(NoParameters parameters) async {
    final res = await databaseRepo.getExpenseChart();
    return res;
  }
}