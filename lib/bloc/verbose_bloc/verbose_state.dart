part of 'verbose_bloc.dart';

abstract class VerboseState extends Equatable {
  const VerboseState();
  
  @override
  List<Object> get props => [];
}

class VerboseInitial extends VerboseState {}
