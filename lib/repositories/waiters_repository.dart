import 'dart:developer';

import 'package:pos_app/shared/app_library.dart';
import 'package:pos_app/shared/config.dart';
import 'package:http/http.dart';

class WaiterRepo {
  static WaiterRepo repo = WaiterRepo._internal();
  WaiterRepo._internal();
  Future<Response> getWaiters() async => await get(await Config.getWaitersApi)
      .timeout(Duration(seconds: Config.SERVER_TIMEOUT),
          onTimeout: () => Lib.timeout)
      .onError(
          (error, stackTrace) => Lib.httpErrorHandler(error: error));
}
