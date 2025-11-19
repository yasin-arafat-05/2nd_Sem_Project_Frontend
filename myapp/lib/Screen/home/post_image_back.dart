// ignore_for_file: avoid_print

import 'dart:io';
import 'package:http/http.dart' as http;
import '../../ip_address.dart';
import '../../token_handling.dart';

class UploadImage {
  Future<String> uploadImage(File imageFile) async {
    final Uri apiUrl =
        Uri.parse('http://${IP.ip}/uploadfile/profile');

    //------------------get token---------------------
    var res = await TokenHandiling.instance.getAccessToken();

    // Create a multipart request
    var request = http.MultipartRequest('POST', apiUrl);

    // Set the headers
    request.headers['Content-Type'] = 'multipart/form-data';

    request.headers['Authorization'] = 'Bearer $res';

    // Add the image to the request
    request.files.add(
      await http.MultipartFile.fromPath(
        'file',
        imageFile.path,
      ),
    );

    try {
      // Send the request
      var response = await request.send();

      // Check the status code of the response
      if (response.statusCode == 200) {
        print('Image uploaded successfully : ${response.statusCode}');
        return await response.stream.bytesToString();
      } else {
        print('Failed to upload image. Status code: ${response.statusCode}');
        print('Response body: ${await response.stream.bytesToString()}');
        return await response.stream.bytesToString();
      }
    } catch (error) {
      print('Error uploading image: $error');
      return error.toString();
    }
  }
}
