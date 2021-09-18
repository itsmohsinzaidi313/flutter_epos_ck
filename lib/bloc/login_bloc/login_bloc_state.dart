part of 'login_bloc.dart';

@immutable
abstract class LoginState {}

class LoginBlocInitial extends LoginState {
  final String deviceKey;
  final String message;
  LoginBlocInitial({this.deviceKey, this.message});
}

class ValidDevicekey extends LoginState {
  final String message;
  ValidDevicekey({@required this.message});
}

class InvalidDeviceKey extends LoginState {
  final String message;
  InvalidDeviceKey({@required this.message});
}

class ValidUsername extends LoginState {}

class InvalidUsername extends LoginState {
  final String message;
  InvalidUsername({@required this.message});
}

class ValidPassword extends LoginState {}

class InvalidPassword extends LoginState {
  final String message;
  InvalidPassword({@required this.message});
}

class ValidSubmission extends LoginState {
  final String message;
  ValidSubmission({this.message});
}

class InvalidSubmission extends LoginState {
  final String message;
  InvalidSubmission({@required this.message});
}

class LoginSuccessful extends LoginState {
  final String message;
  LoginSuccessful({this.message});
}

class LoginFailed extends LoginState {
  final String message;
  LoginFailed({@required this.message});
}


class UsersLoaded extends LoginState {
  final List<User> list;
  UsersLoaded({this.list});
}

class DatabaseMissing extends LoginState{}

class RegisterClosed extends LoginState {}