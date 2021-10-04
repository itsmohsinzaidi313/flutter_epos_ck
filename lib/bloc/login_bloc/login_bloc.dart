import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';
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
            ipAddress: await Config.serverIp, message: 'Welcome.');
        if (await _loginStatus) {
          yield* attemptLogin(
              username: await _username, password: await _password);
        }
        // final response = await UsersRepo.repo.users;
        // if (response.status) {
        //   yield UsersLoaded(
        //       list: (response.data as List<dynamic>)
        //           .map((e) => User.fromJson(e))
        //           .toList());
        // } else {}
      } else if (event is IpAddressChanged) {
        if (event.ipaddress == '') {
          yield InvalidIpAddress(message: 'Ipaddress is required.');
        } else {
          Config.serverIp = Future.value(event.ipaddress);
          yield ValidIpAddress(message: 'Server IP saved.');
        }
      }
      //else if (event is UsernameChanged) {
      //   if (event.username == '') {
      //     yield InvalidUsername(message: 'Username is required.');
      //   } else {
      //     _username = Future.value(event.username);
      //     yield ValidUsername();
      //   }
      // } else if (event is PasswordChanged) {
      //   if (event.password == '') {
      //     yield InvalidPassword(message: 'Password is required.');
      //   } else {
      //     _password = Future.value(event.password);
      //     yield ValidPassword();
      //   }
      // }
      else if (event is LoginPressed) {
        if (event.username == '' ||
            event.password == '' ||
            event.ipaddress == '') {
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
      final response =
          await LoginRepo.repo.login(username: username, password: password);
      if (response.statusCode == HttpStatus.ok) {
        final json = jsonDecode(response.body);
        Config.user = User.fromJson(json);
        _loginStatus = Future.value(true);
        this._username = Future.value(username);
        this._password = Future.value(password);
        yield LoginSuccessful(message: 'Login successful.');
      } else {
        yield LoginFailed(message: jsonDecode(response.body)['Message']);
      }
    } catch (e) {
      yield LoginFailed(message: e.toString());
    }
  }
}
