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
    if (event is LoginInit) {
      final pref = await SharedPreferences.getInstance();
      Config.serverIp = pref.getString('ipAddress');
      yield LoginBlocInitial(ipAddress: Config.serverIp, message: 'Welcome.');
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
        final pref = await SharedPreferences.getInstance();
        if (await pref.setString('ipAddress', event.ipaddress)) {
          Config.serverIp = event.ipaddress;
          yield ValidIpAddress(
              message: 'Server IP saved please restart application.');
        } else {
          yield ValidIpAddress(message: 'Server IP cannot be saved.');
        }
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
        try {
          final response = await LoginRepo.repo
              .login(username: event.username, password: event.password);
          if (response.status) {
            Config.user = User.fromJson(response.data);
            yield Successful(message: 'Login successful.');
          } else {
            yield Failed(message: response.message);
          }
        } catch (e) {
          log('Login Bloc', error: e);
          yield Failed(message: e.toString());
        }
      }
    } else if (event is SwitchChanged) {
      if (event.online) {
      } else {}
    }
  }
}
