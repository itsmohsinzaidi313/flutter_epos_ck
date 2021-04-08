part of 'login_bloc.dart';

@immutable
abstract class LoginBlocState extends Equatable {}

class LoginBlocInitial extends LoginBlocState {
  final String ipAddress;
  LoginBlocInitial({this.ipAddress});
  @override
  List<Object> get props => [];
}

class ValidIpAddress extends LoginBlocState {
  final String message;
  ValidIpAddress({@required this.message});
  @override
  List<Object> get props => [this.message];
}

class InvalidIpAddress extends LoginBlocState {
  final String message;
  InvalidIpAddress({@required this.message});

  @override
  List<Object> get props => [this.message];
}

class ValidUsername extends LoginBlocState {
  @override
  List<Object> get props => [];
}

class InvalidUsername extends LoginBlocState {
  final String message;
  InvalidUsername({@required this.message});

  @override
  List<Object> get props => [this.message];
}

class ValidPassword extends LoginBlocState {
  @override
  List<Object> get props => [];
}

class InvalidPassword extends LoginBlocState {
  final String message;
  InvalidPassword({@required this.message});

  @override
  List<Object> get props => [this.message];
}

class ValidSubmission extends LoginBlocState {
  @override
  List<Object> get props => [];
}

class InvalidSubmission extends LoginBlocState {
  final String message;
  InvalidSubmission({@required this.message});

  @override
  List<Object> get props => [this.message];
}

class Successful extends LoginBlocState {
  @override
  List<Object> get props => [];
}

class Failed extends LoginBlocState {
  final String message;
  Failed({@required this.message});

  @override
  List<Object> get props => [message];
}
