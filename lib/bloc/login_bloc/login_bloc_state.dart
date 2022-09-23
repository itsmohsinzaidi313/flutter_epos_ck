part of 'login_bloc.dart';

@immutable
abstract class LoginState {}

class LoginBlocInitial extends LoginState {
  final String ipAddress;
  final String username;
  final String password;
  LoginBlocInitial({
    required this.ipAddress,
    required this.username,
    required this.password,
  });
}

class LoadingState extends LoginState {
  final String message;
  LoadingState({this.message = ''});
}

class LoadedState extends LoginState {
  final String ipAddress;
  final String username;
  final String password;
  final bool allowLogin;
  final String message;
  final User? user;

  LoadedState({
    this.ipAddress = '',
    this.username = '',
    this.password = '',
    this.allowLogin = false,
    this.message = '',
    this.user,
  });
}

class ErrorState extends LoginState {
  final String? message;
  ErrorState({required this.message});
}

// class ValidIpAddress extends LoginState {
//   final String message;
//   ValidIpAddress({@required this.message});
// }

// class InvalidIpAddress extends LoginState {
//   final String message;
//   InvalidIpAddress({@required this.message});
// }

// class ValidUsername extends LoginState {}

// class InvalidUsername extends LoginState {
//   final String message;
//   InvalidUsername({@required this.message});
// }

// class ValidPassword extends LoginState {}

// class InvalidPassword extends LoginState {
//   final String message;
//   InvalidPassword({@required this.message});
// }

// class ValidSubmission extends LoginState {
//   final String message;
//   ValidSubmission({this.message});
// }

// class InvalidSubmission extends LoginState {
//   final String message;
//   InvalidSubmission({@required this.message});
// }

// class LoginSuccessful extends LoginState {
//   final String message;
//   LoginSuccessful({this.message});
// }

// class LoginFailed extends LoginState {
//   final String message;
//   LoginFailed({@required this.message});
// }


// class UsersLoaded extends LoginState {
//   final List<User> list;
//   UsersLoaded({this.list});
// }