import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:rive/rive.dart' hide Image;
import 'package:myapp/Screen/LogIn/log_in_page.dart';
import 'package:myapp/Screen/SingUp/sing_up_page.dart';

class Welcome extends StatefulWidget {
  const Welcome({super.key});

  @override
  State<Welcome> createState() => _WelcomeState();
}

class _WelcomeState extends State<Welcome> {
  //------------Controller for rive animation---------------
  late RiveAnimationController _riveAnimationControllerONE;
  late RiveAnimationController _riveAnimationControllerTwo;

  //Initialize them,if autoplay=true then when we refresh animation will automatically play
  @override
  void initState() {
    _riveAnimationControllerONE = OneShotAnimation("active", autoplay: false);
    _riveAnimationControllerTwo = OneShotAnimation("active", autoplay: false);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          /*
          Rive Flutter is a runtime library for Rive,
          a real-time interactive design and animation tool.
          */
          Image.asset("assets/Backgrounds/Spline.png"),
          const RiveAnimation.asset("assets/RiveAssets/shapes.riv"),

          //------------------------Adding filter-------------------------------
          BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 15, sigmaY: 10),
            // This is wont be effected with blur.
            child: const SizedBox(),
          ),
          //--------------Other Content in the Welcome Page---------------------
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.only(top: 50, left: 10),
              child: Column(
                children: [
                  const Spacer(flex: 1),
                  const Text(
                    'GalactiCart',
                    style: TextStyle(
                      fontFamily: "Poppins",
                      fontSize: 40,
                      height: 1.5,
                    ),
                  ),
                  const SizedBox(
                    width: 250,
                    child: Padding(
                      padding: EdgeInsets.only(left: 5, top: 10),
                      child: Text(
                        'Welcome to GalactiCart, where the cosmic meets commerce! Embark on an interstellar shopping journey with our e-shop platform, offering a stellar array of products from across the universe.',
                      ),
                    ),
                  ),
                  const Spacer(flex: 6),
                  Column(
                    children: [
                      //----------Button for Login----------------
                      GestureDetector(
                        onTap: () {
                          _riveAnimationControllerONE.isActive = true;

                          Future.delayed(const Duration(milliseconds: 1000), () {
                            showGeneralDialog(
                              //when we press outside of the varrier it will automatically close
                              barrierDismissible: true,
                              barrierLabel: "sign In",
                              context: context,
                              pageBuilder: (context, __, _) =>
                                  const LoginDialog(),
                            );
                          });
                        },
                        child: SizedBox(
                          height: 70,
                          width: 200,
                          child: Stack(
                            children: [
                              RiveAnimation.asset(
                                "assets/RiveAssets/button.riv",
                                controllers: [_riveAnimationControllerONE],
                              ),
                              const Positioned.fill(
                                top: 6,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(Icons.login, size: 20),
                                    SizedBox(width: 5),
                                    Text('Click For Log In'),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      //----------------Button for Sign Up -----------------------
                      GestureDetector(
                        onTap: () {
                          _riveAnimationControllerTwo.isActive = true;
                          Future.delayed(const Duration(milliseconds: 1000), () {
                            showGeneralDialog(
                              //when we press outside of the varrier it will automatically close
                              barrierDismissible: true,
                              barrierLabel: "sign Up",
                              context: context,
                              pageBuilder: (context, __, _) =>
                                  const SignUpPage(),
                            );
                          });
                        },
                        child: SizedBox(
                          height: 70,
                          width: 200,
                          child: Stack(
                            children: [
                              RiveAnimation.asset(
                                "assets/RiveAssets/button.riv",
                                controllers: [_riveAnimationControllerTwo],
                              ),
                              Positioned.fill(
                                top: 6,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Image.asset(
                                      "assets/icons/sign_up.png",
                                      height: 20,
                                      width: 20,
                                    ),
                                    const SizedBox(width: 5),
                                    const Text('Click For Sign Up'),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  const Spacer(flex: 3),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
