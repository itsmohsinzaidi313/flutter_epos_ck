class MenuItem {
  static const String _IdKey = 'Id',
      _CodeKey = 'Code',
      _CatIdKey = 'CategoryId',
      _NameKey = 'Name',
      _PriceKey = 'Price',
      _TaxAmountKey = 'TaxAmount',
      _QuantityKey = 'Quantity',
      _CommentKey = 'Comment',
      _ImageKey = 'image';
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
      : id = map[_IdKey],
        code = map[_CodeKey],
        categoryId = map[_CatIdKey],
        name = map[_NameKey],
        price = map[_PriceKey],
        taxAmount = map[_TaxAmountKey],
        quantity = double.parse(map[_QuantityKey]),
        image = map[_ImageKey];

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

  Map<String, dynamic> toMap() => {
        _IdKey: id,
        _CodeKey: code,
        _CatIdKey: categoryId,
        _NameKey: name,
        _PriceKey: price,
        _TaxAmountKey: taxAmount,
        _QuantityKey: quantity,
        _CommentKey: comment ?? '',
      };
}
