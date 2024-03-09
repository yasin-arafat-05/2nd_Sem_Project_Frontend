// ignore_for_file: file_names, unused_field

import 'package:flutter/material.dart';
import 'package:myapp/Screen/profile/delete_item_back.dart';
import 'package:myapp/Screen/profile/edit_product.dart';
import 'package:myapp/Screen/profile/edit_profile.dart';
import 'package:myapp/ip_address.dart';
import 'package:myapp/provider.dart';
import 'package:provider/provider.dart';

class UserProfile extends StatefulWidget {
  const UserProfile({super.key});

  @override
  State<UserProfile> createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> {
  final DeleteProduct _deleteProduct = DeleteProduct();
  late ProfileProvider _profileProvider;

  @override
  initState() {
    super.initState();
    _profileProvider = Provider.of<ProfileProvider>(context, listen: false);
    _profileProvider.profileData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey[900],
      body: FutureBuilder(
          future: _profileProvider.profileData(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            return SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(
                    height: 50,
                  ),
                  //-----------------------------Profile Pic---------------
                  Center(
                    child: CircleAvatar(
                      radius: 60,
                      backgroundImage: NetworkImage(
                        'http://${IP.ip}/images/${_profileProvider.businessUser['Business Image']}',
                      ),
                    ),
                  ),
                  //------------------User name and Business Name-------
                  const SizedBox(
                    height: 10,
                  ),
                  Center(
                    child: Text(
                      _profileProvider.currentUser['User Name'],
                      style: const TextStyle(
                          color: Colors.white54,
                          fontWeight: FontWeight.bold,
                          fontSize: 20),
                    ),
                  ),
                  Center(
                    child: Text(
                      _profileProvider.businessUser['Business Name'],
                      style:
                          const TextStyle(color: Colors.white60, fontSize: 18),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  //-------------------------For Editing button---------------------
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) {
                              return const EditProfile();
                            },
                          ),
                        );
                      },
                      icon: const Icon(
                        Icons.edit,
                        size: 20,
                        color: Colors.white,
                      ),
                      label: const Text(
                        "Edit profile",
                        style: TextStyle(color: Colors.white),
                      ),
                      style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all<Color>(Colors.white54),
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  const Text(
                    "About : ",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white60,
                    ),
                  ),

                  ListTile(
                    leading: const Icon(
                      Icons.location_city,
                      color: Colors.white,
                    ),
                    title: Text(
                      _profileProvider.businessUser["City"],
                      style:
                          const TextStyle(color: Colors.white54, fontSize: 15),
                    ),
                  ),
                  ListTile(
                    leading: const Icon(
                      Icons.location_off_outlined,
                      color: Colors.white,
                    ),
                    title: Text(
                      _profileProvider.businessUser["region"],
                      style:
                          const TextStyle(color: Colors.white54, fontSize: 15),
                    ),
                  ),
                  const Text(
                    "Business Description : ",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white60,
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Text(
                    _profileProvider.businessUser['Business Description'],
                    style: const TextStyle(color: Colors.white54, fontSize: 15),
                    textAlign: TextAlign.start,
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  //-----------------------Post Before Decoration------------------------------
                  Container(
                    height: 5,
                    decoration: const BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                          color: Colors.white,
                          blurRadius: 15,
                        ),
                      ],
                    ),
                    child: const Divider(
                      color: Colors.white30,
                    ),
                  ),

                  Container(
                    height: 50,
                    width: 400,
                    decoration: const BoxDecoration(
                      color: Color.fromARGB(92, 117, 218, 188),
                    ),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.post_add_outlined,
                          color: Colors.white,
                        ),
                        Text(
                          "Manage Product",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    height: 5,
                    decoration: const BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                          blurRadius: 10,
                          color: Colors.white,
                        )
                      ],
                    ),
                  ),

                  Container(
                    height: 10,
                    color: Colors.black26,
                  ),

                  //-------------------------- Item builder for Post ----------------------

                  SizedBox(
                    child: GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: _profileProvider.allProduct.length,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 1,
                        crossAxisSpacing: 3,
                        childAspectRatio: 0.7,
                      ),
                      itemBuilder: (context, index) {
                        var element = _profileProvider.allProduct[index];
                        return Card(
                          elevation: 10.0,
                          child: Column(
                            children: [
                              //------------ PopupMenuButton ------------------------

                              customPopupMenuButton(
                                  element["id"],
                                  element['Product Name'],
                                  element["Category"],
                                  element["Product Details"],
                                  element["Offer Expiration Date"],
                                  element["Product Image"],
                                  element["Original Price"] ?? 0,
                                  element["New Price"] ?? 0),

                              // ---------first load image--------------
                              const SizedBox(
                                height: 2,
                              ),
                              SizedBox(
                                height: 400,
                                width: double.infinity,
                                child: Image.network(
                                  'http://${IP.ip}/images/${element['Product Image']}',
                                ),
                              ),
                              const SizedBox(
                                height: 2.0,
                              ),
                              //---------Fetch the  product name --------------
                              Text(
                                element['Product Name'],
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              //---------Fetch the  product price --------------
                              Text(
                                "Price: \$ ${element['New Price']}",
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              //---------padding with sizebox --------------
                              const SizedBox(
                                height: 5,
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            );
          }),
    );
  }

//----------------------------------PopupMenu Controller-------------------------
  Row customPopupMenuButton(
      int id,
      String name,
      String category,
      String details,
      String date,
      String image,
      double orginal,
      double newPrice) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(10),
          child: CircleAvatar(
            backgroundImage: NetworkImage(
              'http://${IP.ip}/images/${_profileProvider.businessUser['Business Image']}',
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 0),
          child: Text(
            _profileProvider.currentUser['User Name'],
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
          ),
        ),
        const Spacer(),
        PopupMenuButton(
          itemBuilder: (context) {
            return [
              const PopupMenuItem(
                value: 1,
                child: Text(
                  "Edit",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              const PopupMenuItem(
                value: 2,
                child: Text(
                  "Delete",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ];
          },
          onSelected: (value) async {
            switch (value) {
              case 1:
                customEditProduct(name, category, details, date, image, orginal,
                    newPrice, id);
                break;
              case 2:
                await deleteProduct(id);
                break;
            }
          },
        ),
      ],
    );
  }

  void customEditProduct(String n, String c, String p, String e, String i,
      double o, double newPrice, int id) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) {
          return EditProduct(
            name: n,
            category: c,
            productDetails: p,
            expirationDate: e,
            image: i,
            orginalPrice: o,
            newPrice: newPrice,
            id: id,
          );
        },
      ),
    );
  }

  //------------------------Delete Product --------------------
  Future<void> deleteProduct(ele) async {
    // ignore: unused_local_variable
    String k = await _deleteProduct.deleteProduct(ele);
    setState(() {
      _profileProvider.profileData();
    });
  }
}
