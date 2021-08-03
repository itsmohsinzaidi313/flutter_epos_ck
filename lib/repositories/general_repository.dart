import 'dart:async';

import 'package:http/http.dart';
import 'package:pos_app/database/local_database.dart';
import 'package:pos_app/database/models/customer.dart';
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

  Future<Customer> getCustomer(
      {int localId = 0, int serverId = 0, String name = ''}) async {
    final db = await LocalDatabase.database.getDatabase();

    Customer customer = Customer();
    List<Map<String, dynamic>> list = [];

    if (localId != 0 && serverId == 0 && name == '') {
      list = (await db.query(CustomerTable.TABLE_NAME,
              where: '${CustomerTable.LOCAL_ID} = ?', whereArgs: [localId])) ??
          [];
    } else if (localId == 0 && serverId != 0 && name == '') {
      list = (await db.query(CustomerTable.TABLE_NAME,
              where: '${CustomerTable.SERVER_ID} = ?',
              whereArgs: [serverId])) ??
          [];
    } else if (localId == 0 && serverId == 0 && name != '') {
      list = (await db.query(CustomerTable.TABLE_NAME,
              where: '${CustomerTable.NAME} = ?', whereArgs: [name])) ??
          [];
    }

    for (var map in list) {
      customer = Customer.fromMap(map);
    }

    return customer;
  }
}
