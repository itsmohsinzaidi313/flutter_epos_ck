import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:flutter/services.dart';
import 'package:http/http.dart';
import 'package:intl/intl.dart';

class Lib {
  static forcePortraitView() async =>
      await SystemChrome.setPreferredOrientations(
          [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);

  static forceLandscapeView() async =>
      await SystemChrome.setPreferredOrientations(
          [DeviceOrientation.landscapeLeft, DeviceOrientation.landscapeRight]);

  // static Future<Response> get timeout => Future.value(Response(
  //     jsonEncode({'Status': false, 'Message': 'Offline', 'Data': 0}),
  //     HttpStatus.requestTimeout));

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

  static int getCurrentYear() {
    DateTime dateTime = DateTime.now();
    DateFormat formatDateTime = DateFormat("yyyy");
    int currentYear = int.parse(formatDateTime.format(dateTime));
    return currentYear;
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

  static get timeOutResponse => Response(
      jsonEncode({"Message": "Connection timeout"}), HttpStatus.requestTimeout);

  static Response httpErrorResponseHandler({Exception error, String caller = ''}) {
    log('Error: ${error.toString()}', error: error, name: caller);
    final map = {"Message": error.toString()};
    if (error is SocketException) {
      map['Message'] = 'Cannot connect to server';
    }
    return Response(jsonEncode(map), HttpStatus.serviceUnavailable);
  }
}
