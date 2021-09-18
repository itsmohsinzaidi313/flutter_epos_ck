import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart';

class ServerResponse {
  static const String _statusKey = 'Status';
  static const String _messageKey = 'Message';
  static const String _dataKey = 'Data';

  final Response response;
  Map<String, dynamic> _map;
  bool get status =>
      _map[_statusKey] == true && response.statusCode == 200 ? true : false;
  String get message => _map[_messageKey];
  dynamic get data => _map[_dataKey];
  int get statusCode => response.statusCode;

  ServerResponse({@required this.response}) {
    _map = response == null
        ? {_statusKey: false, _messageKey: 'Timeout', _dataKey: Null}
        : jsonDecode(response.body);
  }
}
