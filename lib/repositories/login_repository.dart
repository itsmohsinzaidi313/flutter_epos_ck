import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get_mac/get_mac.dart';
import 'package:pos_app/repositories/general_repository.dart';
import 'package:pos_app/shared/app_library.dart';
import 'package:pos_app/shared/config.dart';
import 'package:http/http.dart';
import 'package:pos_app/models/server_response.dart';

class LoginRepo {
  static LoginRepo repo = LoginRepo._internal();
  LoginRepo._internal();
  Future<bool> login(
      {@required String username, @required String password}) async => false;
}
