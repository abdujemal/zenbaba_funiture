import 'dart:io';

import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:zenbaba_funiture/data/model/product_category_model.dart';

Color darkOrange = const Color(0xFFf7941f);

Color lightOrange = const Color(0xFFfbaf3a);

Color lightWhite = const Color(0xFF7d7d7f);

Color mainColor = const Color.fromRGBO(9, 32, 66, 1);

Color backgroundColor = const Color(0xff233842);

Color mainBgColor = const Color(0xff374b54);

Color primaryColor = const Color(0xfff2bd57);

Color whiteColor = const Color(0xfff7f7f7);

Color textColor = const Color.fromARGB(255, 190, 190, 190);

Color greyColor = const Color.fromARGB(255, 114, 137, 150);

int numOfDocToGet = 10;

Gradient btnGradient = const LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [
      Color(0xFF025d91),
      Color(0xFF1b3c71),
    ]);

Gradient orangeGradient = LinearGradient(
    begin: Alignment.centerRight,
    end: Alignment.centerLeft,
    colors: [darkOrange, lightOrange]);

Gradient bgGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [const Color.fromRGBO(50, 70, 98, 1), mainColor]);

Widget title(String val) => Text(
      val,
      style: const TextStyle(
        fontSize: 27,
        fontWeight: FontWeight.w300,
      ),
    );

class CustomerSource {
  static String faceBook = 'facebook';
  static String telegram = 'telegram';
  static String whatsapp = 'whatsapp';
  static String instagram = 'instagram';
  static String family = 'family';
  static String customer = 'customer';
  static String custromerReferal = 'customer referal';
  static String showroom = 'showroom';
  static String website = "website";
  static String qefira = "Qefira";
  static String jiji = "Jiji";
  static String ecommerceWeb = "E-commerce web";

  static List<String> list = [
    faceBook,
    telegram,
    whatsapp,
    instagram,
    family,
    customer,
    custromerReferal,
    showroom,
    website,
    qefira,
    jiji,
    ecommerceWeb,
  ];
}

class PaymentMethod {
  static String CBE = 'CBE';
  static String Cash = 'Cash';
  static String Telebirr = 'Telebiir';
  static String Awash = 'Awash';
  static String Abyssinia = "Abyssinia";
  static String others = 'others';

  static List<String> list = [CBE, Cash, Telebirr, Awash, Abyssinia, others];
}

class DeliveryOption {
  static String pickUp = 'Pick up';
  static String delivery = 'Delivery';

  static List<String> list = [pickUp, delivery];
}

class ItemHistoryType {
  static String used = 'Used';
  static String buyed = 'Buyed';

  static List<String> list = [used, buyed];
}

class Gender {
  static String Male = "Male";
  static String Female = "Female";

  static List<String> list = [Male, Female];
}

class KK {
  static String Bole = "Bole";
  static String KolfeKeranyo = "Kolfe Keranyo";
  static String Gulele = "Gullele";
  static String Yeka = "Yeka";
  static String AddisKetema = "Addis Ketema";
  static String AkakyKaliti = "Akaki Kality";
  static String Kirkos = "Kirkos";
  static String Lidata = "Lideta";
  static String NifasSilk = "Nifas Silk";
  static String Arada = "Arada";
  static String LemiKura = "Lemi Kura";
  static String Oromia = "Oromia";

  static List<String> list = [
    Bole,
    KolfeKeranyo,
    Gulele,
    Yeka,
    AddisKetema,
    AkakyKaliti,
    Kirkos,
    Lidata,
    NifasSilk,
    Arada,
    LemiKura,
    Oromia,
  ];
}

class Units {
  static String Kg = "Kg";
  static String Pcs = "Pcs";
  static String Galon = "Galon";
  static String Packet = "Packet";
  static String liter = "Liter";
  static String cm = "cm";

  static List<String> list = [Kg, Pcs, Galon, Packet, liter, cm];
}

class OrderStatus {
  static String Pending = "Pending";
  static String proccessing = "Proccessing";
  static String completed = "Completed";
  static String Delivered = 'Delivered';

  static List<String> list = [Pending, proccessing, completed, Delivered];
}

class ProductCategory {
  static String Bed = "Bed";
  static String BadyBed = "Baby bed";
  static String BunkBed = "Bunk bed";
  static String SingleBed = "Single bed";
  static String BookShelf = "Book shelf";
  static String ShoeShelf = "Shoe shelf";
  static String CoffeTable = "Coffee table";
  static String SofaTable = "Sofa table";
  static String KitchenCabinet = "Kitchen cabinet";
  static String Wardrode = "Wardrobe";
  static String Drawer = "Drawer";
  static String Door = "Door";
  static String DressingTable = "Dressing table";
  static String OfficeTable = "Office table";
  static String Reception = "Reception";
  static String TvRack = "Tv rack";
  static String Custom = "Custom";

  static List<String> list = [
    Bed,
    BadyBed,
    BunkBed,
    SingleBed,
    BookShelf,
    ShoeShelf,
    CoffeTable,
    SofaTable,
    KitchenCabinet,
    Wardrode,
    Drawer,
    Door,
    DressingTable,
    OfficeTable,
    Reception,
    TvRack,
    Custom,
  ];

  static List<ProductCategoryModel> listWIcons = list
      .map(
        (cat) => ProductCategoryModel(
            name: cat, assetImage: 'assets/$cat.png', quantity: 0),
      )
      .toList();
}

class ItemCategory {
  static String Finishing = "Finishing";
  static String Wood = "Wood";
  static String Accessories = "Accessories";

  static List<String> list = [Finishing, Wood, Accessories];
}

class ExpenseState {
  static String payed = 'Payed';
  static String unpayed = 'UnPayed';

  static List<String> list = [payed, unpayed];
}

class ExpenseCategory {
  static String rawMaterial = 'Raw Material';
  static String electricity = 'Electricity';
  static String showRoom = 'Show Room';
  static String employee = 'Employee';
  static String tools = 'Tools';
  static String transport = 'Transport';
  static String government = 'Government';

  static List<String> list = [
    rawMaterial,
    electricity,
    showRoom,
    employee,
    tools,
    transport,
    government
  ];
}

class UserPriority {
  static String Unsigned = "Unsigned";
  static String Admin = 'Admin';
  static String AdminView = "Admin View";
  static String Sells = "Sells";
  static String Storekeeper = 'Storekeeper';
  static String WorkShopManager = "Work Shop Manager";
  static String HR = 'HR';
  static String Designer = 'Designer';

  static isAdmin(priority) => priority == Admin || priority == AdminView;

  static canAccessStock(priority) =>
      isAdmin(priority) ||
      priority == Storekeeper ||
      priority == WorkShopManager ||
      priority == Designer;

  
  static canAccessOrder(priority) =>
      isAdmin(priority) ||
      priority == Sells ||
      priority == WorkShopManager ||
      priority == Designer;

  static List<String> list = [
    Unsigned,
    Admin,
    AdminView,
    Sells,
    Storekeeper,
    WorkShopManager,
    HR,
    Designer,
  ];
}

class EmployeePosition {
  static String woodWorker = "Wood Worker";
  static String sales = "Sales";
  static String painter = "Painter";
  static String manager = "Manager";
  static String assistant = "Assistant";

  static List<String> list = [woodWorker, sales, painter, manager, assistant];
}

class EmployeeType {
  static String fullTime = "Full Time";
  static String contract = "Contract";

  static List<String> list = [fullTime, contract];
}

class SalaryType {
  static String weekly = "Weekly";
  static String monthly = "Monthly";

  static List<String> list = [weekly, monthly];
}

class FirebaseConstants {
  static String products = 'products';
  static String customers = 'customers';
  static String items = 'items';
  static String orders = 'orders';
  static String expenses = 'expenses';
  static String users = 'users';
  static String orderCharts = "orderCharts";
  static String expenseCharts = "expenseCharts";
  static String employees = "employees";
  static String employeeActivity = "employees Activities";
  static String reviews = "reviews";
  static String itemsHistories = 'Items Histories';
}

void toast(String message, ToastType toastType, {bool isLong = false}) {
  Fluttertoast.showToast(
      msg: message,
      toastLength: isLong ? Toast.LENGTH_SHORT : Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
      backgroundColor: toastType == ToastType.error ? Colors.red : Colors.green,
      textColor: Colors.white,
      fontSize: 16.0);
}

enum ToastType { success, error }

enum RequestState { idle, loaded, loading, error }

Future<File?> displayImage(String? imgUrl, String name, String dir) async {
  final directory = await getApplicationSupportDirectory();
  final filePath = "${directory.path}/$dir/$name.jpg";
  // print(filePath);
  if (await File(filePath).exists()) {
    // print("file exsists: ${filePath}");
    return File(filePath);
  } else if (imgUrl != null) {
    try {
      // Get a reference to the Firebase Storage object
      // final ref = FirebaseStorage.instance.refFromURL(imgUrl);
      var response = await http.get(Uri.parse(imgUrl));

      // Download the image data to a file
      var file = File(filePath);
      file = await (await file.create(recursive: true))
          .writeAsBytes(response.bodyBytes);

      // Return the downloaded file
      return file;
    } catch (e) {
      print(e.toString());
      return File("");
    }
  } else {
    return null;
  }
}

Widget section(
    {required List<Widget> children,
    double paddingv = 13,
    double paddingh = 8,
    double mv = 20,
    double mh = 20,
    double mb = 0,
    double b = 10,
    Color? bgColor,
    CrossAxisAlignment? crossAxisAlignment}) {
  return Container(
    margin: EdgeInsets.only(top: mv, left: mh, right: mh, bottom: mb),
    padding: EdgeInsets.symmetric(
      horizontal: paddingh,
      vertical: paddingv,
    ),
    width: double.infinity,
    decoration: BoxDecoration(
      color: bgColor ?? mainBgColor,
      boxShadow: [
        BoxShadow(
          color: Colors.black.withAlpha(50),
          blurRadius: 6,
          spreadRadius: 2,
          offset: const Offset(0, 0),
        )
      ],
      borderRadius: BorderRadius.circular(b),
    ),
    child: Column(
      crossAxisAlignment: crossAxisAlignment ?? CrossAxisAlignment.start,
      children: children,
    ),
  );
}

Widget keyVal(String key, String val, {double pl = 15, double pr = 0}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Padding(
        padding: EdgeInsets.only(
          left: pl,
          top: 0,
          right: pr,
        ),
        child: Text(
          key,
          style: TextStyle(color: primaryColor),
        ),
      ),
      Padding(
        padding: EdgeInsets.only(
          left: pl + 15,
          top: 4,
          right: pr,
        ),
        child: Text(val),
      ),
    ],
  );
}

String formatNumber(int number) {
  final formatter = NumberFormat('#,##0');
  return formatter.format(number);
}

String shortenNum(int number) {
  final formatter = NumberFormat.compact();
  return formatter.format(number);
}
