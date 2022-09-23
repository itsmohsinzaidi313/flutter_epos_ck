import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:http/http.dart';
import 'package:meta/meta.dart';
import 'package:pos_app/models/user.dart';
import 'package:pos_app/repositories/login_repository.dart';
import 'package:pos_app/shared/app_library.dart';
import 'package:pos_app/shared/config.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'login_bloc_event.dart';
part 'login_bloc_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  LoginBloc()
      : super(LoginBlocInitial(ipAddress: '', password: '', username: '')) {
    on<LoginInit>((event, emit) async {
      try {
        // TODO: Disable for production
        // await (await SharedPreferences.getInstance()).clear();
        Config.ipAddress = await Config.serverIp;

        emit(LoginBlocInitial(
          ipAddress: Config.ipAddress,
          username: await _username,
          password: await _password,
        ));
        if (await _loginStatus) {
          emit(LoadingState(message: 'Logging in please wait...'));
          await attemptLogin(
              emit: emit, username: await _username, password: await _password);
        }
      } catch (e) {
        emit(ErrorState(message: e.toString()));
      }
    });
    on<IpAddressChanged>((event, emit) async {
      try {
        if (event.ipaddress == '') {
          emit(ErrorState(message: 'Ipaddress is required.'));
        } else {
          emit(LoadingState(message: 'Please wait...'));
          await checkServerStatus(emit, event.ipaddress);
        }
      } catch (e) {
        emit(ErrorState(message: e.toString()));
      }
    });
    on<LoginPressed>((event, emit) async {
      if (event.username == '' ||
          event.password == '' ||
          event.ipaddress == '') {
        emit(ErrorState(message: 'Please check all fields.'));
      } else {
        emit(LoadingState(message: 'Please wait...'));
        await attemptLogin(
          emit: emit,
          username: event.username,
          password: event.password,
        );
      }
    });
    on<LogoutPressed>((event, emit) {
      _loginStatus = Future.value(false);
      _username = Future.value('');
      _password = Future.value('');
    });
  }

  // REMEMBER LOGIN
  Future<bool> get _loginStatus async =>
      ((await SharedPreferences.getInstance()).getBool('loginStatus') ??
          Future.value(false)) as FutureOr<bool>;
  set _loginStatus(Future<bool> fLoginStatus) =>
      SharedPreferences.getInstance().then((pref) => fLoginStatus
          .then((loginStatus) => pref.setBool('loginStatus', loginStatus)));

  Future<String> get _username async =>
      (await SharedPreferences.getInstance()).getString('username') ?? '';
  set _username(Future<String?> fUsername) =>
      SharedPreferences.getInstance().then((pref) =>
          fUsername.then((username) => pref.setString('username', username!)));

  Future<String> get _password async =>
      (await SharedPreferences.getInstance()).getString('password') ?? '';
  set _password(Future<String?> fPassword) =>
      SharedPreferences.getInstance().then((pref) =>
          fPassword.then((password) => pref.setString('password', password!)));

  Future<void> attemptLogin(
      {required Emitter<LoginState> emit,
      String? username,
      String? password}) async {
    try {
      final response =
          await LoginRepo.repo.login(username: username, password: password);
      if (response.statusCode == HttpStatus.ok) {
        final user = User.fromJson(jsonDecode(response.body));
        Config.user = user;
        _loginStatus = Future.value(true);
        this._username = Future.value(username);
        this._password = Future.value(password);
        emit(LoadedState(
            message: 'Login successful.', allowLogin: true, user: user));
      } else if (response.statusCode == HttpStatus.unauthorized) {
        emit(ErrorState(message: 'Invalid username/password'));
      } else {
        emit(ErrorState(message: Lib.getMessage(response)));
      }
    } catch (e) {
      emit(ErrorState(message: e.toString()));
    }
  }

  Future<void> checkServerStatus(
      Emitter<LoginState> emit, String ipAddress) async {
    Config.ipAddress = ipAddress;
    final Response response = await get(Uri.parse(Config.serverStatusApi))
        .timeout(Duration(seconds: Config.SERVER_TIMEOUT),
            onTimeout: () => Lib.timeout)
        .onError((dynamic error, stackTrace) =>
            Lib.httpErrorResponseHandler(error: error));
    if (response.statusCode == HttpStatus.ok) {
      Config.serverIp = Future<String>.value(ipAddress);
      emit(LoadedState(message: 'Server ip address saved'));
    } else if (response.statusCode == HttpStatus.requestTimeout) {
      emit(ErrorState(
        message: (jsonDecode(response.body) as Map<String, dynamic>)['Message'],
      ));
    } else {
      emit(ErrorState(
        message:
            'Server did not respond to request.\nPlease check the ip address or server configurations',
      ));
    }
  }
}
