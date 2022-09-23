import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'network_event.dart';
part 'network_state.dart';

class NetworkBloc extends Bloc<NetworkEvent, NetworkState> {
  NetworkBloc() : super(NetworkInitial()) {
    on<ConnectionChanged>((event, emit) {
      if (event.connectionState == ConnectionState.Connected) {
        emit(NetworkConnected());
      } else if (event.connectionState == ConnectionState.Disconnected) {
        emit(NetworkDisconnected());
      }
    });
  }
}
