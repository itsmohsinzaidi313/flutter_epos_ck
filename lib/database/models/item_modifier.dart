import 'package:pos_app/database/tables/database_tables.dart';

class ItemModifier {
  String id;
  final int serverId;
  final int modifierId;
  final int foodMenuId;
  final int userId;
  final int outletId;
  final int companyId;
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
      : serverId = map[ItemModifierTable.SERVER_ID],
        modifierId = map[ItemModifierTable.MODIFIED_ID],
        foodMenuId = map[ItemModifierTable.FOOD_MENU_ID],
        userId = map[ItemModifierTable.USER_ID],
        outletId = map[ItemModifierTable.OUTLET_ID],
        companyId = map[ItemModifierTable.COMPANY_ID],
        name = map[ItemModifierTable.NAME],
        price = map[ItemModifierTable.PRICE],
        delStatus = map[ItemModifierTable.DEL_STATUS];
}
