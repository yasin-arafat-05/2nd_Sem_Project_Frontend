import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:myapp/Screen/home/favourite_icon_back.dart';
import 'package:myapp/ip_address.dart';
import 'package:myapp/provider.dart';
import 'package:provider/provider.dart';

class FavouriteScreen extends StatefulWidget {
  const FavouriteScreen({super.key});

  @override
  State<FavouriteScreen> createState() => _FavouriteScreenState();
}

class _FavouriteScreenState extends State<FavouriteScreen> {
  late FavouriteProductProvider favouriteProductProvider;
  late BestSellingProvider bestSellingProviderModel;
  late Favourite fb;
  @override
  void initState() {
    super.initState();
    //_____________ listen: autometical rebuilt widget or not __________________
    favouriteProductProvider =
        Provider.of<FavouriteProductProvider>(context, listen: false);
    bestSellingProviderModel =
        Provider.of<BestSellingProvider>(context, listen: false);
    functionCall();
    fb = Favourite(bestSellingProviderModel);
  }

  Future<void> functionCall() async {
    await favouriteProductProvider.getFavouriteProduct();

    await bestSellingProviderModel.bestProductData();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: FutureBuilder(
        future: functionCall(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            const Center(child: CircularProgressIndicator());
          }
          return favouriteProductProvider.favouriteProduct.isEmpty
              ? const Center(
                  child: Padding(
                    padding: EdgeInsets.only(top: 300),
                    child: Text(
                      "Favourite List Empty",
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
                      // height: 1000,
                      child: ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        padding: const EdgeInsets.all(12.0),
                        itemCount:
                            favouriteProductProvider.favouriteProduct.length,
                        itemBuilder: (context, index) {
                          var item =
                              favouriteProductProvider.favouriteProduct[index];
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
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              //------------------------Get Product name-------------------
                                              Text(
                                                item["Product Name"],
                                                style: const TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                ),
                                                textAlign: TextAlign.center,
                                              ),
                                              //-------------------Get price -------------------
                                              Text(
                                                " ${item["New Price"]} \$",
                                                style: const TextStyle(
                                                  color: Colors.red,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 20,
                                                ),
                                              ),
                                            ],
                                          ),
                                          //--------------------Add to cart  list----------------
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceAround,
                                            children: [
                                              IconButton(
                                                onPressed: () {},
                                                icon: const Icon(
                                                  Iconsax.shopping_cart5,
                                                ),
                                              ),
                                              //--------------------Delete form favourite list----------------
                                              CupertinoButton(
                                                  padding:
                                                      const EdgeInsets.all(0),
                                                  child: const CircleAvatar(
                                                    backgroundColor: Colors.red,
                                                    maxRadius: 13,
                                                    child: Icon(
                                                      Icons.delete,
                                                      color: Colors.white,
                                                    ),
                                                  ),
                                                  onPressed: () {
                                                    setState(() {
                                                      fb.removeFromFavourite(
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
    );
  }
}
