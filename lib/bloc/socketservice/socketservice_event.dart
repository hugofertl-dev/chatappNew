part of 'socketservice_bloc.dart';

@immutable
abstract class SocketserviceEvent {}

class OnConnectSocketService extends SocketserviceEvent {
  OnConnectSocketService();
}

class OnDisconnectSocketService extends SocketserviceEvent {
  OnDisconnectSocketService();
}

class OnEmitStatusSocketService extends SocketserviceEvent {
  final ServerStatus serverStatus;

  OnEmitStatusSocketService(this.serverStatus);
}

class OnEmitMensajeSocketService extends SocketserviceEvent {
  final Map<String, dynamic> mensaje;

  OnEmitMensajeSocketService(this.mensaje);
}
