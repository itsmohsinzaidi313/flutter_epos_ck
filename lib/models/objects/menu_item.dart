import 'dart:convert';

import 'package:equatable/equatable.dart';

class MenuItem {
  static const String IdKey = 'Id';
  static const String CatIdKey = 'CategoryId';
  static const String NameKey = 'Name';
  static const String PriceKey = 'Price';
  static const String TaxPriceKey = 'TaxPrice';
  static const String QuantityKey = 'Quantity';
  static const String ImageKey = 'image';

  final String id, categoryId, name, price, taxPrice, image;
  double quantity;

  String comment;

  MenuItem(
      {this.id,
      this.categoryId,
      this.name,
      this.price,
      this.taxPrice,
      this.quantity,
      this.image});

  MenuItem.fromJson(Map<String, dynamic> map)
      : id = map[IdKey],
        categoryId = map[CatIdKey],
        name = map[NameKey],
        price = map[PriceKey],
        taxPrice = map[TaxPriceKey],
        quantity = double.parse(map[QuantityKey]),
        image = map[ImageKey];

  MenuItem.fromItem(MenuItem item)
      : id = item.id,
        categoryId = item.categoryId,
        name = item.name,
        price = item.price,
        taxPrice = item.taxPrice,
        quantity = 1,
        image = item.image,
        comment = item.comment;

  String toJson() => {
        jsonEncode(IdKey): jsonEncode(id),
        jsonEncode(CatIdKey): jsonEncode(categoryId),
        jsonEncode(NameKey): jsonEncode(name),
        jsonEncode(PriceKey): jsonEncode(price),
        jsonEncode(QuantityKey): jsonEncode(quantity)
      }.toString();
}
