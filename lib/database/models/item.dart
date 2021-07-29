import 'package:pos_app/database/tables/database_tables.dart';

class Item {
  int serverId;
  String code;
  String name;
  String salePrice;
  String photo;
  String categoryName;
  String percentage;
  int quantity;

  Item(
      {this.serverId,
      this.code,
      this.name,
      this.salePrice,
      this.photo,
      this.categoryName,
      this.percentage,
      this.quantity});

  Item.fromItem(Item item) {
    serverId = item.serverId;
    code = item.code;
    name = item.name;
    salePrice = item.salePrice;
    photo = item.photo;
    categoryName = item.categoryName;
    percentage = item.percentage;
    quantity = item.quantity;
  }

  Item.fromMap(Map<String, dynamic> map)
      : serverId = map[ItemTable.SERVER_ID],
        code = map[ItemTable.CODE],
        name = map[ItemTable.NAME],
        salePrice = map[ItemTable.SALE_PRICE],
        photo = map[ItemTable.PHOTO],
        categoryName = map[ItemTable.CATEGORY_NAME],
        quantity = map[ItemTable.QUANTITY],
        percentage = map[ItemTable.PERCENTAGE];
}
