class Item {
  String serverId;
  String code;
  String name;
  String salePrice;
  String photo;
  String categoryName;
  String percentage;
  String quantity;

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
    this.serverId = item.serverId;
    this.code = item.code;
    this.name = item.name;
    this.salePrice = item.salePrice;
    this.photo = item.photo;
    this.categoryName = item.categoryName;
    this.percentage = item.percentage;
    this.quantity = item.quantity;
  }

  Item.fromMap(Map<String, dynamic> map)
      : serverId = map['id'],
        code = map['code'],
        name = map['name'],
        salePrice = map['sale_price'],
        photo = map['photo'],
        categoryName = map['category_name'],
        quantity = 1.toString(),
        percentage = map['percentage'];
}
