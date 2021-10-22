class Item {
  static const String IdKey = 'Id',
      CodeKey = 'Code',
      CatIdKey = 'CategoryId',
      NameKey = 'Name',
      PriceKey = 'Price',
      TaxAmountKey = 'TaxAmount',
      QuantityKey = 'Quantity',
      CommentKey = 'Comment',
      ImageKey = 'image',
      SelectedKey = 'Selected';
  static const int OPENFOOD_CODE = 151605140604;

  final String id, code, categoryId, name, image;
  double price, taxAmount, quantity;
  bool selected = false;
  String comment = '';

  Item(
      {this.id,
      this.code,
      this.categoryId,
      this.name,
      this.price,
      this.taxAmount,
      this.quantity,
      this.image,
      String comment,
      this.selected}) {
    this.comment = comment;
  }

  Item.fromMap(Map<String, dynamic> map)
      : id = map[IdKey],
        code = map[CodeKey],
        categoryId = map[CatIdKey],
        name = map[NameKey],
        price = map[PriceKey],
        taxAmount = map[TaxAmountKey],
        quantity = map[QuantityKey],
        image = map[ImageKey],
        comment = map[CommentKey],
        selected = map[SelectedKey];

  Item.fromItem(Item item)
      : id = item.id,
        code = item.code,
        categoryId = item.categoryId,
        name = item.name,
        price = item.price,
        taxAmount = item.taxAmount,
        quantity = item.quantity ?? 1,
        image = item.image,
        comment = item.comment,
        selected = item.selected;

  Map<String, dynamic> toMap() => {
        IdKey: id,
        CodeKey: code,
        CatIdKey: categoryId,
        NameKey: name,
        PriceKey: price,
        TaxAmountKey: taxAmount,
        QuantityKey: quantity,
        CommentKey: comment ?? '',
        SelectedKey: selected,
      };
}
