import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../ip_address.dart';

class SignUpWithBackend {
  Future<String> registrationUser(
      String username, String email, String password) async {
    final Uri registrationURL = Uri.parse('http://${IP.ip}/registration');

    final Map<String, String> registrationData = {
      'username': username,
      'email': email,
      'password': password,
    };

    final response = await http.post(
      registrationURL,
      headers: {'Content-Type': 'application/json'},
      body: json.encode(registrationData),
    );

    if (response.statusCode == 201) {
      return (response.body);
    } else {
      return (response.body);
    }
  }
}
