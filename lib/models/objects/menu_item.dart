class MenuItem {
  static const String IdKey = 'Id';
  static const String CatIdKey = 'CategoryId';
  static const String NameKey = 'Name';
  static const String PriceKey = 'Price';
  static const String TaxAmountKey = 'TaxAmount';
  static const String QuantityKey = 'Quantity';
  static const String ImageKey = 'image';

  final String id, categoryId, name, price, taxAmount, image;
  double quantity;

  String comment;

  MenuItem(
      {this.id,
      this.categoryId,
      this.name,
      this.price,
      this.taxAmount,
      this.quantity,
      this.image});

  MenuItem.fromJson(Map<String, dynamic> map)
      : id = map[IdKey],
        categoryId = map[CatIdKey],
        name = map[NameKey],
        price = map[PriceKey],
        taxAmount = map[TaxAmountKey],
        quantity = double.parse(map[QuantityKey]),
        image = map[ImageKey];

  MenuItem.fromItem(MenuItem item)
      : id = item.id,
        categoryId = item.categoryId,
        name = item.name,
        price = item.price,
        taxAmount = item.taxAmount,
        quantity = 1,
        image = item.image,
        comment = item.comment;

  Map<String, dynamic> toJson() => {
        IdKey: id,
        CatIdKey: categoryId,
        NameKey: name,
        PriceKey: price,
        QuantityKey: quantity
      };
}
