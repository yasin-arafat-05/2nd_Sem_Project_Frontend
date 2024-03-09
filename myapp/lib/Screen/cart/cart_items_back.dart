// ignore_for_file: avoid_print

import 'dart:convert';

import 'package:myapp/ip_address.dart';
import 'package:http/http.dart' as http;
import 'package:myapp/token_handling.dart';

class GetCartItems {
  Future<List<dynamic>> getCartItems() async {
    try {
      String url = "http://${IP.ip}/get/cart/product";
      var token = await TokenHandiling.instance.getAccessToken();
      Map<String, String> header = {
        'content-type': 'application/json',
        'Authorization': 'bearer $token'
      };
      var response = await http.get(Uri.parse(url), headers: header);
      var product = await jsonDecode(response.body);
      return product["User All Product"];
    } catch (e) {
      print("excption in cart_items_back.dart: $e");
      throw Exception(e.toString());
    }
  }
}
