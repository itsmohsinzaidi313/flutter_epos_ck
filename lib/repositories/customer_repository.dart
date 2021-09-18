import 'dart:convert';
import 'dart:developer';

import 'package:http/http.dart';
import 'package:meta/meta.dart';
import 'package:pos_app/database/local_database.dart';
import 'package:pos_app/database/tables/customer_table.dart';
import 'package:pos_app/database/models/customer.dart' as c;
import 'package:pos_app/models/customer.dart';
import 'package:pos_app/repositories/general_repository.dart';
import 'package:pos_app/repositories/users_repository.dart';
import 'package:pos_app/shared/app_library.dart';
import 'package:pos_app/shared/config.dart';

class CustomerRepo {
  static CustomerRepo repo = CustomerRepo._internal();

  CustomerRepo._internal();

  Future<Customer> getCustomer(
      {String contact = '', int id = 0, int remoteId = 0}) async {
    final db = await LocalDatabase.database.getDatabase();
    if (contact != '' && id == 0 && remoteId == 0) {
      final list = await db.query(CustomerTable.TABLE_NAME,
          where: '${CustomerTable.PHONE} = ?', whereArgs: [contact]);
      return list.map((e) => Customer.fromMap(e)).toList().first;
    } else if (contact == '' && id != 0 && remoteId == 0) {
      final list = await db.query(CustomerTable.TABLE_NAME,
          where: '${CustomerTable.SERVER_ID} = ?', whereArgs: [id]);
      return list.map((e) => Customer.fromMap(e)).toList().first;
    } else if (contact == '' && id == 0 && remoteId != 0) {
      final list = await db.query(CustomerTable.TABLE_NAME,
          where: '${CustomerTable.REMOTE_ID} = ?', whereArgs: [remoteId]);
      return list.map((e) => Customer.fromMap(e)).toList().first;
    }
  }

  Future<c.Customer> getDBCustomer(
      {int localId = 0,
      int remoteId = 0,
      int serverId = 0,
      String name = '',
      String contact = ''}) async {
    final db = await LocalDatabase.database.getDatabase();

    c.Customer customer = c.Customer();
    customer.localId = '0';
    List<Map<String, dynamic>> list = [];
    final x = await db.query(CustomerTable.TABLE_NAME);
    if (localId != 0 &&
        serverId == 0 &&
        name == '' &&
        contact == '' &&
        remoteId == 0) {
      list = (await db.query(CustomerTable.TABLE_NAME,
              where: '${CustomerTable.LOCAL_ID} = ?', whereArgs: [localId])) ??
          [];
    } else if (localId == 0 &&
        serverId != 0 &&
        name == '' &&
        contact == '' &&
        remoteId == 0) {
      list = (await db.query(CustomerTable.TABLE_NAME,
              where: '${CustomerTable.SERVER_ID} = ?',
              whereArgs: [serverId])) ??
          [];
    } else if (localId == 0 &&
        serverId == 0 &&
        name != '' &&
        contact == '' &&
        remoteId == 0) {
      list = (await db.query(CustomerTable.TABLE_NAME,
              where: '${CustomerTable.NAME} = ?', whereArgs: [name])) ??
          [];
    } else if (localId == 0 &&
        serverId == 0 &&
        name == '' &&
        contact != '' &&
        remoteId == 0) {
      list = (await db.query(CustomerTable.TABLE_NAME,
              where: '${CustomerTable.PHONE} = ?', whereArgs: [contact])) ??
          [];
    } else if (localId == 0 &&
        serverId == 0 &&
        name == '' &&
        contact == '' &&
        remoteId != 0) {
      list = (await db.query(CustomerTable.TABLE_NAME,
              where: '${CustomerTable.REMOTE_ID} = ?',
              whereArgs: [remoteId])) ??
          [];
    }

    for (var map in list) {
      customer = c.Customer.fromMap(map);
    }

    return customer;
  }

  Future<int> insertAndUploadIfExists({Customer customer}) async {
    final db = await LocalDatabase.database.getDatabase();
    await db.rawQuery(
        "INSERT INTO ${CustomerTable.TABLE_NAME}(${CustomerTable.NAME}, ${CustomerTable.PHONE}, ${CustomerTable.ADDRESS}, ${CustomerTable.IS_UPLOADED}) SELECT '${customer.name}', '${customer.contact}', '${customer.address}', 0 WHERE NOT EXISTS(SELECT ${CustomerTable.LOCAL_ID} FROM ${CustomerTable.TABLE_NAME} WHERE ${CustomerTable.PHONE} == ${customer.contact})");

    final id = await db.query(CustomerTable.TABLE_NAME,
        columns: [CustomerTable.LOCAL_ID],
        where: '${CustomerTable.PHONE} = ?',
        whereArgs: [customer.contact]);

    final list = await db.query(CustomerTable.TABLE_NAME,
        where:
            '${CustomerTable.PHONE} = ? AND ${CustomerTable.IS_UPLOADED} = ?',
        whereArgs: [customer.contact, 0]);
    try {
      if (list.isEmpty) {
        Map<String, dynamic> data = {
          'user_id': (await UsersRepo.repo.getCurrentUser()).id,
          'json': jsonEncode({
            'remote_id': id[0],
            CustomerTable.NAME: customer.name,
            CustomerTable.PHONE: customer.contact,
            CustomerTable.ADDRESS: customer.address,
            'device_key': await Config.deviceKey,
            CustomerTable.USER_ID: (await UsersRepo.repo.getCurrentUser()).id,
            CustomerTable.COMPANY_ID:
                (await GeneralRepo.repo.getCurrentDevice()).companyId,
            'outlet_id': (await UsersRepo.repo.getCurrentUser()).outletId
          }),
        };

        Response response =
            await post(await Config.customerUploadApi, body: data).timeout(
                Duration(seconds: Config.SERVER_TIMEOUT),
                onTimeout: () => null);
        if (response != null) {
          Map<String, dynamic> result = jsonDecode(response.body);
          bool status = result['status'];
          if (status) {
            await db.update(CustomerTable.TABLE_NAME, {
              CustomerTable.REMOTE_ID: result['customers_synced'][0]
                  ['remote_id'],
              CustomerTable.IS_UPLOADED: 1,
            });
          }
        }
      }
    } catch (e) {
      log('Error', error: e, name: 'Customer Repository');
    }
    return id[0][CustomerTable.LOCAL_ID] as int;
  }
}
