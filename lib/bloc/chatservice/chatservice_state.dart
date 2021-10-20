part of 'chatservice_bloc.dart';

@immutable
class ChatserviceState {
  final Usuario usuarioPara;
  final Map<String, dynamic> nuevoMensaje;

  ChatserviceState({Usuario? usuarioPara, Map<String, dynamic>? nuevoMensaje})
      : usuarioPara = usuarioPara ?? Usuario(),
        nuevoMensaje = nuevoMensaje ?? {};

  ChatserviceState copyWith(
          {Usuario? usuarioPara, Map<String, dynamic>? nuevoMensaje}) =>
      ChatserviceState(
          usuarioPara: usuarioPara ?? this.usuarioPara,
          nuevoMensaje: nuevoMensaje ?? this.nuevoMensaje);
}
