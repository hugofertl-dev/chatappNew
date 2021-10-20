part of 'socketservice_bloc.dart';

@immutable
class SocketserviceState {
  final bool isWorking;
  final ServerStatus serverStatus;

  const SocketserviceState(
      {this.isWorking = false,
      ServerStatus? serverStatus,
      Map<String, dynamic>? mensaje,
      Map<String, dynamic>? mensajeRecivido})
      : serverStatus = serverStatus ?? ServerStatus.connecting;

  SocketserviceState copyWith(
          {bool? isWorking,
          ServerStatus? serverStatus,
          Map<String, dynamic>? mensajeRecivido}) =>
      SocketserviceState(
          isWorking: isWorking ?? this.isWorking,
          serverStatus: serverStatus ?? this.serverStatus);
}
