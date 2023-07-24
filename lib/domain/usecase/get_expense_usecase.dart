// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../base_usecase.dart';
import '../../data/model/expense_model.dart';
import '../repo/database_repo.dart';

class GetExpenseUsecase
    extends BaseUseCase<List<ExpenseModel>, GetExpenseParam> {
  DatabaseRepo databaseRepo;
  GetExpenseUsecase(this.databaseRepo);
  @override
  Future<Either<Exception, List<ExpenseModel>>> call(
      GetExpenseParam parameters) async {
    final res = await databaseRepo.getExpenses(
      parameters.quantity,
      parameters.status,
      parameters.date,
      parameters.isNew
    );
    return res;
  }
}

class GetExpenseParam extends Equatable {
  final int? quantity;
  final String? status;
  final String? date;
  final bool isNew;
  const GetExpenseParam({
    required this.quantity,
    required this.status,
    required this.date,
    required this.isNew,
  });
  @override
  List<Object?> get props => [quantity, status, date];
}
