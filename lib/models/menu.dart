import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:pos_app/models/deals.dart';
import 'package:pos_app/models/items_category.dart';
import 'package:pos_app/models/item.dart';
import 'package:pos_app/repositories/menu_repository.dart';

class POSMenu extends ChangeNotifier {
  List<Category> listCategories = [];
  List<Item> listItems = [];

  POSMenu({
    this.listCategories,
    this.listItems,
  });

  POSMenu.fromMap(dynamic i) {
    listCategories = (i['Categories'] as List<dynamic>)
        .map((e) => Category.fromJson(e))
        .toList();
    listCategories.first.selected = true;
    final items =
        (i['Items'] as List<dynamic>).map((e) => MenuItem.fromMap(e)).toList();
    final listFixedDeals = (i['FixedDeals'] as List<dynamic>)
        .map((e) => FixedDeal.fromMap(e))
        .toList();
    final listOnSpotDeals = (i['OnSpotDeals'] as List<dynamic>)
        .map((e) => OnSpotDeal.fromMap(e))
        .toList();
    listItems.addAll(items);
    listItems.addAll(listFixedDeals);
    listItems.addAll(listOnSpotDeals);

    for (var category in listCategories) {
      for (var item in listItems) {
        if (item.categoryId == category.id) {
          category.items.add(item);
        }
      }
    }
    notifyListeners();
  }

  Future<void> fetchMenu() async {
    Response response = await MenuRepo.repo.getMenu();
    if (response.statusCode == HttpStatus.ok) {
      dynamic i = jsonDecode(response.body);
      listCategories = (i['Categories'] as List<dynamic>)
          .map((e) => Category.fromJson(e))
          .toList();
      listCategories.first.selected = true;
      final items = (i['Items'] as List<dynamic>)
          .map((e) => MenuItem.fromMap(e))
          .toList();
      final listFixedDeals = (i['FixedDeals'] as List<dynamic>)
          .map((e) => FixedDeal.fromMap(e))
          .toList();
      final listOnSpotDeals = (i['OnSpotDeals'] as List<dynamic>)
          .map((e) => OnSpotDeal.fromMap(e))
          .toList();
      listItems.addAll(items);
      listItems.addAll(listFixedDeals);
      listItems.addAll(listOnSpotDeals);

      for (var category in listCategories) {
        for (var item in listItems) {
          if (item.categoryId == category.id) {
            category.items.add(item);
          }
        }
      }
      notifyListeners();
    }
  }

  List<Item> getSelectedCategoryItems() {
    final category =
        listCategories.where((element) => element.selected).toList().first;

    List<Item> list = [];
    for (var item in listItems) {
      if (item.categoryId == category.id) {
        list.add(item);
      }
    }
    return list;
  }

  void setSelectedCategory(Category category) {
    for (var item in listCategories) {
      if (item.id == category.id) {
        item.selected = true;
      } else {
        item.selected = false;
      }
    }
    notifyListeners();
  }
}
