import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'shift_bloc_event.dart';
part 'shift_bloc_state.dart';

class ShiftBloc extends Bloc<ShiftBlocEvent, ShiftBlocState> {
  ShiftBloc() : super(ShiftBlocInitial());

  @override
  Stream<ShiftBlocState> mapEventToState(
    ShiftBlocEvent event,
  ) async* {}
}
