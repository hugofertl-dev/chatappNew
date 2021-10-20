part of 'chatservice_bloc.dart';

@immutable
abstract class ChatserviceEvent {}

class OnInicializaEscuchaMensaje extends ChatserviceEvent {
  OnInicializaEscuchaMensaje();
}

class OnNuevoMensaje extends ChatserviceEvent {
  final Map<String, dynamic> nuevoMensaje;

  OnNuevoMensaje(this.nuevoMensaje);
}

class OnEstableUsuarioPara extends ChatserviceEvent {
  final Usuario usuarioPara;

  OnEstableUsuarioPara(this.usuarioPara);
}
