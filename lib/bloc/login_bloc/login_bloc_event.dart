part of 'login_bloc.dart';

@immutable
abstract class LoginEvent{}

class DeviceKeyChanged extends LoginEvent {
  final String ipaddress;
  DeviceKeyChanged({@required this.ipaddress});
}

class UsernameChanged extends LoginEvent {
  final String username;
  UsernameChanged({@required this.username});
}

class LoginInit extends LoginEvent {
}

class PasswordChanged extends LoginEvent {
  final String password;
  PasswordChanged({@required this.password});
}

class SubmitPressed extends LoginEvent {
  final String deviceKey;
  SubmitPressed({@required this.deviceKey});
}

class LoginPressed extends LoginEvent {
  final String deviceKey;
  final String username;
  final String password;
  LoginPressed(
      {@required this.deviceKey,
      @required this.username,
      @required this.password});
}

class SwitchChanged extends LoginEvent {
  final bool online;
  SwitchChanged({@required this.online});
}

class LogoutPressed extends LoginEvent {}