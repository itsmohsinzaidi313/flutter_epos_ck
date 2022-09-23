class Item {
  static const int OPENFOOD_CODE = 151605140604;

  static const String rowIdKey = 'RowId',
      idKey = 'Id',
      codeKey = 'Code',
      categoryIdKey = 'CategoryId',
      nameKey = 'Name',
      priceKey = 'Price',
      taxAmountKey = 'TaxAmount',
      quantityKey = 'Quantity',
      commentKey = 'Comment',
      imageKey = 'image',
      selectedKey = 'Selected',
      isAdditionalKey = 'isAdditional';

  final String rowId, id, code, categoryId, name, image, comment;
  final double price, taxAmount, quantity;
  final bool selected, isAdditional;

  const Item({
    this.rowId = '',
    this.id = '',
    this.code = '',
    this.categoryId = '',
    this.name = '',
    this.price = 0,
    this.taxAmount = 0,
    this.quantity = 0,
    this.image = '',
    this.comment = '',
    this.selected = false,
    this.isAdditional = false,
  });

  Item.fromMap(Map<String, dynamic> map)
      : rowId = map[rowIdKey],
        id = map[idKey],
        code = map[codeKey],
        categoryId = map[categoryIdKey],
        name = map[nameKey],
        price = map[priceKey],
        taxAmount = map[taxAmountKey],
        quantity = map[quantityKey],
        image = map[imageKey],
        comment = map[commentKey],
        selected = map[selectedKey],
        isAdditional = map[isAdditionalKey];

  Map<String, dynamic> toMap() => {
        idKey: id,
        codeKey: code,
        categoryIdKey: categoryId,
        nameKey: name,
        priceKey: price,
        taxAmountKey: taxAmount,
        quantityKey: quantity,
        commentKey: comment,
        selectedKey: selected,
        isAdditionalKey: isAdditional
      };
}
