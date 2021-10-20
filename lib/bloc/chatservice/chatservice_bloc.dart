import 'package:bloc/bloc.dart';
import 'package:chat_app/bloc/socketservice/socketservice_bloc.dart';
import 'package:chat_app/model/usuario.dart';
import 'package:meta/meta.dart';

part 'chatservice_event.dart';
part 'chatservice_state.dart';

class ChatserviceBloc extends Bloc<ChatserviceEvent, ChatserviceState> {
  ChatserviceBloc() : super(ChatserviceState()) {
    on<OnInicializaEscuchaMensaje>(_onInicializaEscuchaMensaje);
    on<OnEstableUsuarioPara>(_onEstableceUsuarioPara);
    on<OnNuevoMensaje>(_onNuevoMensajeRecivido);
  }

  void _onInicializaEscuchaMensaje(
      OnInicializaEscuchaMensaje event, Emitter emit) {
    SocketserviceBloc.streamMensajeNuevo.listen((mensaje) {
      add(OnNuevoMensaje(mensaje));
    });
  }

  void _onEstableceUsuarioPara(OnEstableUsuarioPara event, Emitter emit) {
    emit(state.copyWith(usuarioPara: event.usuarioPara));
  }

  void _onNuevoMensajeRecivido(OnNuevoMensaje event, Emitter emit) {
    emit(state.copyWith(nuevoMensaje: event.nuevoMensaje));
  }
}
