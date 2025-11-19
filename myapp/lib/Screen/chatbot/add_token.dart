// ignore_for_file: use_build_context_synchronously
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'add_token_back.dart';
import '../../alert_mesg.dart';

class AddTokenPage extends StatefulWidget {
  const AddTokenPage({super.key});

  @override
  State<AddTokenPage> createState() => _AddTokenPageState();
}

class _AddTokenPageState extends State<AddTokenPage> {
  final TextEditingController _facebookController = TextEditingController();
  final TextEditingController _instagramController = TextEditingController();
  final TextEditingController _linkedinController = TextEditingController();
  final TextEditingController _expiresAtController = TextEditingController();

  @override
  void dispose() {
    _facebookController.dispose();
    _instagramController.dispose();
    _linkedinController.dispose();
    _expiresAtController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 30),
            // Title
            const Padding(
              padding: EdgeInsets.all(20.0),
              child: Text(
                "Add Social Media Tokens",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Color.fromARGB(255, 2, 5, 37),
                ),
              ),
            ),
            // Form
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Form(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 20),
                    // Facebook Token
                    TextFormField(
                      controller: _facebookController,
                      decoration: InputDecoration(
                        prefixIcon: const Icon(Icons.facebook, color: Colors.blue),
                        hintText: "Facebook Token",
                        border: const OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                        ),
                      ),
                      maxLines: 3,
                    ),
                    const SizedBox(height: 20),
                    // Instagram Token
                    TextFormField(
                      controller: _instagramController,
                      decoration: InputDecoration(
                        prefixIcon: const Icon(Icons.camera_alt, color: Colors.purple),
                        hintText: "Instagram Token",
                        border: const OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                        ),
                      ),
                      maxLines: 3,
                    ),
                    const SizedBox(height: 20),
                    // LinkedIn Token
                    TextFormField(
                      controller: _linkedinController,
                      decoration: InputDecoration(
                        prefixIcon: const Icon(Icons.business, color: Colors.blue),
                        hintText: "LinkedIn Token",
                        border: const OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                        ),
                      ),
                      maxLines: 3,
                    ),
                    const SizedBox(height: 20),
                    // Expires At
                    TextFormField(
                      controller: _expiresAtController,
                      decoration: const InputDecoration(
                        prefixIcon: Icon(Iconsax.calendar, color: Colors.orange),
                        hintText: "Expires At (e.g., 2025-11-19T00:02:50.639Z)",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                        ),
                      ),
                    ),
                    const SizedBox(height: 30),
                    // Submit Button
                    ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0XFFF77D8E),
                        textStyle: const TextStyle(
                          color: Colors.white,
                        ),
                        minimumSize: const Size(double.infinity, 50),
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                        ),
                      ),
                      onPressed: () async {
                        if (_facebookController.text.isEmpty &&
                            _instagramController.text.isEmpty &&
                            _linkedinController.text.isEmpty) {
                          showMessge("Please enter at least one token");
                          return;
                        }
                        if (_expiresAtController.text.isEmpty) {
                          showMessge("Please enter expiration date");
                          return;
                        }

                        String response = await AddToken.createToken(
                          _facebookController.text,
                          _instagramController.text,
                          _linkedinController.text,
                          _expiresAtController.text,
                        );

                        await showDialog(
                          context: context,
                          builder: (context) => Message(result: response),
                        );

                        // Clear fields after successful submission
                        _facebookController.clear();
                        _instagramController.clear();
                        _linkedinController.clear();
                        _expiresAtController.clear();
                      },
                      icon: const Icon(
                        Iconsax.tick_circle,
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
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

