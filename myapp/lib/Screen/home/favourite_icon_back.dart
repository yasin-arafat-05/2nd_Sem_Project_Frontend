// ignore_for_file: avoid_print

import 'package:myapp/ip_address.dart';
import 'package:http/http.dart' as http;
import 'package:myapp/provider.dart';
import 'package:myapp/token_handling.dart';

class Favourite {
  final BestSellingProvider bestSellingProvider;
  Favourite(this.bestSellingProvider);
  //_______________ To In Favourite Item ______________________
  Future<void> addToFavourite(int id) async {
    try {
      var token = await TokenHandiling().getAccessToken();
      String url = "http://${IP.ip}/add/to/favourite?id=$id";
      Map<String, String> headers = {
        'content-type': 'application/json',
        'Authorization': 'bearer $token'
      };

      var response = await http.post(Uri.parse(url), headers: headers);
      bestSellingProvider.updateFavoriteStatus(id, true);
      print("favourite_back : ${response.body}");
    } catch (e) {
      print("favourite_back error: ${e.toString()}");
    }
  }

  //_______________ remove from favourite Item ______________________
  Future<void> removeFromFavourite(int id) async {
    try {
      var token = await TokenHandiling().getAccessToken();
      String url = "http://${IP.ip}/remove/from/favourite?id=$id";
      Map<String, String> headers = {
        'content-type': 'application/json',
        'Authorization': 'bearer $token'
      };
      var response = await http.post(Uri.parse(url), headers: headers);
      bestSellingProvider.updateFavoriteStatus(id, false);
      print("favourite_back : ${response.body}");
    } catch (e) {
      print("favourite_back error: ${e.toString()}");
    }
  }
}
