import 'package:flutter/material.dart';
import 'package:get_mac/get_mac.dart';
import 'package:pos_app/shared/config.dart';
import 'package:http/http.dart';
import 'package:pos_app/models/objects/server_response.dart';

class LoginRepo {
  static LoginRepo repo = LoginRepo._internal();
  LoginRepo._internal();
  Future<ServerResponse> login(
          {@required String username, @required String password}) async =>
      ServerResponse(
          response: await get(
                  '${await Config.getLoginApi}?username=$username&password=$password&mac=${await GetMac.macAddress}')
              .timeout(Duration(seconds: Config.SERVER_TIMEOUT),
                  onTimeout: () => null));
}
