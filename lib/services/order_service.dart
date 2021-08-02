import 'dart:convert';
import 'dart:developer';

import 'package:http/http.dart';
import 'package:pos_app/database/models/customer.dart';
import 'package:pos_app/database/models/sales_master.dart';
import 'package:pos_app/database/tables/database_tables.dart';
import 'package:pos_app/repositories/general_repository.dart';
import 'package:pos_app/repositories/users_repository.dart';
import 'package:pos_app/services/service_common.dart';
import 'package:pos_app/shared/app_library.dart';
import 'package:pos_app/shared/config.dart';
import 'package:sqflite/sqflite.dart';

class OrderService extends ServiceCommon {
  static final OrderService svc = OrderService._instance();

  Database _db;
  OrderService._instance() {
    initiate();
  }
  @override
  Future<bool> perform() async {
    try {
      log('Responding', name: 'Order Service : ${Lib.getCurrentTime24Format()}');
      List<Map<String, dynamic>> masterRows = await _db.query(
          SalesMasterTable.TABLE_NAME,
          where:
              '${SalesMasterTable.IS_UPLOADED} = ? and ${SalesMasterTable.SHIFT} != ?',
          whereArgs: ['0', '']); // GETTING ORDERS FOR UPLOAD FROM DATABASE
      for (int i = 0; i < masterRows.length; i++) {
        final salesMaster = SalesMaster.fromMap(masterRows[i]);

        List<Map<String, dynamic>> detailRows = await _db.query(
            SalesDetailTable.TABLE_NAME,
            where: '${SalesDetailTable.SALES_MASTER_ID} = ?',
            whereArgs: [salesMaster.localId]);

        List<Map<String, dynamic>> details = [];
        detailRows.map((e) => details.add(Map<String, dynamic>.from(e)));
        List<Map<String, dynamic>> masterJson = [];

        Map<String, dynamic> map = salesMaster.getMap();
        map.remove(SalesMasterTable.SHIFT);
        map.remove(SalesMasterTable.IS_DELETED);
        map.remove(SalesMasterTable.IS_UPLOADED);
        map['sale_details'] = details;
        masterJson.add(map);
        Map<String, dynamic> json = {
          'user_id': (await UsersRepo.repo.getCurrentUser()).id,
          'json': jsonEncode(masterJson)
        };
        Response response = await post(Config.addUpdateOrderApi, body: json)
            .timeout(Duration(seconds: 5), onTimeout: () => null);
        log(response.body, name: 'Order Service');
        if (response != null && response.statusCode == 200) {
          Map<String, dynamic> result = jsonDecode(response.body);
          bool status = result['status'];
          if (status) {
            List<dynamic> y = result['orders_synced'];
            String id = y[0]['id'].toString();
            await _db.update(
                SalesMasterTable.TABLE_NAME,
                {
                  SalesMasterTable.IS_UPLOADED: '1',
                  SalesMasterTable.SERVER_ID: id,
                },
                where: '${SalesMasterTable.LOCAL_ID} = ?',
                whereArgs: [salesMaster.localId]);
          } else {
            if (result['message']
                .toString()
                .contains('Customer does not exist')) {
              final customer = await GeneralRepo.repo.getCustomer(localId: salesMaster.customerId);
              await Lib.uploadCustomer(customer)
                  ? log('Customer uploaded Successfully',
                      name: 'Order Service', time: DateTime.now())
                  : log('Customer upload unsuccessful',
                      name: 'Order Service', time: DateTime.now());
            }
            log(json.toString(), name: 'Order Service', time: DateTime.now());
          }
        }
      }
      return true;
    } catch (e) {
      log('Error occured on Order Service',
          name: 'Order Service', time: DateTime.now(), error: e);
      return true;
    }
  }
}
