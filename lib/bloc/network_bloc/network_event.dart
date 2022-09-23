part of 'network_bloc.dart';

enum ConnectionState { Connected, Disconnected, Timeout }

abstract class NetworkEvent extends Equatable {
  const NetworkEvent();

  @override
  List<Object> get props => [];
}

class ConnectionChanged extends NetworkEvent {
  final ConnectionState connectionState;
  ConnectionChanged({required this.connectionState});
}
