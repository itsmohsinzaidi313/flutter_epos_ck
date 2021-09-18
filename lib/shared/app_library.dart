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

  static Future<int> uploadCustomer(Customer customer) async {
    int remoteId = 0;
    Map<String, dynamic> data = {
      'user_id': (await UsersRepo.repo.getCurrentUser()).id,
      'json': jsonEncode({
        'remote_id': customer.localId,
        CustomerTable.NAME: customer.name,
        CustomerTable.PHONE: customer.phone,
        CustomerTable.ADDRESS: customer.address,
        'device_key': await Config.deviceKey,
        CustomerTable.USER_ID: (await UsersRepo.repo.getCurrentUser()).id,
        CustomerTable.COMPANY_ID:
            (await GeneralRepo.repo.getCurrentDevice()).companyId,
        'outlet_id': (await UsersRepo.repo.getCurrentUser()).outletId
      }),
    };
    Response response = await post(await Config.customerUploadApi, body: data)
        .timeout(Duration(seconds: Config.SERVER_TIMEOUT),
            onTimeout: () => null);
    if (response != null) {
      Map<String, dynamic> result = jsonDecode(response.body);
      bool status = result['status'];
      if (status) {
        List<dynamic> x = result['customers_synced'];
        remoteId = x[0]['remote_id'];
        await (await LocalDatabase.database.getDatabase()).update(
            CustomerTable.TABLE_NAME,
            {CustomerTable.REMOTE_ID: remoteId, CustomerTable.IS_UPLOADED: '1'},
            where: '${CustomerTable.LOCAL_ID} = ?',
            whereArgs: [customer.localId]);
      }
      return remoteId;
    } else {
      return remoteId;
    }
  }

  static Future<String> codeGenerator(String prefix, int id) async {
    String code = '$prefix/';
    String deviceId;
    final device = await GeneralRepo.repo.getCurrentDevice();
    deviceId = device.serverId.toString();
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

  static Future<Response> internetConnectivityErrorHandler(
      dynamic error, StackTrace stackTrace) async {
    return Response(installJson, 200);
  }

  static const String installJson =
      '{"company":[{"id":"1","currency":"Rs.","timezone":"Asia\/KArachi","date_format":"d\/m\/Y","outlet_id":"1","name":"Devaj Technology","email":null,"phone_1":"0213-1234567","phone_2":"0213-1234567","address":"Karachi, Pakistan","status":"Active","date_added":"2021-04-07 18:47:17","expiry_date":null,"token":null}],"outlet":[{"id":"1","outlet_name":"Devaj","outlet_code":"000001","address":"Karachi","phone":"+92 315 2860863","invoice_print":null,"starting_date":"2021-04-08","invoice_footer":"So Good","collect_tax":"Yes","pre_or_post_payment":"Post Payment","user_id":"1","company_id":"1","del_status":"Live","branch_id":null,"printer_ips":[{"id":"4","outlet_id":"1","printer_ip":"12.12.11.1","date_added":"2021-08-07 18:31:47","date_modified":null},{"id":"5","outlet_id":"1","printer_ip":" 192.168.192.1","date_added":"2021-08-07 18:31:47","date_modified":null}]}],"device":[{"id":"1","outlet_id":"1","company_id":"1","device_key":"923746037","del_status":"Live","is_installed":"1","date_added":"2021-04-16 17:58:45","date_modified":null}],"users":[{"id":"1","full_name":"Devaj Testing","phone":"01812391633","email_address":"admin@devaj.co","password":"123456","designation":null,"will_login":"No","role":"Admin","outlet_id":"1","company_id":"1","account_creation_date":"2018-02-17 07:28:32","language":"english","last_login":"2019-01-01 00:00:00","active_status":"Active","del_status":"Live"},{"id":"25","full_name":"Waiter","phone":"123456789091","email_address":"waiter@devaj.co","password":"1234567","designation":"Waiter","will_login":"Yes","role":"User","outlet_id":"1","company_id":"1","account_creation_date":"0000-00-00 00:00:00","language":"english","last_login":"0000-00-00 00:00:00","active_status":"Active","del_status":"Live"},{"id":"28","full_name":"Waiter1","phone":"1234567890098765","email_address":"Waiter1@devaj.co","password":"","designation":"Waiter1","will_login":"No","role":"","outlet_id":"1","company_id":"1","account_creation_date":"0000-00-00 00:00:00","language":"english","last_login":"0000-00-00 00:00:00","active_status":"Active","del_status":"Live"},{"id":"29","full_name":"Waiter 11","phone":"12345678","email_address":"waiter11@devaj.co","password":"","designation":"Waiter","will_login":"No","role":"","outlet_id":"1","company_id":"1","account_creation_date":"0000-00-00 00:00:00","language":"english","last_login":"0000-00-00 00:00:00","active_status":"Active","del_status":"Live"}],"vatamount":[],"tables":[{"id":"1","name":"1","sit_capacity":"4","position":"","description":"","user_id":"1","outlet_id":"1","company_id":"1","del_status":"Live"},{"id":"2","name":"2","sit_capacity":"4","position":"","description":"","user_id":"1","outlet_id":"1","company_id":"1","del_status":"Live"},{"id":"3","name":"3","sit_capacity":"4","position":"","description":"","user_id":"1","outlet_id":"1","company_id":"1","del_status":"Live"},{"id":"4","name":"4","sit_capacity":"4","position":"","description":"","user_id":"1","outlet_id":"1","company_id":"1","del_status":"Live"}],"categories":[{"id":"1","category_name":"Fast Food","description":"","user_id":"1","company_id":"1","del_status":"Live","department_id":"5","parent_id":"0"},{"id":"2","category_name":"Bar B Q","description":"","user_id":"1","company_id":"1","del_status":"Live","department_id":"5","parent_id":"0"},{"id":"3","category_name":"Beverages","description":"","user_id":"1","company_id":"1","del_status":"Live","department_id":"6","parent_id":"0"},{"id":"4","category_name":"Pizza","description":"","user_id":"1","company_id":"1","del_status":"Live","department_id":"5","parent_id":"0"}],"modifiers":[],"item_menus":[{"id":"1","code":"001","name":"Name 1","sale_price":"500.00","photo":null,"category_id":"1","department_id":"5","category_name":"Fast Food","percentage":null},{"id":"2","code":"002","name":"CHICKEN BURGER","sale_price":"200.00","photo":null,"category_id":"1","department_id":"5","category_name":"Fast Food","percentage":null},{"id":"3","code":"003","name":"BEEF BURGER","sale_price":"250.00","photo":null,"category_id":"1","department_id":"5","category_name":"Fast Food","percentage":null},{"id":"4","code":"004","name":"SMALL PIZZA","sale_price":"300.00","photo":null,"category_id":"4","department_id":"5","category_name":"Pizza","percentage":null},{"id":"5","code":"005","name":"REGULAR PIZZA","sale_price":"500.00","photo":null,"category_id":"4","department_id":"5","category_name":"Pizza","percentage":null},{"id":"6","code":"006","name":"LARGE PIZZA","sale_price":"700.00","photo":null,"category_id":"4","department_id":"5","category_name":"Pizza","percentage":null},{"id":"7","code":"007","name":"CHICKEN TIKKA","sale_price":"280.00","photo":null,"category_id":"2","department_id":"5","category_name":"Bar B Q","percentage":null},{"id":"8","code":"008","name":"CHICKEN MALAI BOTI","sale_price":"450.00","photo":null,"category_id":"2","department_id":"5","category_name":"Bar B Q","percentage":null},{"id":"9","code":"009","name":"BEEF BIHARI BOTI","sale_price":"450.00","photo":null,"category_id":"2","department_id":"5","category_name":"Bar B Q","percentage":null},{"id":"10","code":"010","name":"REGULAR DRINK","sale_price":"50.00","photo":null,"category_id":"3","department_id":"6","category_name":"Beverages","percentage":null},{"id":"11","code":"011","name":"SLICE JUICE","sale_price":"50.00","photo":null,"category_id":"3","department_id":"6","category_name":"Beverages","percentage":null},{"id":"12","code":"012","name":"MOCKTAIL","sale_price":"150.00","photo":null,"category_id":"3","department_id":"6","category_name":"Beverages","percentage":null}],"item_modifiers":[],"customers":[{"id":"2","name":"shahrukh","phone":"03422299469","email":null,"address":"","gst_number":null,"area_id":null,"user_id":"1","company_id":"1","del_status":"Live","date_of_birth":null,"date_of_anniversary":null,"device_key":"923746037","remote_id":"2","outlet_id":"1"},{"id":"1","name":"WalkIn","phone":"123123","email":"@123","address":"Karachi","gst_number":"","area_id":null,"user_id":"1","company_id":"1","del_status":"Live","date_of_birth":"2021-08-01","date_of_anniversary":"2021-08-01","device_key":null,"remote_id":"1","outlet_id":null}],"payment_methods":[{"id":"1","name":"Cash","description":"Allows customer to pay cash","user_id":"1","company_id":"1","del_status":"Live"},{"id":"2","name":"Credit","description":"Allows customer to pay using a credit card","user_id":"1","company_id":"1","del_status":"Live"}],"expense_categories":[{"id":"1","name":"Entertainment","description":"","user_id":"1","company_id":"1","del_status":"Live"},{"id":"2","name":"Rent","description":"","user_id":"1","company_id":"1","del_status":"Live"},{"id":"3","name":"Salary","description":"","user_id":"1","company_id":"1","del_status":"Live"}],"department":[{"id":"5","outlet_id":"1","company_id":"1","name":"Kitchen","del_status":"Live","date_added":"2021-04-10 19:56:20","date_modified":"2021-08-07 18:42:06","printer_ips":[{"id":"1","department_id":"5","printer_ip":"192168.0.1","date_added":"2021-08-07 18:42:06","date_modified":null},{"id":"2","department_id":"5","printer_ip":"119.118.198.111","date_added":"2021-08-07 18:42:06","date_modified":null}]},{"id":"6","outlet_id":"1","company_id":"1","name":"Bar","del_status":"Live","date_added":"2021-04-10 20:26:41","date_modified":"2021-08-07 18:33:55","printer_ips":[]},{"id":"7","outlet_id":"1","company_id":"1","name":"Store","del_status":"Live","date_added":"2021-04-10 20:26:55","date_modified":"2021-08-07 18:33:40","printer_ips":[]}],"sales":[],"expenses":[],"registers":[]}';
}
