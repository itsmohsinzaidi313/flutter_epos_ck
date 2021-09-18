import 'package:pos_app/database/tables/database_tables.dart';

class Modifier {
  final int serverId;
  final String name;
  final String price;
  final String description;
  final int userId;
  final int companyId;
  final String delStatus;

  Modifier(
      {this.serverId,
      this.name,
      this.price,
      this.description,
      this.userId,
      this.companyId,
      this.delStatus});

  Modifier.fromMap(Map<String, dynamic> map)
      : serverId = map[ModifierTable.SERVER_ID],
        name = map[ModifierTable.NAME],
        price = map[ModifierTable.PRICE],
        description = map[ModifierTable.DESCRIPTION],
        userId = map[ModifierTable.USER_ID],
        companyId = map[ModifierTable.COMPANY_ID],
        delStatus = map[ModifierTable.DEL_STATUS];
}
