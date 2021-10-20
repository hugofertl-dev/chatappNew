import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:chat_app/bloc/autservice/authservice_bloc.dart';
import 'package:chat_app/global/environment.dart';
import 'package:meta/meta.dart';

import 'package:socket_io_client/socket_io_client.dart' as iosocket;

part 'socketservice_event.dart';
part 'socketservice_state.dart';

enum ServerStatus { online, offline, connecting }

class SocketserviceBloc extends Bloc<SocketserviceEvent, SocketserviceState> {
  iosocket.Socket? _socket;

  static final StreamController<Map<String, dynamic>> _streamMensajeNuevo =
      StreamController.broadcast();

  static Stream<Map<String, dynamic>> get streamMensajeNuevo =>
      _streamMensajeNuevo.stream;

  SocketserviceBloc() : super(const SocketserviceState()) {
    on<OnConnectSocketService>(_onConnectSocketService);
    on<OnDisconnectSocketService>(_onDisconnectSocketService);
    on<OnEmitStatusSocketService>(_onEmitStatusSocketService);
    on<OnEmitMensajeSocketService>(_onEmitMensajeSocketService);
  }

  void _onConnectSocketService(
      OnConnectSocketService event, Emitter emit) async {
    emit(state.copyWith(isWorking: true));

    final token = await AuthserviceBloc.obtenerToken();

    _socket = iosocket.io(Environment.socketUrl, {
      'transports': ['websocket'],
      'autoConnect': true,
      'forceNew': true,
      'extraHeaders': {'x-token': token}
    });

    _socket?.on('connect', (_) {
      add(OnEmitStatusSocketService(ServerStatus.online));
    });

    _socket?.on('disconnect', (_) {
      add(OnEmitStatusSocketService(ServerStatus.offline));
    });

    _socket?.on('mensaje-personal', (data) => _streamMensajeNuevo.add(data));

    emit(state.copyWith(isWorking: false));
  }

  void _onEmitStatusSocketService(
      OnEmitStatusSocketService event, Emitter emit) {
    emit(state.copyWith(serverStatus: event.serverStatus));
  }

  void _onDisconnectSocketService(
      OnDisconnectSocketService event, Emitter emit) {
    _socket?.disconnect();
  }

  void _onEmitMensajeSocketService(
      OnEmitMensajeSocketService event, Emitter emit) {
    _socket?.emit('mensaje-personal', event.mensaje);
  }
}
