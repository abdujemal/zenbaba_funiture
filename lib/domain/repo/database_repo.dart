import 'dart:io';
import 'package:dartz/dartz.dart';
import 'package:zenbaba_funiture/data/model/employee_activity_model.dart';

import '../../data/data_src/database_data_src.dart';
import '../../data/model/cutomer_model.dart';
import '../../data/model/employee_model.dart';
import '../../data/model/expense_chart_model.dart';
import '../../data/model/expense_model.dart';
import '../../data/model/item_history_model.dart';
import '../../data/model/item_model.dart';
import '../../data/model/order_chart_model.dart';
import '../../data/model/order_model.dart';
import '../../data/model/product_model.dart';
import '../../data/model/user_model.dart';

abstract class DatabaseRepo {
  Future<Either<Exception, List<ExpenseChartModel>>> getExpenseChart();
  Future<Either<Exception, List<OrderChartModel>>> getOrderChart();
  Future<Either<Exception, void>> addProduct(
      ProductModel productModel, List<File> files);
  Future<Either<Exception, List<ProductModel>>> getProducts(
      int? quantity, String? category, bool isNew);
  Future<Either<Exception, List<ProductModel>>> searchProducts(
      String key, String value, int length);
  Future<Either<Exception, void>> updateProduct(
      ProductModel productModel, List<File> files);
  Future<Either<Exception, int>> count(String path, String key, String value);
  Future<Either<Exception, String>> addOrder(OrderModel orderModel);
  Future<Either<Exception, List<OrderModel>>> getOrders(
      int? quantity, String? status, String? date, bool isNew);
  Future<Either<Exception, OrderModel>> getOrder(String id);
  Future<Either<Exception, void>> updateOrder(
      OrderModel orderModel, String prevState);
  Future<Either<Exception, void>> addItem(ItemModel itemModel, File? file);
  Future<Either<Exception, List<ItemModel>>> getItems();
  Future<Either<Exception, List<ItemHistoryModel>>> getStockActivities(
      int quantity, bool isNew);
  Future<Either<Exception, void>> updateItem(ItemModel itemModel, File? file,
      {int? quantity});
  Future<Either<Exception, void>> addItemHistory(
      ItemHistoryModel itemHistoryModel, String itemId);
  Future<Either<Exception, void>> addExpense(ExpenseModel expenseModel);
  Future<Either<Exception, List<ExpenseModel>>> searchExpense(
      String sellerName);
  Future<Either<Exception, List<ExpenseModel>>> getExpenses(
      int? quantity, String? status, String? date, bool isNew);
  Future<Either<Exception, void>> updateExpense(ExpenseModel expenseModel);
  Future<Either<Exception, List<UserModel>>> getUsers();
  Future<Either<Exception, void>> updateUser(UserModel userModel);
  Future<Either<Exception, String>> addCustomer(CustomerModel customerModel);
  Future<Either<Exception, List<CustomerModel>>> getCustomers(
      int? start, int? end);
  Future<Either<Exception, List<CustomerModel>>> searchCustomers(
      String key, String value, int length);
  Future<Either<Exception, void>> updateCustomer(CustomerModel customerModel);
  Future<Either<Exception, void>> delete(
      String path, String id, String name, bool alsoImage, int? numOfImages);
  Future<Either<Exception, void>> addUpdateEmpoloyee(
      EmployeeModel employeeModel, File? file);
  Future<Either<Exception, List<EmployeeModel>>> getEmployees();
  Future<Either<Exception, void>> addUpdateEmployeeActivity(
      EmployeeActivityModel employeeActivityModel);
  Future<Either<Exception, List<EmployeeActivityModel>>> getEmployeeeActivities(
    String employeeId,
    int? quantity, {
    bool isNew = true,
  });
  Future<Either<Exception, List<EmployeeActivityModel>>> searchEmployee(
    String month,
    String year,
    String employeeId,
  );
  Future<Either<Exception, List>> search(
    String firebasePath,
    String key,
    String val,
    SearchType searchType, {
    required String? key2,
    required String? val2,
  });
  Future<Either<Exception, int>> countDoc(
    String path,
    String keyForDate,
    String startDate,
    String endDate,
  );
}
