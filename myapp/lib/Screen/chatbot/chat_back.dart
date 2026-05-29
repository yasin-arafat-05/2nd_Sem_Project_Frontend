// ignore_for_file: avoid_print, non_constant_identifier_names
import 'dart:convert';
import '../../ip_address.dart';
import '../../token_handling.dart';
import "package:dio/dio.dart";

class Chat {
  static Stream<Map<String, dynamic>> sendMessage(
    String message,
    String checkpointId,
    String workflowType,
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
        data: {
          'message': message.trim(),
          'checkpoint_id': checkpointId,
          'workflow_type': workflowType,
        },
        options: Options(responseType: ResponseType.stream),
      );

      final responseBody = response.data as ResponseBody;

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

              // ✅ end বা error আসলে stream বন্ধ
              if (data['type'] == 'end' || data['type'] == 'error') {
                return;
              }
            } catch (e) {
              print(e);
              continue;
            }
          }
        }
      }
    } on DioException catch (e) {
      if (e.type == DioExceptionType.cancel ||
          e.type == DioExceptionType.connectionError ||
          (e.message != null && e.message!.contains('closed'))) {
        print('Stream ended normally: $Expando');
        return;
      }
      yield {'type': 'error', 'content': e.toString()};
    } catch (e) {
      print(e);
      yield {'type': 'error', 'content': e.toString()};
    }
  }

  // ✅ Location resume এর জন্য আলাদা method
  static Stream<Map<String, dynamic>> resumeWithLocation(
    String checkpointId,
    double lat,
    double long,
    String workflowType,
  ) async* {
    var token = await TokenHandiling.instance.getAccessToken();

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
        data: {
          'message': '', // resume এ message লাগে না
          'checkpoint_id': checkpointId,
          'workflow_type': workflowType,
          'is_location_resume': true, // ✅ backend জানবে এটা resume
          'user_lat': lat,
          'user_long': long,
        },
        options: Options(responseType: ResponseType.stream),
      );

      final responseBody = response.data as ResponseBody;

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
