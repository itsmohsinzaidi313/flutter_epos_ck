import 'package:pos_app/database/tables/database_tables.dart';

class MenuItem {
  // static const int OPENFOOD_CODE = 151605140604;

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
      : id = map[ItemTable.SERVER_ID].toString(),
        code = map[ItemTable.CODE].toString(),
        categoryId = map[ItemTable.CATEGORY_ID].toString(),
        name = map[ItemTable.NAME],
        price = map[ItemTable.SALE_PRICE].toString(),
        taxAmount = map[ItemTable.SALE_PRICE].toString(),
        quantity = 1,
        image = map[ItemTable.PHOTO];

  MenuItem.fromDB(Map<String, dynamic> map)
      : id = map[ItemTable.LOCAL_ID].toString(),
        code = map[ItemTable.CODE].toString(),
        categoryId = map[ItemTable.CATEGORY_ID].toString(),
        name = map[ItemTable.NAME],
        price = map[ItemTable.SALE_PRICE].toString(),
        taxAmount = map[ItemTable.SALE_PRICE].toString(),
        quantity = map[ItemTable.QUANTITY],
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
}
