import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:myapp/Constant/constanvalue.dart';
import 'package:myapp/Constant/curve_home.dart';
import 'package:iconsax/iconsax.dart';
import 'package:myapp/Screen/home/favourite_icon_back.dart';
import 'package:myapp/Screen/single_product_details/single_product_details.dart';
import 'package:myapp/ip_address.dart';
import 'package:myapp/provider.dart';
import 'package:provider/provider.dart';

class HOMETWO extends StatefulWidget {
  const HOMETWO({super.key});

  @override
  State<HOMETWO> createState() => _HOMETWOState();
}

class _HOMETWOState extends State<HOMETWO> {
  late CategoriesProvider categoriesProviderModel;
  late BestSellingProvider bestSellingProviderModel;
  late Favourite fb;
  @override
  void initState() {
    super.initState();
    categoriesProviderModel =
        Provider.of<CategoriesProvider>(context, listen: false);
    bestSellingProviderModel = Provider.of(context, listen: false);
    functionCall();
    fb = Favourite(bestSellingProviderModel);
  }

  Future<void> functionCall() async {
    await categoriesProviderModel.categoriesData();
    await bestSellingProviderModel.bestProductData();
  }

  @override
  Widget build(BuildContext context) {
    final List<String> imgList = [
      "assets/banner/bannerONE.png",
      "assets/banner/bannerTWO.png"
    ];

    return Scaffold(
      body: SingleChildScrollView(
        child: FutureBuilder(
          future: functionCall(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                  child: Padding(
                      padding: EdgeInsets.only(top: 300),
                      child: CircularProgressIndicator()));
            }
            return Column(
              children: [
                //------------------------- First Upper Part ---------------------------
                //______ ClipPath for give custom shpae and use cliper property_________
                ClipPath(
                  clipper: CurveHome(),
                  child: Container(
                    color: ConstantColor.primary,
                    padding: const EdgeInsets.all(0),
                    child: SizedBox(
                      height: 270,
                      child: Stack(
                        children: [
                          //______________ Set the Two Circle ____________________
                          Positioned(
                              top: -150,
                              right: -300,
                              child: customContainerWIthCircle()),
                          Positioned(
                              top: 50,
                              right: -320,
                              child: customContainerWIthCircle()),

                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              //_______________________ Search Bar _____________________
                              customSearchBarCode(),
                              const SizedBox(
                                height: 10,
                              ),
                              //_____________ Popular Categories___________
                              const Padding(
                                padding: EdgeInsets.only(left: 20),
                                child: Text(
                                  "C A T E G O R I E S",
                                  style: TextStyle(
                                    fontFamily: "Poppins",
                                    fontSize: 20,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              //--------------- Card For Categories------------------
                              SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: Row(
                                    children: categoriesProviderModel.categories
                                        .map(
                                          (e) => Padding(
                                            padding:
                                                const EdgeInsets.only(left: 20),
                                            child: Column(
                                              children: [
                                                CircleAvatar(
                                                  maxRadius: 30,
                                                  backgroundImage: NetworkImage(
                                                      'http://${IP.ip}/images/${e['image']}'),
                                                ),
                                                const SizedBox(
                                                  height: 10,
                                                ),
                                                Center(
                                                  child: Text(
                                                    e['category'],
                                                    style: const TextStyle(
                                                      color: Colors.white,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        )
                                        .toList()),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                //___________________________ White Backgournd Part _____________________
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 20, right: 20),
                      child: Container(
                        decoration: const BoxDecoration(
                          borderRadius: BorderRadius.all(
                            Radius.circular(12),
                          ),
                        ),
                        //______________________Image Slider______________________
                        child: CarouselSlider(
                          items: imgList.map((e) {
                            return Center(
                              child: Image.asset(
                                e,
                                fit: BoxFit.cover,
                              ),
                            );
                          }).toList(),
                          options: CarouselOptions(
                            viewportFraction: 1,
                            autoPlay: true,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    //__________________________ Best Product __________________

                    Padding(
                      padding: const EdgeInsets.only(left: 20),
                      child: Text(
                        "P O P U L A R   P R O D U C T",
                        style: TextStyle(
                          fontFamily: "Poppins",
                          fontSize: 20,
                          color: ConstantColor.primary,
                        ),
                      ),
                    ),

                    const SizedBox(
                      height: 20,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 5, right: 5),
                      child: GridView.builder(
                        itemCount: bestSellingProviderModel.bestProduct.length,
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisSpacing: 10,
                                mainAxisSpacing: 10,
                                childAspectRatio: 0.6,
                                crossAxisCount: 2),
                        itemBuilder: (context, index) {
                          var element =
                              bestSellingProviderModel.bestProduct[index];
                          var percentange = element['dis'];
                          int per = percentange.floor();
                          return GestureDetector(
                            onTap: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) {
                                  return SingleProductDetails(
                                      productModel: element);
                                },
                              ));
                            },
                            child: Container(
                              width: 180,
                              padding: const EdgeInsets.all(2),
                              decoration: const BoxDecoration(
                                color: Colors.white,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(12)),
                                boxShadow: [BoxShadow(blurRadius: 5)],
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Stack(
                                    children: [
                                      //_______________image_______
                                      ClipRRect(
                                        borderRadius: BorderRadius.circular(20),
                                        child: Image.network(
                                          'http://${IP.ip}/images/${element['image']}',
                                          height: 220,
                                          width: double.infinity,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                      //_______________Product price and favourite ________
                                      Row(
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.all(5),
                                            child: Container(
                                              height: 20,
                                              width: 35,
                                              decoration: const BoxDecoration(
                                                color: Colors.black,
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(5)),
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
                                          //__________________________ Favourite Icon _____________________
                                          GestureDetector(
                                            onTap: () {
                                              element['favourite']
                                                  ? fb.removeFromFavourite(
                                                      element['id'])
                                                  : fb.addToFavourite(
                                                      element['id']);
                                            },
                                            //_____minimize the cost using provider and consumer____
                                            child:
                                                Consumer<BestSellingProvider>(
                                              builder: (context, fb, child) {
                                                return Icon(
                                                  Iconsax.heart5,
                                                  size: 40,
                                                  color: element['favourite']
                                                      ? Colors.deepOrangeAccent
                                                      : Colors.black,
                                                );
                                              },
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                  Stack(
                                    clipBehavior: Clip.none,
                                    children: [
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          //_______________Product name______________
                                          Text(
                                            element['name'],
                                            style: const TextStyle(
                                              fontSize: 15,
                                              fontWeight: FontWeight.bold,
                                            ),
                                            textAlign: TextAlign.center,
                                          ),
                                          Text(
                                            "\$${element['newPrice']}",
                                            style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: Colors.red,
                                              fontSize: 20,
                                            ),
                                            textAlign: TextAlign.left,
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ],
            );
          },
        ),
      ),
    );
  }

//_________________________________SHORTEN THE CODE_____________________________
//________________________________Custom Search Bar__________________________
  Padding customSearchBarCode() {
    return Padding(
      padding: const EdgeInsets.only(top: 30),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 20),
        width: double.infinity,
        height: 50,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(12)),
        ),
        //__________Search Icon,Text_____________
        child: const Row(
          children: [
            SizedBox(
              width: 5,
            ),
            Icon(Iconsax.search_normal),
            SizedBox(
              width: 5,
            ),
            Text(
              "Search in store . . .",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
          ],
        ),
      ),
    );
  }

  // ------------------ customContainerWithCircle -------------------------------
  Container customContainerWIthCircle() {
    return Container(
      height: 400,
      width: 400,
      padding: const EdgeInsets.all(0),
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(Radius.circular(400)),
        color: ConstantColor.textWhite.withOpacity(0.3),
      ),
    );
  }
}

class CustomBannerImage extends StatelessWidget {
  const CustomBannerImage({
    super.key,
    required this.path,
  });
  final String path;
  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: const BorderRadius.all(
        Radius.circular(12),
      ),
      child: Image(
        image: AssetImage(path),
        fit: BoxFit.cover,
      ),
    );
  }
}
