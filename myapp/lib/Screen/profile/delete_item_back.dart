import 'package:http/http.dart' as http;
import 'package:myapp/ip_address.dart';
import 'package:myapp/token_handling.dart';

class DeleteProduct {
  Future<String> deleteProduct(int id) async {
    String url = "http://${IP.ip}/delete/product/{$id}?product_id=$id";
    var token = await TokenHandiling.instance.getAccessToken();
    try {
      Map<String, String> headers = {
        'content-type': 'application/json',
        'Authorization': 'bearer $token'
      };
      var response = await http.delete(Uri.parse(url), headers: headers);
      if (response.statusCode == 200) {
        return response.body;
      } else {
        return response.body;
      }
    } catch (e) {
      return e.toString();
    }
  }
}
