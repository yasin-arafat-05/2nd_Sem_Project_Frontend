// ignore_for_file: use_build_context_synchronously

import 'dart:convert';

import 'package:flutter/material.dart';
import 'sign_up_back.dart';
import '../WelcomePage/welcome.dart';
import '../../alert_mesg.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});
  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final SignUpWithBackend _signUp = SignUpWithBackend();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool isShowPassword = true;
  @override
  Widget build(BuildContext context) {
    return Center(
      // first container for occupy place
      // up the profile page
      child: Container(
        height: 650,
        width: 350,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(
            Radius.circular(30.0),
          ),
        ),
        /*
          We use scaffold because, we use dialogbox
          for this dialogbox we should occpy (in the container) place for 
          dialogbox where i can easily use material app 
          degin, and we set the color is background color to 
          transparent so that before dialogbox we use sizebox
          where we define the boundries of the dialogbox.
          */
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          backgroundColor: Colors.transparent,
          body: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                Column(
                  children: [
                    //----------------Sign in Text and other texts------------------
                    const SizedBox(
                      height: 10,
                    ),
                    const Text(
                      'Sign UP',
                      style: TextStyle(
                        fontFamily: "Poppins",
                        fontSize: 30,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const Padding(
                      padding:
                          EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                      child: Text(
                        "Welcome to Galacticart, where your shopping journey begins in a universe of endless possibilities!",
                        textAlign: TextAlign.center,
                      ),
                    ),
                    //----------------------From for sign in------------------------
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Form(
                        child: Column(
                          children: [
                            const SizedBox(
                              height: 10,
                            ),
                            //------------User_Name---------------
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Padding(
                                  padding: EdgeInsets.only(left: 10),
                                  child: Text(
                                    "User Name:",
                                    style: TextStyle(fontSize: 18),
                                  ),
                                ),
                                const SizedBox(
                                  height: 5,
                                ),
                                TextFormField(
                                  controller: _nameController,
                                  keyboardType: TextInputType.text,
                                  textInputAction: TextInputAction.next,
                                  decoration: InputDecoration(
                                    prefixIcon:
                                        const Icon(Icons.email_outlined),
                                    //hintText: "Email",
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(30),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            //------------E-mail---------------
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Padding(
                                  padding: EdgeInsets.only(left: 10),
                                  child: Text(
                                    "Email:",
                                    style: TextStyle(fontSize: 18),
                                  ),
                                ),
                                const SizedBox(
                                  height: 5,
                                ),
                                TextFormField(
                                  controller: _emailController,
                                  keyboardType: TextInputType.emailAddress,
                                  textInputAction: TextInputAction.next,
                                  decoration: InputDecoration(
                                    prefixIcon:
                                        const Icon(Icons.email_outlined),
                                    //hintText: "Email",
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(30),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            //------------passoword---------------
                            const SizedBox(
                              height: 10,
                            ),

                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Padding(
                                  padding: EdgeInsets.only(left: 10.0),
                                  child: Text(
                                    "Password:",
                                    style: TextStyle(fontSize: 18),
                                    textAlign: TextAlign.start,
                                  ),
                                ),
                                const SizedBox(
                                  height: 5,
                                ),
                                TextFormField(
                                  controller: _passwordController,
                                  obscureText: isShowPassword,
                                  textInputAction: TextInputAction.next,
                                  decoration: InputDecoration(
                                    prefixIcon:
                                        const Icon(Icons.password_outlined),
                                    suffixIcon: IconButton(
                                      onPressed: () {
                                        setState(() {
                                          isShowPassword = !isShowPassword;
                                        });
                                      },
                                      icon: Icon(
                                        isShowPassword
                                            ? Icons.visibility_off_outlined
                                            : Icons.visibility_outlined,
                                      ),
                                    ),
                                    //hintText: "Passoword",
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(30),
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
                                    minimumSize:
                                        const Size(double.infinity, 50),
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
                                    Future<String> res =
                                        _signUp.registrationUser(
                                            _nameController.text,
                                            _emailController.text,
                                            _passwordController.text);
                                    //convert future string to string;
                                    String result = await res;
                                    Map<String, dynamic> finalResult =
                                        json.decode(result);
                                    showMessge(
                                      finalResult["detail"],
                                    );
                                    Navigator.of(context)
                                        .push(MaterialPageRoute(
                                      builder: (context) {
                                        return const Welcome();
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
                            const SizedBox(
                              height: 20,
                            ),
                            //---------------OR Already have an account-------------
                            //Divider
                            const Row(
                              children: [
                                Expanded(child: Divider()),
                                Text("OR"),
                                Expanded(child: Divider()),
                              ],
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            const Text("Already have an account?"),
                            const SizedBox(
                              height: 10,
                            ),
                            const Text("Go to welcome page and happy sign in"),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                //------------------draw the close button-----------------------
                const Positioned(
                  left: 160,
                  bottom: -80,
                  child: CircleAvatar(
                    maxRadius: 15,
                    backgroundColor: Colors.white,
                    child: Icon(
                      Icons.close_rounded,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
