// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../base_usecase.dart';
import '../repo/database_repo.dart';


class CountUsecase extends BaseUseCase<int, CounterParams> {
  DatabaseRepo databaseRepo;
  CountUsecase(this.databaseRepo);
  @override
  Future<Either<Exception, int>> call(CounterParams parameters) async {
    final res = await databaseRepo.count(
        parameters.path, parameters.key, parameters.value);
    return res;
  }
}

class CounterParams extends Equatable {
  final String path;
  final String key;
  final String value;
  const CounterParams({
    required this.path,
    required this.key,
    required this.value,
  });

  @override
  List<Object?> get props => [path, key, value];
}
