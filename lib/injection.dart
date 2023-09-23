import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:get_it/get_it.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:zenbaba_funiture/domain/usecase/add_update_employee_activity_usecase.dart';
import 'package:zenbaba_funiture/domain/usecase/add_update_employee_usecase.dart';
import 'package:zenbaba_funiture/domain/usecase/count_doc_usecase.dart';
import 'package:zenbaba_funiture/domain/usecase/get_employee_activities.dart';
import 'package:zenbaba_funiture/domain/usecase/get_employee_usecase.dart';
import 'package:zenbaba_funiture/domain/usecase/get_stock_activities_usecase.dart';
import 'package:zenbaba_funiture/domain/usecase/search_employee_usecase.dart';
import 'package:zenbaba_funiture/domain/usecase/search_usecase.dart';
import 'package:zenbaba_funiture/view/controller/l_s_controller.dart';
import 'package:zenbaba_funiture/view/controller/main_controller.dart';

import 'data/data_src/auth_data_src.dart';
import 'data/data_src/database_data_src.dart';
import 'data/repo/auth_repo_impl.dart';
import 'data/repo/database_repo_impl.dart';
import 'domain/repo/auth_repo.dart';
import 'domain/repo/database_repo.dart';
import 'domain/usecase/add_customer_usecase.dart';
import 'domain/usecase/add_expense_usecase.dart';
import 'domain/usecase/add_item_history_usecase.dart';
import 'domain/usecase/add_item_usecase.dart';
import 'domain/usecase/add_order_usecase.dart';
import 'domain/usecase/add_product_usecase.dart';
import 'domain/usecase/count_usecase.dart';
import 'domain/usecase/delete_usecase.dart';
import 'domain/usecase/forget_password_usecase.dart';
import 'domain/usecase/get_customer_usecase.dart';
import 'domain/usecase/get_expense_chart_usecase.dart';
import 'domain/usecase/get_expense_usecase.dart';
import 'domain/usecase/get_items_usecase.dart';
import 'domain/usecase/get_order_chart_usecase.dart';
import 'domain/usecase/get_order_usecase.dart';
import 'domain/usecase/get_products_usecase.dart';
import 'domain/usecase/get_single_order_usecase.dart';
import 'domain/usecase/get_user_usecase.dart';
import 'domain/usecase/get_users_usecase.dart';
import 'domain/usecase/search_customers_usecase.dart';
import 'domain/usecase/search_expense_usecase.dart';
import 'domain/usecase/search_products_usecase.dart';
import 'domain/usecase/set_user_usecase.dart';
import 'domain/usecase/sign_in_with_email_password.dart';
import 'domain/usecase/sign_out_usecase.dart';
import 'domain/usecase/sign_up_with_email_password_usecase.dart';
import 'domain/usecase/sign_up_with_google_usecase.dart';
import 'domain/usecase/update_cutomer_usecase.dart';
import 'domain/usecase/update_expense_usecase.dart';
import 'domain/usecase/update_item_usecase.dart';
import 'domain/usecase/update_order_usecase.dart';
import 'domain/usecase/update_product_usecase.dart';
import 'domain/usecase/update_user_usecase.dart';

final di = GetIt.instance;

void setup() {
  // controller
  di.registerFactory(() => LSController(di(), di(), di(), di(), di()));
  di.registerFactory(
    () => MainConntroller(
      di(),
      di(),
      di(),
      di(),
      di(),
      di(),
      di(),
      di(),
      di(),
      di(),
      di(),
      di(),
      di(),
      di(),
      di(),
      di(),
      di(),
      di(),
      di(),
      di(),
      di(),
      di(),
      di(),
      di(),
      di(),
      di(),
      di(),
      di(),
      di(),
      di(),
      di(),
      di(),
      di(),
      di(),
    ),
  );

  // data source
  di.registerLazySingleton<AuthDataSource>(
    () => AuthDataSourceImpl(
      firebaseStorage: di(),
      firebaseAuth: di(),
      googleSignIn: di(),
      firebaseFirestore: di(),
    ),
  );

  di.registerLazySingleton<DatabaseDataSrc>(() => DatabaseDataSrcImpl(
      firebaseAuth: di(), firebaseFirestore: di(), firebaseStorage: di()));

  // repo
  di.registerLazySingleton<AuthRepo>(() => AuthRepoImpl(di()));

  di.registerLazySingleton<DatabaseRepo>(() => DatabaseRepoImpl(di()));

  // usecase
  di.registerLazySingleton(() => GetStockActivitiesUsecase(di()));
  di.registerLazySingleton(() => SearchEmployeeUsecase(di()));
  di.registerLazySingleton(() => CountDocUsecase(databaseRepo: di()));
  di.registerLazySingleton(() => SearchUsecase(databaseRepo: di()));
  di.registerLazySingleton(() => GetEmployeeActivitiesUsecase(di()));
  di.registerLazySingleton(() => AddUpdateEmployeeActivityUsecase(di()));
  di.registerLazySingleton(() => GetEmployeeUsecase(di()));
  di.registerLazySingleton(() => AddUpdateEmployeeUsecase(databaseRepo: di()));
  di.registerLazySingleton(() => AddCustomerUsecase(di()));
  di.registerLazySingleton(() => AddExpenseUsecase(di()));
  di.registerLazySingleton(() => AddItemHistoryUsecase(di()));
  di.registerLazySingleton(() => AddItemUsecase(di()));
  di.registerLazySingleton(() => AddOrderUsecase(di()));
  di.registerLazySingleton(() => AddProductUsecase(di()));
  di.registerLazySingleton(() => ForgetPasswordUsecase(di()));
  di.registerLazySingleton(() => GetCustomerUsecase(di()));
  di.registerLazySingleton(() => GetExpenseUsecase(di()));
  di.registerLazySingleton(() => GetItemUsecase(di()));
  di.registerLazySingleton(() => GetORderUsecase(di()));
  di.registerLazySingleton(() => GetProductsUsecase(di()));
  di.registerLazySingleton(() => GetUserUsecase(di()));
  di.registerLazySingleton(() => GetUsersUsecase(di()));
  di.registerLazySingleton(() => SetUserUsecase(di()));
  di.registerLazySingleton(() => SignInWithEmailPasswordUSecase(di()));
  di.registerLazySingleton(() => SignOutUsecase(di()));
  di.registerLazySingleton(() => SignUpWithEmailPasswordUsecase(di()));
  di.registerLazySingleton(() => SignUpWithGoogleUsecase(di()));
  di.registerLazySingleton(() => UpdateCustomerUsecase(di()));
  di.registerLazySingleton(() => UpdateExpenseUsecase(di()));
  di.registerLazySingleton(() => UpdateItemUsecase(di()));
  di.registerLazySingleton(() => UpdateOrderUsecase(di()));
  di.registerLazySingleton(() => UpdateProductUsecase(di()));
  di.registerLazySingleton(() => UpdateUserUsecase(di()));
  di.registerLazySingleton(() => DeleteUsecase(di()));
  di.registerLazySingleton(() => SearchCustomersUsecase(di()));
  di.registerLazySingleton(() => SearchProductsUsecase(di()));
  di.registerLazySingleton(() => CountUsecase(di()));
  di.registerLazySingleton(() => GetExpenseChartUsecase(di()));
  di.registerLazySingleton(() => GetOrderChartUsecase(di()));
  di.registerLazySingleton(() => GetSingleOrderUsecase(di()));
  di.registerLazySingleton(() => SearchExpenseUsecase(di()));

  // externals
  FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
  firebaseFirestore.settings = const Settings(persistenceEnabled: true);

  FirebaseStorage firebaseStorage = FirebaseStorage.instance;

  GoogleSignIn googleSignIn = GoogleSignIn();

  di.registerLazySingleton(() => firebaseStorage);
  di.registerLazySingleton(() => firebaseAuth);
  di.registerLazySingleton(() => firebaseFirestore);
  di.registerLazySingleton(() => googleSignIn);
}
