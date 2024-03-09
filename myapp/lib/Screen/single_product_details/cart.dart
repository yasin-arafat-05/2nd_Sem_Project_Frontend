// ignore_for_file: avoid_print

import 'package:http/http.dart' as http;
import 'package:myapp/ip_address.dart';
import 'package:myapp/provider.dart';
import 'package:myapp/token_handling.dart';

class Cart {
  final BestSellingProvider bestSellingProvider;
  Cart(this.bestSellingProvider);
//_____________ Add product to cart ___________
  Future<void> addToCart(int id) async {
    try {
      var token = await TokenHandiling.instance.getAccessToken();
      String url = "http://${IP.ip}/add/to/cart?id=$id";
      Map<String, String> headers = {
        'content-type': 'application/json',
        'Authorization': 'bearer $token'
      };
      var response = await http.post(Uri.parse(url), headers: headers);
      bestSellingProvider.updateCartStatus(id, true);
      print("cart.dart: ${response.body}");
    } catch (e) {
      print("Exception is cart.dart file : $e");
    }
  }

  //_________________ Remove From cart ________________
  Future<void> removeFromCart(int id) async {
    try {
      var token = await TokenHandiling.instance.getAccessToken();
      String url = "http://${IP.ip}/remove/from/cart?id=$id";
      Map<String, String> headers = {
        'content-type': 'application/json',
        'Authorization': 'bearer $token'
      };
      var response = await http.post(Uri.parse(url), headers: headers);
      bestSellingProvider.updateCartStatus(id, false);
      print("cart.dart: ${response.body}");
    } catch (e) {
      print("Exception is cart.dart file : $e");
    }
  }
}
