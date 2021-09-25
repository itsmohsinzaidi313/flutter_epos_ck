import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';

class ServerResponse extends Equatable{
  static const String _StatusKey = 'Status';
  static const String _MessageKey = 'Message';
  static const String _DataKey = 'Data';

  final Response response;
  Map<String, dynamic> _map;
  bool get status => _map[_StatusKey] == true && response.statusCode == 200 ? true : false;
  String get message => _map[_MessageKey];
  dynamic get data => _map[_DataKey];
  int get statusCode => response.statusCode;

  ServerResponse({@required this.response}) {
    _map = response == null
        ? {_StatusKey: false, _MessageKey: 'Timeout', _DataKey: Null}
        : jsonDecode(response.body);
  }

  @override
  List<Object> get props => [_map];
}
