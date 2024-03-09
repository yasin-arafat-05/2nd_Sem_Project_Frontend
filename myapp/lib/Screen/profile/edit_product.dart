import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:myapp/Screen/ConnectSideBar/connet_side_bar.dart';
import 'package:myapp/Screen/profile/product_pic_back.dart';
import 'package:myapp/Screen/profile/update_product_back.dart';
import 'package:myapp/ip_address.dart';

class EditProduct extends StatefulWidget {
  EditProduct(
      {super.key,
      required this.name,
      required this.category,
      required this.productDetails,
      required this.expirationDate,
      required this.image,
      required this.orginalPrice,
      required this.newPrice,
      required this.id});

  final String name;
  final String category;
  final String productDetails;
  final String expirationDate;
  final String image;
  final double orginalPrice;
  final double newPrice;
  final int id;

  final UpdateSingleProduct _updateSingleProduct = UpdateSingleProduct();
  @override
  State<EditProduct> createState() => _EditProductState();
}

class _EditProductState extends State<EditProduct> {
  final _fromKeyONE = GlobalKey<FormState>();
  final TextEditingController productNameController = TextEditingController();
  final TextEditingController productCategoryController =
      TextEditingController();
  final TextEditingController newPrizeController = TextEditingController();
  final TextEditingController orginalPrizeController = TextEditingController();
  final TextEditingController expiration = TextEditingController();
  final TextEditingController productDesController = TextEditingController();
  @override
  void initState() {
    super.initState();
    productNameController.text = widget.name;
    productCategoryController.text = widget.category;
    newPrizeController.text = widget.newPrice.toString();
    orginalPrizeController.text = widget.orginalPrice.toString();
    expiration.text = widget.expirationDate;
    productDesController.text = widget.productDetails;
  }

  @override
  Widget build(BuildContext context) {
    // ignore: no_leading_underscores_for_local_identifiers
    File? _imageFile;
    final UploadProductImage uploadProductImage = UploadProductImage();
    return Scaffold(
      appBar: AppBar(
        elevation: 10,
        title: const Text(
          "Edit Product",
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      //backgroundColor: Colors.transparent,
      body: SingleChildScrollView(
        child: Stack(
          children: [
            Column(
              children: [
                //------------------Setting UP the Image--------------------
                Padding(
                  padding: const EdgeInsets.all(30),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(30),
                    child: Image.network(
                      'http://${IP.ip}/images/${widget.image}',
                    ),
                  ),
                ),
                //--------------------- image upload button ---------------

                //-------Edit Buttion------------
                Center(
                  child: SizedBox(
                    child: ElevatedButton.icon(
                      onPressed: () async {
                        final picker = ImagePicker();
                        final pickedImage =
                            await picker.pickImage(source: ImageSource.gallery);
                        if (pickedImage != null) {
                          _imageFile = File(pickedImage.path);
                        }
                        uploadProductImage.uploadProductImage(
                            widget.id, _imageFile!);
                      },
                      icon: const Icon(
                        Icons.edit,
                        color: Color.fromARGB(255, 63, 58, 58),
                      ),
                      label: const Text(
                        "Edit Product Picture",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Color.fromARGB(255, 63, 58, 58),
                        ),
                      ),
                      style: ButtonStyle(
                        backgroundColor: const MaterialStatePropertyAll<Color>(
                          Color.fromARGB(255, 230, 222, 222),
                        ),
                        shape: MaterialStatePropertyAll<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),

                //--------------------------------- From --------------------------------------
                Form(
                  key: _fromKeyONE,
                  child: Padding(
                    padding:
                        const EdgeInsets.only(left: 10, right: 10, top: 30),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // ------------------- Product Name -----------------
                        const Text(
                          "Product Name : ",
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        TextFormField(
                          controller: productNameController,
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          decoration: const InputDecoration(
                              border: OutlineInputBorder()),
                          validator: (value) {
                            if (value!.length > 20) {
                              return "Can't assign more than 20 words!";
                            }
                            return null;
                          },
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        // ------------------- Product Category --------------------
                        const Text(
                          "Product Category : ",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        TextFormField(
                          controller: productCategoryController,
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          decoration: const InputDecoration(
                              border: OutlineInputBorder()),
                          validator: (value) {
                            if (value!.length > 30) {
                              return "Can't assign more than 30 words!";
                            }
                            return null;
                          },
                        ),
                        // ---------------- New  Price ------------------
                        const SizedBox(
                          height: 10,
                        ),
                        const Text(
                          "New Price : ",
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        const Text('New prize should less than orginal price'),
                        const SizedBox(
                          height: 10,
                        ),
                        TextFormField(
                          controller: newPrizeController,
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          decoration: const InputDecoration(
                              border: OutlineInputBorder()),
                          validator: (value) {
                            if (value!.length > 10) {
                              return "Can't assign more than 10 words!";
                            }
                            return null;
                          },
                        ),
                        // -------------- Orginal prize -------------
                        const SizedBox(
                          height: 10,
                        ),
                        const Text(
                          "Orginal Prize : ",
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        TextFormField(
                          controller: orginalPrizeController,
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                          ),
                          validator: (value) {
                            if (value!.length > 10) {
                              return "Can't assign more than 10 words!";
                            }
                            return null;
                          },
                        ),
                        // -------------- expiration date  -------------
                        const SizedBox(
                          height: 10,
                        ),
                        const Text(
                          "Expiration Date: ",
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        TextFormField(
                          controller: expiration,
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                          ),
                        ),
                        // -------------- Product  Details -------------
                        const SizedBox(
                          height: 10,
                        ),
                        const Text(
                          "Product Details: ",
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        TextFormField(
                          controller: productDesController,
                          maxLines: 8,
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                          ),
                          validator: (value) {
                            if (value!.length > 500) {
                              return "Can't assign more than 500 words!";
                            }
                            return null;
                          },
                        ),
                        //---------------------- Submit Button -------------
                        const SizedBox(
                          height: 40,
                        ),
                        SizedBox(
                          width: double.infinity,
                          height: 50,
                          child: ElevatedButton(
                            onPressed: () async {
                              _fromKeyONE.currentState!.validate();

                              String s = await widget._updateSingleProduct
                                  .updateSingleProduct(
                                      widget.id,
                                      productNameController.text,
                                      productCategoryController.text,
                                      productDesController.text,
                                      expiration.text,
                                      double.tryParse(
                                              orginalPrizeController.text) ??
                                          0.0,
                                      double.tryParse(
                                              newPrizeController.text) ??
                                          0);
                              // ignore: avoid_print
                              print(s);

                              // ignore: use_build_context_synchronously
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) {
                                    return const ConnectSideBarAndMenuBar(
                                      initialIndex: 3,
                                    );
                                  },
                                ),
                              );
                            },
                            style: const ButtonStyle(
                              backgroundColor: MaterialStatePropertyAll<Color>(
                                Color.fromARGB(255, 230, 222, 222),
                              ),
                              shape: MaterialStatePropertyAll<
                                  BeveledRectangleBorder>(
                                BeveledRectangleBorder(
                                  borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(10),
                                    bottomRight: Radius.circular(10),
                                    topRight: Radius.circular(20),
                                    bottomLeft: Radius.circular(20),
                                  ),
                                ),
                              ),
                            ),
                            child: const Text(
                              "Submit",
                              style: TextStyle(
                                color: Color.fromARGB(255, 63, 58, 58),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 100,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
