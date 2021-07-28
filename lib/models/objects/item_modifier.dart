class ItemModifier {
  String id;
  final String serverId;
  final String modifierId;
  final String foodMenuId;
  final String userId;
  final String outletId;
  final String companyId;
  final String delStatus;
  final String name;
  final String price;

  ItemModifier(
      {this.serverId,
      this.modifierId,
      this.foodMenuId,
      this.userId,
      this.outletId,
      this.companyId,
      this.delStatus,
      this.name,
      this.price});

  ItemModifier.fromMap(Map<String, dynamic> map)
      : serverId = map['id'],
        modifierId = map['modifier_id'],
        foodMenuId = map['food_menu_id'],
        userId = map['user_id'],
        outletId = map['outlet_id'],
        companyId = map['company_id'],
        name = map['name'],
        price = map['price'],
        delStatus = map['del_status'];
}
