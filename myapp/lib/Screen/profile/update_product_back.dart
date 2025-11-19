import 'dart:convert';

import '../../ip_address.dart';
import '../../token_handling.dart';
import 'package:http/http.dart' as http;

class UpdateSingleProduct {
  Future<String> updateSingleProduct(
      int id,
      String name,
      String category,
      String productDetails,
      String expirationDate,
      double orginalPrice,
      double newPrice) async {
    try {
      var token = await TokenHandiling.instance.getAccessToken();
      String url = "http://${IP.ip}/update/product/$id?id=$id";

      Map<String, dynamic> updateData = {
        "name": name,
        "category": category,
        "product_details": productDetails,
        "original_price": orginalPrice,
        "new_price": newPrice,
        "offer_expiration_date": expirationDate
      };
      Map<String, String> headers = {
        'content-type': 'application/json',
        'Authorization': 'bearer $token'
      };
      var response = await http.put(Uri.parse(url),
          headers: headers, body: jsonEncode(updateData));
      if (response.statusCode == 200) {
        return response.body;
      }
    } catch (e) {
      return e.toString();
    }
    return "DURBOL VAI";
  }
}
