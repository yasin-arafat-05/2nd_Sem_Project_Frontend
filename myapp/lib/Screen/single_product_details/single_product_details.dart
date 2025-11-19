// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import '../../Constant/constanvalue.dart';
import 'cart.dart';
import '../../alert_mesg.dart';
import '../../ip_address.dart';
import '../../provider.dart';
import 'package:provider/provider.dart';

class SingleProductDetails extends StatefulWidget {
  const SingleProductDetails({super.key, required this.productModel});
  final Map<String, dynamic> productModel;
  @override
  State<SingleProductDetails> createState() => _SingleProductDetailsState();
}

class _SingleProductDetailsState extends State<SingleProductDetails> {
  int cnt = 1;
  Future<dynamic> buttonCall(BuildContext context) async {
    return await showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          height: 300,
          width: double.infinity,
          decoration: const BoxDecoration(
              color: Colors.white, boxShadow: [BoxShadow(blurRadius: 5)]),
          child: Column(
            children: [
              const SizedBox(
                height: 30,
              ),

              const SizedBox(
                height: 30,
              ),
              Text(
                "Total Payment: ${cnt * widget.productModel['newPrice']}\$",
                style:
                    const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(
                height: 30,
              ),
              //______________________Check OUT Button_________________________
              SizedBox(
                height: 50,
                width: 300,
                child: ElevatedButton.icon(
                  onPressed: () {},
                  icon: const Icon(Iconsax.wallet_check),
                  label: const Text("Checkout"),
                  style: const ButtonStyle(
                      shape: MaterialStatePropertyAll(RoundedRectangleBorder(
                          borderRadius: BorderRadius.only(
                    topLeft: Radius.elliptical(40, 20),
                    bottomRight: Radius.elliptical(20, 40),
                  )))),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  late BestSellingProvider bestSellingProvider;
  late Cart cart;

  @override
  void initState() {
    super.initState();
    bestSellingProvider =
        Provider.of<BestSellingProvider>(context, listen: false);
    functionCall();
    cart = Cart(bestSellingProvider);
  }

  Future<void> functionCall() async {
    await bestSellingProvider.bestProductData();
  }

  @override
  Widget build(BuildContext context) {
    var percentange = widget.productModel['dis'];
    int per = percentange.floor();
    return Scaffold(
      //______________________App Bar_________________________________
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: IconButton(
          icon: const Icon(
            Iconsax.backward,
            color: Colors.white,
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        backgroundColor: ConstantColor.appbarBottombar,
        title: const Center(
          child: Text(
            "Single Product Details",
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(
              height: 20,
            ),
            Container(
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      //____________ Discount and Favourite Icon _______
                      Padding(
                        padding: const EdgeInsets.all(5),
                        child: Container(
                          height: 20,
                          width: 35,
                          decoration: const BoxDecoration(
                            color: Colors.black,
                            borderRadius: BorderRadius.all(Radius.circular(5)),
                          ),
                          //__________________________ Discount percentange _____________________
                          child: Text(
                            "${per.toString()}%",
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                      const Spacer(),
                      GestureDetector(
                        onTap: () {},
                        child: Icon(
                          Iconsax.heart5,
                          size: 35,
                          color: widget.productModel['favourite']
                              ? Colors.red
                              : Colors.black,
                        ),
                      ),
                    ],
                  ),
                  // ---------first load image--------------
                  ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: Image.network(
                      'http://${IP.ip}/images/${widget.productModel['image']}',
                      height: 300,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
                  ),
                  //--------- Fetch the  product name -------------
                  Stack(
                    clipBehavior: Clip.none,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(
                            height: 20,
                          ),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "${widget.productModel['name']}",
                                style: const TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const Spacer(),
                              //---------Fetch the  product price --------------
                              Text(
                                "\$${widget.productModel['newPrice']}",
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 25,
                                  color: Colors.red,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          //---------Fetch the  decription price --------------
                          Text(
                            "${widget.productModel["decription"]}",
                            style: const TextStyle(
                              color: Colors.black,
                            ),
                            textAlign: TextAlign.start,
                          ),
                          const SizedBox(
                            height: 50,
                          ),
                          //__________________ Product and Add to Item _________________
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              //__________ Increase the number of Item ________________

                              IconButton(
                                onPressed: () {
                                  setState(() {
                                    cnt++;
                                  });
                                },
                                icon: const Icon(
                                  Iconsax.add_square5,
                                  size: 50,
                                ),
                              ),
                              const SizedBox(
                                width: 20,
                              ),
                              //____________Show the number____________
                              Text(
                                cnt.toString(),
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 20),
                              ),
                              const SizedBox(
                                width: 20,
                              ),
                              //__________ Minus ________________

                              IconButton(
                                onPressed: () {
                                  setState(() {
                                    if (cnt > 1) {
                                      cnt--;
                                    }
                                  });
                                },
                                icon: const Icon(
                                  Iconsax.minus_square,
                                  size: 50,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 50,
                          ),
                          //_________________CART AND BUY NOW BUTTON_________________________
                          Row(
                            children: [
                              SizedBox(
                                width: 150,
                                child: ElevatedButton.icon(
                                  onPressed: () async {
                                    cart.addToCart(widget.productModel["id"]);
                                    showMessge("Added into cart.");
                                  },
                                  icon: const Icon(Iconsax.shopping_cart),
                                  label: const Text(
                                    "CART",
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                  style: const ButtonStyle(
                                      shape: MaterialStatePropertyAll(
                                          BeveledRectangleBorder(
                                              borderRadius: BorderRadius.only(
                                    bottomLeft: Radius.elliptical(30, 30),
                                    topRight: Radius.elliptical(30, 30),
                                  )))),
                                ),
                              ),
                              const Spacer(),
                              SizedBox(
                                width: 150,
                                child: ElevatedButton(
                                  onPressed: () {
                                    buttonCall(context);
                                  },
                                  style: const ButtonStyle(
                                    shape: MaterialStatePropertyAll(
                                      BeveledRectangleBorder(
                                        borderRadius: BorderRadius.only(
                                          topRight: Radius.circular(20),
                                          bottomRight: Radius.circular(20),
                                          bottomLeft: Radius.elliptical(20, 20),
                                        ),
                                      ),
                                    ),
                                  ),
                                  child: const Text(
                                    "BUY NOW ",
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 100,
            )
          ],
        ),
      ),
    );
  }
}
