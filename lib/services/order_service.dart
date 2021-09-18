import 'dart:convert';
import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart';
import 'package:pos_app/bloc/verbose_bloc/verbose_bloc.dart';
import 'package:pos_app/database/local_database.dart';
import 'package:pos_app/database/models/sales_master.dart';
import 'package:pos_app/database/tables/database_tables.dart';
import 'package:pos_app/repositories/customer_repository.dart';
import 'package:pos_app/repositories/general_repository.dart';
import 'package:pos_app/repositories/users_repository.dart';
import 'package:pos_app/services/service_common.dart';
import 'package:pos_app/shared/app_library.dart';
import 'package:pos_app/shared/config.dart';
import 'package:sqflite/sqflite.dart';

class OrderService extends ServiceCommon {
  final Database db;

  OrderService({@required int id, @required String name, @required this.db, @required VerboseBloc bloc})
      : super(id: id, name: name, serviceVersion: '1', bloc: bloc) {
    initiate();
  }

  @override
  Future<bool> perform() async {
    List<Map<String, dynamic>> masterRows = await db.query(
        SalesMasterTable.TABLE_NAME,
        where:
            '${SalesMasterTable.IS_DELETED} = ? AND ${SalesMasterTable.IS_UPLOADED} = ? AND ${SalesMasterTable.SHIFT} != ?',
        whereArgs: [0, 0, '']);
    for (int i = 0; i < masterRows.length; i++) {
      final salesMaster = SalesMaster.fromMap(masterRows[i]);

      List<Map<String, dynamic>> detailRows =
          await db.query(SalesDetailTable.TABLE_NAME,
              columns: [
                SalesDetailTable.SERVER_ID,
                SalesDetailTable.FOOD_MENU_ID,
                SalesDetailTable.MENU_NAME,
                SalesDetailTable.QUANTITY,
                SalesDetailTable.MENU_PRICE_WITHOUT_DISCOUNT,
                SalesDetailTable.MENU_PRICE_WITH_DISCOUNT,
                SalesDetailTable.MENU_UNIT_PRICE,
                SalesDetailTable.MENU_VAT_PERCENTAGE,
                SalesDetailTable.MENU_TAXES,
                SalesDetailTable.MENU_DISCOUNT_VALUE,
                SalesDetailTable.DISCOUNT_TYPE,
                SalesDetailTable.MENU_NOTE,
                SalesDetailTable.DISCOUNT_AMOUNT,
                SalesDetailTable.ITEM_TYPE,
                SalesDetailTable.COOKING_STATUS,
                SalesDetailTable.COOKING_START_TIME,
                SalesDetailTable.COOKING_DONE_TIME,
                SalesDetailTable.PREVIOUS_ID,
                SalesDetailTable.SALES_MASTER_ID,
                SalesDetailTable.ORDER_STATUS,
                SalesDetailTable.USER_ID,
                SalesDetailTable.OUTLET_ID,
                SalesDetailTable.DEL_STATUS,
              ],
              where: '${SalesDetailTable.SALES_MASTER_ID} = ?',
              whereArgs: [salesMaster.localId]);

      Map<String, dynamic> map = salesMaster.getMap();
      map.remove(SalesMasterTable.SHIFT);
      map.remove(SalesMasterTable.IS_DELETED);
      map.remove(SalesMasterTable.IS_UPLOADED);
      map['remote_id'] = map[SalesMasterTable.LOCAL_ID];
      map.remove(SalesMasterTable.LOCAL_ID);
      map['sale_details'] = detailRows;

      Map<String, dynamic> json = {
        'user_id': (await UsersRepo.repo.getCurrentUser()).id,
        'json': jsonEncode([map])
      };
      // log(json.toString());
      Response response =
          await post(await Config.addUpdateOrderApi, body: json).timeout(
              Duration(
                seconds: Config.SERVER_TIMEOUT,
              ),
              onTimeout: () => null);
      if (response != null) {
        if (response.statusCode == 200) {
          Map<String, dynamic> result = jsonDecode(response.body);
          log(result['message'], name: name);
          bool status = result['status'];
          if (status) {
            passEvent(VerboseNotify(message: 'Order uploaded'));
            List<dynamic> y = result['orders_synced'];
            String id = y[0]['id'].toString();
            await db.update(
                SalesMasterTable.TABLE_NAME,
                {
                  SalesMasterTable.IS_UPLOADED: '1',
                  SalesMasterTable.SERVER_ID: id,
                },
                where: '${SalesMasterTable.LOCAL_ID} = ?',
                whereArgs: [salesMaster.localId]);
          } else {}
        } else if (response.statusCode == 400) {
          Map<String, dynamic> result = jsonDecode(response.body);
          log(result['message'], name: name);
          passEvent(VerboseNotify(message: result['message']));
          // if (result['message']
          //     .toString()
          //     .contains('Customer does not exist')) {
          // final customer = await CustomerRepo.repo
          //     .getCustomer(localId: salesMaster.customerId);
          // if (customer.isUpload == 0) {
          // await Lib.uploadCustomer(customer) != 0
          //     ? log('Customer uploaded successfully',
          //         name: name, time: DateTime.now())
          //     : log('Customer upload unsuccessful',
          //         name: name, time: DateTime.now());
          // }
          // } else if (result['message'].toString().contains(
          //       'Either Register does not exist or It has been closed, please open',
          //     )) {}
          // log(json.toString(), name: name, time: DateTime.now());
        }
      }
    }
    return true;
  }

  @override
  void onError(e) {}
}
