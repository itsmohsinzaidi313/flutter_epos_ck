import 'dart:async';
import 'package:meta/meta.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'network_event.dart';
part 'network_state.dart';

class NetworkBloc extends Bloc<NetworkEvent, NetworkState> {
  NetworkBloc() : super(NetworkInitial());

  @override
  Stream<NetworkState> mapEventToState(
    NetworkEvent event,
  ) async* {
    if (event is ConnectionChanged) {
      if (event.connectionState == ConnectionState.Connected) {
        yield NetworkConnected();
      } else if (event.connectionState == ConnectionState.Disconnected) {
        yield NetworkDisconnected();
      }
    }
  }
}
