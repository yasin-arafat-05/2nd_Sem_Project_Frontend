// ignore_for_file: avoid_print

import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class TokenHandiling {
  final FlutterSecureStorage _storage = const FlutterSecureStorage();
  static TokenHandiling instance = TokenHandiling(); 
  //-----Get the Token---------
  Future<void> storeAccessToken(String accessToken) async {
    await _storage.write(key: 'access_token', value: accessToken);
    print('Access token stored successfully');
  }

  //-------Retive access token--------------
  Future<String?> getAccessToken() async {
    return await _storage.read(key: 'access_token');
  }

  //--------------Log out-----------------------
  Future<void> clearAccessToken() async {
    await _storage.delete(key: 'access_token');
    print('Access token cleared');
  }

  //------------------------Check the expration time----------------------------
  // ------------- --------- ----------- --------- --------- -----
  // ------------- --------- ----------- --------- --------- -----
  // ------------- --------- ----------- --------- --------- -----
  // ------------- --------- ----------- --------- --------- -----
  // ------------- --------- ----------- --------- --------- -----
  // ------------- --------- ----------- --------- --------- -----
  //-------------------------Can't Complete-----------------------
}
