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

  static Response get timeout => Response(
      jsonEncode({
        'Message': 'Connection request timeout',
      }),
      HttpStatus.requestTimeout);

  static Response httpErrorResponseHandler(
      {Exception error, String caller = ''}) {
    log('Error: ${error.toString()}', error: error, name: caller);
    final message = {'Status': false, 'Message': error.toString(), 'Data': 0};
    if (error is SocketException) {
      message['Message'] = 'Cannot connect to server';
    }
    return Response(
        jsonEncode(message), HttpStatus.connectionClosedWithoutResponse);
  }

  static String getMessage(Response response) =>
      jsonDecode(response.body)['Message'];

  static String getDateTime24HR() {
    final formatter = DateFormat('yyyy-MM-dd HH:mm:ss');
    return formatter.format(DateTime.now());
  }

  static String getDateTime12HR() {
    final formatter = DateFormat('yyyy-MM-dd h:mm a');
    return formatter.format(DateTime.now());
  }

  static String getTime12HR() {
    final formatter = DateFormat.jm();
    return formatter.format(DateTime.now());
  }

  static String getDate() {
    final formatter = DateFormat('yyyy-MM-dd');
    return formatter.format(DateTime.now());
  }
}
