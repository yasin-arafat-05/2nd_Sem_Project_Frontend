// ignore_for_file: avoid_print

import 'dart:io';

import '../../ip_address.dart';
import '../../token_handling.dart';
import 'package:http/http.dart' as http;

class UploadProductImage {
  Future<void> uploadProductImage(int id, File imageFile) async {
    String url = "http://${IP.ip}/product/picture/$id";
    final Uri finalUri = Uri.parse(url);
    var token = await TokenHandiling().getAccessToken();
    try {
      var request = http.MultipartRequest("POST", finalUri);
      request.headers['Content-Type'] = 'multipart/form-data';
      request.headers['Authorization'] = 'Bearer $token';
      //add the image to the request:
      request.files.add(
        await http.MultipartFile.fromPath('file', imageFile.path),
      );
      //send the request:
      var response = await request.send();
      if (response.statusCode == 200) {
        print("image uploaded successfully");
      } else {
        print("image uploaded failed ");
      }
    } catch (e) {
      print("exception in product_pic_back: $e");
    }
  }
}
