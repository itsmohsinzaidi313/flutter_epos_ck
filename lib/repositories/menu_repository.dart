import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:http/http.dart';
import 'package:pos_app/models/menu_item.dart';
import 'package:pos_app/shared/app_library.dart';
import 'package:pos_app/shared/config.dart';

class MenuRepo {
  static MenuRepo repo = MenuRepo._internal();
  MenuRepo._internal();

  static Response _menuResponseCache;
  Future<Response> getMenu() async {
    if (_menuResponseCache == null ||
        _menuResponseCache.statusCode != HttpStatus.ok)
      return await get('${await Config.getMenuApi}&phrase=*').timeout(
          Duration(seconds: Config.SERVER_TIMEOUT),
          onTimeout: () => Lib.timeout);
    else
      return _menuResponseCache;
  }

  Future<List<MenuItem>> searchItems(String phrase) async {
    final response = await getMenu();
    if (response.statusCode == HttpStatus.ok) {
      return ((jsonDecode(response.body) as Map<String, dynamic>)['Items']
                  as List<dynamic>)
              .where((element) => element['Name']
                  .toString()
                  .toLowerCase()
                  .contains(phrase.toLowerCase()))
              .map((e) => MenuItem.fromJson(e))
              .toList() ??
          <MenuItem>[];
    } else {
      return <MenuItem>[];
    }
  }
}
