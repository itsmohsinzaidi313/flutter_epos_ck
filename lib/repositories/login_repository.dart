import 'package:flutter/material.dart';
import 'package:pos_app/database/local_database.dart';
import 'package:pos_app/database/tables/database_tables.dart';

class LoginRepo {
  static LoginRepo repo = LoginRepo._internal();
  LoginRepo._internal();
  Future<bool> login(
      {@required String email, @required String password}) async {
    final db = await LocalDatabase.database.getDatabase();
    final map = (await db.query(UserTable.TABLE_NAME,
            columns: [UserTable.SERVER_ID],
            where:
                '${UserTable.EMAIL} = ? AND ${UserTable.PASSWORD} = ? AND ${UserTable.WILL_LOGIN} = ? AND ${UserTable.ACTIVE_STATUS} = ?',
            whereArgs: ['$email', '$password', 'Yes', 'Active'])) ??
        [];
    return map.isNotEmpty;
  }

  Future<int> getCurrentUserId() async {
    final db = await LocalDatabase.database.getDatabase();
    final id = (await db.query(UserTable.TABLE_NAME,
            columns: [UserTable.SERVER_ID],
            where: '${UserTable.LOGIN_STATUS} = ?',
            whereArgs: [1])) ??
        0;
    return id;
  }
}
