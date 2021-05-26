import 'dart:async';
import 'dart:developer';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:pos_app/models/objects/user.dart';
import 'package:pos_app/repositories/login_repository.dart';
import 'package:pos_app/repositories/users_repository.dart';
import 'package:pos_app/shared/config.dart';
import 'package:shared_preferences/shared_preferences.dart';
part 'login_bloc_event.dart';
part 'login_bloc_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  LoginBloc() : super(LoginBlocInitial());

  @override
  Stream<LoginState> mapEventToState(
    LoginEvent event,
  ) async* {
    try {
      if (event is LoginInit) {
        yield LoginBlocInitial(
            ipAddress: await Config.serverIp, message: 'Welcome.');
        if (await Config.loginStatus) {
          yield* attemptLogin(
              username: await Config.username, password: await Config.password);
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
      } else if (event is UsernameChanged) {
        if (event.username == '') {
          yield InvalidUsername(message: 'Username is required.');
        } else {
          yield ValidUsername();
        }
      } else if (event is PasswordChanged) {
        if (event.password == '') {
          yield InvalidPassword(message: 'Password is required.');
        } else {
          yield ValidPassword();
        }
      } else if (event is LoginPressed) {
        if (event.ipaddress == '' ||
            event.username == '' ||
            event.password == '') {
          yield InvalidSubmission(message: 'Please check all fields.');
        } else {
          yield ValidSubmission(message: 'Login request sent.');
          yield* attemptLogin(
              username: event.username, password: event.password);
        }
      } else if (event is SwitchChanged) {
        if (event.online) {
        } else {}
      }
    } catch (e) {
      yield LoginFailed(message: e.toString());
    }
  }

  Stream<LoginState> attemptLogin({String username, String password}) async* {
    final response =
        await LoginRepo.repo.login(username: username, password: password);
    if (response.status) {
      Config.user = User.fromJson(response.data);
      Config.loginStatus = Future.value(true);
      Config.username = Future.value(username);
      Config.password = Future.value(password);
      yield LoginSuccessful(message: 'Login successful.');
    } else {
      yield LoginFailed(message: response.message);
    }
  }
}
