import 'package:pos_app/database/local_database.dart';
import 'package:pos_app/database/tables/database_tables.dart';
import 'package:pos_app/models/waiter.dart';

class WaiterRepo {
  static WaiterRepo repo = WaiterRepo._internal();
  WaiterRepo._internal();
  Future<List<Waiter>> getWaiters({int waiterId = 0}) async {
    final db = await LocalDatabase.database.getDatabase();
    final map = (await db.query(UserTable.TABLE_NAME,
            columns: [],
            where:
                '${UserTable.DESIGNATION} = ? AND ${UserTable.WILL_LOGIN} = ? AND ${UserTable.ACTIVE_STATUS} = ?',
            whereArgs: ['Waiter', 'Yes', 'Active'])) ??
        [];
    final list = map.map((e) => Waiter.fromMap(e)).toList();
    if (waiterId != 0) {
      list.where((element) => element.id == waiterId.toString()).toList();
    }
    return list;
  }
}
