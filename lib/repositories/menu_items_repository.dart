import 'package:flutter/material.dart';
import 'package:pos_app/models/menu_item.dart';

class MenuItemRepo {
  static MenuItemRepo repo = MenuItemRepo._internal();
  MenuItemRepo._internal();
  Future<List<MenuItem>> allItems() async => [];

  Future<List<MenuItem>> searchItems({@required String phrase}) async => [];
}
