import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Config {
  static const String appTitle = 'CLOUD KITCHEN';

  static const allowDineIn = true;
  static const allowTakeAway = true;
  static const allowDelivery = true;
  static const tempDevKey = '923746037';

  static Future<String> get deviceKey async {
    final pref = await SharedPreferences.getInstance();
    return pref.getString('deviceKey') ?? '0';
  }

  static set deviceKey(Future<String> fdeviceKey) =>
      SharedPreferences.getInstance().then((pref) => fdeviceKey
          .then((deviceKey) => pref.setString('deviceKey', deviceKey)));

  static String activeStatus = '';

  static const String DATABASE_NAME = 'CloudKitchen.db';
  static const int DATABASE_VERSION = 1;
  static const int APP_VERSION = 1;
  static const String URL_PREFIX = 'https://';
  static const String DOMIN = 'clients.devaj.technology/demos';
  static const String URL_COMMONS = '/cloud-kitchen/api';

  static get authToken async => '?auth=${await deviceKey}';

  static Future<String> get installApi async =>
      '$URL_PREFIX$DOMIN$URL_COMMONS/install${await authToken}&sale_limit=20&expense_limit=20';
  static Future<String> get addUpdateOrderApi async =>
      '$URL_PREFIX$DOMIN$URL_COMMONS/order${await authToken}';
  static Future<String> get customerUploadApi async =>
      '$URL_PREFIX$DOMIN$URL_COMMONS/customer${await authToken}';
  static Future<String> get openRegisterApi async =>
      '$URL_PREFIX$DOMIN$URL_COMMONS/openRegister${await authToken}';
  static Future<String> get closeRegisterApi async =>
      '$URL_PREFIX$DOMIN$URL_COMMONS/closeRegister${await authToken}';
  static Future<String> get shiftApi async =>
      '$URL_PREFIX$DOMIN$URL_COMMONS/shift${await authToken}';

  static const int SPLASH_DURATION = 3; //SECONDS
  static const int SNACKBAR_TIMEOUT = 1; //SECONDS
  static const int SERVER_TIMEOUT = 30; //SECONDS
  static const int SERVICE_CYCLE_DELAY = 5; //SECONDS

  static double getDeviceWidth(BuildContext context) =>
      MediaQuery.of(context).size.width;

  static double getDeviceHeight(BuildContext context) =>
      MediaQuery.of(context).size.height;

  static String getCurrentDateTime() {
    DateTime dateTime = DateTime.now();
    DateFormat formatDateTime = DateFormat.yMd().add_jm();
    String currentDateTime = formatDateTime.format(dateTime);
    return currentDateTime;
  }

  static String getCurrentDateTimeDBFormat() {
    DateTime dateTime = DateTime.now();
    DateFormat formatDateTime = DateFormat("yyyy-MM-dd HH:mm:ss");
    String currentDateTime = formatDateTime.format(dateTime);
    return currentDateTime;
  }

  static String getCurrentTime() {
    DateTime dateTime = DateTime.now();
    DateFormat formatDateTime = DateFormat("HH:mm:ss");
    String currentDateTime = formatDateTime.format(dateTime);
    return currentDateTime;
  }

  static String getCurrentShiftDate(String date) {
    DateFormat formatDateTime = DateFormat("yyyy-MM-dd");
    String currentDateTime = formatDateTime.format(DateTime.parse(date));
    return currentDateTime;
  }

  static String convertDateTimeToDate(DateTime date) {
    DateFormat formatDateTime = DateFormat("yyyy-MM-dd");
    String currentDateTime = formatDateTime.format(date);
    return currentDateTime;
  }

  static String getCurrentDate() {
    DateTime dateTime = DateTime.now();
    DateFormat formatDateTime = DateFormat("yyyy-MM-dd");
    String currentDate = formatDateTime.format(dateTime);
    return currentDate;
  }

  static String getCurrentTime24Format() {
    DateTime dateTime = DateTime.now();
    DateFormat formatDateTime = DateFormat("HH:mm:ss");
    String currentTime = formatDateTime.format(dateTime);
    return currentTime;
  }
}
