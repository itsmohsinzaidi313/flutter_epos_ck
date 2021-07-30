class MenuItem {
  static const String IdKey = 'Id';
  static const String CodeKey = 'Code';
  static const String CatIdKey = 'CategoryId';
  static const String NameKey = 'Name';
  static const String PriceKey = 'Price';
  static const String TaxAmountKey = 'TaxAmount';
  static const String QuantityKey = 'Quantity';
  static const String CommentKey = 'Comment';
  static const String ImageKey = 'image';
  static const int OPENFOOD_CODE = 151605140604;

  final String id, code, categoryId, name, price, taxAmount, image;
  double quantity;

  String comment;

  MenuItem(
      {this.id,
      this.code,
      this.categoryId,
      this.name,
      this.price,
      this.taxAmount,
      this.quantity,
      this.image});

  MenuItem.fromMap(Map<String, dynamic> map)
      : id = map[IdKey],
        code = map[CodeKey],
        categoryId = map[CatIdKey],
        name = map[NameKey],
        price = map[PriceKey],
        taxAmount = map[TaxAmountKey],
        quantity = double.parse(map[QuantityKey]),
        image = map[ImageKey];

  MenuItem.fromItem(MenuItem item)
      : id = item.id,
        code = item.code,
        categoryId = item.categoryId,
        name = item.name,
        price = item.price,
        taxAmount = item.taxAmount,
        quantity = item.quantity ?? 1,
        image = item.image,
        comment = item.comment;

  Map<String, dynamic> toJson() => {
        IdKey: id,
        CodeKey: code,
        CatIdKey: categoryId,
        NameKey: name,
        PriceKey: price,
        QuantityKey: quantity,
        CommentKey: comment,
      };
}
