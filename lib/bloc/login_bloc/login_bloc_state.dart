part of 'login_bloc.dart';

@immutable
abstract class LoginState {}

class LoginBlocInitial extends LoginState {
  final String ipAddress;
  final String message;
  LoginBlocInitial({this.ipAddress, this.message});
}

class ValidIpAddress extends LoginState {
  final String message;
  ValidIpAddress({@required this.message});
}

class InvalidIpAddress extends LoginState {
  final String message;
  InvalidIpAddress({@required this.message});
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

class Successful extends LoginState {
  final String message;
  Successful({this.message});
}

class Failed extends LoginState {
  final String message;
  Failed({@required this.message});
}


class UsersLoaded extends LoginState {
  final List<User> list;
  UsersLoaded({this.list});
}