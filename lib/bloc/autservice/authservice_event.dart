part of 'authservice_bloc.dart';

@immutable
abstract class AuthserviceEvent {}

class OnLogin extends AuthserviceEvent {
  final String email;
  final String passWord;

  OnLogin({required this.email, required this.passWord});
}

class OnRegister extends AuthserviceEvent {
  final String nombre;
  final String email;
  final String passWord;

  OnRegister(this.nombre, this.email, this.passWord);
}

class OnLeggedIn extends AuthserviceEvent {
  OnLeggedIn();
}

class OnLogOut extends AuthserviceEvent {
  OnLogOut();
}
