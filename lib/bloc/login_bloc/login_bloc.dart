import 'dart:async';
import 'dart:developer';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:pos_app/models/objects/user.dart';
import 'package:pos_app/repositories/login_repository.dart';
import 'package:pos_app/shared/config.dart';
import 'package:shared_preferences/shared_preferences.dart';
part 'login_bloc_event.dart';
part 'login_bloc_state.dart';

class LoginBloc extends Bloc<LoginBlocEvent, LoginBlocState> {
  LoginBloc() : super(LoginBlocInitial());

  @override
  Stream<LoginBlocState> mapEventToState(
    LoginBlocEvent event,
  ) async* {
    if (event is LoginInit) {
      final pref = await SharedPreferences.getInstance();
      Config.serverIp = pref.getString('ipAddress');
      yield LoginBlocInitial(ipAddress: Config.serverIp);
    } else if (event is IpAddressChanged) {
      if (event.ipaddress == '') {
        yield InvalidIpAddress(message: 'Ipaddress is required.');
      } else {
        final pref = await SharedPreferences.getInstance();
        if (await pref.setString('ipAddress', event.ipaddress)) {
          Config.serverIp = event.ipaddress;
          yield ValidIpAddress(message: 'Server IP saved.');
        } else {
          yield ValidIpAddress(message: 'Server IP saved.');
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
        yield ValidSubmission();
        try {
          final response = await LoginRepo.repo
              .login(username: event.username, password: event.password);
          if (response.status) {
            Config.user = User.fromJson(response.data);
            yield Successful();
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
