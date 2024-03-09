// ignore_for_file: avoid_print

import 'dart:convert';

import 'package:myapp/ip_address.dart';
import 'package:myapp/token_handling.dart';
import 'package:http/http.dart' as http;

class GetFavouriteItem {
  Future<List<dynamic>> getFavouriteItem() async {
    var token = await TokenHandiling().getAccessToken();
    String url = "http://${IP.ip}/get/fav/product";
    Map<String, String> header = {
      'content-type': 'application/json',
      'Authorization': 'bearer $token'
    };
    try {
      var respone = await http.get(Uri.parse(url), headers: header);
      var res = jsonDecode(respone.body);
      return res["User All Product"] ?? [];
    } catch (e) {
      print("exception in get_favourite_product.dart : $e");
      throw Exception(e.toString());
    }
  }
}
