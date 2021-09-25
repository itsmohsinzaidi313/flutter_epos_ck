import 'dart:io';

import 'package:flutter/material.dart';
import 'package:pos_app/shared/config.dart';
import 'package:http/http.dart';

class LoginRepo {
  static LoginRepo repo = LoginRepo._internal();
  LoginRepo._internal();
  Future<Response> login(
          {@required String username, @required String password}) async =>
      await get(
              '${await Config.getLoginApi}&username=$username&password=$password')
          .timeout(Duration(seconds: Config.SERVER_TIMEOUT),
              onTimeout: () => null);
}
