part of 'register_bloc.dart';

abstract class RegisterEvent extends Equatable {
  const RegisterEvent();

  @override
  List<Object> get props => [];
}

class LoadRegister extends RegisterEvent {}

class OpeningAmountChanged extends RegisterEvent {
  final double amount;
  OpeningAmountChanged({this.amount});
}

class ClosingAmountChanged extends RegisterEvent {
  final double amount;
  ClosingAmountChanged({this.amount});
}

class RegisterOpen extends RegisterEvent {}

class RegisterClose extends RegisterEvent {}

class ContinueWithRegister extends RegisterEvent {}
