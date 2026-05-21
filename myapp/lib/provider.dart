// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:myapp/Screen/ConnectSideBar/load_chat_message_title_back.dart';
import 'Screen/cart/cart_items_back.dart';
import 'Screen/favourtire/get_favourite_product.dart';
import 'Screen/home/best_selling_back.dart';
import 'Screen/home/categories_back.dart';
import 'Screen/LogIn/user_profile_back.dart';

class CategoriesProvider extends ChangeNotifier {
  // আমরা যদি একে empty বা late হিসেবে declear না করি তাইলে
  // state management এ ঝামেলা হবে ।
  // কারণ আমরা যখন কোন কিছু directly database থেকে
  // delete করে hot reload করবো তখন আমার list এর মধ্যে
  // আগে যে value গুলো ছিল সেইগুলো থাকবে সাথে সাথে নতুন
  // fetch করা ডাটা গুলোও আড হবে ।

  late List<dynamic> categories;
  Future<void> categoriesData() async {
    CategoriesData getCategory = CategoriesData();
    Future<List<dynamic>> list = getCategory.Categories();
    categories = await list;
    notifyListeners();
  }
}

class BestSellingProvider extends ChangeNotifier {
  late List<dynamic> bestProduct;

  Future<void> bestProductData() async {
    BestSelling getBestSelling = BestSelling();
    Future<List<dynamic>> finalList = getBestSelling.bestSelling();
    bestProduct = await finalList;
    notifyListeners();
  }

  //___________ when any user update the favourite product _____________________
  void updateFavoriteStatus(int productId, bool isFavorite) {
    var productIndex = bestProduct.indexWhere(
      (element) => element['id'] == productId,
    );
    if (productIndex != -1) {
      bestProduct[productIndex]['favourite'] = isFavorite;
      notifyListeners();
    }
  }

  //________ When any user update the cart status of a product ___________
  void updateCartStatus(int productId, bool inCart) {
    var productIndex = bestProduct.indexWhere(
      (element) => element['id'] == productId,
    );
    if (productIndex != -1) {
      bestProduct[productIndex]['cart'] = inCart;
      notifyListeners();
    }
  }
}

class ProfileProvider extends ChangeNotifier {
  late Map<String, dynamic> currentUser;
  late Map<String, dynamic> businessUser;
  late List<dynamic> allProduct;

  Future<void> profileData() async {
    UserProfileBack getUserProfile = UserProfileBack();
    var getData = getUserProfile.GetUserData();
    var tempStoreage = await getData;

    currentUser = tempStoreage['Current User Information'];
    businessUser = tempStoreage['Business Information'];
    allProduct = tempStoreage['User All Product'];

    notifyListeners();
  }
}

class FavouriteProductProvider extends ChangeNotifier {
  late List<dynamic> favouriteProduct;
  Future<void> getFavouriteProduct() async {
    GetFavouriteItem gt = GetFavouriteItem();
    favouriteProduct = await gt.getFavouriteItem();
    notifyListeners();
  }
}

class CartProductProvider extends ChangeNotifier {
  List<dynamic> cartProduct = [];
  bool isloading = false;

  Future<void> getCartProductList() async {
    // tells the ui loading started
    isloading = true;
    notifyListeners();
    try {
      GetCartItems getCartItems = GetCartItems();
      cartProduct = await getCartItems.getCartItems();
    } catch (e) {
      print("Error fetching cart: $e");
    } finally {
      // data comes successfully tell the dart build the screen
      isloading = false;
      notifyListeners();
    }
  }
}

// Notifier for chatting message title:
// extends -> inheritence:
class ChatMessageTitle extends ChangeNotifier {
  List<dynamic> mgsTitle = [];
  bool isloading = false;
  Future<void> getMessageTitle() async {
    isloading = true;
    notifyListeners();
    try {
      LoadChatMessageTitleBack lc = LoadChatMessageTitleBack();
      mgsTitle = await lc.getMsgTitle();
      // print(mgsTitle);
    } catch (e) {
      print("error in ChatMessageTitle Provider: $e");
    } finally {
      isloading = false;
      notifyListeners();
    }
  }
}
