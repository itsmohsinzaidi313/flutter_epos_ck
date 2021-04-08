import 'package:flutter/material.dart';
import 'package:pos_app/shared/config.dart';
import 'package:http/http.dart';
import 'package:pos_app/models/objects/server_response.dart';

class LoginRepo {
  static LoginRepo repo = LoginRepo._internal();
  String _url;
  LoginRepo._internal() {
    _url = Config.getLoginApi;
  }
  Future<ServerResponse> login({@required String username, @required String password}) async => ServerResponse(
      response: await get('$_url?username=$username&password=$password')
          .timeout(Duration(seconds: Config.SERVER_TIMEOUT), onTimeout: () => null));
}
