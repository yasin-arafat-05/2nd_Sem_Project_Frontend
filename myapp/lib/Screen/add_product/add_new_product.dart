// ignore_for_file: use_build_context_synchronously
import 'package:flutter/material.dart';
import 'package:myapp/Screen/ConnectSideBar/connet_side_bar.dart';
import 'package:myapp/Screen/add_product/new_product_back.dart';
import 'package:myapp/alert_mesg.dart';

class AddNewProduct extends StatefulWidget {
  const AddNewProduct({super.key});

  @override
  State<AddNewProduct> createState() => _AddNewProductState();
}

class _AddNewProductState extends State<AddNewProduct> {
  /*
  "name" "category" "original_price" "new_price" "product_details" "offer_expiration_date":
  */
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _categoryController = TextEditingController();
  final TextEditingController _orginalController = TextEditingController();
  final TextEditingController _newController = TextEditingController();
  final TextEditingController _productController = TextEditingController();
  final TextEditingController _offerController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            //----------------Sign in Text and other texts------------------
            const SizedBox(
              height: 30,
            ),

            //----------------------From for add new Product------------------------
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Form(
                child: Column(
                  children: [
                    const SizedBox(
                      height: 10,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        //------------Product Name---------------
                        const SizedBox(
                          height: 5,
                        ),
                        TextFormField(
                          controller: _nameController,
                          decoration: const InputDecoration(
                            prefixIcon: Icon(Icons.email_outlined),
                            hintText: "Product Name",
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.zero,
                                topRight: Radius.zero,
                                bottomLeft: Radius.zero,
                                bottomRight: Radius.zero,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        //------------Product Category---------------

                        const SizedBox(
                          height: 5,
                        ),
                        TextFormField(
                          controller: _categoryController,
                          decoration: const InputDecoration(
                            prefixIcon: Icon(Icons.password_outlined),
                            hintText: "Category",
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.zero,
                                topRight: Radius.zero,
                                bottomLeft: Radius.zero,
                                bottomRight: Radius.zero,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        //------------Orginal_Price---------------

                        const SizedBox(
                          height: 5,
                        ),
                        TextFormField(
                          controller: _orginalController,
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                            prefixIcon: Icon(Icons.password_outlined),
                            hintText: "Orginal Price",
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.zero,
                                topRight: Radius.zero,
                                bottomLeft: Radius.zero,
                                bottomRight: Radius.zero,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        //------------New Price---------------

                        const SizedBox(
                          height: 5,
                        ),
                        TextFormField(
                          controller: _newController,
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                            prefixIcon: Icon(Icons.password_outlined),
                            hintText: "New Price",
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.zero,
                                topRight: Radius.zero,
                                bottomLeft: Radius.zero,
                                bottomRight: Radius.zero,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        //------------Product Details---------------

                        const SizedBox(
                          height: 5,
                        ),
                        TextFormField(
                          controller: _productController,
                          decoration: const InputDecoration(
                            prefixIcon: Icon(Icons.password_outlined),
                            hintText: "Product Detials",
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.zero,
                                topRight: Radius.zero,
                                bottomLeft: Radius.zero,
                                bottomRight: Radius.zero,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        //------------Discount Final Date---------------

                        const SizedBox(
                          height: 5,
                        ),
                        TextFormField(
                          controller: _offerController,
                          keyboardType: TextInputType.datetime,
                          decoration: const InputDecoration(
                            prefixIcon: Icon(Icons.password_outlined),
                            hintText: "Discount Final Date",
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.zero,
                                topRight: Radius.zero,
                                bottomLeft: Radius.zero,
                                bottomRight: Radius.zero,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        //-----------------submit button-----------
                        ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0XFFF77D8E),
                            textStyle: const TextStyle(
                              color: Colors.white,
                            ),
                            minimumSize: const Size(double.infinity, 50),
                            shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(10),
                                topRight: Radius.circular(25),
                                bottomLeft: Radius.circular(25),
                                bottomRight: Radius.circular(10),
                              ),
                            ),
                          ),
                          onPressed: () async {
                            var k = AddProduct.addProduct(
                                _nameController.text,
                                _categoryController.text,
                                int.tryParse(_orginalController.text) ?? 0,
                                int.tryParse(_newController.text) ?? 0,
                                _productController.text,
                                _offerController.text);
                            String response = await k;
                            await showDialog(
                              context: context,
                              builder: (context) => Message(result: response),
                            );
                            Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) {
                                return const ConnectSideBarAndMenuBar(
                                    initialIndex: 0);
                              },
                            ));
                          },
                          icon: const Icon(
                            Icons.arrow_forward_outlined,
                            color: Colors.white,
                          ),
                          label: const Text(
                            "Submit",
                            style: TextStyle(
                              fontSize: 20,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        //------------------draw the close button----------------------
      ),
    );
  }
}
