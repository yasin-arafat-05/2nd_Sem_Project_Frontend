// ignore_for_file: avoid_print

import 'dart:convert';

import '../../ip_address.dart';
import 'package:http/http.dart' as http;

class GetCartItems {
  Future<List<dynamic>> getCartItems() async {
    try {
      String url = "http://${IP.ip}/get/cart/product";

      var response = await http.get(Uri.parse(url));
      var product = await jsonDecode(response.body);
      return product["User All Product"];
    } catch (e) {
      print("excption in cart_items_back.dart: $e");
      throw Exception(e.toString());
    }
  }
}
