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

  SocketserviceBloc() : super(const SocketserviceState()) {
    on<OnConnectSocketService>(_onConnectSocketService);
    on<OnDisconnectSocketService>(_onDisconnectSocketService);
    on<OnEmitStatusSocketService>(_onEmitStatusSocketService);
  }

  void _onConnectSocketService(
      OnConnectSocketService event, Emitter emit) async {
    emit(state.copyWith(isWorking: true));

    final token = await AuthserviceBloc.obtenerToken();

    _socket = iosocket.io(Environment.socketUrl, {
      'transports': ['websocket'],
      'autoConnect': true,
      'forceNew': true,
      'extraHeaders': token
    });

    _socket?.on('connect', (_) {
      add(OnEmitStatusSocketService(ServerStatus.online));
    });

    _socket?.on('disconnect', (_) {
      add(OnEmitStatusSocketService(ServerStatus.offline));
    });

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
}
