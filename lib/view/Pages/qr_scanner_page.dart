import 'dart:io';
import 'dart:typed_data';

// import 'package:ai_barcode_scanner/ai_barcode_scanner.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:zenbaba_funiture/view/Pages/order_details_page.dart';
// import 'package:qr_code_scanner/qr_code_scanner.dart';

import '../../data/model/order_model.dart';
import '../../constants.dart';
import '../controller/main_controller.dart';
import 'add_order.dart';

class QrScannerPage extends StatefulWidget {
  const QrScannerPage({Key? key}) : super(key: key);

  @override
  State<QrScannerPage> createState() => _QrScannerPageState();
}

class _QrScannerPageState extends State<QrScannerPage> {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  // QRViewController? controller;
  MainConntroller mainConntroller = Get.find<MainConntroller>();
  // In order to get hot reload to work we need to pause the camera if the platform
  // is android, or resume the camera if the platform is iOS.

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(),
      //  MobileScanner(
      //   // fit: BoxFit.contain,
      //   onDetect: (capture) {
      //     final List<Barcode> barcodes = capture.barcodes;
      //     final Uint8List? image = capture.image;
      //     for (final barcode in barcodes) {
      //       if(barcode.rawValue != null){
              
      //       }
      //       mainConntroller.getOrder(barcode.rawValue!).then((order) {
      //         Get.to(() => OrderDetailsPage(orderModel: order!));
      //         debugPrint('Barcode found! ${barcode.rawValue}');
      //       });
      //     }
      //   },
      // ),
      // Column(
      //   children: <Widget>[
      //     const Expanded(
      //       flex: 5,
      //       child: //QRView(
      //           SizedBox(
      //               // key: qrKey,
      //               // onQRViewCreated: _onQRViewCreated,
      //               ),
      //     ),
      //     Expanded(
      //       flex: 1,
      //       child: Obx(() {
      //         if (mainConntroller.orderStatus.value == RequestState.loading) {
      //           return Center(
      //             child: CircularProgressIndicator(color: primaryColor),
      //           );
      //         }
      //         return const Center(
      //           child: Text('Scan a code'),
      //         );
      //       }),
      //     )
      //   ],
      // ),
    );
  }

  // void _onQRViewCreated(QRViewController controller) {
  //   this.controller = controller;
  //   controller.scannedDataStream.listen((scanData) {
  //     print("gooo");
  //     getOrder(scanData);
  //   });
  // }

  // getOrder(Barcode scanData) async {
  //   OrderModel? orderModel = await mainConntroller.getOrder(scanData.code!);
  //   if (orderModel != null) {
  //     Get.to(
  //       () => AddOrder(
  //         orderModel: orderModel,
  //       ),
  //     );
  //   }
  // }

  // @override
  // void dispose() {
  //   controller?.dispose();
  //   super.dispose();
  // }
}
