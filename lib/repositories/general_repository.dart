import 'dart:async';

import 'package:http/http.dart';
import 'package:pos_app/database/local_database.dart';
import 'package:pos_app/database/models/device.dart';
import 'package:pos_app/database/models/register.dart';
import 'package:pos_app/database/tables/database_tables.dart';
import 'package:pos_app/models/server_response.dart';
import 'package:pos_app/shared/app_library.dart';
import 'package:pos_app/shared/config.dart';

class GeneralRepo {
  static GeneralRepo repo = GeneralRepo._internal();
  GeneralRepo._internal();
  Future<ServerResponse> getInstallationData() async {
    return ServerResponse(
        response: await get(await Config.installApi).timeout(
            Duration(seconds: Config.SERVER_TIMEOUT),
            onTimeout: () => Lib.timeout));
  }

  Future<Register> getCurrentRegister() async {
    final db = await LocalDatabase.database.getDatabase();
    final list = (await db.query(RegisterTable.TABLE_NAME,
            where: '${RegisterTable.REGISTER_STATUS} = ?', whereArgs: [1])) ??
        [];
    final register =
        list.map((e) => Register.fromMap(e)).toList().first ?? Register();
    return register;
  }

  Future<Device> getCurrentDevice() async {
    final db = await LocalDatabase.database.getDatabase();
    final list = (await db.query(DeviceTable.TABLE_NAME,
        where: '${DeviceTable.DEVICE_KEY}= ?',
        whereArgs: [await Config.deviceKey]));
    final device = list.map((e) => Device.fromMap(e)).first;
    return device;
  }
}
