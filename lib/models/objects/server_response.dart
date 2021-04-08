import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart';

class ServerResponse {
  static const String StatusKey = 'Status';
  static const String MessageKey = 'Message';
  static const String DataKey = 'Data';

  final Response response;
  Map<String, dynamic> _map;
  bool get status => _map[StatusKey] == true && response.statusCode == 200 ? true : false;
  String get message => _map[MessageKey];
  dynamic get data => _map[DataKey];
  int get statusCode => response.statusCode;

  ServerResponse({@required this.response}) {
    _map = response == null
        ? {StatusKey: false, MessageKey: 'Timeout', DataKey: Null}
        : jsonDecode(response.body);
  }
}
