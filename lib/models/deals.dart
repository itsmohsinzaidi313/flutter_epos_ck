import 'package:pos_app/models/menu_item.dart';

class FixedDeal extends MenuItem {
  static const String _IdKey = 'Id',
      _CodeKey = 'Code',
      _CatIdKey = 'CategoryId',
      _NameKey = 'Name',
      _PriceKey = 'Price',
      _TaxAmountKey = 'TaxAmount',
      _QuantityKey = 'Quantity',
      _CommentKey = 'Comment',
      _ImageKey = 'Image',
      _ItemsKey = 'Items';

  final List<MenuItem> dealItems;

  FixedDeal(
      {String id,
      String code,
      String categoryId,
      String name,
      String price,
      String taxAmount,
      double quantity,
      String image,
      this.dealItems})
      : super(
            id: id,
            code: code,
            categoryId: categoryId,
            name: name,
            price: price,
            taxAmount: taxAmount,
            quantity: quantity,
            image: image);

  FixedDeal.fromMap(Map<String, dynamic> map)
      : this.dealItems = (map[_ItemsKey] as List<dynamic>)
            .map((e) => MenuItem.fromMap(e))
            .toList(),
        super(
            id: map[_IdKey],
            code: map[_CodeKey],
            categoryId: map[_CatIdKey],
            name: map[_NameKey],
            price: map[_PriceKey],
            taxAmount: map[_TaxAmountKey],
            quantity: double.parse(map[_QuantityKey]),
            image: map[_ImageKey]);

  @override
  Map<String, dynamic> toMap() => {
        _IdKey: id,
        _CodeKey: code,
        _CatIdKey: categoryId,
        _NameKey: name,
        _TaxAmountKey: taxAmount,
        _PriceKey: price,
        _QuantityKey: quantity,
        _CommentKey: comment ?? '',
        _ItemsKey: dealItems.map((e) => e.toMap()).toList(),
      };
}

class OnSpotDeals extends MenuItem {
  static const String _IdKey = 'Id',
      _CodeKey = 'Code',
      _CatIdKey = 'CategoryId',
      _NameKey = 'Name',
      _PriceKey = 'Price',
      _TaxAmountKey = 'TaxAmount',
      _QuantityKey = 'Quantity',
      _CommentKey = 'Comment',
      _ImageKey = 'Image',
      _ItemsKey = 'Items';

  final List<OnSpotDealItem> dealItems;

  OnSpotDeals(
      {String id,
      String code,
      String categoryId,
      String name,
      String price,
      String taxAmount,
      double quantity,
      String image,
      this.dealItems})
      : super(
            id: id,
            code: code,
            categoryId: categoryId,
            name: name,
            price: price,
            taxAmount: taxAmount,
            quantity: quantity,
            image: image);

  OnSpotDeals.fromMap(Map<String, dynamic> map)
      : this.dealItems = (map[_ItemsKey] as List<dynamic>)
            .map((e) => OnSpotDealItem.fromMap(e))
            .toList(),
        super(
            id: map[_IdKey],
            code: map[_CodeKey],
            categoryId: map[_CatIdKey],
            name: map[_NameKey],
            price: map[_PriceKey],
            taxAmount: map[_TaxAmountKey],
            quantity: double.parse(map[_QuantityKey]),
            image: map[_ImageKey]);

  @override
  Map<String, dynamic> toMap() => {
        _IdKey: id,
        _CodeKey: code,
        _CatIdKey: categoryId,
        _NameKey: name,
        _TaxAmountKey: taxAmount,
        _PriceKey: price,
        _QuantityKey: quantity,
        _CommentKey: comment ?? '',
        _ItemsKey: dealItems.map((e) => e.toMap()).toList(),
      };
}

class OnSpotDealItem extends MenuItem {
  static const String _IdKey = 'Id',
      _CodeKey = 'Code',
      _CatIdKey = 'CategoryId',
      _NameKey = 'Name',
      _PriceKey = 'Price',
      _TaxAmountKey = 'TaxAmount',
      _QuantityKey = 'Quantity',
      _CommentKey = 'Comment',
      _ImageKey = 'Image',
      _ChoiceKey = 'Choice';

  final double choice;

  OnSpotDealItem(
      {String id,
      String code,
      String categoryId,
      String name,
      String price,
      String taxAmount,
      double quantity,
      this.choice,
      String image})
      : super(
            id: id,
            code: code,
            categoryId: categoryId,
            name: name,
            price: price,
            taxAmount: taxAmount,
            quantity: quantity,
            image: image);

  OnSpotDealItem.fromMap(Map<String, dynamic> map)
      : choice = map[_ChoiceKey],
        super(
          id: map[_IdKey],
          code: map[_CodeKey],
          categoryId: map[_CatIdKey],
          name: map[_NameKey],
          price: map[_PriceKey],
          taxAmount: map[_TaxAmountKey],
          quantity: double.parse(map[_QuantityKey]),
          image: map[_ImageKey],
        );

  @override
  Map<String, dynamic> toMap() => {
        _IdKey: id,
        _CodeKey: code,
        _CatIdKey: categoryId,
        _NameKey: name,
        _PriceKey: price,
        _QuantityKey: quantity,
        _CommentKey: comment ?? '',
        _ChoiceKey: choice,
      };
}
