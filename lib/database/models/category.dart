import 'package:pos_app/database/tables/database_tables.dart';

class Category {
  final int serverId;
  final String categoryName;
  final String description;
  final int userId;
  final int companyId;
  final String delStatus;

  Category(
      {this.serverId,
      this.categoryName,
      this.description,
      this.userId,
      this.companyId,
      this.delStatus});

  Category.fromMap(Map<String, dynamic> map)
      : serverId = map[CategoryTable.SERVER_ID],
        categoryName = map[CategoryTable.CATEGORY_NAME],
        description = map[CategoryTable.DESCRIPTION],
        userId = map[CategoryTable.USER_ID],
        companyId = map[CategoryTable.COMPANY_ID],
        delStatus = map[CategoryTable.DEL_STATUS];
}
