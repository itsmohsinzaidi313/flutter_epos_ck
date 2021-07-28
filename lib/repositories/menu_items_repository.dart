import 'package:flutter/material.dart';
import 'package:pos_app/models/objects/item.dart';

class MenuItemRepo {
  static MenuItemRepo repo = MenuItemRepo._internal();
  MenuItemRepo._internal();
  Future<List<Item>> allItems() async => [];

  Future<List<Item>> searchItems({@required String phrase}) async =>[];
}
