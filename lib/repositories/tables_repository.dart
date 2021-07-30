import 'package:pos_app/database/local_database.dart';
import 'package:pos_app/database/tables/database_tables.dart';
import 'package:pos_app/models/customer_table.dart';

class TablesRepo {
  static TablesRepo repo = TablesRepo._internal();
  TablesRepo._internal();
  Future<List<Tables>> tables() async {
    final db = await LocalDatabase.database.getDatabase();

    final map = (await db.query(TablesTable.TABLE_NAME)) ?? [];
    final list = map.map((e) => Tables.fromMap(e)).toList();
    return list;
  }
}
