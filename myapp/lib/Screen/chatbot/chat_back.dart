// ignore_for_file: avoid_print, non_constant_identifier_names
import 'dart:convert';
import '../../ip_address.dart';
import '../../token_handling.dart';
import "package:dio/dio.dart";

class Chat {
  static Dio _buildDio(String token) {
    return Dio(
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
  }

  // Common stream parser for ui message —:
  static Stream<Map<String, dynamic>> _parseStream(
    ResponseBody responseBody,
  ) async* {
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
            if (data['type'] == 'end' || data['type'] == 'error') return;
          } catch (_) {
            continue;
          }
        }
      }
    }
  }

  // ===================================================
  //  Send the user message to the bot
  static Stream<Map<String, dynamic>> sendMessage(
    String message,
    String checkpointId,
    String workflowType,
  ) async* {
    if (message.trim().isEmpty) {
      yield {'type': 'error', 'content': 'Message cannot be empty'};
      return;
    }

    var token = await TokenHandiling.instance.getAccessToken();
    final dio = _buildDio(token!);

    try {
      final response = await dio.post(
        '/chat',
        data: {
          'message': message.trim(),
          'checkpoint_id': checkpointId,
          'workflow_type': workflowType,
          'resume_data': null,
        },
        options: Options(responseType: ResponseType.stream),
      );
      yield* _parseStream(response.data as ResponseBody);
    } on DioException catch (e) {
      if (e.type == DioExceptionType.cancel ||
          e.type == DioExceptionType.connectionError ||
          (e.message != null && e.message!.contains('closed'))) {
        return;
      }
      yield {'type': 'error', 'content': e.toString()};
    } catch (e) {
      yield {'type': 'error', 'content': e.toString()};
      print("error from yield data: $e");
    }
  }

  // =========================================
  //  Generic resume — interrupt handling code
  static Stream<Map<String, dynamic>> resume(
    String checkpointId,
    String workflowType,
    Map<String, dynamic> resumeData,
  ) async* {
    var token = await TokenHandiling.instance.getAccessToken();
    final dio = _buildDio(token!);

    try {
      final response = await dio.post(
        '/chat',
        data: {
          'message': '',
          'checkpoint_id': checkpointId,
          'workflow_type': workflowType,
          'resume_data': resumeData,
        },
        options: Options(responseType: ResponseType.stream),
      );
      print("================resume class success===================");
      yield* _parseStream(response.data as ResponseBody);
    } on DioException catch (e) {
      if (e.type == DioExceptionType.cancel ||
          e.type == DioExceptionType.connectionError ||
          (e.message != null && e.message!.contains('closed'))) {
        return;
      }
      yield {'type': 'error', 'content': e.toString()};
    } catch (e) {
      yield {'type': 'error', 'content': e.toString()};
    }
  }
}
