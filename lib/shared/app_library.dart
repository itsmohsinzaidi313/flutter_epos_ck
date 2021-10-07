import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:flutter/services.dart';
import 'package:http/http.dart';

class Lib {
  static forcePortraitView() async =>
      await SystemChrome.setPreferredOrientations(
          [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);

  static forceLandscapeView() async =>
      await SystemChrome.setPreferredOrientations(
          [DeviceOrientation.landscapeLeft, DeviceOrientation.landscapeRight]);

  static Response get timeout => Response(
      jsonEncode({
        'Status': false,
        'Message': 'Connection request timeout',
        'Data': 0
      }),
      HttpStatus.requestTimeout);

  static Response httpErrorResponseHandler(
      {Exception error, String caller = ''}) {
    log('Error: ${error.toString()}', error: error, name: caller);
    final message = {'Status': false, 'Message': error.toString(), 'Data': 0};
    if (error is SocketException) {
      message['Message'] = 'Cannot connect to server';
    }
    return Response(jsonEncode(message), HttpStatus.requestTimeout);
  }

  static String getMessage(Response response) => jsonDecode(response.body)['Message'];
}
