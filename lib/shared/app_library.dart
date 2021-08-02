import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:flutter/services.dart';
import 'package:http/http.dart';
import 'package:intl/intl.dart';
import 'package:pos_app/database/local_database.dart';
import 'package:pos_app/database/models/customer.dart';
import 'package:pos_app/database/tables/database_tables.dart';
import 'package:pos_app/repositories/general_repository.dart';
import 'package:pos_app/repositories/users_repository.dart';
import 'package:pos_app/shared/config.dart';

class Lib {
  static forcePortraitView() async =>
      await SystemChrome.setPreferredOrientations(
          [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);

  static forceLandscapeView() async =>
      await SystemChrome.setPreferredOrientations(
          [DeviceOrientation.landscapeLeft, DeviceOrientation.landscapeRight]);
          
  static Response get timeout => Response(
      jsonEncode({'Status': false, 'Message': 'Offline', 'Data': 0}),
      HttpStatus.requestTimeout);

      static String getCurrentTime24Format() {
    DateTime dateTime = DateTime.now();
    DateFormat formatDateTime = DateFormat("HH:mm:ss");
    String currentTime = formatDateTime.format(dateTime);
    return currentTime;
  }

  static String getCurrentDateTimeWithFormat() {
    DateTime dateTime = DateTime.now();
    DateFormat formatDateTime = DateFormat("yyyy-MM-dd HH:mm:ss");
    String currentDateTime = formatDateTime.format(dateTime);
    return currentDateTime;
  }
  static Future<bool> uploadCustomer(Customer customer) async {
    Map<String, dynamic> data = <String, dynamic>{};
    List<Map<String, dynamic>> map = [];

    map.add({
      'remote_id': customer.localId,
      CustomerTable.NAME: customer.name,
      CustomerTable.PHONE: customer.phone,
      CustomerTable.ADDRESS: customer.address,
      'device_key': await Config.deviceKey,
      CustomerTable.USER_ID: customer.userId,
      CustomerTable.COMPANY_ID: (await GeneralRepo.repo.getCurrentDevice()).companyId,
      'outlet_id': (await UsersRepo.repo.getCurrentUser()).outletId
    });

    data['user_id'] = (await UsersRepo.repo.getCurrentUser()).id;
    data['json'] = jsonEncode(map);
    print(data);
    print(Config.customerUploadApi);
    Response response = await post(Config.customerUploadApi, body: data)
        .timeout(Duration(seconds: 5), onTimeout: () => null);
    if (response != null) {
      log(response.body);
      Map<String, dynamic> result = jsonDecode(response.body);
      List<dynamic> x = result['customers_synced'];
      print('ID: ${x[0]['id']}\n SERVER ID: ${x[0]['remote_id']}');
      String id = x[0]['id'];
      String remoteId = x[0]['remote_id'];
      int y = await (await LocalDatabase.database.getDatabase()).update(CustomerTable.TABLE_NAME, {CustomerTable.SERVER_ID: id, CustomerTable.IS_UPLOADED: '1'},
          where: '${CustomerTable.LOCAL_ID} = ?', whereArgs: [remoteId]);
      print('Customer server id update value : $y');
      return true;
    } else {
      return false;
    }
  }

  static Future<String> codeGenerator(String prefix, int id) async {
    String code = '$prefix/';
    String deviceId;
    deviceId = await Config.deviceKey;
    if (int.parse(deviceId) < 10) {
      deviceId = '0$deviceId/';
    }
    String digits = '';
    if (id < 10) {
      digits = '000$id';
    } else if (id < 100) {
      digits = '00$id';
    } else if (id < 1000) {
      digits = '0$id';
    } else {
      digits = '$id';
    }
    return code + deviceId + digits;
  }
}
