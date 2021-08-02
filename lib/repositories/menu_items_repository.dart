import 'package:flutter/material.dart';
import 'package:pos_app/database/local_database.dart';
import 'package:pos_app/database/tables/database_tables.dart';
import 'package:pos_app/models/menu_item.dart';

class MenuItemRepo {
  static MenuItemRepo repo = MenuItemRepo._internal();
  MenuItemRepo._internal();
  Future<List<MenuItem>> allItems() async {
    final db = await LocalDatabase.database.getDatabase();
    final list = (await db.query(ItemTable.TABLE_NAME)) ?? [];
    final items = list.map((e) => MenuItem.fromMap(e)).toList();
    return items;
  }

  Future<List<MenuItem>> searchItems({@required String phrase}) async {
    final items = await allItems();
    return items.where((element) => element.name.contains(phrase)).toList();
  }
}
