import 'package:dartz/dartz.dart';

import '../../base_usecase.dart';
import '../../data/model/order_chart_model.dart';
import '../repo/database_repo.dart';

class GetOrderChartUsecase extends BaseUseCase<List<OrderChartModel>, NoParameters> {
  DatabaseRepo databaseRepo;
  GetOrderChartUsecase(this.databaseRepo);

  @override
  Future<Either<Exception, List<OrderChartModel>>> call(NoParameters parameters) async {
    final res = await databaseRepo.getOrderChart();
    return res;
  }
}
