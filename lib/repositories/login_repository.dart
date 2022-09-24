import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:pos_app/shared/app_library.dart';
import 'package:pos_app/shared/config.dart';
import 'package:http/http.dart';

class LoginRepo {
  static LoginRepo repo = LoginRepo._internal();
  LoginRepo._internal();
  Future<Response> login(
      {required String? username, required String? password}) async => await get(
            Uri.parse(
                '${Config.getLoginApi}&username=$username&password=$password&deviceId=${(await Config.deviceData)!.androidId}'),
            headers: {
          HttpHeaders.authorizationHeader:
              'Basic ${base64Encode(utf8.encode('$username:$password'))}'
        })
        .timeout(Duration(seconds: Config.SERVER_TIMEOUT),
            onTimeout: () => Lib.timeout)
        .onError((dynamic error, stackTrace) =>
            Lib.httpErrorResponseHandler(error: error));
}
