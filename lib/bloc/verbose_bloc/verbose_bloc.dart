import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'verbose_event.dart';
part 'verbose_state.dart';

class VerboseBloc extends Bloc<VerboseEvent, VerboseState> {
  VerboseBloc() : super(VerboseInitial());

  @override
  Stream<VerboseState> mapEventToState(
    VerboseEvent event,
  ) async* {
  }
}
