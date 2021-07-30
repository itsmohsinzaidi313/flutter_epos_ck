import 'package:pos_app/database/tables/database_tables.dart';

class Tables {
  String id;
  String tableName;
  bool reserved;
  bool selected;

  Tables({this.id, this.tableName, this.reserved, this.selected});
  Tables.fromMap(Map<String, dynamic> map)
      : id = map[TablesTable.LOCAL_ID],
        tableName = map[TablesTable.NAME],
        reserved = map[TablesTable.FREE],
        selected = false;
}
