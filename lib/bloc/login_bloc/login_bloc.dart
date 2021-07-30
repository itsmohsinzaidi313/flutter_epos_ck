import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:pos_app/models/user.dart';
import 'package:pos_app/repositories/users_repository.dart';
import 'package:pos_app/shared/config.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart';
part 'login_bloc_event.dart';
part 'login_bloc_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  LoginBloc() : super(LoginBlocInitial());

  // REMEMBER LOGIN
  Future<bool> get _loginStatus async =>
      (await SharedPreferences.getInstance()).getBool('loginStatus') ??
      Future.value(false);
  set _loginStatus(Future<bool> fLoginStatus) =>
      SharedPreferences.getInstance().then((pref) => fLoginStatus
          .then((loginStatus) => pref.setBool('loginStatus', loginStatus)));

  Future<String> get _username async =>
      (await SharedPreferences.getInstance()).getString('username');
  set _username(Future<String> fUsername) =>
      SharedPreferences.getInstance().then((pref) =>
          fUsername.then((username) => pref.setString('username', username)));

  Future<String> get _password async =>
      (await SharedPreferences.getInstance()).getString('password');
  set _password(Future<String> fPassword) =>
      SharedPreferences.getInstance().then((pref) =>
          fPassword.then((password) => pref.setString('password', password)));

  @override
  Stream<LoginState> mapEventToState(
    LoginEvent event,
  ) async* {
    try {
      if (event is LoginInit) {
        deleteDatabase(Config.DATABASE_NAME);
        if (!(await databaseExists(Config.DATABASE_NAME))) {
          yield DatabaseMissing();
        }
        yield LoginBlocInitial(
            deviceKey: await Config.deviceKey, message: 'Welcome.');
        if (await _loginStatus) {
          yield* attemptLogin(
              username: await _username, password: await _password);
        }
      } else if (event is DeviceKeyChanged) {
        if (event.deviceKey == '') {
          yield InvalidDeviceKey(message: 'DeviceKey is required.');
        } else {
          Config.deviceKey = Future.value(event.deviceKey);
          yield ValidDevicekey(message: 'DeviceKey saved.');
        }
      } else if (event is LoginPressed) {
        if (event.username == '' ||
            event.password == '' ||
            event.deviceKey == '') {
          yield InvalidSubmission(message: 'Please check all fields.');
        } else {
          yield ValidSubmission(message: 'Login request sent.');
          yield* attemptLogin(
              username: event.username, password: event.password);
        }
      } else if (event is LogoutPressed) {
        _loginStatus = Future.value(false);
        _username = Future.value('');
        _password = Future.value('');
      } else if (event is SwitchChanged) {
        if (event.online) {
        } else {}
      }
    } catch (e) {
      yield LoginFailed(message: e.toString());
    }
  }

  Stream<LoginState> attemptLogin({String username, String password}) async* {
    try {
      final status =
          await UsersRepo.repo.login(email: username, password: password);
      if (status) {
        this._username = Future.value(username);
        this._password = Future.value(password);
        yield LoginSuccessful(message: 'Login successful.');
      } else {
        yield LoginFailed(
            message:
                'Login failed. Either email/password is invalid or user does not exist.');
      }
    } catch (e) {
      yield LoginFailed(message: e.toString());
    }
  }
}
