import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../base_usecase.dart';
import '../repo/database_repo.dart';

class DeleteUsecase extends BaseUseCase<void, DeleteParams> {
  DatabaseRepo databaseRepo;
  DeleteUsecase(this.databaseRepo);
  @override
  Future<Either<Exception, void>> call(DeleteParams parameters) async {
    final res = await databaseRepo.delete(
      parameters.path,
      parameters.id,
      parameters.name,
      parameters.alsoImage,
      parameters.numOfImages,
    );
    return res;
  }
}

class DeleteParams extends Equatable {
  final String path, id, name;
  final bool alsoImage;
  final int? numOfImages;
  const DeleteParams({
    required this.alsoImage,
    required this.id,
    required this.path,
    required this.name,
    required this.numOfImages,
  });

  @override
  List<Object?> get props => [path, id, alsoImage, name, numOfImages];
}
