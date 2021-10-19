part of 'authservice_bloc.dart';

@immutable
class AuthserviceState {
  final bool isWorking;
  final Usuario usuario;
  final String error;
  final bool loginOk;

  AuthserviceState(
      {this.isWorking = false,
      Usuario? usuario,
      this.error = '',
      this.loginOk = false})
      : usuario = usuario ?? Usuario();

  AuthserviceState copyWith(
          {bool? isWorking, Usuario? usuario, String? error, bool? loginOk}) =>
      AuthserviceState(
          isWorking: isWorking ?? this.isWorking,
          usuario: usuario ?? this.usuario,
          error: error ?? this.error,
          loginOk: loginOk ?? this.loginOk);
}
