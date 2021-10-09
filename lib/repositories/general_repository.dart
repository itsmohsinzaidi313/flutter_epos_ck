import 'dart:async';

import 'package:http/http.dart';
import 'package:pos_app/database/local_database.dart';
import 'package:pos_app/database/models/company.dart';
import 'package:pos_app/database/models/device.dart';
import 'package:pos_app/database/models/register.dart';
import 'package:pos_app/database/models/shift.dart';
import 'package:pos_app/database/tables/database_tables.dart';
import 'package:pos_app/models/customer_table.dart';
import 'package:pos_app/models/server_response.dart';
import 'package:pos_app/repositories/users_repository.dart';
import 'package:pos_app/shared/app_library.dart';
import 'package:pos_app/shared/config.dart';

class GeneralRepo {
  static GeneralRepo repo = GeneralRepo._internal();
  GeneralRepo._internal();
  Future<ServerResponse> getInstallationData() async {
    return ServerResponse(
        response: await get(await Config.installApi).timeout(
            Duration(seconds: Config.SERVER_TIMEOUT),
            onTimeout: () => Lib.timeout)
        // .onError((error, stackTrace) =>
        //     Lib.internetConnectivityErrorHandler(error, stackTrace)),
        );
  }

  Future<Register> getCurrentRegister() async {
    final db = await LocalDatabase.database.getDatabase();
    final list = (await db.query(RegisterTable.TABLE_NAME,
            where: '${RegisterTable.REGISTER_STATUS} = ?', whereArgs: [1])) ??
        [];
    Register register = Register();
    if (list.isNotEmpty) {
      return Register.fromMap(list[0]);
    }
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

  Future<Shift> getCurrentShift() async {
    final db = await LocalDatabase.database.getDatabase();
    final list = (await db.query(ShiftTable.TABLE_NAME,
            where: '${ShiftTable.IS_OPEN} = ?',
            whereArgs: [1],
            limit: 1,
            orderBy: '${ShiftTable.SHIFT_ID} desc')) ??
        [];
    if (list.isNotEmpty) {
      return Shift.fromMap(list[0]);
    } else {
      return Shift();
    }
  }

  Future<Company> getCurrentCompany() async {
    final db = await LocalDatabase.database.getDatabase();
    final companyId = (await getCurrentDevice()).companyId;
    final list = (await db.query(CompanyTable.TABLE_NAME,
            where: '${CompanyTable.SERVER_ID} = ?', whereArgs: [companyId])) ??
        [];
    for (var item in list) {
      return Company.fromMap(item);
    }
    return null;
  }

  Future<Tables> getTable({int tableId}) async {
    final db = await LocalDatabase.database.getDatabase();
    final list = (await db.query(TablesTable.TABLE_NAME,
        where: '${TablesTable.SERVER_ID} = ?', whereArgs: [tableId]));
    for (var item in list) {
      return Tables.fromMap(item);
    }
    return null;
  }

  Future<bool> openShift({double openingAmount}) async {
    final db = await LocalDatabase.database.getDatabase();

    final device = await GeneralRepo.repo.getCurrentDevice();
    final remoteId = await db.query(RegisterTable.TABLE_NAME, columns: [
      '(IFNULL(${RegisterTable.REMOTE_ID},0) + 1) ${RegisterTable.REMOTE_ID}'
    ]);
    final register = Register();
    register.openingBalance = openingAmount;
    register.remoteId = remoteId.first[RegisterTable.REMOTE_ID];
    register.deviceKey = device.deviceKey;
    register.companyId = device.companyId;
    register.outletId = device.outletId;
    register.userId = int.parse((await UsersRepo.repo.getCurrentUser()).id);
    register.openingBalanceDateTime = Lib.getCurrentDateTimeWithFormat();
    register.registerNo =
        await Lib.codeGenerator('REG', remoteId.first[RegisterTable.REMOTE_ID]);
    register.closingBalance = 0.0;
    register.closingBalanceDateTime = '0000-00-00 00:00:00';
    register.registerStatus = 1;
    register.isUpload = 0;
    await db.insert(RegisterTable.TABLE_NAME, register.getMap());
    return true;
  }
}
