import 'package:flutter/material.dart';
import 'package:pos_app/shared/config.dart';
import 'package:http/http.dart';
import 'package:pos_app/models/server_response.dart';

class MenuItemRepo {
  static MenuItemRepo repo = MenuItemRepo._internal();
  MenuItemRepo._internal();
  Future<ServerResponse> allItems() async => ServerResponse(
      response: await get('${await Config.getItemsApi}?phrase=*').timeout(
          Duration(seconds: Config.SERVER_TIMEOUT),
          onTimeout: () => null));

  Future<ServerResponse> searchItems({@required String phrase}) async =>
      ServerResponse(
          response: await get('${await Config.getItemsApi}?phrase=$phrase')
              .timeout(Duration(seconds: Config.SERVER_TIMEOUT),
                  onTimeout: () => null));
}
