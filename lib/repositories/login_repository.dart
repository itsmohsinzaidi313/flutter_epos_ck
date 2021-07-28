import 'package:flutter/material.dart';

class LoginRepo {
  static LoginRepo repo = LoginRepo._internal();
  LoginRepo._internal();
  Future<bool> login(
      {@required String username, @required String password}) async => false;
}
