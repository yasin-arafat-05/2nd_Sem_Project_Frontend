// ignore_for_file: use_build_context_synchronously, avoid_print

import 'package:flutter/material.dart';
import 'package:myapp/Screen/LogIn/log_in_back.dart';
import 'package:myapp/Screen/ConnectSideBar/connet_side_bar.dart';
import 'package:myapp/alert_mesg.dart';
import 'package:myapp/token_handling.dart';

class LoginDialog extends StatefulWidget {
  const LoginDialog({super.key});

  @override
  State<LoginDialog> createState() => _LoginDialogState();
}

class _LoginDialogState extends State<LoginDialog> {
  bool isShowPassword = true;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        height: 600,
        width: 350,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(
            Radius.circular(30.0),
          ),
        ),
        /*
          We use scaffold because, we use dialogbox
          for this dialogbox we should occpy place for 
          dialogbox where i can easily use material app 
          degin, and we set the color is background color to 
          transparent so that before dialogbox we use sizebox
          where we define the boundries of the dialogbox.
          */
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          backgroundColor: Colors.transparent,
          body: SingleChildScrollView(
            //--------This is for textfromfield---------------
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
                      'Sign In',
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
                        "Welcome back to Galacticart, where your shopping journey continues in the vast galaxy of incredible products and endless possibilities. Happy shopping! ",
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
                                //-----------------------Submit button------------------
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
                                    var k = LogIn.login(_emailController.text,
                                        _passwordController.text);
                                    Map<String, dynamic> response = await k;
                                    print(
                                        "the value of k ${response['success']} and ${response['error']}");

                                    if (response['success']) {
                                      TokenHandiling()
                                          .storeAccessToken(response['token']);

                                      Navigator.of(context).pushAndRemoveUntil(
                                        MaterialPageRoute(
                                          builder: (context) {
                                            return const ConnectSideBarAndMenuBar(
                                                initialIndex: 0);
                                          },
                                        ),
                                        (route) => false,
                                      );
                                    } else {
                                      showDialog(
                                        context: context,
                                        builder: (context) => Message(
                                          result: response['error'],
                                        ),
                                      );
                                    }
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
                            const Text("Don't have an account?"),
                            const SizedBox(
                              height: 10,
                            ),
                            const Text("Go to welcome page and happy sign up"),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                //------------------draw the close button-----------------------
                const Positioned(
                  left: 160,
                  bottom: -150,
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
