part of 'shift_bloc.dart';

abstract class ShiftBlocState extends Equatable {
  const ShiftBlocState();
  
  @override
  List<Object> get props => [];
}

class ShiftBlocInitial extends ShiftBlocState {}
