import 'dart:convert';
import 'dart:developer';
import 'package:flutter/foundation.dart';
import 'package:pos_app/bloc/verbose_bloc/verbose_bloc.dart';
import 'package:pos_app/database/models/register.dart';
import 'package:pos_app/database/tables/database_tables.dart';
import 'package:pos_app/services/service_common.dart';
import 'package:pos_app/shared/app_library.dart';
import 'package:pos_app/shared/config.dart';
import 'package:http/http.dart';
import 'package:sqflite/sqflite.dart';

class RegisterService extends ServiceCommon {
  final Database db;
  RegisterService({@required int id, @required String name, @required this.db, @required VerboseBloc bloc})
      : super(id: id, name: name, serviceVersion: '1', bloc: bloc) {
    initiate();
  }

  @override
  Future<bool> perform() async {
    final openList = await db.query(RegisterTable.TABLE_NAME,
        where:
            '${RegisterTable.REGISTER_STATUS} = ? AND ${RegisterTable.IS_UPLOADED} = ?',
        whereArgs: [1, 0],
        orderBy: '${RegisterTable.LOCAL_ID} asc');

    for (var item in openList) {
      final Register register = Register.fromMap(item);
      if (register.registerStatus == 1) {
        Map<String, dynamic> json = {
          'user_id': register.userId.toString(),
          'json': jsonEncode({
            'device_key': register.deviceKey,
            'remote_id': register.localId,
            'register_no': await Lib.codeGenerator('REG', register.localId),
            'opening_balance': register.openingBalance,
            'opening_balance_date_time': register.openingBalanceDateTime
          })
        };
        Response _response =
            await post(await Config.openRegisterApi, body: json).timeout(
                Duration(seconds: Config.SERVER_TIMEOUT),
                onTimeout: () => null);
        if (_response != null) {
          final reply = jsonDecode(_response.body);
          final status = jsonDecode(_response.body)['status'] as bool;
          if (status) {
            await db.update(
                RegisterTable.TABLE_NAME,
                {
                  RegisterTable.IS_UPLOADED: 1,
                  RegisterTable.REMOTE_ID: reply['id']
                },
                where: '${RegisterTable.LOCAL_ID} = ?',
                whereArgs: [register.localId]);
          }
        }
        log(_response.body, name: name);
      }
    }

    final closedList = await db.query(RegisterTable.TABLE_NAME,
        where:
            '${RegisterTable.REGISTER_STATUS} = ? AND ${RegisterTable.IS_UPLOADED} = ?',
        whereArgs: [2, 1],
        orderBy: '${RegisterTable.LOCAL_ID} asc');
    for (var item in closedList) {
      final Register register = Register.fromMap(item);

      Map<String, dynamic> json = {
        'user_id': register.userId.toString(),
        'json': jsonEncode({
          'device_key': register.deviceKey,
          'remote_id': register.remoteId,
          'closing_balance': register.closingBalance,
          'closing_balance_date_time': register.closingBalanceDateTime
        })
      };
      Response _response = await post(await Config.closeRegisterApi, body: json)
          .timeout(Duration(seconds: Config.SERVER_TIMEOUT),
              onTimeout: () => null);
      if (_response != null) {
        final status = jsonDecode(_response.body)['status'] as bool;
        if (status) {
          await db.update(
              RegisterTable.TABLE_NAME, {RegisterTable.IS_UPLOADED: 2},
              where: '${RegisterTable.LOCAL_ID} = ?',
              whereArgs: [register.localId]);
        }
      }
      log(_response.body, name: name);
    }
    return true;
  }

  @override
  void onError(e) {}
}
