import 'package:flutter/material.dart';
import 'package:pos_app/shared/config.dart';
import 'package:http/http.dart';
import 'package:pos_app/models/objects/server_response.dart';

class MenuItemRepo {
  static MenuItemRepo repo = MenuItemRepo._internal();
  String _url;
  MenuItemRepo._internal() {
    _url = Config.getItemsApi;
  }
  Future<ServerResponse> get allItems async => ServerResponse(
      response: await get('$_url?phrase').timeout(
          Duration(seconds: Config.SERVER_TIMEOUT),
          onTimeout: () => null));

  Future<ServerResponse> searchItems({@required String phrase}) async =>
      ServerResponse(
          response: await get('$_url?phrase=$phrase').timeout(
              Duration(seconds: Config.SERVER_TIMEOUT),
              onTimeout: () => null));
}
