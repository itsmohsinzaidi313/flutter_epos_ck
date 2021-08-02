import 'dart:convert';
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
}
