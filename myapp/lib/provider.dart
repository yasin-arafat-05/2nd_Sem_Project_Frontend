import 'package:flutter/material.dart';
import 'package:myapp/Screen/cart/cart_items_back.dart';
import 'package:myapp/Screen/favourtire/get_favourite_product.dart';
import 'package:myapp/Screen/home/best_selling_back.dart';
import 'package:myapp/Screen/home/categories_back.dart';
import 'package:myapp/Screen/LogIn/user_profile_back.dart';

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
    var productIndex =
        bestProduct.indexWhere((element) => element['id'] == productId);
    if (productIndex != -1) {
      bestProduct[productIndex]['favourite'] = isFavorite;
      notifyListeners();
    }
  }

  //________ When any user update the cart status of a product ___________
  void updateCartStatus(int productId, bool inCart) {
    var productIndex =
        bestProduct.indexWhere((element) => element['id'] == productId);
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
  late List<dynamic> cartProduct;
  Future<void> getCartProductList() async {
    GetCartItems getCartItems = GetCartItems();
    cartProduct = await getCartItems.getCartItems();
    notifyListeners();
  }
}
