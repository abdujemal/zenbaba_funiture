import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:zenbaba_funiture/view/Pages/products_gallery.dart';

import '../../constants.dart';
import '../controller/main_controller.dart';
import '../widget/customer_card.dart';
import '../widget/product_card.dart';
import '../widget/sl_input.dart';

class SearchPage extends StatefulWidget {
  final String path;
  final String? tag;
  const SearchPage({
    Key? key,
    required this.path,
    this.tag,
  }) : super(key: key);

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  var searchTc = TextEditingController();

  MainConntroller mainConntroller = Get.find<MainConntroller>();

  var numOfProductsTc = TextEditingController();

  int numOfProducts = 10;

  @override
  void dispose() {
    searchTc.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    numOfProductsTc.text = numOfProducts.toString();
    if (widget.tag != null) {
      searchTc.text = widget.tag!;
    }
  }

  renderItems() {
    if (widget.path == FirebaseConstants.products) {
      return Obx(
        () {
          return Padding(
            padding: const EdgeInsets.only(top: 85),
            child: mainConntroller.getProductsStatus.value ==
                    RequestState.loading
                ? Align(
                    alignment: Alignment.center,
                    child: CircularProgressIndicator(color: primaryColor),
                  )
                : ListView.builder(
                    itemCount: mainConntroller.products.length,
                    itemBuilder: (context, index) {
                      return ProductCard(
                        productModel: mainConntroller.products[index],
                        onClickImage: () {
                          Get.to(
                            () => ProductGallery(
                              products: mainConntroller.products,
                              selectedSku: mainConntroller.products[index].sku,
                            ),
                          );
                        },
                      );
                    },
                  ),
          );
        },
      );
    } else {
      return Obx(
        () {
          return Padding(
            padding: const EdgeInsets.only(top: 85),
            child:
                mainConntroller.getCustomersStatus.value == RequestState.loading
                    ? Align(
                        alignment: Alignment.center,
                        child: CircularProgressIndicator(color: primaryColor),
                      )
                    : ListView.builder(
                        itemCount: mainConntroller.customers.length,
                        itemBuilder: (context, index) {
                          return CustomerCard(
                            customerModel: mainConntroller.customers[index],
                          );
                        },
                      ),
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.transparent,
        title: title("Search ${widget.path.capitalize}"),
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            size: 30,
          ),
          onPressed: () {
            Get.back();
          },
        ),
      ),
      body: Stack(
        children: [
          renderItems(),
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 23,
            ),
            child: Row(
              children: [
                Expanded(
                  child: SLInput(
                    margin: 0,
                    title: "",
                    hint: "Search...",
                    keyboardType: TextInputType.text,
                    controller: searchTc,
                    isOutlined: true,
                    inputColor: whiteColor,
                    onChanged: (val) async {
                      if (val.isNotEmpty) {
                        if (widget.path == FirebaseConstants.products) {
                          if (mainConntroller.getProductsStatus.value !=
                              RequestState.loading) {
                            await mainConntroller.searchProducts(
                                "name", val, numOfProducts);
                          }
                        } else if (widget.path == FirebaseConstants.customers) {
                          if (mainConntroller.getCustomersStatus.value !=
                              RequestState.loading) {
                            if(val.substring(0,1).isNum){
                              await mainConntroller.searchCustomers(
                                  "phone", val, numOfProducts);
                            }else{
                              await mainConntroller.searchCustomers(
                                  "name", val, numOfProducts);
                            }
                          }
                        }
                      }
                    },
                  ),
                ),
                const SizedBox(
                  width: 20,
                ),
                SLInput(
                  margin: 0,
                  title: "",
                  hint: "10",
                  keyboardType: TextInputType.number,
                  controller: numOfProductsTc,
                  inputColor: whiteColor,
                  isOutlined: true,
                  width: 60,
                  onChanged: (val) {
                    numOfProducts = int.parse(val);
                  },
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
