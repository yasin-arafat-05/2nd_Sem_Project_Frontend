import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:myapp/ip_address.dart';

class CategoriesData {
  // ignore: non_constant_identifier_names
  Future<List<dynamic>> Categories() async {
    const url = "http://${IP.ip}/Categorie";

    final response = await http.get(Uri.parse(url));

    Map<String, dynamic> k = jsonDecode(response.body);
    // ignore: avoid_print
    print('categories fetch from data base done');
    return k['Categories'];
  }
}
