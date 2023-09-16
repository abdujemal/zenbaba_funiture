// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import 'package:zenbaba_funiture/base_usecase.dart';
import 'package:zenbaba_funiture/domain/repo/database_repo.dart';

class CountDocUsecase extends BaseUseCase<int, CountDocParams> {
  final DatabaseRepo databaseRepo;
  CountDocUsecase({
    required this.databaseRepo,
  });
  @override
  Future<Either<Exception, int>> call(CountDocParams parameters) async {
    final res = await databaseRepo.countDoc(
      parameters.path,
      parameters.keyForDate,
      parameters.startDate,
      parameters.endDate,
    );
    return res;
  }
}

class CountDocParams extends Equatable {
  final String path;
  final String keyForDate;
  final String startDate;
  final String endDate;
  const CountDocParams({
    required this.path,
    required this.keyForDate,
    required this.startDate,
    required this.endDate,
  });
  @override
  List<Object?> get props => [path, keyForDate, startDate, endDate];
}
