// ignore_for_file: no_leading_underscores_for_local_identifiers

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:myapp/Screen/ConnectSideBar/connet_side_bar.dart';
import 'package:myapp/Screen/profile/edit_profile_back.dart';
import 'package:myapp/Screen/profile/profile_pic_back.dart';
import 'package:myapp/ip_address.dart';
import 'package:myapp/provider.dart';
import 'package:provider/provider.dart';

final _fromKey = GlobalKey<FormState>();

class EditProfile extends StatefulWidget {
  const EditProfile({super.key});
  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  late ProfileProvider _profileProvider;
  final EditProfileBack _editProfileBack = EditProfileBack();
  final TextEditingController _country = TextEditingController();
  final TextEditingController _city = TextEditingController();
  final TextEditingController _businessName = TextEditingController();
  final TextEditingController _businessDescription = TextEditingController();

  @override
  void initState() {
    super.initState();
    _profileProvider = Provider.of<ProfileProvider>(context, listen: false);
    functionCall();
    _country.text = _profileProvider.businessUser["region"];
    _city.text = _profileProvider.businessUser["City"];
    _businessName.text = _profileProvider.businessUser["Business Name"];
    _businessDescription.text =
        _profileProvider.businessUser["Business Description"];
  }

  Future<void> functionCall() async {
    await _profileProvider.profileData();
  }

  @override
  Widget build(BuildContext context) {
    File? _imageFile;
    final UploadProfilePicture _uploadProfilePicture = UploadProfilePicture();
    return Scaffold(
      appBar: AppBar(
        elevation: 10,
        title: const Text(
          "Edit User Profile",
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: FutureBuilder(
          future: _profileProvider.profileData(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            return SingleChildScrollView(
              child: Stack(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 10, right: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(
                          height: 50,
                        ),
                        // ---------------------Profile Picture --------------------
                        Center(
                          child: CircleAvatar(
                            radius: 60,
                            backgroundImage: NetworkImage(
                              "http://${IP.ip}/images/${_profileProvider.businessUser['Business Image']}",
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 30,
                        ),
                        //-------Edit Buttion------------
                        Center(
                          child: SizedBox(
                            child: ElevatedButton.icon(
                              onPressed: () async {
                                final picker = ImagePicker();
                                final pickedImage = await picker.pickImage(
                                    source: ImageSource.gallery);
                                if (pickedImage != null) {
                                  _imageFile = File(pickedImage.path);
                                }
                                _uploadProfilePicture
                                    .uploadProfilePicture(_imageFile!);
                              },
                              icon: const Icon(
                                Icons.edit,
                                color: Color.fromARGB(255, 63, 58, 58),
                              ),
                              label: const Text(
                                "Edit Profile  Picture",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Color.fromARGB(255, 63, 58, 58),
                                ),
                              ),
                              style: ButtonStyle(
                                backgroundColor:
                                    const MaterialStatePropertyAll<Color>(
                                  Color.fromARGB(255, 230, 222, 222),
                                ),
                                shape: MaterialStatePropertyAll<
                                    RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        //----------- Edit Country, Location and Business Product  ----------
                        const SizedBox(
                          height: 50,
                        ),
                        //--------------------------- From -----------------
                        Form(
                          key: _fromKey,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // ------------------- Country -----------------
                              const Text(
                                "Country : ",
                                style: TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              TextFormField(
                                controller: _country,
                                autovalidateMode:
                                    AutovalidateMode.onUserInteraction,
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
                              // ------------------- City --------------------
                              const Text(
                                "City : ",
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              TextFormField(
                                controller: _city,
                                autovalidateMode:
                                    AutovalidateMode.onUserInteraction,
                                decoration: const InputDecoration(
                                    border: OutlineInputBorder()),
                                validator: (value) {
                                  if (value!.length > 20) {
                                    return "Can't assign more than 20 words!";
                                  }
                                  return null;
                                },
                              ),
                              // ---------------- Business Name ------------------
                              const SizedBox(
                                height: 10,
                              ),
                              const Text(
                                "Business Name : ",
                                style: TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              TextFormField(
                                controller: _businessName,
                                autovalidateMode:
                                    AutovalidateMode.onUserInteraction,
                                decoration: const InputDecoration(
                                    border: OutlineInputBorder()),
                                validator: (value) {
                                  if (value!.length > 20) {
                                    return "Can't assign more than 20 words!";
                                  }
                                  return null;
                                },
                              ),
                              // -------------- Business Description -------------
                              const SizedBox(
                                height: 10,
                              ),
                              const Text(
                                "Business Description : ",
                                style: TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              TextFormField(
                                controller: _businessDescription,
                                autovalidateMode:
                                    AutovalidateMode.onUserInteraction,
                                maxLines: 6,
                                decoration: const InputDecoration(
                                  border: OutlineInputBorder(),
                                ),
                                validator: (value) {
                                  if (value!.length > 200) {
                                    return "Can't assign more than 200 words!";
                                  }
                                  return null;
                                },
                              ),
                            ],
                          ),
                        ),
                        //---------------------- Submit Button -------------
                        const SizedBox(
                          height: 40,
                        ),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () async {
                              // ignore: unused_local_variable
                              String s = await _editProfileBack.editProfileBack(
                                  _businessName.text,
                                  _businessDescription.text,
                                  _city.text,
                                  _country.text);

                              // ignore: use_build_context_synchronously
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) {
                                    return const ConnectSideBarAndMenuBar(
                                      initialIndex: 4,
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
                          height: 40,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          }),
    );
  }
}
