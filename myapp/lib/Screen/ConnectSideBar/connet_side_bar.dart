// ignore_for_file: avoid_print

import 'dart:math';

import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:provider/provider.dart';
import '../../Constant/constanvalue.dart';
import '../../provider.dart';
import '../add_product/add_new_product.dart';
import '../cart/shoping_cart.dart';
import '../home/home.dart';
import '../favourtire/favourite.dart';
import '../profile/user_Profile.dart';
import '../sidebar/sidebar.dart';
import '../chatbot/add_token.dart';
import '../chatbot/chat.dart';

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
    _controller =
        AnimationController(
          vsync: this,
          duration: const Duration(milliseconds: 200),
        )..addListener(() {
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
                  body: Stack(children: [nb.screens[nb.selectedIndex]]),
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
                        icon: Icon(Iconsax.home, color: Colors.white),
                        label: "",
                        selectedIcon: Icon(
                          Iconsax.home_25,
                          color: Color.fromARGB(255, 2, 5, 37),
                        ),
                      ),
                      //----------------------Cart----------------
                      const NavigationDestination(
                        icon: Icon(Iconsax.shopping_cart, color: Colors.white),
                        label: "",
                        selectedIcon: Icon(
                          Iconsax.shopping_cart5,
                          color: Color.fromARGB(255, 2, 5, 37),
                        ),
                      ),
                      //----------------------Favourite Product ----------------
                      const NavigationDestination(
                        icon: Icon(Iconsax.favorite_chart, color: Colors.white),
                        selectedIcon: Icon(
                          Iconsax.favorite_chart5,
                          color: Color.fromARGB(255, 2, 5, 37),
                        ),
                        label: "",
                      ),
                      //----------------------Add a New Product ----------------
                      const NavigationDestination(
                        icon: Icon(Iconsax.add_circle, color: Colors.white),
                        selectedIcon: Icon(
                          Iconsax.add_circle5,
                          color: Color.fromARGB(255, 2, 5, 37),
                        ),
                        label: "",
                      ),
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
  String appBarName(int n) {
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

// ________________________ Chatbot Wrapper (without navbar selection)  ____________________________

class ChatbotWrapper extends StatefulWidget {
  const ChatbotWrapper({super.key, required this.pageType});
  final String pageType; // 'add_token' or 'chat'

  @override
  State<ChatbotWrapper> createState() => _ChatbotWrapperState();
}

class _ChatbotWrapperState extends State<ChatbotWrapper>
    with SingleTickerProviderStateMixin {
  bool isshowSideBar = false;
  late AnimationController _controller;
  late Animation<double> _animation;
  int? _selectedConversationId;

  @override
  void initState() {
    _controller =
        AnimationController(
          vsync: this,
          duration: const Duration(milliseconds: 200),
        )..addListener(() {
          setState(() {});
        });
    _animation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _controller, curve: Curves.fastOutSlowIn),
    );
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  String getAppBarTitle() {
    if (widget.pageType == 'add_token') {
      return "Add Token";
    } else if (widget.pageType == 'chat') {
      return "Chat";
    }
    return "Chatbot";
  }

  Widget getPage() {
    if (widget.pageType == 'add_token') {
      return const AddTokenPage();
    } else if (widget.pageType == 'chat') {
      return ChatPage(conversationId: _selectedConversationId);
    }
    return const Center(child: Text("Page not found"));
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        //--------------sidebar(Left)--------------------
        const AnimatedPositioned(
          duration: Duration(milliseconds: 300),
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
                  //------------------------ Chat History Drawer ---------------------
                  endDrawer: widget.pageType == 'chat'
                      ? ChatHistoryDrawer(
                          onConversationSelected: (convId) {
                            setState(() {
                              _selectedConversationId = convId;
                            });
                            Navigator.pop(context);
                          },
                        )
                      : null,
                  //---------------------- App Bar -----------------------------
                  appBar: AppBar(
                    backgroundColor: const Color.fromARGB(255, 2, 5, 37),
                    automaticallyImplyLeading: false,
                    leading: const Text(""),
                    title: Center(
                      child: Text(
                        getAppBarTitle(),
                        style: const TextStyle(
                          fontFamily: "Poppins",
                          fontSize: 25,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  //---------------------------- Body of the Scaffold --------------
                  body: getPage(),
                ),
              ),
            ),
          ),
        ),
        // __________________For stack last in fast out_________________________
        Positioned(
          left: isshowSideBar ? 220 : 0,
          top: isshowSideBar ? 55 : 35,
          child: IconButton(
            icon: Icon(
              isshowSideBar ? Icons.close : Icons.sort,
              color: Colors.white,
            ),
            onPressed: () {
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

// ------------------Drawer for chat history----------------------------
class ChatHistoryDrawer extends StatefulWidget {
  final Function(int) onConversationSelected;
  const ChatHistoryDrawer({super.key, required this.onConversationSelected});
  @override
  State<ChatHistoryDrawer> createState() => _ChatHistoryDrawerState();
}

class _ChatHistoryDrawerState extends State<ChatHistoryDrawer> {
  @override
  void initState() {
    super.initState();

    /*
    Hey Provider, don't run towards the API just yet! Wait for Flutter to finish 
    drawing the initial loading screen first. Once the first frame is fully rendered on screen, 
    only then call the function to fetch data.
    */
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<ChatMessageTitle>(context, listen: false).getMessageTitle();
    });
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.98,
      child: Drawer(
        backgroundColor: const Color.fromARGB(255, 2, 5, 37),
        child: SafeArea(
          child: Column(
            children: [
              const DrawerHeader(
                child: Center(
                  child: Text(
                    'C H A T   H I S T O R Y',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      fontFamily: "Poppins",
                      color: Colors.white70,
                    ),
                  ),
                ),
              ),
              // use a consumer to show the real time data:
              Expanded(
                child: Consumer<ChatMessageTitle>(
                  builder: (context, provider, child) {
                    // while loading show the circlar indecator
                    if (provider.isloading) {
                      return const Center(
                        child: CircularProgressIndicator(color: Colors.white54),
                      );
                    }
                    // load data:
                    final chatHistoryList = provider.mgsTitle;
                    // print(chatHistoryList);
                    // check if the list is empty:
                    if (chatHistoryList.isEmpty) {
                      return const Center(
                        child: Text(
                          "No ChAt HiStOrY Is FOunD.",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.white54,
                          ),
                        ),
                      );
                    }

                    // now return the actual meslist:
                    return ListView.builder(
                      itemCount: chatHistoryList.length,
                      itemBuilder: (context, index) {
                        // for every invidual data
                        final chatItem = chatHistoryList[index];
                        return Container(
                          margin: const EdgeInsets.symmetric(
                            horizontal: 14,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.04),
                            borderRadius: BorderRadius.circular(12.0),
                            border: Border.all(
                              color: Colors.white.withValues(alpha: 0.08),
                              width: 1,
                            ),
                          ),
                          child: ListTile(
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 14,
                              vertical: 2,
                            ),
                            leading: Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: Colors.blueAccent.withValues(
                                  alpha: 0.12,
                                ),
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.chat_bubble_outline_rounded,
                                color: Colors.blueAccent,
                                size: 18,
                              ),
                            ),
                            title: Text(
                              chatItem["title"] ?? 'Untitled Chat',
                              style: const TextStyle(
                                color: Colors.white,
                                fontFamily: "Poppins",
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            trailing: Icon(
                              Icons.arrow_forward_ios_rounded,
                              color: Colors.white.withValues(alpha: 0.2),
                              size: 12,
                            ),
                            onTap: () {
                              //print(chatItem);
                              int convId = chatItem['converation_id'];
                              //print(convId);
                              // LoadChatMsgForThreadIdBack lm =
                              //     LoadChatMsgForThreadIdBack();
                              // final data = lm.getConvMsg(convId);
                              // print('Tapped Thread ID: $data');
                              widget.onConversationSelected(convId);
                            },
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
