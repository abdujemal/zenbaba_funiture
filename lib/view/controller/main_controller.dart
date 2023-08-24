import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_zoom_drawer/flutter_zoom_drawer.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zenbaba_funiture/data/model/employee_model.dart';
import 'package:zenbaba_funiture/domain/usecase/get_employee_usecase.dart';

import '../../base_usecase.dart';
import '../../constants.dart';
import '../../data/data_src/database_data_src.dart';
import '../../data/model/cutomer_model.dart';
import '../../data/model/employee_activity_model.dart';
import '../../data/model/expense_chart_model.dart';
import '../../data/model/expense_model.dart';
import '../../data/model/item_history_model.dart';
import '../../data/model/item_model.dart';
import '../../data/model/order_chart_model.dart';
import '../../data/model/order_model.dart';
import '../../data/model/product_model.dart';
import '../../domain/usecase/add_customer_usecase.dart';
import '../../data/model/user_model.dart';
import '../../domain/usecase/add_expense_usecase.dart';
import '../../domain/usecase/add_item_history_usecase.dart';
import '../../domain/usecase/add_item_usecase.dart';
import '../../domain/usecase/add_order_usecase.dart';
import '../../domain/usecase/add_product_usecase.dart';
import '../../domain/usecase/add_update_employee_activity_usecase.dart';
import '../../domain/usecase/add_update_employee_usecase.dart';
import '../../domain/usecase/count_usecase.dart';
import '../../domain/usecase/delete_usecase.dart';
import '../../domain/usecase/get_customer_usecase.dart';
import '../../domain/usecase/get_employee_activities.dart';
import '../../domain/usecase/get_expense_chart_usecase.dart';
import '../../domain/usecase/get_expense_usecase.dart';
import '../../domain/usecase/get_items_usecase.dart';
import '../../domain/usecase/get_order_chart_usecase.dart';
import '../../domain/usecase/get_order_usecase.dart';
import '../../domain/usecase/get_products_usecase.dart';
import '../../domain/usecase/get_single_order_usecase.dart';
import '../../domain/usecase/get_users_usecase.dart';
import '../../domain/usecase/search_customers_usecase.dart';
import '../../domain/usecase/search_expense_usecase.dart';
import '../../domain/usecase/search_products_usecase.dart';
import '../../domain/usecase/search_usecase.dart';
import '../../domain/usecase/update_cutomer_usecase.dart';
import '../../domain/usecase/update_expense_usecase.dart';
import '../../domain/usecase/update_item_usecase.dart';
import '../../domain/usecase/update_order_usecase.dart';
import '../../domain/usecase/update_product_usecase.dart';
import '../../domain/usecase/update_user_usecase.dart';
import '../../notification_service.dart';
import '../widget/order_dialog.dart';

class MainConntroller extends GetxController {
  final currentTabIndex = 0.obs;
  final mainIndex = 0.obs;

  Rx<ZoomDrawerController> z = ZoomDrawerController().obs;
  RxBool isAddDialogueOpen = false.obs;
  RxList<String> dropdownVal = <String>[].obs;

  Rx<RequestState> expenseStatus = RequestState.idle.obs;
  Rx<RequestState> orderStatus = RequestState.idle.obs;
  Rx<RequestState> productStatus = RequestState.idle.obs;
  Rx<RequestState> itemStatus = RequestState.idle.obs;
  Rx<RequestState> customerStatus = RequestState.idle.obs;
  Rx<RequestState> stockStatus = RequestState.idle.obs;
  Rx<RequestState> employeeStatus = RequestState.idle.obs;
  Rx<RequestState> employeeActivityStatus = RequestState.idle.obs;

  Rx<RequestState> getEmployeeActivityStatus = RequestState.idle.obs;
  Rx<RequestState> getExpensesStatus = RequestState.idle.obs;
  Rx<RequestState> getOrdersStatus = RequestState.idle.obs;
  Rx<RequestState> getProductsStatus = RequestState.idle.obs;
  Rx<RequestState> getItemsStatus = RequestState.idle.obs;
  Rx<RequestState> getCustomersStatus = RequestState.idle.obs;
  Rx<RequestState> getUsersStatus = RequestState.idle.obs;
  Rx<RequestState> getEmployeeStatus = RequestState.idle.obs;

  RxList<ExpenseModel> payedExpenses = <ExpenseModel>[].obs;
  RxList<EmployeeModel> employees = <EmployeeModel>[].obs;
  RxList<EmployeeActivityModel> employeesActivities =
      <EmployeeActivityModel>[].obs;
  RxList<ExpenseModel> unPayedExpenses = <ExpenseModel>[].obs;
  RxList<ExpenseModel> searchExpenses = <ExpenseModel>[].obs;
  RxList<OrderModel> pendingOrders = <OrderModel>[].obs;
  RxList<OrderModel> processingOrders = <OrderModel>[].obs;
  RxList<OrderModel> completedOrders = <OrderModel>[].obs;
  // RxList<OrderModel> searchorders = <OrderModel>[].obs;
  RxList<ExpenseChartModel> expensesChart = <ExpenseChartModel>[].obs;
  RxList<OrderChartModel> ordersChart = <OrderChartModel>[].obs;
  RxList<ProductModel> products = <ProductModel>[].obs;
  RxList<ItemModel> items = <ItemModel>[].obs;
  RxList<CustomerModel> customers = <CustomerModel>[].obs;
  RxList<ItemHistoryModel> itemHistories = <ItemHistoryModel>[].obs;
  RxList<UserModel> users = <UserModel>[].obs;

  DeleteUsecase deleteUsecase;
  AddExpenseUsecase addExpenseUsecase;
  UpdateExpenseUsecase updateExpenseUsecase;
  GetExpenseUsecase getExpenseUsecase;
  AddProductUsecase addProductUsecase;
  UpdateProductUsecase updateProductUsecase;
  GetProductsUsecase getProductsUsecase;
  SearchProductsUsecase searchProductsUsecase;
  AddOrderUsecase addOrderUsecase;
  UpdateOrderUsecase updateOrderUsecase;
  GetORderUsecase getORderUsecase;
  AddItemUsecase addItemUsecase;
  UpdateItemUsecase updateItemUsecase;
  GetItemUsecase getItemUsecase;
  AddCustomerUsecase addCustomerUsecase;
  UpdateCustomerUsecase updateCustomerUsecase;
  GetCustomerUsecase getCustomerUsecase;
  SearchCustomersUsecase searchCustomersUsecase;
  AddItemHistoryUsecase addItemHistoryUsecase;
  GetUsersUsecase getUsersUsecase;
  UpdateUserUsecase updateUserUsecase;
  CountUsecase countUsecase;
  GetExpenseChartUsecase getExpenseChartUsecase;
  GetOrderChartUsecase getOrderChartUsecase;
  GetSingleOrderUsecase getSingleOrderUsecase;
  SearchExpenseUsecase searchExpenseUsecase;
  AddUpdateEmployeeUsecase addUpdateEmployeeUsecase;
  GetEmployeeUsecase getEmployeeUsecase;
  SearchUsecase searchUsecase;
  GetEmployeeActivitiesUsecase getEmployeeActivitiesUsecase;
  AddUpdateEmployeeActivityUsecase addUpdateEmployeeActivityUsecase;

  Future<SharedPreferences> sharedPreferences = SharedPreferences.getInstance();

  MainConntroller(
    this.deleteUsecase,
    this.addExpenseUsecase,
    this.updateExpenseUsecase,
    this.getExpenseUsecase,
    this.addProductUsecase,
    this.updateProductUsecase,
    this.getProductsUsecase,
    this.searchProductsUsecase,
    this.addOrderUsecase,
    this.updateOrderUsecase,
    this.getORderUsecase,
    this.addItemUsecase,
    this.updateItemUsecase,
    this.getItemUsecase,
    this.addCustomerUsecase,
    this.updateCustomerUsecase,
    this.getCustomerUsecase,
    this.searchCustomersUsecase,
    this.addItemHistoryUsecase,
    this.getUsersUsecase,
    this.updateUserUsecase,
    this.countUsecase,
    this.getExpenseChartUsecase,
    this.getOrderChartUsecase,
    this.getSingleOrderUsecase,
    this.searchExpenseUsecase,
    this.addUpdateEmployeeUsecase,
    this.getEmployeeUsecase,
    this.addUpdateEmployeeActivityUsecase,
    this.getEmployeeActivitiesUsecase,
    this.searchUsecase,
  );

  setCurrentTabIndex(int val) {
    currentTabIndex.value = val;
  }

  setMainIndex(int val) {
    mainIndex.value = val;
    update();
  }

  toggleAddDialogue() {
    isAddDialogueOpen.value = !isAddDialogueOpen.value;
  }

  // Search
  Future<List> search(
    String firebasePath,
    String key,
    String val,
    SearchType searchType, {
    String? key2,
    String? val2,
  }) async {
    // getOrdersStatus.value = RequestState.loading;

    final res = await searchUsecase.call(Search1Params(
      firebasePath: firebasePath,
      key: key,
      val: val,
      key2: key2,
      val2: val2,
      searchType: searchType,
    ));

    List searchLst = [];

    res.fold((l) {
      // getOrdersStatus.value = RequestState.error;
      print(l.toString());
      toast(l.toString(), ToastType.error);
    }, (r) {
      // getOrdersStatus.value = RequestState.loaded;
      searchLst = r;
    });

    return searchLst;
  }

  // employeees
  addUpdateEmployee(EmployeeModel employeeModel, File? file) async {
    var connectivityResult = await Connectivity().checkConnectivity();

    if (connectivityResult == ConnectivityResult.none) {
      toast("No Network", ToastType.error);
      return;
    }

    employeeStatus.value = RequestState.loading;
    String employeeName = employeeModel.id!;

    final res = await addUpdateEmployeeUsecase(
        AddUpdateEmployeeParams(employeeModel, file));
    res.fold(
      (l) {
        employeeStatus.value = RequestState.error;
        toast(l.toString(), ToastType.error, isLong: true);
      },
      (r) {
        // deleting previously downloaded files
        if (file != null) {
          displayImage(null, employeeName, FirebaseConstants.employees)
              .then((value) {
            if (value != null) {
              value.delete();
            }
          });
        }
        employeeStatus.value = RequestState.loaded;
        getEmployees();
        Get.back();
      },
    );
  }

  addUpdateEmployeeActivity(
    EmployeeActivityModel employeeActivityModel, {
    bool getBack = true,
  }) async {
    var connectivityResult = await Connectivity().checkConnectivity();

    if (connectivityResult == ConnectivityResult.none) {
      toast("No Network", ToastType.error);
      return;
    }

    employeeActivityStatus.value = RequestState.loading;

    final res = await addUpdateEmployeeActivityUsecase.call(
      AddUpdateEmployeeActivityParams(
          employeeActivityModel: employeeActivityModel),
    );

    res.fold(
      (l) {
        employeeActivityStatus.value = RequestState.error;
        toast(l.toString(), ToastType.error);
      },
      (r) {
        employeeActivityStatus.value = RequestState.error;
        getEmployeeActivity(employeeActivityModel.employeeId);
        if (getBack) {
          Get.back();
        }
      },
    );
  }

  Future<void> getEmployees() async {
    getEmployeeStatus.value = RequestState.loading;

    final res = await getEmployeeUsecase.call(const NoParameters());

    res.fold((l) {
      getEmployeeStatus.value = RequestState.error;
      toast(l.toString(), ToastType.error);
    }, (r) {
      getEmployeeStatus.value = RequestState.loaded;
      employees.value = r;
    });
  }

  Future<void> getEmployeeActivity(
    String? employeeId, {
    int? quantity,
    bool isNew = true,
  }) async {
    if (isNew) {
      employeesActivities.value = [];
      getEmployeeActivityStatus.value = RequestState.loading;
    }

    final res = await getEmployeeActivitiesUsecase.call(
      GetEmployeeActivityParams(
        employeeId!,
        quantity,
        isNew: isNew,
      ),
    );

    res.fold((l) {
      getEmployeeActivityStatus.value = RequestState.error;
      toast(l.toString(), ToastType.error);
    }, (r) {
      getEmployeeActivityStatus.value = RequestState.loaded;
      if (isNew) {
        employeesActivities.value = r;
      } else {
        employeesActivities.value = [
          ...r,
          ...employeesActivities,
        ];
      }
      print(r);
    });
  }

  // delete

  delete(
    String path,
    String id,
    String name,
    bool alsoImage,
    int? numOfImages,
  ) async {
    var connectivityResult = await Connectivity().checkConnectivity();

    if (connectivityResult == ConnectivityResult.none) {
      toast("No Network", ToastType.error);
      return;
    }

    if (path == FirebaseConstants.expenses) {
      expenseStatus.value = RequestState.loading;
    } else if (path == FirebaseConstants.items) {
      itemStatus.value = RequestState.loading;
    } else if (path == FirebaseConstants.orders) {
      orderStatus.value = RequestState.loading;
    } else if (path == FirebaseConstants.products) {
      productStatus.value = RequestState.loading;
    } else if (path == FirebaseConstants.customers) {
      customerStatus.value = RequestState.loading;
    }
    final res = await deleteUsecase.call(DeleteParams(
        alsoImage: alsoImage,
        id: id,
        path: path,
        name: name,
        numOfImages: numOfImages));

    res.fold((l) {
      if (path == FirebaseConstants.expenses) {
        expenseStatus.value = RequestState.error;
      } else if (path == FirebaseConstants.items) {
        itemStatus.value = RequestState.error;
      } else if (path == FirebaseConstants.orders) {
        orderStatus.value = RequestState.error;
      } else if (path == FirebaseConstants.products) {
        productStatus.value = RequestState.error;
      } else if (path == FirebaseConstants.customers) {
        customerStatus.value = RequestState.error;
      }
      toast(l.toString(), ToastType.error);
    }, (r) {
      if (path == FirebaseConstants.expenses) {
        expenseStatus.value = RequestState.loaded;
      } else if (path == FirebaseConstants.items) {
        itemStatus.value = RequestState.loaded;
      } else if (path == FirebaseConstants.orders) {
        orderStatus.value = RequestState.loaded;
      } else if (path == FirebaseConstants.products) {
        productStatus.value = RequestState.loaded;
      } else if (path == FirebaseConstants.customers) {
        customerStatus.value = RequestState.loaded;
      }

      if (path == FirebaseConstants.expenses) {
        // getExpenses();
      } else if (path == FirebaseConstants.items) {
        getItems();
      } else if (path == FirebaseConstants.orders) {
        // getOrders();
      } else if (path == FirebaseConstants.products) {
        // getProducts();
      } else if (path == FirebaseConstants.customers) {
        // getCustomers();
      }

      Get.back();
    });
  }

  // user
  getUsers() async {
    getUsersStatus.value = RequestState.loading;

    final res = await getUsersUsecase.call(const NoParameters());

    res.fold((l) {
      getUsersStatus.value = RequestState.error;
      toast(l.toString(), ToastType.error);
    }, (r) {
      getUsersStatus.value = RequestState.loaded;
      users.value = r;
    });
  }

  updateUser(UserModel userModel) async {
    var connectivityResult = await Connectivity().checkConnectivity();

    if (connectivityResult == ConnectivityResult.none) {
      toast("No Network", ToastType.error);
      return;
    }

    getUsersStatus.value = RequestState.loading;

    final res = await updateUserUsecase.call(UpdateUserParams(userModel));

    res.fold((l) {
      getUsersStatus.value = RequestState.error;
      toast(l.toString(), ToastType.error);
    }, (r) async {
      getUsersStatus.value = RequestState.loaded;
      await getUsers();
      toast("Successfully updated.", ToastType.success);
    });
  }

  // stock
  Future<void> increaseStock(int quantity, ItemModel itemModel,
      ItemHistoryModel itemHistoryModel) async {
    var connectivityResult = await Connectivity().checkConnectivity();

    if (connectivityResult == ConnectivityResult.none) {
      toast("No Network", ToastType.error);
      return;
    }

    stockStatus.value = RequestState.loading;

    final res = await addItemHistoryUsecase
        .call(AddItemHistoryParams(itemHistoryModel, itemModel.id!));

    res.fold(
      (l) {
        stockStatus.value = RequestState.error;
        toast(l.toString(), ToastType.error);
      },
      (r) {
        updateItem(
          null,
          itemModel,
          quantity: itemModel.quantity + quantity,
          stayin: true,
        ).then((value) {
          stockStatus.value = RequestState.loaded;
        });
      },
    );
  }

  Future<void> decreaseStock(int quantity, ItemModel itemModel,
      ItemHistoryModel itemHistoryModel, String orderName) async {
    var connectivityResult = await Connectivity().checkConnectivity();

    if (connectivityResult == ConnectivityResult.none) {
      toast("No Network", ToastType.error);
      return;
    }

    stockStatus.value = RequestState.loading;

    final res = await addItemHistoryUsecase
        .call(AddItemHistoryParams(itemHistoryModel, itemModel.id!));

    res.fold(
      (l) {
        stockStatus.value = RequestState.error;
        toast(l.toString(), ToastType.error);
      },
      (r) async {
        updateItem(
          null,
          itemModel.copyWith(lastUsedFor: orderName),
          quantity: itemModel.quantity - quantity,
          stayin: true,
        ).then((value) {
          stockStatus.value = RequestState.loaded;
        });
      },
    );
  }

  // expense

  Future<void> getExpenses(
      {int? quantity, String? status, String? date, bool isNew = true}) async {
    getExpensesStatus.value = RequestState.loading;
    final res = await getExpenseUsecase.call(GetExpenseParam(
        quantity: quantity, status: status, date: date, isNew: isNew));

    res.fold((l) {
      getExpensesStatus.value = RequestState.error;
      toast(l.toString(), ToastType.error);
    }, (r) {
      getExpensesStatus.value = RequestState.loaded;

      if (status == ExpenseState.payed) {
        if (isNew) {
          payedExpenses.value = r;
          payedExpenses.sort((a, b) =>
              DateTime.parse(b.date).compareTo(DateTime.parse(a.date)));
        } else {
          payedExpenses.addAll(r);
          payedExpenses.sort((a, b) =>
              DateTime.parse(b.date).compareTo(DateTime.parse(a.date)));
        }
      } else {
        if (isNew) {
          unPayedExpenses.value = r;
          unPayedExpenses.sort((a, b) =>
              DateTime.parse(b.date).compareTo(DateTime.parse(a.date)));
        } else {
          unPayedExpenses.addAll(r);
          unPayedExpenses.sort((a, b) =>
              DateTime.parse(b.date).compareTo(DateTime.parse(a.date)));
        }
      }
    });
  }

  searchExpense(String sellerName) async {
    getExpensesStatus.value = RequestState.loading;

    final res =
        await searchExpenseUsecase.call(SearchExpenseParams(sellerName));

    res.fold((l) {
      getExpensesStatus.value = RequestState.error;
      toast(l.toString(), ToastType.error);
    }, (r) {
      getExpensesStatus.value = RequestState.loaded;

      List<String> sellers = [];

      List<ExpenseModel> expenses = [];

      for (ExpenseModel element in r) {
        if (!sellers.contains(element.seller)) {
          sellers.add(element.seller);
          expenses.add(element);
        }
      }

      searchExpenses.value = expenses;
    });
  }

  Future<void> addExpense(ExpenseModel expenseModel, {goBack = true}) async {
    var connectivityResult = await Connectivity().checkConnectivity();

    if (connectivityResult == ConnectivityResult.none) {
      toast("No Network", ToastType.error);
      return;
    }

    expenseStatus.value = RequestState.loading;
    final res = await addExpenseUsecase.call(AddExpenseParams(expenseModel));

    res.fold((l) {
      expenseStatus.value = RequestState.error;
      toast(l.toString(), ToastType.error);
    }, (r) {
      expenseStatus.value = RequestState.loaded;
      if (goBack) {
        Get.back();
      }
    });
  }

  updateExpense(ExpenseModel expenseModel) async {
    var connectivityResult = await Connectivity().checkConnectivity();

    if (connectivityResult == ConnectivityResult.none) {
      toast("No Network", ToastType.error);
      return;
    }

    expenseStatus.value = RequestState.loading;
    final res =
        await updateExpenseUsecase.call(UpdateExpenseParams(expenseModel));

    res.fold((l) {
      expenseStatus.value = RequestState.error;
      toast(l.toString(), ToastType.error);
    }, (r) {
      expenseStatus.value = RequestState.loaded;
      Get.back();
    });
  }

  // products

  getProducts({int? quantity, String? category, bool isNew = true}) async {
    getProductsStatus.value = RequestState.loading;
    if (isNew) {
      products.value = [];
    }
    final res = await getProductsUsecase.call(
      GetProductsParam(quantity: quantity, category: category, isNew: isNew),
    );

    res.fold((l) {
      getProductsStatus.value = RequestState.error;
      toast(l.toString(), ToastType.error);
    }, (r) {
      if (isNew) {
        getProductsStatus.value = RequestState.loaded;
        products.value = r;
      } else {
        getProductsStatus.value = RequestState.loaded;
        products.addAll(r);
      }
    });
  }

  searchProducts(String key, String value, int length) async {
    getProductsStatus.value = RequestState.loading;
    final res = await searchProductsUsecase
        .call(SearchParams(key: key, value: value, length: length));

    res.fold((l) {
      getProductsStatus.value = RequestState.error;
      toast(l.toString(), ToastType.error);
    }, (r) {
      getProductsStatus.value = RequestState.loaded;
      products.value = r;
    });
  }

  addProduct(ProductModel productModel, List<File> files) async {
    var connectivityResult = await Connectivity().checkConnectivity();

    if (connectivityResult == ConnectivityResult.none) {
      toast("No Network", ToastType.error);
      return;
    }

    productStatus.value = RequestState.loading;
    final res =
        await addProductUsecase.call(AddProductsParams(productModel, files));

    res.fold((l) {
      productStatus.value = RequestState.error;
      toast(l.toString(), ToastType.error);
    }, (r) {
      productStatus.value = RequestState.loaded;
      Get.back();
    });
  }

  updateProduct(ProductModel productModel, List<File> files) async {
    var connectivityResult = await Connectivity().checkConnectivity();

    if (connectivityResult == ConnectivityResult.none) {
      toast("No Network", ToastType.error);
      return;
    }

    final directory = await getApplicationSupportDirectory();

    final String sku = productModel.sku;

    productStatus.value = RequestState.loading;

    final res = await updateProductUsecase
        .call(UpdateProductParams(files, productModel));

    res.fold((l) {
      productStatus.value = RequestState.error;
      toast(l.toString(), ToastType.error);
    }, (r) {
      // deleting previously downloaded files
      if (files.isNotEmpty) {
        Directory("${directory.path}/${FirebaseConstants.products}/$sku")
            .delete(recursive: true);
      }
      productStatus.value = RequestState.loaded;
      // getProducts();
      Get.back();
    });
  }

  // Orders

  Future<void> getOrders(
      {int? quantity, String? status, String? date, bool isNew = true}) async {
    SharedPreferences pref = await sharedPreferences;

    getOrdersStatus.value = RequestState.loading;
    final res = await getORderUsecase.call(GetOrderParams(
      quantity: quantity,
      status: status,
      date: date,
      isNew: isNew,
    ));

    res.fold((l) {
      getOrdersStatus.value = RequestState.error;
      toast(l.toString(), ToastType.error);
      print(l.toString());
    }, (r) {
      getOrdersStatus.value = RequestState.loaded;

      String? currentDate = pref.getString("CurrentDate");
      String today = DateTime.now().toString().split(" ")[0];

      if (status == OrderStatus.Pending) {
        if (isNew) {
          pendingOrders.value = r;
        } else {
          pendingOrders.addAll(r);
        }
        pendingOrders.sort((a, b) => DateTime.parse(b.finishedDate)
            .compareTo(DateTime.parse(a.finishedDate)));
      } else if (status == OrderStatus.proccessing) {
        if (isNew) {
          processingOrders.value = r;

          if (currentDate == null || currentDate != today) {
            pref.setString("CurrentDate", today);

            final list = processingOrders.length <= 3
                ? processingOrders
                : processingOrders.sublist(0, 3);

            int i = 0;
            for (OrderModel orderModel in list) {
              int daysLeft = DateTime.parse(orderModel.finishedDate)
                  .difference(DateTime.now())
                  .inDays;
              NotificationService().showNotification(
                i,
                orderModel.productName,
                "for: ${orderModel.customerName},   ${daysLeft - 1} days left",
                const Duration(days: 1),
              );
              i++;
            }
          }
        } else {
          processingOrders.addAll(r);
        }
        processingOrders.sort((a, b) => DateTime.parse(a.finishedDate)
            .compareTo(DateTime.parse(b.finishedDate)));
      } else {
        if (isNew) {
          completedOrders.value = r;
        } else {
          completedOrders.addAll(r);
        }
        completedOrders.sort((a, b) => DateTime.parse(a.finishedDate)
            .compareTo(DateTime.parse(b.finishedDate)));
      }
    });
  }

  getOrder(String id) async {
    orderStatus.value = RequestState.loading;

    final res = await getSingleOrderUsecase.call(GetSingleOrderParams(id));

    OrderModel? orderModel;

    res.fold((l) {
      orderStatus.value = RequestState.error;
      toast(l.toString(), ToastType.error);
    }, (r) {
      orderStatus.value = RequestState.loaded;
      orderModel = r;
    });

    return orderModel;
  }

  addOrder(OrderModel orderModel) async {
    var connectivityResult = await Connectivity().checkConnectivity();

    if (connectivityResult == ConnectivityResult.none) {
      toast("No Network", ToastType.error);
      return;
    }

    orderStatus.value = RequestState.loading;
    final res = await addOrderUsecase.call(AddOrderParams(orderModel));

    res.fold((l) {
      orderStatus.value = RequestState.error;
      toast(l.toString(), ToastType.error);
      print(l.toString());
    }, (r) {
      orderStatus.value = RequestState.loaded;
      Get.back();
      Get.dialog(
          OrderDialog(
            orderModel: orderModel.copyWith(id: r),
          ),
          barrierColor: const Color.fromARGB(200, 0, 0, 0));
    });
  }

  updateOrder(
    OrderModel orderModel,
    String prevState, {
    bool isBack = true,
  }) async {
    var connectivityResult = await Connectivity().checkConnectivity();

    if (connectivityResult == ConnectivityResult.none) {
      toast("No Network", ToastType.error);
      return;
    }

    orderStatus.value = RequestState.loading;
    final res =
        await updateOrderUsecase.call(UpdateOrderParams(orderModel, prevState));

    res.fold((l) {
      orderStatus.value = RequestState.error;
      toast(l.toString(), ToastType.error);
    }, (r) {
      orderStatus.value = RequestState.loaded;

      if (isBack) {
        Get.back();
      }
    });
  }

  // Items

  getItems() async {
    getItemsStatus.value = RequestState.loading;
    final res = await getItemUsecase.call(const NoParameters());

    res.fold((l) {
      getItemsStatus.value = RequestState.error;
      toast(l.toString(), ToastType.error);
    }, (r) {
      getItemsStatus.value = RequestState.loaded;
      items.value = r;
    });
  }

  addItem(File file, ItemModel itemModel) async {
    var connectivityResult = await Connectivity().checkConnectivity();

    if (connectivityResult == ConnectivityResult.none) {
      toast("No Network", ToastType.error);
      return;
    }

    itemStatus.value = RequestState.loading;
    final res = await addItemUsecase.call(AddItemParams(file, itemModel));

    res.fold((l) {
      itemStatus.value = RequestState.error;
      toast(l.toString(), ToastType.error);
    }, (r) {
      itemStatus.value = RequestState.loaded;
      getItems();
      Get.back();
    });
  }

  Future<void> updateItem(File? file, ItemModel itemModel,
      {bool stayin = false, int? quantity}) async {
    var connectivityResult = await Connectivity().checkConnectivity();

    if (connectivityResult == ConnectivityResult.none) {
      toast("No Network", ToastType.error);
      return;
    }

    itemStatus.value = RequestState.loading;
    final res = await updateItemUsecase
        .call(UpdateItemParams(file, itemModel, quantity: quantity));

    String itemName = itemModel.id!;

    res.fold((l) {
      itemStatus.value = RequestState.error;
      toast(l.toString(), ToastType.error);
    }, (r) async {
      // deleting previously downloaded files
      if (file != null) {
        displayImage(null, itemName, FirebaseConstants.items).then((value) {
          if (value != null) {
            value.delete();
          }
        });
      }
      itemStatus.value = RequestState.loaded;
      await getItems();

      if (!stayin) {
        Get.back();
      }
    });
  }

  // customers

  getCustomers({int? quantity, int? end}) async {
    getCustomersStatus.value = RequestState.loading;
    final res = await getCustomerUsecase.call(GetCustomersParam(
      start: quantity,
      end: end,
    ));

    res.fold((l) {
      getCustomersStatus.value = RequestState.error;
      toast(l.toString(), ToastType.error);
    }, (r) {
      getCustomersStatus.value = RequestState.loaded;
      customers.value = r;
    });
  }

  searchCustomers(String key, String value, int length) async {
    getCustomersStatus.value = RequestState.loading;
    final res = await searchCustomersUsecase
        .call(SearchParams(key: key, value: value, length: length));

    res.fold((l) {
      getCustomersStatus.value = RequestState.error;
      toast(l.toString(), ToastType.error);
    }, (r) {
      getCustomersStatus.value = RequestState.loaded;
      customers.value = r;
    });
  }

  Future<String?> addCustomer(CustomerModel customerModel) async {
    var connectivityResult = await Connectivity().checkConnectivity();

    String? cid;

    if (connectivityResult == ConnectivityResult.none) {
      toast("No Network", ToastType.error);
      return null;
    }

    customerStatus.value = RequestState.loading;
    final res = await addCustomerUsecase.call(AddCutomerParams(customerModel));

    res.fold((l) {
      customerStatus.value = RequestState.error;
      toast(l.toString(), ToastType.error);
    }, (r) {
      cid = r;
      customerStatus.value = RequestState.loaded;
      toast("New Customer is Added", ToastType.success);
      Get.back();
    });

    return cid;
  }

  updateCustomer(CustomerModel customerModel) async {
    var connectivityResult = await Connectivity().checkConnectivity();

    if (connectivityResult == ConnectivityResult.none) {
      toast("No Network", ToastType.error);
      return;
    }

    customerStatus.value = RequestState.loading;
    final res =
        await updateCustomerUsecase.call(UpdateCustomerPArams(customerModel));

    res.fold((l) {
      customerStatus.value = RequestState.error;
      toast(l.toString(), ToastType.error);
    }, (r) {
      customerStatus.value = RequestState.loaded;
      Get.back();
    });
  }

  getOrderChart() async {
    getOrdersStatus.value = RequestState.loading;

    final res = await getOrderChartUsecase.call(const NoParameters());

    res.fold((l) {
      getOrdersStatus.value = RequestState.error;
      toast(l.toString(), ToastType.error);
    }, (r) {
      getOrdersStatus.value = RequestState.loaded;
      ordersChart.value = r;
    });
  }

  getExpenseChart() async {
    getExpensesStatus.value = RequestState.loading;

    final res = await getExpenseChartUsecase.call(const NoParameters());

    res.fold((l) {
      getExpensesStatus.value = RequestState.error;
      toast(l.toString(), ToastType.error);
    }, (r) {
      getExpensesStatus.value = RequestState.loaded;
      expensesChart.value = r;
    });
  }
}
