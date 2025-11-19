// ignore_for_file: avoid_print, non_constant_identifier_names

import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../ip_address.dart';
import '../../token_handling.dart';

class Chat {
  static Future<String> sendMessage(String message, String checkpointId) async {
    var res = await TokenHandiling.instance.getAccessToken();

    try {
      // Validate message is not empty
      if (message.trim().isEmpty) {
        print('Error: Message is empty');
        return '{"error": "Message cannot be empty"}';
      }

      // Prepare headers with the access token
      Map<String, String> headers = {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $res',
      };

      // Your chat data - preserve original message (only trim for validation)
      String finalMessage = message.trim();
      Map<String, dynamic> chatData = {"message": finalMessage};

      // Only add checkpoint_id if it's not empty
      if (checkpointId.isNotEmpty) {
        chatData["checkpoint_id"] = checkpointId;
      } else {
        chatData["checkpoint_id"] = "";
      }

      // Debug: Print what we're sending
      print('Sending chat request:');
      print('Message: ${chatData["message"]}');
      print('Checkpoint ID: ${chatData["checkpoint_id"]}');
      print('JSON Body: ${jsonEncode(chatData)}');

      // Make authenticated request
      var response = await http.post(
        Uri.parse('http://${IP.ip}/chat'),
        headers: headers,
        body: jsonEncode(chatData),
      );

      // Debug: Print response
      print('Response status code: ${response.statusCode}');
      print('Response body: ${response.body}');

      // Check the response
      if (response.statusCode == 200 || response.statusCode == 201) {
        // Message sent successfully
        print('Message sent successfully');
        return response.body;
      } else {
        // Handle error
        print('Error sending message: ${response.statusCode}');
        print('Response body: ${response.body}');
        return response.body;
      }
    } catch (e) {
      // Handle exceptions
      print('Error: $e');
      return e.toString();
    }
  }
}
