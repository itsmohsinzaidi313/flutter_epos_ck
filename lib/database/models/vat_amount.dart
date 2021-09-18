import 'package:pos_app/database/tables/database_tables.dart';

class VatAmount {
  String serverID;
  String name;
  String percentage;
  String userId;
  String companyId;
  String delStatus;

  VatAmount(
      {this.serverID,
      this.name,
      this.percentage,
      this.userId,
      this.companyId,
      this.delStatus});

  VatAmount.fromMap(Map<String, dynamic> map) {
    serverID = map[VatAmountTable.SERVER_ID];
    name = map[VatAmountTable.NAME];
    percentage = map[VatAmountTable.PERCENTAGE];
    companyId = map[VatAmountTable.COMPANY_ID];
    userId = map[VatAmountTable.USER_ID];
    delStatus = map[VatAmountTable.DEL_STATUS];
  }
}
