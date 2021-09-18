import 'package:pos_app/database/tables/database_tables.dart';

class Table {
  String serverId;
  String name;
  String sitCapacity;
  String position;
  String description;
  String userId;
  String outletId;
  String companyId;
  String delStatus;

  Table(
      {this.serverId,
      this.name,
      this.sitCapacity,
      this.position,
      this.description,
      this.userId,
      this.outletId,
      this.companyId,
      this.delStatus});

  Table.fromMap(Map<String, dynamic> map)
      : serverId = map[TablesTable.SERVER_ID],
        name = map[TablesTable.NAME],
        sitCapacity = map[TablesTable.SIT_CAPACITY],
        position = map[TablesTable.POSITION],
        description = map[TablesTable.DESCRIPTION],
        userId = map[TablesTable.USER_ID],
        outletId = map[TablesTable.OUTLET_ID],
        companyId = map[TablesTable.COMPANY_ID],
        delStatus = map[TablesTable.DEL_STATUS];
}
