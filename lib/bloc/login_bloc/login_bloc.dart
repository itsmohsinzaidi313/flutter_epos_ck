import 'dart:async';
import 'dart:developer';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:pos_app/models/objects/user.dart';
import 'package:pos_app/repositories/login_repository.dart';
import 'package:pos_app/shared/config.dart';
import 'package:shared_preferences/shared_preferences.dart';
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
        yield LoginBlocInitial(
            deviceKey: await Config.deviceKey, message: 'Welcome.');
        if (await _loginStatus) {
          yield* attemptLogin(
              username: await _username, password: await _password);
        }
      } else if (event is DeviceKeyChanged) {
        if (event.ipaddress == '') {
          yield InvalidDeviceKey(message: 'Device key is required.');
        } else {
          Config.deviceKey = Future.value(event.ipaddress);
          yield ValidIpAddress(message: 'Device key saved.');
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
          await LoginRepo.repo.login(username: username, password: password);
      if (status) {
        yield LoginSuccessful(message: 'Login successful.');
      } else {
        yield LoginFailed(message: 'Invalid Username/Password');
      }
    } catch (e) {
      yield LoginFailed(message: e.toString());
    }
  }
}
