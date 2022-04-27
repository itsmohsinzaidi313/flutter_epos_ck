import 'package:flutter/material.dart';
import 'package:pos_app/shared/app_library.dart';
import 'package:pos_app/shared/config.dart';
import 'package:http/http.dart';

class LoginRepo {
  static LoginRepo repo = LoginRepo._internal();
  LoginRepo._internal();
  Future<Response> login(
          {@required String username, @required String password}) async =>
      await get(
              '${Config.getLoginApi}&username=$username&password=$password&deviceId=${(await Config.deviceData).androidId}')
          .timeout(Duration(seconds: Config.SERVER_TIMEOUT),
              onTimeout: () => Lib.timeout)
          .onError((error, stackTrace) =>
              Lib.httpErrorResponseHandler(error: error));
}
