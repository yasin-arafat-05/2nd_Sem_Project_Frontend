import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:myapp/ip_address.dart';

class BestSelling {
  Future<List<dynamic>> bestSelling() async {
    const url = "http://${IP.ip}/bestSelling";
    final res = await http.get(Uri.parse(url));
    Map<String, dynamic> ret = jsonDecode(res.body);
    return ret['Categories'];
  }
}
