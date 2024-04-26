// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:async';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';

import 'package:zenbaba_funiture/data/model/item_history_model.dart';
import 'package:zenbaba_funiture/data/model/review_model.dart';

import '../../constants.dart';
import '../model/cutomer_model.dart';
import '../model/employee_activity_model.dart';
import '../model/employee_model.dart';
import '../model/expense_chart_model.dart';
import '../model/expense_model.dart';
import '../model/item_model.dart';
import '../model/order_chart_model.dart';
import '../model/order_model.dart';
import '../model/product_model.dart';
import '../model/user_model.dart';

abstract class DatabaseDataSrc {
  Future<List<ExpenseChartModel>> getExpenseChart();
  Future<List<OrderChartModel>> getOrderChart();
  Future<void> addExpenseChart(ExpenseChartModel expenseChartModel);
  Future<void> addOrderChart(OrderChartModel orderChartModel);
  Future<void> deleteExpenseChart(String id);
  Future<void> deleteOrderChart(String id);
  Future<void> addProduct(
      ProductModel productModel, List files, dynamic pdfFile);
  Future<List<ProductModel>> getProducts(
      int? quantity, String? category, bool isNew);
  Future<List<ProductModel>> searchProducts(
      String key, String value, int length);
  Future<int> count(String path, String key, String value);
  Future<void> updateProduct(
      ProductModel productModel, List files, dynamic pdfFile);
  Future<String> addOrder(OrderModel orderModel);
  Future<List<OrderModel>> getOrders(
      int? quantity, String? status, String? date, bool isNew);
  Future<OrderModel> getOrder(String id);
  Future<void> updateOrder(OrderModel orderModel, String prevState);
  Future<void> addItem(ItemModel itemModel, var file);
  Future<List<ItemModel>> getItems();
  Future<List<ItemHistoryModel>> getStockActivities(int quantity, bool isNew);
  Future<void> updateItem(ItemModel itemModel, var file, {int? quantity});
  Future<void> addItemHistory(ItemHistoryModel itemHistoryModel, String itemId);
  Future<void> addExpense(ExpenseModel expenseModel);
  Future<List<ExpenseModel>> searchExpense(String sellerName);
  Future<List<ExpenseModel>> getExpenses(
      int? quantity, String? status, String? date, bool isNew);
  Future<void> updateExpense(ExpenseModel expenseModel);
  Future<List<UserModel>> getUsers();
  Future<void> updateUser(UserModel userModel);
  Future<String> addCustomer(CustomerModel customerModel);
  Future<List<CustomerModel>> getCustomers(int? quantity, int? end);
  Future<List<CustomerModel>> searchCustomers(
      String key, String value, int length);
  Future<void> updateCustomer(CustomerModel customerModel);
  Future<void> delete(
      String path, String id, String name, bool alsoImage, List<String> images);
  Future<void> addUpdateEmpoloyee(EmployeeModel employeeModel, var file);
  Future<List<EmployeeModel>> getEmployees();
  Future<void> addUpdateEmployeeActivity(
      EmployeeActivityModel employeeActivity);
  Future<List<EmployeeActivityModel>> getEmployeeeActivities(
    String employeeId,
    int? quantity, {
    bool isNew = true,
  });
  Future<List<EmployeeActivityModel>> searchEmployee(
    String month,
    String year,
    String employeeId,
  );
  Future<List> search(
    String firebasePath,
    String key,
    String val,
    SearchType searchType, {
    required String? key2,
    required String? val2,
  });
  Future<int> countDoc(
    String path,
    String keyForDate,
    String startDate,
    String endDate,
  );
}

class DatabaseDataSrcImpl extends DatabaseDataSrc {
  FirebaseAuth firebaseAuth;
  FirebaseFirestore firebaseFirestore;
  FirebaseStorage firebaseStorage;

  DatabaseDataSrcImpl({
    required this.firebaseAuth,
    required this.firebaseFirestore,
    required this.firebaseStorage,
  });

  DocumentSnapshot? lastStoreActivity;
  DocumentSnapshot? lastProductDoc;
  DocumentSnapshot? lastPendingOrder;
  DocumentSnapshot? lastProccessingOrder;
  DocumentSnapshot? lastCompletedOrder;
  DocumentSnapshot? lastUnpayedExpense;
  DocumentSnapshot? lastPayedExpense;
  DocumentSnapshot? lastEmployeeActivity;
  DocumentSnapshot? lastItemHistory;

  @override
  Future<String> addCustomer(CustomerModel customerModel) async {
    final ref = await firebaseFirestore
        .collection(FirebaseConstants.customers)
        .add(customerModel.toMap());

    return ref.id;
  }

  @override
  Future<void> addExpense(ExpenseModel expenseModel) async {
    if (expenseModel.category == ExpenseCategory.employee) {
      final activityQs = await firebaseFirestore
          .collection(FirebaseConstants.employeeActivity)
          .where('employeeId', isEqualTo: expenseModel.employeeId)
          .where('date', isEqualTo: expenseModel.date)
          .get();

      if (activityQs.docs.isNotEmpty) {
        await firebaseFirestore
            .collection(FirebaseConstants.employeeActivity)
            .doc(activityQs.docs[0].id)
            .update(
          {
            'payment': expenseModel.price,
          },
        );
      } else {
        throw Exception(
            "There is not employee Activity, please go and create employee activity for ${expenseModel.seller}.");
      }
    }

    final ds = await firebaseFirestore
        .collection(FirebaseConstants.expenses)
        .add(expenseModel.toMap());

    await addExpenseChart(
      ExpenseChartModel(
        id: ds.id,
        date: expenseModel.date,
        price: expenseModel.price,
        category: expenseModel.category,
      ),
    );
  }

  @override
  Future<void> addItem(ItemModel itemModel, var file) async {
    int id = Random().nextInt(999999);

    String itemId =
        "${List.generate(6 - "$id".length, (index) => "0").join()}$id";

    if (itemModel.image != null && file == null) {
      await firebaseFirestore
          .collection(FirebaseConstants.items)
          .doc(itemId)
          .set(itemModel.toMap());
      return;
    } else {
      final ref = firebaseStorage
          .ref()
          .child("${FirebaseConstants.items}/${itemModel.name}");
      UploadTask task = kIsWeb ? ref.putData(file) : ref.putFile(file!);
      String imageUrl =
          await (await task.whenComplete(() {})).ref.getDownloadURL();

      ItemModel newItem = itemModel.copyWith(image: imageUrl);

      await firebaseFirestore
          .collection(FirebaseConstants.items)
          .doc(itemId)
          .set(newItem.toMap());
    }
  }

  @override
  Future<void> addItemHistory(
      ItemHistoryModel itemHistoryModel, String itemId) async {
    await firebaseFirestore
        .collection(FirebaseConstants.itemsHistories)
        .add(itemHistoryModel.toMap());
  }

  @override
  Future<String> addOrder(OrderModel orderModel) async {
    int id = Random().nextInt(999999);
    String orderId =
        "${List.generate(6 - "$id".length, (index) => "0").join()}$id";

    await firebaseFirestore
        .collection(FirebaseConstants.orders)
        .doc(orderId)
        .set(orderModel.toMap());

    await addOrderChart(
      OrderChartModel(
        orderId: orderId,
        date: orderModel.orderedDate,
        price: orderModel.payedPrice,
      ),
    );

    if (orderModel.status == OrderStatus.Delivered) {
      await addOrderChart(
        OrderChartModel(
          orderId: orderId,
          date: orderModel.finishedDate,
          price: ((orderModel.productPrice * orderModel.quantity) -
                  orderModel.payedPrice) +
              orderModel.deliveryPrice,
        ),
      );
    }

    return orderId;
  }

  @override
  Future<void> addProduct(
      ProductModel productModel, List files, dynamic pdfFile) async {
    if (productModel.images.isNotEmpty && files.isEmpty) {
      print("files is empty");

      if (pdfFile != null) {
        final ref = firebaseStorage.ref().child(
            "${FirebaseConstants.products}/PDFs/${productModel.name}${productModel.sku}");
        UploadTask task =
            pdfFile is Uint8List ? ref.putData(pdfFile) : ref.putFile(pdfFile);
        String pdfUrl =
            await (await task.whenComplete(() {})).ref.getDownloadURL();
        productModel = productModel.copyWith(pdfLink: pdfUrl);
      }

      await firebaseFirestore
          .collection(FirebaseConstants.products)
          .add(productModel.toMap());
    } else {
      print("files is not empty");

      List<String> imagesUrl = [];
      int i = 0;
      for (var file in files) {
        final ref = firebaseStorage
            .ref()
            .child("${FirebaseConstants.products}/${productModel.sku}$i");
        UploadTask task = kIsWeb ? ref.putData(file) : ref.putFile(file);
        String imageUrl =
            await (await task.whenComplete(() {})).ref.getDownloadURL();
        i++;
        imagesUrl.add(imageUrl);
      }

      if (pdfFile != null) {
        final ref = firebaseStorage.ref().child(
            "${FirebaseConstants.products}/PDFs/${productModel.name}${productModel.sku}");
        UploadTask task =
            pdfFile is Uint8List ? ref.putData(pdfFile) : ref.putFile(pdfFile);
        String pdfUrl =
            await (await task.whenComplete(() {})).ref.getDownloadURL();
        productModel = productModel.copyWith(pdfLink: pdfUrl);
      }

      ProductModel newItem = productModel.copyWith(images: imagesUrl);

      await firebaseFirestore
          .collection(FirebaseConstants.products)
          .add(newItem.toMap());
    }
  }

  @override
  Future<List<CustomerModel>> getCustomers(int? quantity, int? end) async {
    QuerySnapshot customersds;

    if (quantity == null && end == null) {
      customersds =
          await firebaseFirestore.collection(FirebaseConstants.customers).get();
    } else {
      customersds = await firebaseFirestore
          .collection(FirebaseConstants.customers)
          .orderBy('name')
          .limit(end!)
          .limitToLast(quantity!)
          .get();
    }

    List<CustomerModel> list = [];

    for (var snap in customersds.docs) {
      CustomerModel customerModel = CustomerModel.fromFirebase(snap);
      list.add(customerModel);
    }

    return list;
  }

  @override
  Future<List<ExpenseModel>> getExpenses(
      int? quantity, String? status, String? date, bool isNew) async {
    QuerySnapshot? expenseqs;
    if (quantity != null && status != null) {
      DocumentSnapshot? lastExpense =
          status == ExpenseState.payed ? lastPayedExpense : lastUnpayedExpense;
      if (isNew) {
        lastExpense = null;
      }
      if (date == null) {
        print("quantity: $quantity, status: $status");
        expenseqs = lastExpense == null
            ? await firebaseFirestore
                .collection(FirebaseConstants.expenses)
                .where("expenseStatus", isEqualTo: status)
                .orderBy('date', descending: true)
                .limit(quantity)
                .get()
            : await firebaseFirestore
                .collection(FirebaseConstants.expenses)
                .where("expenseStatus", isEqualTo: status)
                .orderBy('date', descending: true)
                .startAfterDocument(lastExpense)
                .limit(quantity)
                .get();
        if (expenseqs.docs.isNotEmpty) {
          if (status == ExpenseState.payed) {
            lastPayedExpense = expenseqs.docs[expenseqs.docs.length - 1];
          } else {
            lastUnpayedExpense = expenseqs.docs[expenseqs.docs.length - 1];
          }
        }
      } else {
        expenseqs = await firebaseFirestore
            .collection(FirebaseConstants.expenses)
            .where("expenseStatus", isEqualTo: status)
            .where("date", isEqualTo: date)
            .get();
      }
    } else {
      expenseqs =
          await firebaseFirestore.collection(FirebaseConstants.expenses).get();
    }

    List<ExpenseModel> expenses = [];

    for (var snap in expenseqs.docs) {
      ExpenseModel expenseModel = ExpenseModel.fromFirebase(snap);
      expenses.add(expenseModel);
    }

    return expenses;
  }

  @override
  Future<List<ItemModel>> getItems() async {
    final itemqs =
        await firebaseFirestore.collection(FirebaseConstants.items).get();

    List<ItemModel> items = [];

    for (var snap in itemqs.docs) {
      ItemModel itemModel = ItemModel.fromFirebase(snap);
      items.add(itemModel);
    }

    return items;
  }

  @override
  Future<List<ItemHistoryModel>> getStockActivities(
      int quantity, bool isNew) async {
    QuerySnapshot? qs;

    if (isNew) {
      lastStoreActivity = null;
    }

    qs = lastStoreActivity == null
        ? await firebaseFirestore
            .collection(FirebaseConstants.itemsHistories)
            .orderBy('date', descending: true)
            .limit(quantity)
            .get()
        : await firebaseFirestore
            .collection(FirebaseConstants.itemsHistories)
            .orderBy('date', descending: true)
            .startAfterDocument(lastStoreActivity!)
            .limit(quantity)
            .get();
    if (qs.docs.isNotEmpty) {
      lastStoreActivity = qs.docs[qs.docs.length - 1];
    }

    List<ItemHistoryModel> histories = [];

    for (var snap in qs.docs) {
      ItemHistoryModel model = ItemHistoryModel.fromMap(snap);
      histories.add(model);
    }

    return histories;
  }

  @override
  Future<List<OrderModel>> getOrders(
      int? quantity, String? status, String? date, bool isNew) async {
    QuerySnapshot orderqs;

    DocumentSnapshot? lastDoc;

    if (status == OrderStatus.Pending) {
      lastDoc = lastPendingOrder;
    } else if (status == OrderStatus.proccessing) {
      lastDoc = lastProccessingOrder;
    } else {
      lastDoc = lastCompletedOrder;
    }

    if (isNew) {
      lastDoc = null;
    }
    if (quantity != null && status != null) {
      print("status: $status");
      bool isCompleted = status == OrderStatus.completed;
      bool isPending = status == OrderStatus.Pending;
      if (date == null) {
        if (lastDoc == null) {
          orderqs = isCompleted
              ? await firebaseFirestore
                  .collection(FirebaseConstants.orders)
                  .where(
                    "status",
                    whereIn: [
                      OrderStatus.completed,
                      OrderStatus.Delivered,
                    ],
                  )
                  .orderBy('finishedDate', descending: true)
                  .limit(quantity)
                  .get()
              : isPending
                  ? await firebaseFirestore
                      .collection(FirebaseConstants.orders)
                      .where(
                        "status",
                        whereIn: [
                          OrderStatus.Pending,
                          OrderStatus.ready,
                        ],
                      )
                      .orderBy('finishedDate', descending: false)
                      .limit(quantity)
                      .get()
                  : await firebaseFirestore
                      .collection(FirebaseConstants.orders)
                      .where(
                        "status",
                        isEqualTo: status,
                      )
                      .orderBy('finishedDate', descending: false)
                      .limit(quantity)
                      .get();
        } else {
          orderqs = isCompleted
              ? await firebaseFirestore
                  .collection(FirebaseConstants.orders)
                  .where(
                    "status",
                    whereIn: [
                      OrderStatus.completed,
                      OrderStatus.Delivered,
                    ],
                  )
                  .orderBy('finishedDate', descending: true)
                  .startAfterDocument(lastDoc)
                  .limit(quantity)
                  .get()
              : isPending
                  ? await firebaseFirestore
                      .collection(FirebaseConstants.orders)
                      .where(
                        "status",
                        whereIn: [
                          OrderStatus.Pending,
                          OrderStatus.ready,
                        ],
                      )
                      .orderBy('finishedDate', descending: false)
                      .startAfterDocument(lastDoc)
                      .limit(quantity)
                      .get()
                  : await firebaseFirestore
                      .collection(FirebaseConstants.orders)
                      .where(
                        "status",
                        isEqualTo: status,
                      )
                      .orderBy('finishedDate', descending: false)
                      .startAfterDocument(lastDoc)
                      .limit(quantity)
                      .get();
          // orderqs = await firebaseFirestore
          //     .collection(FirebaseConstants.orders)
          //     .where(
          //       "status",
          //       isEqualTo: !isCompleted ? status : null,
          //       whereIn: isCompleted
          //           ? [
          //               OrderStatus.Delivered,
          //               OrderStatus.completed,
          //             ]
          //           : null,
          //     )
          //     .orderBy('finishedDate', descending: true)
          //     .startAfterDocument(lastDoc)
          //     .limit(quantity)
          //     .get();
        }

        if (orderqs.docs.isNotEmpty) {
          if (status == OrderStatus.Pending) {
            lastPendingOrder = orderqs.docs[orderqs.docs.length - 1];
          } else if (status == OrderStatus.proccessing) {
            lastProccessingOrder = orderqs.docs[orderqs.docs.length - 1];
          } else {
            lastCompletedOrder = orderqs.docs[orderqs.docs.length - 1];
          }
        }
      } else {
        orderqs = await firebaseFirestore
            .collection(FirebaseConstants.orders)
            .where("status", isEqualTo: status)
            .where('finishedDate', isEqualTo: date)
            .get();
      }
    } else {
      orderqs = await firebaseFirestore
          .collection(FirebaseConstants.orders)
          .where("status", isEqualTo: OrderStatus.Pending)
          .orderBy('finishedDate')
          .get();
    }

    List<OrderModel> orders = [];

    for (var snap in orderqs.docs) {
      OrderModel orderModel = OrderModel.fromFirebase(snap);

      orders.add(orderModel);
    }
    print("orders: ${orders.length}");

    return orders;
  }

  @override
  Future<List<ProductModel>> getProducts(
      int? quantity, String? category, bool isNew) async {
    QuerySnapshot productsqs;

    if (quantity == null) {
      productsqs =
          await firebaseFirestore.collection(FirebaseConstants.products).get();
    } else if (category != null) {
      if (isNew) {
        lastProductDoc = null;
      }
      if (lastProductDoc != null) {
        print('isNew: $isNew');
        productsqs = await firebaseFirestore
            .collection(FirebaseConstants.products)
            .where("category", isEqualTo: category)
            .orderBy('name')
            .startAfterDocument(lastProductDoc!)
            .limit(quantity)
            .get();
      } else {
        productsqs = await firebaseFirestore
            .collection(FirebaseConstants.products)
            .where("category", isEqualTo: category)
            .orderBy('name')
            .limit(quantity)
            .get();
      }
    } else {
      productsqs = await firebaseFirestore
          .collection(FirebaseConstants.products)
          .orderBy("name")
          .limit(quantity)
          .get();
    }

    List<ProductModel> products = [];

    if (productsqs.docs.isNotEmpty) {
      lastProductDoc = productsqs.docs[productsqs.docs.length - 1];
    }

    for (var snap in productsqs.docs) {
      ProductModel productModel = ProductModel.fromFirebase(snap);
      products.add(productModel);
    }

    return products;
  }

  @override
  Future<List<UserModel>> getUsers() async {
    final userqs =
        await firebaseFirestore.collection(FirebaseConstants.users).get();

    List<UserModel> list = [];

    for (var snap in userqs.docs) {
      UserModel userModel = UserModel.fromFirebase(snap);
      list.add(userModel);
    }

    return list;
  }

  @override
  Future<void> updateCustomer(CustomerModel customerModel) async {
    await firebaseFirestore
        .collection(FirebaseConstants.customers)
        .doc(customerModel.id)
        .update(customerModel.toMap());
  }

  @override
  Future<void> updateExpense(ExpenseModel expenseModel) async {
    await firebaseFirestore
        .collection(FirebaseConstants.expenses)
        .doc(expenseModel.id)
        .update(expenseModel.toMap());
  }

  @override
  Future<void> updateItem(ItemModel itemModel, var file,
      {int? quantity}) async {
    if (file == null) {
      await firebaseFirestore
          .collection(FirebaseConstants.items)
          .doc(itemModel.id)
          .update(quantity != null
              ? {
                  'image': itemModel.image,
                  'name': itemModel.name,
                  'category': itemModel.category,
                  'unit': itemModel.unit,
                  'pricePerUnit': itemModel.pricePerUnit,
                  'description': itemModel.description,
                  "lastUsedFor": itemModel.lastUsedFor,
                  'quantity': quantity,
                  'timeLine': itemModel.timeLine.map((x) => x.toMap()).toList(),
                }
              : {
                  'image': itemModel.image,
                  'name': itemModel.name,
                  'category': itemModel.category,
                  'unit': itemModel.unit,
                  'pricePerUnit': itemModel.pricePerUnit,
                  'description': itemModel.description,
                  'timeLine': itemModel.timeLine.map((x) => x.toMap()).toList(),
                });
    } else {
      final ref = firebaseStorage
          .ref()
          .child("${FirebaseConstants.items}/${itemModel.name}");
      UploadTask task = ref.putFile(file);
      String imageUrl =
          await (await task.whenComplete(() {})).ref.getDownloadURL();

      ItemModel newItem = itemModel.copyWith(image: imageUrl);

      await firebaseFirestore
          .collection(FirebaseConstants.items)
          .doc(newItem.id)
          .update({
        'image': newItem.image,
        'name': newItem.name,
        'category': newItem.category,
        'unit': newItem.unit,
        'pricePerUnit': newItem.pricePerUnit,
        'description': newItem.description,
      });
    }
  }

  @override
  Future<void> updateOrder(OrderModel orderModel, String prevState) async {
    await firebaseFirestore
        .collection(FirebaseConstants.orders)
        .doc(orderModel.id)
        .update(orderModel.toMap());

    if (prevState != OrderStatus.Delivered &&
        orderModel.status == OrderStatus.Delivered) {
      await addOrderChart(
        OrderChartModel(
          orderId: orderModel.id!,
          date: orderModel.finishedDate,
          price: ((orderModel.productPrice * orderModel.quantity) +
                  orderModel.deliveryPrice) -
              orderModel.payedPrice,
        ),
      );
    }
  }

  @override
  Future<void> updateProduct(
      ProductModel productModel, List files, dynamic pdfFile) async {
    if (productModel.images.isNotEmpty && files.isEmpty) {
      if (pdfFile != null) {
        final ref = firebaseStorage.ref().child(
            "${FirebaseConstants.products}/PDFs/${productModel.name}${productModel.sku}");
        UploadTask task =
            pdfFile is Uint8List ? ref.putData(pdfFile) : ref.putFile(pdfFile);
        String pdfUrl =
            await (await task.whenComplete(() {})).ref.getDownloadURL();
        productModel = productModel.copyWith(pdfLink: pdfUrl);
      }

      await firebaseFirestore
          .collection(FirebaseConstants.products)
          .doc(productModel.id)
          .update(productModel.toMap());
    } else {
      List<String> imagesUrl = [];
      int i = 0;
      for (var file in files) {
        final ref = firebaseStorage
            .ref()
            .child("${FirebaseConstants.products}/${productModel.sku}$i");
        UploadTask task = kIsWeb ? ref.putData(file) : ref.putFile(file);
        String imageUrl =
            await (await task.whenComplete(() {})).ref.getDownloadURL();
        i++;
        imagesUrl.add(imageUrl);
      }

      if (pdfFile != null) {
        final ref = firebaseStorage.ref().child(
            "${FirebaseConstants.products}/PDFs/${productModel.name}${productModel.sku}");
        UploadTask task =
            pdfFile is Uint8List ? ref.putData(pdfFile) : ref.putFile(pdfFile);
        String pdfUrl =
            await (await task.whenComplete(() {})).ref.getDownloadURL();
        productModel = productModel.copyWith(pdfLink: pdfUrl);
      }

      ProductModel newItem = productModel.copyWith(images: imagesUrl);

      await firebaseFirestore
          .collection(FirebaseConstants.products)
          .doc(productModel.id)
          .update(newItem.toMap());
    }
  }

  @override
  Future<void> updateUser(UserModel userModel) async {
    await firebaseFirestore
        .collection(FirebaseConstants.users)
        .doc(userModel.id)
        .update(userModel.toMap());
  }

  @override
  Future<void> delete(String path, String id, String name, bool alsoImage,
      List<String> images) async {
    if (alsoImage) {
      for (String img in images) {
        if (img.isNotEmpty) {
          String filePath = firebaseStorage.refFromURL(img).fullPath;
          await firebaseStorage.ref().child(filePath).delete();
        }
      }
    }
    await firebaseFirestore.collection(path).doc(id).delete();

    if (path == FirebaseConstants.orders) {
      await deleteOrderChart(id);
    } else if (path == FirebaseConstants.expenses) {
      await deleteExpenseChart(id);
    }
  }

  @override
  Future<List<CustomerModel>> searchCustomers(
      String key, String value, int length) async {
    final customersqs = await firebaseFirestore
        .collection(FirebaseConstants.customers)
        .orderBy(key)
        .startAfter([value])
        .limit(length)
        .get();

    List<CustomerModel> list = [];

    for (var doc in customersqs.docs) {
      list.add(CustomerModel.fromFirebase(doc));
    }

    return list;
  }

  @override
  Future<List<ProductModel>> searchProducts(
      String key, String value, int length) async {
    QuerySnapshot productsqs;

    if (value.contains("#")) {
      productsqs = await firebaseFirestore
          .collection(FirebaseConstants.products)
          .where('tags', arrayContains: value.replaceAll("#", ""))
          .limit(length)
          .get();
    } else {
      productsqs = await firebaseFirestore
          .collection(FirebaseConstants.products)
          .orderBy(key)
          .startAt([value])
          .limit(length)
          .get();
    }

    List<ProductModel> list = [];

    for (var doc in productsqs.docs) {
      list.add(ProductModel.fromFirebase(doc));
    }

    return list;
  }

  @override
  Future<int> count(String path, String key, String value) async {
    final productQs = await firebaseFirestore
        .collection(path)
        .where(key, isEqualTo: value)
        .count()
        .get();

    return productQs.count;
  }

  @override
  Future<List<ExpenseChartModel>> getExpenseChart() async {
    final chartsQs = await firebaseFirestore
        .collection(FirebaseConstants.expenseCharts)
        .get();

    List<ExpenseChartModel> data = [];
    for (var chart in chartsQs.docs) {
      data.add(ExpenseChartModel.fromMap(chart));
    }
    return data;
  }

  @override
  Future<List<OrderChartModel>> getOrderChart() async {
    final chartsQs =
        await firebaseFirestore.collection(FirebaseConstants.orderCharts).get();

    List<OrderChartModel> data = [];
    for (var chart in chartsQs.docs) {
      data.add(OrderChartModel.fromMap(chart));
    }
    return data;
  }

  @override
  Future<void> addExpenseChart(ExpenseChartModel expenseChartModel) async {
    await firebaseFirestore
        .collection(FirebaseConstants.expenseCharts)
        .doc(expenseChartModel.id)
        .set(expenseChartModel.toMap());
  }

  @override
  Future<void> addOrderChart(OrderChartModel orderChartModel) async {
    await firebaseFirestore
        .collection(FirebaseConstants.orderCharts)
        .add(orderChartModel.toMap());
  }

  @override
  Future<OrderModel> getOrder(String id) async {
    final ds = await firebaseFirestore
        .collection(FirebaseConstants.orders)
        .doc(id)
        .get();
    return OrderModel.fromFirebase(ds);
  }

  @override
  Future<void> deleteExpenseChart(String id) async {
    await firebaseFirestore
        .collection(FirebaseConstants.expenseCharts)
        .doc(id)
        .delete();
  }

  @override
  Future<void> deleteOrderChart(String id) async {
    final charts = await firebaseFirestore
        .collection(FirebaseConstants.orderCharts)
        .where('orderId', isEqualTo: id)
        .get();
    final batch = firebaseFirestore.batch();
    for (var doc in charts.docs) {
      batch.delete(doc.reference);
    }
    await batch.commit();
  }

  @override
  Future<List<ExpenseModel>> searchExpense(String sellerName) async {
    final expenseQs = await firebaseFirestore
        .collection(FirebaseConstants.expenses)
        .orderBy('seller')
        .startAfter([sellerName])
        .limit(5)
        .get();

    List<ExpenseModel> expenses = [];
    for (var doc in expenseQs.docs) {
      expenses.add(ExpenseModel.fromFirebase(doc));
    }

    return expenses;
  }

  @override
  Future<void> addUpdateEmpoloyee(EmployeeModel employeeModel, var file) async {
    String imgUrl = "";
    if (employeeModel.id == null) {
      String eid = Random().nextInt(5000000).toString();
      // it is new

      if (file != null) {
        UploadTask uploadTask = kIsWeb
            ? firebaseStorage
                .ref()
                .child("${FirebaseConstants.employees}/$eid")
                .putData(file)
            : firebaseStorage
                .ref()
                .child("${FirebaseConstants.employees}/$eid")
                .putData(file);
        imgUrl =
            await (await uploadTask.whenComplete(() {})).ref.getDownloadURL();
      }
      await firebaseFirestore
          .collection(FirebaseConstants.employees)
          .doc(eid)
          .set(
            employeeModel.copyWith(imgUrl: imgUrl).toMap(),
          );
    } else {
      imgUrl = employeeModel.imgUrl!;
      if (file != null) {
        UploadTask uploadTask = firebaseStorage
            .ref()
            .child("${FirebaseConstants.employees}/${employeeModel.id}")
            .putFile(file);
        imgUrl =
            await (await uploadTask.whenComplete(() {})).ref.getDownloadURL();
      }
      await firebaseFirestore
          .collection(FirebaseConstants.employees)
          .doc(employeeModel.id)
          .update(employeeModel.copyWith(imgUrl: imgUrl).toMap());
    }
  }

  @override
  Future<List<EmployeeModel>> getEmployees() async {
    final employeeDs =
        await firebaseFirestore.collection(FirebaseConstants.employees).get();
    List<EmployeeModel> employees = [];
    for (var data in employeeDs.docs) {
      employees.add(EmployeeModel.fromMap(data));
    }
    return employees;
  }

  @override
  Future<void> addUpdateEmployeeActivity(
      EmployeeActivityModel employeeActivity) async {
    if (employeeActivity.id == null) {
      await firebaseFirestore
          .collection(FirebaseConstants.employeeActivity)
          .add(
            employeeActivity.toMap(),
          );
    } else {
      await firebaseFirestore
          .collection(FirebaseConstants.employeeActivity)
          .doc(employeeActivity.id)
          .update(
            employeeActivity.toMap(),
          );
    }
  }

  @override
  Future<int> countDoc(
      String path, String keyForDate, String startDate, String endDate) async {
    final aq = await firebaseFirestore
        .collection(path)
        .orderBy(keyForDate)
        .startAt([startDate])
        .endBefore([endDate])
        .count()
        .get();

    return aq.count;
  }

  @override
  Future<List<EmployeeActivityModel>> getEmployeeeActivities(
      String? employeeId, int? quantity,
      {bool isNew = true}) async {
    if (isNew) {
      lastEmployeeActivity = null;
    }
    QuerySnapshot? ds;

    ds = lastEmployeeActivity == null
        ? await firebaseFirestore
            .collection(FirebaseConstants.employeeActivity)
            .where("employeeId", isEqualTo: employeeId)
            .orderBy('date')
            .limitToLast(quantity ?? DateTime.now().day)
            .get()
        : await firebaseFirestore
            .collection(FirebaseConstants.employeeActivity)
            .where("employeeId", isEqualTo: employeeId)
            .orderBy('date')
            .endBeforeDocument(lastEmployeeActivity!)
            .limitToLast(quantity!)
            .get();

    if (ds.docs.isNotEmpty) {
      lastEmployeeActivity = ds.docs[0];
    }

    List<EmployeeActivityModel> lst = [];
    for (var data in ds.docs) {
      lst.add(EmployeeActivityModel.fromMap(data));
    }

    return lst;
  }

  @override
  Future<List> search(
    String firebasePath,
    String key,
    String val,
    SearchType searchType, {
    required String? key2,
    required String? val2,
  }) async {
    QuerySnapshot? ds;
    if (searchType == SearchType.normalOrder) {
      ds = key2 == null
          ? await firebaseFirestore
              .collection(firebasePath)
              .orderBy(key)
              .startAt([val])
              .limit(numOfDocToGet)
              .get()
          : await firebaseFirestore
              .collection(firebasePath)
              .where(key2, isEqualTo: val2)
              .orderBy(key)
              .startAt([val])
              .limit(numOfDocToGet)
              .get();
    } else if (searchType == SearchType.specificOrder) {
      ds = await firebaseFirestore
          .collection(firebasePath)
          .where(key, isEqualTo: val)
          .get();
    } else if (searchType == SearchType.fromArrayOfValEmployeeActivitty) {
      ds = await firebaseFirestore
          .collection(firebasePath)
          .where(key, arrayContains: val)
          .get();
    } else if (searchType == SearchType.normalreviews) {
      ds = await firebaseFirestore
          .collection(firebasePath)
          .where(key, isEqualTo: val)
          .get();
    } else if (searchType == SearchType.normalCustomer) {
      ds = await firebaseFirestore
          .collection(firebasePath)
          .where(key, isEqualTo: val)
          .get();
    } else if (searchType == SearchType.normalItemHistories) {
      if (val == "*") {
        ds =
            await firebaseFirestore.collection(firebasePath).orderBy(key).get();
      } else {
        ds = await firebaseFirestore
            .collection(firebasePath)
            .where(key, isEqualTo: val)
            .get();
      }
    }
    List lst = [];

    for (var data in ds!.docs) {
      if (searchType == SearchType.normalOrder) {
        lst.add(OrderModel.fromFirebase(data));
      }
      if (searchType == SearchType.specificOrder) {
        lst.add(OrderModel.fromFirebase(data));
      } else if (searchType == SearchType.fromArrayOfValEmployeeActivitty) {
        lst.add(EmployeeActivityModel.fromMap(data));
      } else if (searchType == SearchType.normalreviews) {
        lst.add(ReviewModel.fromMap(data));
      } else if (searchType == SearchType.normalItemHistories) {
        lst.add(ItemHistoryModel.fromMap(data));
      } else if (searchType == SearchType.normalCustomer) {
        lst.add(CustomerModel.fromFirebase(data));
      }
    }
    return lst;
  }

  @override
  Future<List<EmployeeActivityModel>> searchEmployee(
      String month, String year, String employeeId) async {
    final ds = await firebaseFirestore
        .collection(FirebaseConstants.employeeActivity)
        .where("employeeId", isEqualTo: employeeId)
        .orderBy('date') //2023-08-23
        .startAt(["$year-$month-01"]).endAt(["$year-$month-30"]).get();

    List<EmployeeActivityModel> lst = [];

    for (var data in ds.docs) {
      lst.add(EmployeeActivityModel.fromMap(data));
    }

    if (ds.docs.isNotEmpty) {
      lastEmployeeActivity = ds.docs[0];
    }

    return lst;
  }
}

enum SearchType {
  normalOrder,
  normalCustomer,
  specificOrder,
  fromArrayOfValEmployeeActivitty,
  normalreviews,
  normalItemHistories,
}
