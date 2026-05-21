// ignore_for_file: avoid_print

import 'dart:convert';
import '../../ip_address.dart';
import '../../token_handling.dart';
import 'package:http/http.dart' as http;

class LoadChatMessageTitleBack {
  Future<List<dynamic>> getMsgTitle() async {
    print("loadchatmessagetitleback");
    var token = await TokenHandiling.instance.getAccessToken();
    String url = "http://${IP.ip}/chat/title";
    try {
      Map<String, String> headers = {
        'Content-Type': 'application/json',
        'Authorization': 'bearer $token',
      };
      final response = await http.get(Uri.parse(url), headers: headers);
      // print(response.body);
      // print(response.statusCode);
      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        return data;
      } else {
        print('Failed to fetch data ${response.statusCode}');
        return [];
      }
    } catch (e) {
      print('Error while fetch conversation title data: $e');
    }
    return [];
  }
}
