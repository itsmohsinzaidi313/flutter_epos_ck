import 'dart:convert';
import 'dart:typed_data';

import 'package:crypto/crypto.dart';
import 'package:device_info/device_info.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pos_app/models/user.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Config {
  static const String appTitle = 'KBC POS';
  static const String _AuthKey = '123';

  static const allowDineIn = true;
  static const allowTakeAway = true;
  static const allowDelivery = false;
  // APIS
  static Future<String> get serverIp async {
    final pref = await SharedPreferences.getInstance();
    return pref.getString('ipAddress') ?? '';
  }

  static set serverIp(Future<String> fServerIp) =>
      SharedPreferences.getInstance().then((pref) =>
          fServerIp.then((serverIp) => pref.setString('ipAddress', serverIp)));

  static User user;
  static Future<String> get _apiCommon async =>
      'http://${await serverIp}/api/pos';

  static String get _key => md5.convert(utf8.encode(_AuthKey)).toString();

  static Future<String> get getLoginApi async =>
      '${await _apiCommon}/Login?key=$_key';
  static Future<String> get getTablesApi async =>
      '${await _apiCommon}/Table?key=$_key';
  static Future<String> get getWaitersApi async =>
      '${await _apiCommon}/Waiters?key=$_key';
  static Future<String> get ordersApi async =>
      '${await _apiCommon}/Order?key=$_key';
  static Future<String> get getCustomerApi async =>
      '${await _apiCommon}/Customer?key=$_key';
  static Future<String> get getUsersApi async =>
      '${await _apiCommon}/User?key=$_key';
  static Future<String> get postFeedbackApi async =>
      '${await _apiCommon}/Feedback?key=$_key';
  static Future<String> get getMenuApi async =>
      '${await _apiCommon}/Menu?key=$_key';
  static Future<String> get serverStatusApi async =>
      '${await _apiCommon}/Status?key=$_key';

  static AndroidDeviceInfo _deviceData;
  static AndroidDeviceInfo get deviceData {
    if (_deviceData == null) {
      DeviceInfoPlugin().androidInfo.then((value) => _deviceData = value);
    }
    return _deviceData;
  }

  static String activeStatus = 'Online';
  static const int SCREEN_START_TIME = 3;
  static const int SNACKBAR_TIMEOUT = 1;
  static const int SERVER_TIMEOUT = 5;

  static const int serviceCycleDelay = 5; //SECONDS

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
