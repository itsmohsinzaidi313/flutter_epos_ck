import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'reports_event.dart';
part 'reports_state.dart';

class ReportsBloc extends Bloc<ReportsEvent, ReportsState> {
  ReportsBloc() : super(ReportsInitial());

  @override
  Stream<ReportsState> mapEventToState(
    ReportsEvent event,
  ) async* {
    // TODO: implement mapEventToState
  }
}
