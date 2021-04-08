part of 'login_bloc.dart';

@immutable
abstract class LoginBlocEvent extends Equatable {}

class IpAddressChanged extends LoginBlocEvent {
  final String ipaddress;
  IpAddressChanged({@required this.ipaddress});

  @override
  List<Object> get props => [this.ipaddress];
}

class UsernameChanged extends LoginBlocEvent {
  final String username;
  UsernameChanged({@required this.username});

  @override
  List<Object> get props => [this.username];
}

class LoginInit extends LoginBlocEvent {
  @override
  List<Object> get props => [];
}

class PasswordChanged extends LoginBlocEvent {
  final String password;
  PasswordChanged({@required this.password});

  @override
  List<Object> get props => [this.password];
}

class SubmitPressed extends LoginBlocEvent {
  final String ipaddress;
  SubmitPressed({@required this.ipaddress});

  @override
  List<Object> get props => throw UnimplementedError();
}

class LoginPressed extends LoginBlocEvent {
  final String ipaddress;
  final String username;
  final String password;
  LoginPressed(
      {@required this.ipaddress,
      @required this.username,
      @required this.password});

  @override
  List<Object> get props => [this.ipaddress, this.username, this.password];
}

class SwitchChanged extends LoginBlocEvent {
  final bool online;
  SwitchChanged({@required this.online});

  @override
  List<Object> get props => [
        this.online,
      ];
}
