// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import 'package:zenbaba_funiture/base_usecase.dart';
import 'package:zenbaba_funiture/domain/repo/database_repo.dart';

import '../../data/data_src/database_data_src.dart';

class SearchUsecase extends BaseUseCase<List, Search1Params> {
  final DatabaseRepo databaseRepo;
  SearchUsecase({
    required this.databaseRepo,
  });

  @override
  Future<Either<Exception, List>> call(Search1Params p) async {
    final res = await databaseRepo.search(p.firebasePath, p.key, p.val, p.searchType, key2: p.key2, val2: p.val2);

    return res;
  }
}

class Search1Params extends Equatable {
  final String firebasePath;
  final String key;
  final String val;
   final String? key2;
  final String? val2;
  final SearchType searchType;
  const Search1Params({
    required this.firebasePath,
    required this.key,
    required this.val,
   required this.key2,
    required this.val2,
    required this.searchType,
  });

  @override
  List<Object?> get props => [firebasePath, key, val, searchType];
}
