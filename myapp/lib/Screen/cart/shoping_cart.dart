import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:myapp/Screen/single_product_details/cart.dart';
import 'package:myapp/ip_address.dart';
import 'package:myapp/provider.dart';
import 'package:provider/provider.dart';

class SoppingCart extends StatefulWidget {
  const SoppingCart({
    super.key,
  });

  @override
  State<SoppingCart> createState() => _SoppingCartState();
}

class _SoppingCartState extends State<SoppingCart> {
  late CartProductProvider cartProductProvider;
  late BestSellingProvider bestSellingProvider;
  late Cart cart;
  @override
  void initState() {
    super.initState();
    cartProductProvider =
        Provider.of<CartProductProvider>(context, listen: false);
    bestSellingProvider =
        Provider.of<BestSellingProvider>(context, listen: false);
    functionCall();
    cart = Cart(bestSellingProvider);
  }

  Future<void> functionCall() async {
    await bestSellingProvider.bestProductData();
    await cartProductProvider.getCartProductList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.only(left: 5, right: 5),
        child: SingleChildScrollView(
          child: FutureBuilder(
            future: functionCall(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                const Center(child: CircularProgressIndicator());
              }
              return cartProductProvider.cartProduct.isEmpty
                  ? const Center(
                      child: Padding(
                        padding: EdgeInsets.only(top: 300),
                        child: Text(
                          "Cart List Empty",
                          style: TextStyle(
                            color: Colors.blueAccent,
                            fontSize: 25,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    )
                  : Column(
                      children: [
                        SizedBox(
                          child: ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            padding: const EdgeInsets.all(12.0),
                            itemCount: cartProductProvider.cartProduct.length,
                            itemBuilder: (context, index) {
                              var item = cartProductProvider.cartProduct[index];
                              return Container(
                                margin: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12.0),
                                  border: Border.all(
                                    color: Colors.red,
                                    width: 3,
                                  ),
                                ),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: Container(
                                        height: 130,
                                        color: Colors.red.withOpacity(0.1),
                                        child: Image.network(
                                          'http://${IP.ip}/images/${item['Product Image']}',
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      flex: 2,
                                      child: SizedBox(
                                        height: 140,
                                        child: Padding(
                                          padding: const EdgeInsets.all(12),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  //------------------------Get Product name-------------------
                                                  Text(
                                                    item["Product Name"],
                                                    style: const TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                    textAlign: TextAlign.center,
                                                  ),
                                                  //-------------------Get price -------------------
                                                  Text(
                                                    " ${item["New Price"]} \$",
                                                    style: const TextStyle(
                                                      color: Colors.red,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 20,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              //--------------------Favourite OR NOT ----------------
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceAround,
                                                children: [
                                                  IconButton(
                                                    onPressed: () {},
                                                    icon: Icon(
                                                      Iconsax.heart5,
                                                      size: 30,
                                                      color: item["Favourite"]
                                                          ? Colors.red
                                                          : Colors.black,
                                                    ),
                                                  ),
                                                  //--------------------Delete form favourite list----------------
                                                  CupertinoButton(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              0),
                                                      child: const CircleAvatar(
                                                        backgroundColor:
                                                            Colors.red,
                                                        maxRadius: 13,
                                                        child: Icon(
                                                          Icons.delete,
                                                          color: Colors.white,
                                                        ),
                                                      ),
                                                      onPressed: () {
                                                        setState(() {
                                                          cart.removeFromCart(
                                                              item["id"]);
                                                        });
                                                      }),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    );
            },
          ),
        ),
      ),
    );
  }
}
