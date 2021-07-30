import 'package:pos_app/database/tables/database_tables.dart';

class Tables {
  static const String IdKey = 'id';
  static const String TableNameKey = 'tableName';
  static const String ReservedKey = 'reserved';

  String id;
  String tableName;
  bool reserved;
  bool selected;
  Tables({this.id, this.tableName, this.reserved, this.selected});
  Tables.fromMap(Map<String, dynamic> map)
      : id = map[TablesTable.SERVER_ID],
        tableName = map[TablesTable.NAME],
        reserved = map[TablesTable.RESERVED],
        selected = false;
}
