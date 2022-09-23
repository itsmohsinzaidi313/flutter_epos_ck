part of 'login_bloc.dart';

@immutable
abstract class LoginEvent{}

class IpAddressChanged extends LoginEvent {
  final String ipaddress;
  IpAddressChanged({required this.ipaddress});
}

class UsernameChanged extends LoginEvent {
  final String username;
  UsernameChanged({required this.username});
}

class LoginInit extends LoginEvent {
}

class PasswordChanged extends LoginEvent {
  final String password;
  PasswordChanged({required this.password});
}

class SubmitPressed extends LoginEvent {
  final String ipaddress;
  SubmitPressed({required this.ipaddress});
}

class LoginPressed extends LoginEvent {
  final String ipaddress;
  final String username;
  final String password;
  LoginPressed(
      {required this.ipaddress,
      required this.username,
      required this.password});
}

class SwitchChanged extends LoginEvent {
  final bool online;
  SwitchChanged({required this.online});
}

class LogoutPressed extends LoginEvent {}