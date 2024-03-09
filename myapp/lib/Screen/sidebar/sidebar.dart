// ignore_for_file: camel_case_types

import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:myapp/Screen/ConnectSideBar/connet_side_bar.dart';
import 'package:myapp/Screen/WelcomePage/welcome.dart';
import 'package:myapp/ip_address.dart';
import 'package:myapp/provider.dart';
import 'package:myapp/token_handling.dart';
import 'package:provider/provider.dart';

class SideBar extends StatefulWidget {
  const SideBar({super.key});

  @override
  State<SideBar> createState() => _SideBarState();
}

class _SideBarState extends State<SideBar> {
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
      backgroundColor: Colors.transparent,
      body: FutureBuilder(
        future: _profileProvider.profileData(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          return SafeArea(
            child: Container(
              width: 290,
              height: double.infinity,
              color: const Color.fromARGB(255, 2, 5, 37),
              child: Column(
                children: [
                  const SizedBox(
                    height: 10,
                  ),
                  //---------Custom ListTile business name, name-----
                  custom_list_tile(
                    businessName:
                        _profileProvider.businessUser['Business Name'],
                    name: _profileProvider.currentUser['User Name'],
                    profileProvider: _profileProvider,
                  ),
                  //------------------Browser------------------
                  Padding(
                    padding: const EdgeInsets.only(left: 24, top: 32),
                    child: Text(
                      "Browser".toUpperCase(),
                      style: Theme.of(context)
                          .textTheme
                          .titleMedium!
                          .copyWith(color: Colors.white38),
                    ),
                  ),
                  const Divider(
                    color: Colors.white24,
                  ),
                  //----------------Home-----------------------

                  Column(
                    children: [
                      InkWell(
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) {
                                return const ConnectSideBarAndMenuBar(
                                    initialIndex: 0);
                              },
                            ),
                          );
                        },
                        child: const ListTile(
                          leading: SizedBox(
                            height: 34,
                            width: 34,
                            child: Icon(
                              Iconsax.home,
                              color: Colors.white,
                            ),
                          ),
                          title: Text(
                            "Home",
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: 250,
                        child: Divider(
                          color: Colors.white24,
                        ),
                      ),

                      //----------------Cart-----------------------
                      InkWell(
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) {
                                return const ConnectSideBarAndMenuBar(
                                    initialIndex: 1);
                              },
                            ),
                          );
                        },
                        child: const ListTile(
                          leading: SizedBox(
                            height: 34,
                            width: 34,
                            child: Icon(
                              Iconsax.shopping_cart,
                              color: Colors.white,
                            ),
                          ),
                          title: Text(
                            "Cart",
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: 250,
                        child: Divider(
                          color: Colors.white24,
                        ),
                      ),
                      //----------------add product-----------------------
                      InkWell(
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) {
                                return const ConnectSideBarAndMenuBar(
                                    initialIndex: 3);
                              },
                            ),
                          );
                        },
                        child: const ListTile(
                          leading: SizedBox(
                            height: 34,
                            width: 34,
                            child: Icon(
                              Iconsax.add_circle,
                              color: Colors.white,
                            ),
                          ),
                          title: Text(
                            "Add Product",
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: 250,
                        child: Divider(
                          color: Colors.white24,
                        ),
                      ),
                      //----------------favourites-----------------------
                      InkWell(
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) {
                                return const ConnectSideBarAndMenuBar(
                                    initialIndex: 2);
                              },
                            ),
                          );
                        },
                        child: const ListTile(
                          leading: SizedBox(
                            height: 34,
                            width: 34,
                            child: Icon(
                              Iconsax.favorite_chart,
                              color: Colors.white,
                            ),
                          ),
                          title: Text(
                            "Favourites",
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  //----------------User-----------------------
                  Padding(
                    padding: const EdgeInsets.only(left: 24, top: 32),
                    child: Text(
                      "User".toUpperCase(),
                      style: Theme.of(context)
                          .textTheme
                          .titleMedium!
                          .copyWith(color: Colors.white38),
                    ),
                  ),
                  const Divider(
                    color: Colors.white24,
                  ),
                  //-------------------Profile---------------
                  InkWell(
                    hoverColor: Colors.white,
                    splashColor: Colors.white,
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) {
                            return const ConnectSideBarAndMenuBar(
                                initialIndex: 4);
                          },
                        ),
                      );
                    },
                    child: const ListTile(
                      leading: SizedBox(
                        height: 34,
                        width: 34,
                        child: Icon(
                          Iconsax.profile_circle,
                          color: Colors.white,
                        ),
                      ),
                      title: Text(
                        "Profile",
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 250,
                    child: Divider(
                      color: Colors.white24,
                    ),
                  ),
                  //-------------------Logout---------------
                  InkWell(
                    onTap: () {
                      TokenHandiling.instance.clearAccessToken();
                      Navigator.of(context).pushAndRemoveUntil(
                        MaterialPageRoute(
                          builder: (context) {
                            return const Welcome();
                          },
                        ),
                        (route) => false,
                      );
                    },
                    splashColor: Colors.white,
                    child: const ListTile(
                      leading: SizedBox(
                        height: 34,
                        width: 34,
                        child: Icon(
                          Iconsax.logout,
                          color: Colors.white,
                        ),
                      ),
                      title: Text(
                        "Logout",
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class custom_list_tile extends StatelessWidget {
  const custom_list_tile({
    super.key,
    required this.businessName,
    required this.name,
    required this.profileProvider,
  });
  final String name;
  final String businessName;
  final ProfileProvider profileProvider;
  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
        backgroundImage: NetworkImage(
            'http://${IP.ip}/images/${profileProvider.businessUser['Business Image']}'),
      ),
      title: Text(
        name,
        style: const TextStyle(color: Colors.white),
      ),
      subtitle: Text(
        businessName,
        style: const TextStyle(color: Colors.white),
      ),
    );
  }
}

//__________________________Class Menu______________________________________
class Menu {
  final String title;
  final IconData iconData;

  Menu({required this.title, required this.iconData});
}
