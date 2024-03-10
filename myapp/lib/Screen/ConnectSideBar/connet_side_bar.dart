import 'dart:math';

import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:myapp/Constant/constanvalue.dart';
import 'package:myapp/Screen/add_product/add_new_product.dart';
import 'package:myapp/Screen/cart/shoping_cart.dart';
import 'package:myapp/Screen/home/home.dart';
import 'package:myapp/Screen/favourtire/favourite.dart';
import 'package:myapp/Screen/profile/user_Profile.dart';
import 'package:myapp/Screen/sidebar/sidebar.dart';

class ConnectSideBarAndMenuBar extends StatefulWidget {
  const ConnectSideBarAndMenuBar({super.key, required this.initialIndex});
  final int initialIndex;
  @override
  State<ConnectSideBarAndMenuBar> createState() =>
      _ConnectSideBarAndMenuBarState();
}

class _ConnectSideBarAndMenuBarState extends State<ConnectSideBarAndMenuBar>
    with SingleTickerProviderStateMixin {
  bool isshowSideBar = false;
  late AnimationController _controller;
  late Animation<double> _animation;
  late NavigationController nb;
  late ChangeAppBarTitleName ct;
  String appBarTitle = "";
  @override
  void initState() {
    _controller = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 200))
      ..addListener(() {
        setState(() {});
      });
    _animation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _controller, curve: Curves.fastOutSlowIn),
    );
    setState(() {
      nb = NavigationController(widget.initialIndex);
      ct = ChangeAppBarTitleName(widget.initialIndex);
      appBarTitle = ct.appBarName(nb.selectedIndex);
    });
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        //--------------sidebar--------------------
        const AnimatedPositioned(
          duration: Duration(microseconds: 300),
          curve: Curves.fastOutSlowIn,
          child: SideBar(),
        ),
        //-------- Other code-----------------
        Transform(
          alignment: Alignment.center,
          transform: Matrix4.identity()
            ..setEntry(3, 2, 0.001)
            ..rotateY(_animation.value - 30 * _animation.value * pi / 180),
          child: Transform.translate(
            offset: Offset(_animation.value * 280, 0),
            child: Transform.scale(
              scale: 1,
              child: ClipRRect(
                child: Scaffold(
                  //----------------------App Bar -----------------------------
                  appBar: AppBar(
                    backgroundColor: const Color.fromARGB(255, 2, 5, 37),
                    automaticallyImplyLeading: false,
                    leading: const Text(""),
                    //--------------------------- Middle part of the app bar ------------------------
                    title: Center(
                      child: Text(
                        appBarTitle,
                        style: const TextStyle(
                          fontFamily: "Poppins",
                          fontSize: 25,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  //---------------------------- Body of the Scaffold --------------
                  body: Stack(
                    children: [
                      nb.screens[nb.selectedIndex],
                    ],
                  ),
                  //---------------------- Bottom Navigation Bar ----------------------
                  bottomNavigationBar: NavigationBar(
                    height: 80,
                    elevation: 10.0,
                    shadowColor: Colors.yellow,
                    indicatorColor: Colors.white54,
                    backgroundColor: const Color.fromARGB(255, 2, 5, 37),
                    selectedIndex: nb.selectedIndex,
                    onDestinationSelected: (value) {
                      setState(() {
                        nb.selectedIndex = value;
                        appBarTitle = ct.appBarName(nb.selectedIndex);
                      });
                    },
                    labelBehavior:
                        NavigationDestinationLabelBehavior.onlyShowSelected,
                    destinations: [
                      //----------------------HOME----------------

                      const NavigationDestination(
                        icon: Icon(
                          Iconsax.home,
                          color: Colors.white,
                        ),
                        label: "",
                        selectedIcon: Icon(
                          Iconsax.home_25,
                          color: Color.fromARGB(255, 2, 5, 37),
                        ),
                      ),
                      //----------------------Cart----------------
                      const NavigationDestination(
                        icon: Icon(
                          Iconsax.shopping_cart,
                          color: Colors.white,
                        ),
                        label: "",
                        selectedIcon: Icon(
                          Iconsax.shopping_cart5,
                          color: Color.fromARGB(255, 2, 5, 37),
                        ),
                      ),
                      //----------------------Favourite Product ----------------
                      const NavigationDestination(
                          icon: Icon(
                            Iconsax.favorite_chart,
                            color: Colors.white,
                          ),
                          selectedIcon: Icon(
                            Iconsax.favorite_chart5,
                            color: Color.fromARGB(255, 2, 5, 37),
                          ),
                          label: ""),
                      //----------------------Add a New Product ----------------
                      const NavigationDestination(
                          icon: Icon(
                            Iconsax.add_circle,
                            color: Colors.white,
                          ),
                          selectedIcon: Icon(
                            Iconsax.add_circle5,
                            color: Color.fromARGB(255, 2, 5, 37),
                          ),
                          label: ""),
                      //----------------------User Profile ----------------
                      NavigationDestination(
                        icon: const Icon(
                          Iconsax.profile_circle,
                          color: Colors.white,
                        ),
                        label: "",
                        selectedIcon: Icon(
                          Iconsax.profile_circle5,
                          color: ConstantColor.appbarBottombar,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
        // __________________For stack last in fast out_________________________
        //------------------------Icon Button---------------------------------
        Positioned(
          left: isshowSideBar ? 220 : 0,
          top: isshowSideBar ? 55 : 35,
          child: IconButton(
            icon: Icon(
              isshowSideBar ? Icons.close : Icons.sort,
              color: Colors.white,
            ),
            onPressed: () {
              Future.delayed(const Duration(milliseconds: 300));
              setState(() {
                isshowSideBar = !isshowSideBar;
                if (isshowSideBar) {
                  _controller.forward();
                } else {
                  _controller.reverse();
                }
              });
            },
          ),
        ),
      ],
    );
  }
}

// ________________________ Control the screen  ____________________________

class NavigationController {
  late int selectedIndex;
  NavigationController(int x) {
    selectedIndex = x;
  }

  final screens = const [
    HOMETWO(), //0
    SoppingCart(), //1
    FavouriteScreen(), //2
    AddNewProduct(), //3
    UserProfile(), //4
  ];
}

class ChangeAppBarTitleName {
  late int n;
  ChangeAppBarTitleName(int x) {
    n = x;
  }
  String appBarName(n) {
    switch (n) {
      case 0:
        return "Galacticart";

      case 1:
        return "Cart";

      case 2:
        return "Favourite Items";

      case 3:
        return "Add New Product";
      case 4:
        return "Profile";

      default:
        return "Galacticart";
    }
  }
}
