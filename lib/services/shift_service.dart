import 'dart:convert';
import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart';
import 'package:pos_app/bloc/verbose_bloc/verbose_bloc.dart';
import 'package:pos_app/database/tables/database_tables.dart';
import 'package:pos_app/services/service_common.dart';
import 'package:pos_app/shared/app_library.dart';
import 'package:pos_app/shared/config.dart';
import 'package:sqflite/sqflite.dart';

class ShiftService extends ServiceCommon {
  final Database db;
  ShiftService(
      {@required int id,
      @required String name,
      @required this.db,
      @required VerboseBloc bloc})
      : super(id: id, name: name, serviceVersion: '1', bloc: bloc) {
    initiate();
  }
  @override
  Future<bool> perform() async {
    return await updateShiftNumber();
  }

  Future<bool> updateShiftNumber() async {
    Response response = await get(
      Uri.parse(await Config.shiftApi),
    )
        .timeout(
          Duration(seconds: Config.SERVER_TIMEOUT),
          onTimeout: () => null,
        )
        .onError((error, stackTrace) => null);
    if (response != null && response.statusCode == 200) {
      dynamic x1 = jsonDecode(response.body);
      List<dynamic> x2 = x1['shift'];
      String isOpen = x2[0]['is_open'];
      if (isOpen == '1') {
        String shiftId = x2[0]['shift_id'];
        await db.update(SalesMasterTable.TABLE_NAME,
            {SalesMasterTable.SHIFT: shiftId.toString()},
            where: '${SalesMasterTable.SHIFT} = ?', whereArgs: ['']);
        final list = (await db.query(ShiftTable.TABLE_NAME,
                where: '${ShiftTable.SHIFT_ID} = ?', whereArgs: [shiftId])) ??
            [];
        if (list.isEmpty) {
          await db.insert(ShiftTable.TABLE_NAME, x1['shift'][0]);
        }
      }
    }
    return true;
  }

  @override
  void onError(e) {}
}
