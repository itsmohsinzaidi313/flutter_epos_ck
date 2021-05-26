import 'dart:developer';

import 'package:pos_app/shared/config.dart';
import 'package:http/http.dart';
import 'package:pos_app/models/objects/server_response.dart';

class WaiterRepo {
  static WaiterRepo repo = WaiterRepo._internal();
  WaiterRepo._internal();
  Future<ServerResponse> get waiters async => ServerResponse(
      response: await get(await Config.getWaitersApi).timeout(
          Duration(seconds: Config.SERVER_TIMEOUT),
          onTimeout: () => null));
}
