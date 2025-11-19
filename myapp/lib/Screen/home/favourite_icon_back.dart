// ignore_for_file: avoid_print

import '../../ip_address.dart';
import 'package:http/http.dart' as http;
import '../../provider.dart';

class Favourite {
  final BestSellingProvider bestSellingProvider;
  Favourite(this.bestSellingProvider);
  //_______________ To In Favourite Item ______________________
  Future<void> addToFavourite(int id) async {
    try {
      String url = "http://${IP.ip}/add/to/favourite?id=$id";

      var response = await http.post(Uri.parse(url));
      bestSellingProvider.updateFavoriteStatus(id, true);
      print("favourite_back : ${response.body}");
    } catch (e) {
      print("favourite_back error: ${e.toString()}");
    }
  }

  //_______________ remove from favourite Item ______________________
  Future<void> removeFromFavourite(int id) async {
    try {
      String url = "http://${IP.ip}/remove/from/favourite?id=$id";

      var response = await http.post(Uri.parse(url));
      bestSellingProvider.updateFavoriteStatus(id, false);
      print("favourite_back : ${response.body}");
    } catch (e) {
      print("favourite_back error: ${e.toString()}");
    }
  }
}
