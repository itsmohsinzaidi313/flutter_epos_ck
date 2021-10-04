import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart';
import 'package:pos_app/models/objects/menu.dart';
import 'package:pos_app/models/objects/menu_item.dart';
import 'package:pos_app/shared/app_library.dart';
import 'package:pos_app/shared/config.dart';

class MenuRepo {
  static MenuRepo repo = MenuRepo._internal();
  MenuRepo._internal();

  Response _menuCache;
  Future<Response> getMenu() async {
    try {
      if (_menuCache == null || _menuCache.statusCode != HttpStatus.ok || true)
        _menuCache = await get('${await Config.getMenuApi}&phrase=*').timeout(
            Duration(seconds: Config.SERVER_TIMEOUT),
            onTimeout: () => Lib.timeOutResponse);
      return _menuCache;
    } catch (e) {
      return Lib.httpErrorResponseHandler(error: e, caller: 'MenuRepo');
    }
  }

  Future<List<MenuItem>> searchItems({@required String phrase}) async {
    if (_menuCache == null) {
      _menuCache = await getMenu();
    }

    Menu menu = Menu.fromJson(jsonDecode(_menuCache.body));
    if (int.tryParse(phrase) == null) {
      return menu.items
          .where((element) => element.name.contains(phrase))
          .toList();
    } else {
      return menu.items.where((element) => element.code == phrase).toList();
    }
  }
}
