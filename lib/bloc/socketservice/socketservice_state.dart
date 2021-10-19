part of 'socketservice_bloc.dart';

@immutable
class SocketserviceState {
  final bool isWorking;
  final ServerStatus serverStatus;

  const SocketserviceState({this.isWorking = false, ServerStatus? serverStatus})
      : serverStatus = serverStatus ?? ServerStatus.connecting;

  SocketserviceState copyWith({bool? isWorking, ServerStatus? serverStatus}) =>
      SocketserviceState(
          isWorking: isWorking ?? this.isWorking,
          serverStatus: serverStatus ?? this.serverStatus);
}
