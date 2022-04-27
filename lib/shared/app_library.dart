import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
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
    final message = {'Status': false, 'Message': error.toString(), 'Data': 0};
    final int httpStatusCode = HttpStatus.connectionClosedWithoutResponse;
    if (error is SocketException) {
      log('Error: ${error.message}}', error: error, name: caller);
      message['Message'] = error.message;
    } else if (error is FormatException) {
      log('Error: ${error.message}}', error: error, name: caller);
    }  else {
      message['Message'] = 'Unknown error has occured.';
    }
    return Response(jsonEncode(message), httpStatusCode);
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

  static bool validateIpAddress(String ipAddress) =>
      RegExp(r'^[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+:[0-9]+$').hasMatch(ipAddress);

  static T getArguments<T>(BuildContext context) =>
      ModalRoute.of(context).settings.arguments as T;
}
