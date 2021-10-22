import 'dart:developer';

import 'package:equatable/equatable.dart';
import 'package:pos_app/models/item.dart';

class MenuItem extends Item with EquatableMixin {
  MenuItem({
    String id,
    String code,
    String categoryId,
    String name,
    double price,
    double taxAmount,
    double quantity,
    String image,
    String comment,
    bool selected,
  }) : super(
            id: id,
            code: code,
            categoryId: categoryId,
            name: name,
            price: price,
            taxAmount: taxAmount,
            quantity: quantity,
            image: image,
            comment: comment,
            selected: selected);

  MenuItem.fromMap(Map<String, dynamic> map)
      : super(
            id: map[Item.IdKey],
            code: map[Item.CodeKey],
            categoryId: map[Item.CatIdKey],
            name: map[Item.NameKey],
            price: map[Item.PriceKey],
            taxAmount: map[Item.TaxAmountKey],
            quantity: map[Item.QuantityKey],
            image: map[Item.ImageKey],
            selected: map[Item.SelectedKey],
            comment: map[Item.CommentKey]);

  MenuItem.fromMenuItem(MenuItem item)
      : super(
            id: item.id,
            categoryId: item.categoryId,
            code: item.code,
            name: item.name,
            price: item.price,
            quantity: item.quantity,
            comment: item.comment,
            image: item.image,
            selected: item.selected,
            taxAmount: item.taxAmount);

  Map<String, dynamic> toMap() => {
        Item.IdKey: id,
        Item.CodeKey: code,
        Item.CatIdKey: categoryId,
        Item.NameKey: name,
        Item.PriceKey: price,
        Item.TaxAmountKey: taxAmount,
        Item.QuantityKey: quantity,
        Item.ImageKey: image,
        Item.SelectedKey: selected,
        Item.CommentKey: comment,
      };

  @override
  List<Object> get props => [id];
}

class FixedDeal extends Item with EquatableMixin {
  static String _ItemsKey = 'Items';
  final List<Item> dealItems;

  FixedDeal(
      {String id,
      String code,
      String categoryId,
      String name,
      double price,
      double taxAmount,
      double quantity,
      String image,
      String comment,
      bool selected,
      this.dealItems})
      : super(
            id: id,
            code: code,
            categoryId: categoryId,
            name: name,
            price: price,
            taxAmount: taxAmount,
            quantity: quantity,
            image: image,
            comment: comment,
            selected: selected);

  FixedDeal.fromMap(Map<String, dynamic> map)
      : this.dealItems = (map[_ItemsKey] as List<dynamic>)
            .map((e) => Item.fromMap(e))
            .toList(),
        super(
            id: map[Item.IdKey],
            code: map[Item.CodeKey],
            categoryId: map[Item.CatIdKey],
            name: map[Item.NameKey],
            price: map[Item.PriceKey],
            taxAmount: map[Item.TaxAmountKey],
            quantity: map[Item.QuantityKey],
            image: map[Item.ImageKey],
            selected: map[Item.SelectedKey],
            comment: map[Item.CommentKey]);

  FixedDeal.fromDeal(FixedDeal deal)
      : dealItems = deal.dealItems,
        super(
            id: deal.id,
            categoryId: deal.categoryId,
            code: deal.code,
            name: deal.name,
            price: deal.price,
            quantity: deal.quantity,
            comment: deal.comment,
            image: deal.image,
            selected: deal.selected,
            taxAmount: deal.taxAmount);

  @override
  Map<String, dynamic> toMap() => {
        Item.IdKey: id,
        Item.CodeKey: code,
        Item.CatIdKey: categoryId,
        Item.NameKey: name,
        Item.TaxAmountKey: taxAmount,
        Item.PriceKey: price,
        Item.QuantityKey: quantity,
        Item.CommentKey: comment ?? '',
        Item.SelectedKey: selected,
        _ItemsKey: dealItems.map((e) => e.toMap()).toList(),
      };

  @override
  List<Object> get props => [id];
}

class OnSpotDeal extends Item with EquatableMixin {
  static const String _DealItemsKey = 'DealItems',
      _UniqueDealId = 'UniqueDealId';
  final String uniqueDealId;
  final List<OnSpotDealItem> dealItems;
  bool changeable = true;
  OnSpotDeal(
      {this.uniqueDealId = '',
      String id = '',
      String code = '',
      String categoryId = '',
      String name = '',
      double price = 0,
      double taxAmount = 0,
      double quantity = 0,
      String image = '',
      bool selected,
      this.dealItems})
      : super(
            id: id,
            code: code,
            categoryId: categoryId,
            name: name,
            price: price,
            taxAmount: taxAmount,
            quantity: quantity,
            image: image,
            selected: selected);

  OnSpotDeal.fromMap(Map<String, dynamic> map)
      : this.uniqueDealId = map[_UniqueDealId],
        this.dealItems = (map[_DealItemsKey] as List<dynamic>)
            .map((e) => OnSpotDealItem.fromMap(e))
            .toList(),
        super(
            id: map[Item.IdKey],
            code: map[Item.CodeKey],
            categoryId: map[Item.CatIdKey],
            name: map[Item.NameKey],
            price: map[Item.PriceKey],
            taxAmount: map[Item.TaxAmountKey],
            quantity: map[Item.QuantityKey],
            selected: map[Item.SelectedKey],
            comment: '',
            image: map[Item.ImageKey]);

  OnSpotDeal.fromOnSpotDeal(OnSpotDeal deal)
      : this.uniqueDealId = deal.uniqueDealId,
        this.dealItems = deal.dealItems,
        super(
            id: deal.id,
            code: deal.code,
            categoryId: deal.categoryId,
            name: deal.name,
            price: deal.price,
            quantity: deal.quantity,
            comment: deal.comment,
            image: deal.image,
            selected: deal.selected,
            taxAmount: deal.taxAmount);

  OnSpotDeal.newDeal(OnSpotDeal deal, List<OnSpotDealItem> items)
      : this.uniqueDealId = deal.uniqueDealId,
        this.dealItems = items,
        super(
            id: deal.id,
            code: deal.code,
            categoryId: deal.categoryId,
            name: deal.name,
            price: deal.price,
            quantity: deal.quantity,
            comment: deal.comment,
            image: deal.image,
            selected: deal.selected,
            taxAmount: deal.taxAmount);

  @override
  Map<String, dynamic> toMap() => {
        _UniqueDealId: uniqueDealId,
        Item.IdKey: id,
        Item.CodeKey: code,
        Item.CatIdKey: categoryId,
        Item.NameKey: name,
        Item.TaxAmountKey: taxAmount,
        Item.PriceKey: price,
        Item.QuantityKey: quantity,
        Item.CommentKey: comment ?? '',
        Item.SelectedKey: selected,
        _DealItemsKey: dealItems.map((e) => e.toMap()).toList(),
      };
  static String signature = '';

  @override
  List<Object> get props {
    signature = '';
    signature += id;
    signature += name;
    signature += dealItems.length.toString();
    for (var item in dealItems) {
      signature += item.id;
    }
    return [signature];
  }
}

class OnSpotDealItem extends Item with EquatableMixin {
  static const String _ChoiceKey = 'Choice';

  final double choice;

  OnSpotDealItem(
      {String id,
      String code,
      String categoryId,
      String name,
      double price,
      double taxAmount,
      double quantity,
      this.choice,
      String image,
      bool selected})
      : super(
            id: id,
            code: code,
            categoryId: categoryId,
            name: name,
            price: price,
            taxAmount: taxAmount,
            quantity: quantity,
            image: image,
            selected: selected);

  OnSpotDealItem.fromMap(Map<String, dynamic> map)
      : choice = map[_ChoiceKey],
        super(
          id: map[Item.IdKey],
          code: map[Item.CodeKey],
          categoryId: map[Item.CatIdKey],
          name: map[Item.NameKey],
          price: map[Item.PriceKey],
          taxAmount: map[Item.TaxAmountKey],
          quantity: map[Item.QuantityKey],
          selected: map[Item.SelectedKey],
          image: map[Item.ImageKey],
        );

  OnSpotDealItem.fromItem(OnSpotDealItem item)
      : this.choice = item.choice,
        super(
            id: item.id,
            code: item.code,
            categoryId: item.categoryId,
            name: item.name,
            price: item.price,
            taxAmount: item.taxAmount,
            quantity: 0,
            image: item.image,
            selected: item.selected);

  @override
  Map<String, dynamic> toMap() => {
        Item.IdKey: id,
        Item.CodeKey: code,
        Item.CatIdKey: categoryId,
        Item.NameKey: name,
        Item.PriceKey: price,
        Item.QuantityKey: quantity,
        Item.CommentKey: comment ?? '',
        _ChoiceKey: choice,
        Item.SelectedKey: selected,
      };

  @override
  List<Object> get props => [id, code, quantity];
}
