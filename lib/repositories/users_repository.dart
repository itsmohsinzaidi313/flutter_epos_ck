import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:pos_app/database/local_database.dart';
import 'package:pos_app/models/user.dart';
import 'package:pos_app/database/tables/database_tables.dart';
import 'package:pos_app/models/waiter.dart';

class UsersRepo {
  static UsersRepo repo = UsersRepo._internal();
  UsersRepo._internal();

  Future<bool> login(
      {@required String email,
      @required String password,
      bool logout = false}) async {
    final db = await LocalDatabase.database.getDatabase();
    final list = (await db.query(UserTable.TABLE_NAME,
            columns: [UserTable.SERVER_ID],
            where:
                '${UserTable.EMAIL} = ? AND ${UserTable.PASSWORD} = ? AND ${UserTable.WILL_LOGIN} = ? AND ${UserTable.ACTIVE_STATUS} = ?',
            whereArgs: [email, password, 'Yes', 'Active'])) ??
        [];
    if (list.isNotEmpty) {
      await db.update(
          UserTable.TABLE_NAME, {UserTable.LOGIN_STATUS: logout ? 0 : 1},
          where: '${UserTable.EMAIL} = ? AND ${UserTable.PASSWORD} = ?',
          whereArgs: [email, password]);
    }
    return list.isNotEmpty;
  }

  Future<User> getCurrentUser() async {
    final db = await LocalDatabase.database.getDatabase();
    final list = (await db.query(UserTable.TABLE_NAME,
            where: '${UserTable.LOGIN_STATUS} = ?', whereArgs: [1])) ??
        [];
    User user = User();
    if (list.isNotEmpty) {
      user = User.fromMap(list[0]);
    }
    return user;
  }

  Future<List<Waiter>> getWaiters() async {
    final db = await LocalDatabase.database.getDatabase();
    final list = (await db.query(UserTable.TABLE_NAME,
            columns: [UserTable.SERVER_ID],
            where:
                '${UserTable.DESIGNATION} = ? AND ${UserTable.WILL_LOGIN} = ? AND ${UserTable.ACTIVE_STATUS} = ?',
            whereArgs: ['Waiter', 'Yes', 'Active'])) ??
        [];
    final waiters = list.map((e) => Waiter.fromMap(e)).toList();
    return waiters;
  }
}
