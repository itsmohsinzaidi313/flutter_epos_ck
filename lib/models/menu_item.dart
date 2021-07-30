import 'package:pos_app/database/tables/database_tables.dart';

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
      : id = map[ItemTable.SERVER_ID],
        code = map[ItemTable.CODE],
        categoryId = map[ItemTable.CATEGORY_NAME],
        name = map[ItemTable.NAME],
        price = map[ItemTable.SALE_PRICE],
        taxAmount = map[''],
        quantity = double.parse(map[ItemTable.QUANTITY]),
        image = map[ItemTable.PHOTO];

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
