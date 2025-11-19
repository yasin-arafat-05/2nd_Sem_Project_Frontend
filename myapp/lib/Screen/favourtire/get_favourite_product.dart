// ignore_for_file: avoid_print

import 'dart:convert';

import '../../ip_address.dart';
import 'package:http/http.dart' as http;

class GetFavouriteItem {
  Future<List<dynamic>> getFavouriteItem() async {
    String url = "http://${IP.ip}/get/fav/product";

    try {
      var respone = await http.get(Uri.parse(url));
      var res = jsonDecode(respone.body);
      return res["User All Product"] ?? [];
    } catch (e) {
      print("exception in get_favourite_product.dart : $e");
      throw Exception(e.toString());
    }
  }
}
