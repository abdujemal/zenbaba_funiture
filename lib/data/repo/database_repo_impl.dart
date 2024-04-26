import 'package:dartz/dartz.dart';
import 'package:zenbaba_funiture/data/model/employee_activity_model.dart';
import 'package:zenbaba_funiture/data/model/employee_model.dart';

import '../../domain/repo/database_repo.dart';
import '../data_src/database_data_src.dart';
import '../model/cutomer_model.dart';
import '../model/expense_chart_model.dart';
import '../model/expense_model.dart';
import '../model/item_history_model.dart';
import '../model/item_model.dart';
import '../model/order_chart_model.dart';
import '../model/order_model.dart';
import '../model/product_model.dart';
import '../model/user_model.dart';

class DatabaseRepoImpl extends DatabaseRepo {
  DatabaseDataSrc databaseDataSrc;
  DatabaseRepoImpl(this.databaseDataSrc);
  @override
  Future<Either<Exception, String>> addCustomer(
      CustomerModel customerModel) async {
    try {
      final res = await databaseDataSrc.addCustomer(customerModel);
      return right(res);
    } on Exception catch (e) {
      return left(e);
    }
  }

  @override
  Future<Either<Exception, void>> addExpense(ExpenseModel expenseModel) async {
    try {
      final res = await databaseDataSrc.addExpense(expenseModel);
      return right(res);
    } on Exception catch (e) {
      return left(e);
    }
  }

  @override
  Future<Either<Exception, void>> addItem(ItemModel itemModel, var file) async {
    try {
      final res = await databaseDataSrc.addItem(itemModel, file);
      return right(res);
    } on Exception catch (e) {
      return left(e);
    }
  }

  @override
  Future<Either<Exception, void>> addItemHistory(
      ItemHistoryModel itemHistoryModel, String itemId) async {
    try {
      final res =
          await databaseDataSrc.addItemHistory(itemHistoryModel, itemId);
      return right(res);
    } on Exception catch (e) {
      return left(e);
    }
  }

  @override
  Future<Either<Exception, String>> addOrder(OrderModel orderModel) async {
    try {
      final res = await databaseDataSrc.addOrder(orderModel);
      return right(res);
    } on Exception catch (e) {
      return left(e);
    }
  }

  @override
  Future<Either<Exception, void>> addProduct(
      ProductModel productModel, List files, dynamic pdfFile) async {
    try {
      final res = await databaseDataSrc.addProduct(productModel, files, pdfFile);
      return right(res);
    } on Exception catch (e) {
      return left(e);
    }
  }

  @override
  Future<Either<Exception, List<CustomerModel>>> getCustomers(
      int? start, int? end) async {
    try {
      final res = await databaseDataSrc.getCustomers(start, end);
      return right(res);
    } on Exception catch (e) {
      return left(e);
    }
  }

  @override
  Future<Either<Exception, List<ExpenseModel>>> getExpenses(
      int? quantity, String? status, String? date, bool isNew) async {
    try {
      final res =
          await databaseDataSrc.getExpenses(quantity, status, date, isNew);
      return right(res);
    } on Exception catch (e) {
      return left(e);
    }
  }

  @override
  Future<Either<Exception, List<ItemModel>>> getItems() async {
    try {
      final res = await databaseDataSrc.getItems();
      return right(res);
    } on Exception catch (e) {
      return left(e);
    }
  }

  @override
  Future<Either<Exception, List<OrderModel>>> getOrders(
      int? quantity, String? status, String? date, bool isNew) async {
    try {
      final res =
          await databaseDataSrc.getOrders(quantity, status, date, isNew);
      return right(res);
    } on Exception catch (e) {
      return left(e);
    }
  }

  @override
  Future<Either<Exception, List<ProductModel>>> getProducts(
      int? quantity, String? category, bool isNew) async {
    try {
      final res = await databaseDataSrc.getProducts(quantity, category, isNew);
      return right(res);
    } on Exception catch (e) {
      return left(e);
    }
  }

  @override
  Future<Either<Exception, List<UserModel>>> getUsers() async {
    try {
      final res = await databaseDataSrc.getUsers();
      return right(res);
    } on Exception catch (e) {
      return left(e);
    }
  }

  @override
  Future<Either<Exception, void>> updateCustomer(
      CustomerModel customerModel) async {
    try {
      final res = await databaseDataSrc.updateCustomer(customerModel);
      return right(res);
    } on Exception catch (e) {
      return left(e);
    }
  }

  @override
  Future<Either<Exception, void>> updateExpense(
      ExpenseModel expenseModel) async {
    try {
      final res = await databaseDataSrc.updateExpense(expenseModel);
      return right(res);
    } on Exception catch (e) {
      return left(e);
    }
  }

  @override
  Future<Either<Exception, void>> updateItem(ItemModel itemModel, var file,
      {int? quantity}) async {
    try {
      final res =
          await databaseDataSrc.updateItem(itemModel, file, quantity: quantity);
      return right(res);
    } on Exception catch (e) {
      return left(e);
    }
  }

  @override
  Future<Either<Exception, void>> updateOrder(
      OrderModel orderModel, String prevState) async {
    try {
      final res = await databaseDataSrc.updateOrder(orderModel, prevState);
      return right(res);
    } on Exception catch (e) {
      return left(e);
    }
  }

  @override
  Future<Either<Exception, void>> updateProduct(
      ProductModel productModel, List files, dynamic pdfFile) async {
    try {
      final res = await databaseDataSrc.updateProduct(productModel, files, pdfFile);
      return right(res);
    } catch (e) {
      print(e.toString());
      return left(Exception(e.toString()));
    }
  }

  @override
  Future<Either<Exception, void>> updateUser(UserModel userModel) async {
    try {
      final res = await databaseDataSrc.updateUser(userModel);
      return right(res);
    } on Exception catch (e) {
      return left(e);
    }
  }

  @override
  Future<Either<Exception, void>> delete(String path, String id, String name,
      bool alsoImage, List<String> images) async {
    try {
      final res =
          await databaseDataSrc.delete(path, id, name, alsoImage, images);
      return right(res);
    } on Exception catch (e) {
      return left(e);
    }
  }

  @override
  Future<Either<Exception, List<CustomerModel>>> searchCustomers(
      String key, String value, int length) async {
    try {
      final res = await databaseDataSrc.searchCustomers(key, value, length);
      return right(res);
    } on Exception catch (e) {
      return left(e);
    }
  }

  @override
  Future<Either<Exception, List<ProductModel>>> searchProducts(
      String key, String value, int length) async {
    try {
      final res = await databaseDataSrc.searchProducts(key, value, length);
      return right(res);
    } on Exception catch (e) {
      return left(e);
    }
  }

  @override
  Future<Either<Exception, int>> count(
      String path, String key, String value) async {
    try {
      final res = await databaseDataSrc.count(path, key, value);
      return right(res);
    } on Exception catch (e) {
      return left(e);
    }
  }

  @override
  Future<Either<Exception, List<ExpenseChartModel>>> getExpenseChart() async {
    try {
      final res = await databaseDataSrc.getExpenseChart();
      return right(res);
    } on Exception catch (e) {
      return left(e);
    }
  }

  @override
  Future<Either<Exception, List<OrderChartModel>>> getOrderChart() async {
    try {
      final res = await databaseDataSrc.getOrderChart();
      return right(res);
    } on Exception catch (e) {
      return left(e);
    }
  }

  @override
  Future<Either<Exception, OrderModel>> getOrder(String id) async {
    try {
      final res = await databaseDataSrc.getOrder(id);
      return right(res);
    } on Exception catch (e) {
      return left(e);
    }
  }

  @override
  Future<Either<Exception, List<ExpenseModel>>> searchExpense(
      String sellerName) async {
    try {
      final res = await databaseDataSrc.searchExpense(sellerName);
      return right(res);
    } on Exception catch (e) {
      return left(e);
    }
  }

  @override
  Future<Either<Exception, void>> addUpdateEmpoloyee(
    EmployeeModel employeeModel,
    var file,
  ) async {
    try {
      final res = await databaseDataSrc.addUpdateEmpoloyee(
        employeeModel,
        file,
      );
      return right(res);
    } on Exception catch (e) {
      return left(e);
    }
  }

  @override
  Future<Either<Exception, List<EmployeeModel>>> getEmployees() async {
    try {
      final res = await databaseDataSrc.getEmployees();
      return right(res);
    } on Exception catch (e) {
      return left(e);
    }
  }

  @override
  Future<Either<Exception, void>> addUpdateEmployeeActivity(
      EmployeeActivityModel employeeActivityModel) async {
    try {
      final res = await databaseDataSrc
          .addUpdateEmployeeActivity(employeeActivityModel);
      return right(res);
    } on Exception catch (e) {
      return left(e);
    }
  }

  @override
  Future<Either<Exception, List<EmployeeActivityModel>>> getEmployeeeActivities(
    String employeeId,
    int? quantity, {
    bool isNew = true,
  }) async {
    try {
      final res = await databaseDataSrc
          .getEmployeeeActivities(employeeId, quantity, isNew: isNew);
      return right(res);
    } on Exception catch (e) {
      return left(e);
    }
  }

  @override
  Future<Either<Exception, List>> search(
    String firebasePath,
    String key,
    String val,
    SearchType searchType, {
    required String? key2,
    required String? val2,
  }) async {
    try {
      final res = await databaseDataSrc
          .search(firebasePath, key, val, searchType, key2: key2, val2: val2);
      return right(res);
    } on Exception catch (e) {
      return left(e);
    }
  }

  @override
  Future<Either<Exception, int>> countDoc(
    String path,
    String keyForDate,
    String startDate,
    String endDate,
  ) async {
    try {
      final res =
          await databaseDataSrc.countDoc(path, keyForDate, startDate, endDate);
      return right(res);
    } on Exception catch (e) {
      return left(e);
    }
  }

  @override
  Future<Either<Exception, List<EmployeeActivityModel>>> searchEmployee(
      String month, String year, String employeeId) async {
    try {
      final res = await databaseDataSrc.searchEmployee(month, year, employeeId);
      return right(res);
    } on Exception catch (e) {
      return left(e);
    }
  }

  @override
  Future<Either<Exception, List<ItemHistoryModel>>> getStockActivities(
      int quantity, bool isNew) async {
    try {
      final res = await databaseDataSrc.getStockActivities(quantity, isNew);
      return right(res);
    } on Exception catch (e) {
      return left(e);
    }
  }
}
