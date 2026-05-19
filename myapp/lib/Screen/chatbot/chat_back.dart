// ignore_for_file: avoid_print, non_constant_identifier_names

import 'dart:convert';
import '../../ip_address.dart';
import '../../token_handling.dart';
import "package:dio/dio.dart";

class Chat {
  static Stream<Map<String, dynamic>> sendMessage(
    String message,
    String checkpointId,
  ) async* {
    var token = await TokenHandiling.instance.getAccessToken();

    if (message.trim().isEmpty) {
      yield {'type': 'error', 'content': 'Message cannot be empty'};
      return;
    }

    final dio = Dio(
      BaseOptions(
        baseUrl: 'http://${IP.ip}',
        connectTimeout: const Duration(minutes: 5),
        receiveTimeout: const Duration(minutes: 5),
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'text/event-stream',
          'Content-Type': 'application/json',
        },
      ),
    );

    try {
      final response = await dio.post(
        '/chat',
        data: {'message': message.trim(), 'checkpoint_id': checkpointId},
        options: Options(responseType: ResponseType.stream),
      );

      // ⬇️ ResponseBody থেকে stream নাও
      final responseBody = response.data as ResponseBody;

      // ⬇️ Uint8List → String (utf8.decoder সরাসরি চলবে কারণ Uint8List implements List<int>)
      await for (final chunk in responseBody.stream) {
        final text = utf8.decode(chunk);

        for (final line in text.split('\n')) {
          final trimmed = line.trim();
          if (trimmed.startsWith('data: ')) {
            final jsonStr = trimmed.substring(6).trim();
            if (jsonStr.isEmpty) continue;

            try {
              final data = jsonDecode(jsonStr) as Map<String, dynamic>;
              yield data;

              if (data['type'] == 'end' || data['type'] == 'error') {
                return;
              }
            } catch (_) {
              continue;
            }
          }
        }
      }
    } on DioException catch (e) {
      // Connection close হলে ignore করো (SSE normal behavior)
      if (e.type == DioExceptionType.cancel ||
          e.type == DioExceptionType.connectionError ||
          (e.message != null && e.message!.contains('closed'))) {
        print('Stream ended normally');
        return;
      }
      yield {'type': 'error', 'content': e.toString()};
    } catch (e) {
      yield {'type': 'error', 'content': e.toString()};
    }
  }
}
