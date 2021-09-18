part of 'register_bloc.dart';

abstract class RegisterState extends Equatable {
  const RegisterState();

  @override
  List<Object> get props => [];
}

class RegisterInitial extends RegisterState {}

class RegisterExists extends RegisterState {}

class RegisterOpened extends RegisterState {}

class RegisterClosed extends RegisterState {}
