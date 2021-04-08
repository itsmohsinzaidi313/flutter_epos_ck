import 'package:flutter/material.dart';
import 'package:pos_app/shared/config.dart';
import 'package:http/http.dart';
import 'package:pos_app/models/objects/server_response.dart';

class WaiterRepo {
  static WaiterRepo repo = WaiterRepo._internal();
  String _url;
  WaiterRepo._internal() {
    _url = Config.getWaitersApi;
  }
  Future<ServerResponse> get waiters async => ServerResponse(
      response: await get('$_url').timeout(
          Duration(seconds: Config.SERVER_TIMEOUT),
          onTimeout: () => null));
}
