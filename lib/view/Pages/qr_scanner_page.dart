import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

import '../../constants.dart';
import '../../data/model/order_model.dart';
import '../controller/main_controller.dart';
import 'add_order.dart';

class QrScannerPage extends StatefulWidget {
  const QrScannerPage({Key? key}) : super(key: key);

  @override
  State<QrScannerPage> createState() => _QrScannerPageState();
}

class _QrScannerPageState extends State<QrScannerPage> {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  QRViewController? controller;
  MainConntroller mainConntroller = Get.find<MainConntroller>();
  // In order to get hot reload to work we need to pause the camera if the platform
  // is android, or resume the camera if the platform is iOS.
  @override
  void reassemble() {
    super.reassemble();
    if (Platform.isAndroid) {
      controller!.pauseCamera();
    } else if (Platform.isIOS) {
      controller!.resumeCamera();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: <Widget>[
          Expanded(
            flex: 5,
            child: QRView(
              key: qrKey,
              onQRViewCreated: _onQRViewCreated,
            ),
          ),
          Expanded(
            flex: 1,
            child: Obx(() {
              if (mainConntroller.orderStatus.value == RequestState.loading) {
                return Center(
                  child: CircularProgressIndicator(color: primaryColor),
                );
              }
              return const Center(
                child: Text('Scan a code'),
              );
            }),
          )
        ],
      ),
    );
  }

  void _onQRViewCreated(QRViewController controller) {
    this.controller = controller;
    controller.scannedDataStream.listen((scanData) {
      print("gooo");
      getOrder(scanData);
    });
  }

  getOrder(Barcode scanData) async {
    OrderModel? orderModel = await mainConntroller.getOrder(scanData.code!);
      if (orderModel != null) {
        Get.to(
          () => AddOrder(
            orderModel: orderModel,
          ),
        );
      }
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }
}
