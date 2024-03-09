// ignore_for_file: avoid_print, non_constant_identifier_names

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:myapp/ip_address.dart';
import 'package:myapp/token_handling.dart';

class AddProduct {
  static Future<String> addProduct(String name, String category, int org_price,
      int new_price, String pdetails, String date) async {
    var res = await TokenHandiling.instance.getAccessToken();

    /*
      In the context of HTTP (Hypertext Transfer Protocol), a header is a 
      component of an HTTP request or response that provides metadata about 
      the message being sent or received.

      Request Headers:

      Authorization: Used to include credentials or tokens for authentication.

      Content-Type: Specifies the media type of the resource sent to the 
      server (e.g., 'application/json' for JSON data).

      Accept: Informs the server about the types of media that the client can process.
    */
    try {
      // Prepare headers with the access token
      Map<String, String> headers = {
        'Content-Type': 'application/json',
        'Authorization': 'bearer $res',
      };

      // Your product data
      Map<String, dynamic> productData = {
        "name": name,
        "category": category,
        "original_price": org_price,
        "new_price": new_price,
        "product_details": pdetails,
        "offer_expiration_date": date
      };

      // Make authenticated request in body get information
      var response = await http.post(
        Uri.parse('http://${IP.ip}/upload/product'),
        headers: headers,
        body: jsonEncode(productData),
      );

      // Check the response
      if (response.statusCode == 200) {
        // Product added successfully
        print('Product added successfully');
        return response.body;
      } else {
        // Handle error
        print('Error adding product: ${response.statusCode}');
        return response.body;
      }
    } catch (e) {
      // Handle exceptions
      print('Error: $e');
      return e.toString();
    }
  }
}
