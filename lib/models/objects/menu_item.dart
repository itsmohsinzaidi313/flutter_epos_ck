class MenuItem {
  static const String IdKey = 'Id';
  static const String CodeKey = 'Code';
  static const String CatIdKey = 'CategoryId';
  static const String NameKey = 'Name';
  static const String PriceKey = 'Price';
  static const String TaxAmountKey = 'TaxAmount';
  static const String QuantityKey = 'Quantity';
  static const String CommentKey = 'Comment';

  final String id, code, categoryId, name, price, taxAmount;
  double quantity;

  String comment;

  MenuItem(
      {this.id,
      this.code,
      this.categoryId,
      this.name,
      this.price,
      this.taxAmount,
      this.quantity});

  MenuItem.fromJson(Map<String, dynamic> map)
      : id = map[IdKey],
        code = map[CodeKey],
        categoryId = map[CatIdKey],
        name = map[NameKey],
        price = map[PriceKey],
        taxAmount = map[TaxAmountKey],
        quantity = double.parse(map[QuantityKey]);

  MenuItem.fromItem(MenuItem item)
      : id = item.id,
        code = item.code,
        categoryId = item.categoryId,
        name = item.name,
        price = item.price,
        taxAmount = item.taxAmount,
        quantity = item.quantity ?? 1,
        comment = item.comment;

  Map<String, dynamic> toMap() => {
        IdKey: id,
        CodeKey: code,
        CatIdKey: categoryId,
        NameKey: name,
        PriceKey: price,
        QuantityKey: quantity,
        CommentKey: comment ?? '',
      };
}
