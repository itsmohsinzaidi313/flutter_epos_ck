import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pos_app/models/objects/user.dart';

class Config {
  static const String appTitle = 'POS';
  static String serverIp;
  static User user;
  static String _apiCommon = 'http://$serverIp/api/pos';

  static String get getLoginApi => '$_apiCommon/Login';
  static String get getCategoryApi => '$_apiCommon/Category';
  static String get getItemsApi => '$_apiCommon/Item';
  static String get getTablesApi => '$_apiCommon/Table';
  static String get getWaitersApi => '$_apiCommon/Waiters';
  static String get getOrdersApi => '$_apiCommon/Order';
  static String get getCustomerApi => '$_apiCommon/Customer';
  static String get getUsersApi => '$_apiCommon/User';

  static String _authToken;
  static set authToken(String value) => _authToken = value;
  static String get authToken => _authToken;
  static String activeStatus = 'Online';
  static const int SCREEN_START_TIME = 3;
  static const int SNACKBAR_TIMEOUT = 1;
  static const int SERVER_TIMEOUT = 30;

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
