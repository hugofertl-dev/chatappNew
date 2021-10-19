import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:chat_app/global/environment.dart';
import 'package:chat_app/model/login_response.dart';
import 'package:chat_app/model/usuario.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:meta/meta.dart';

import 'package:http/http.dart' as http;

part 'authservice_event.dart';
part 'authservice_state.dart';

class AuthserviceBloc extends Bloc<AuthserviceEvent, AuthserviceState> {
  final storage = const FlutterSecureStorage();

  AuthserviceBloc() : super(AuthserviceState()) {
    on<OnLogin>(_onLogin);
    on<OnRegister>(_onRegister);
    on<OnLeggedIn>(_onLoggedIn);
    on<OnLogOut>(_onLogOut);
  }

  void _onLogOut(OnLogOut event, Emitter<AuthserviceState> emit) {
    eliminarToken();
    emit(state.copyWith(usuario: Usuario(), loginOk: false));
  }

  void _onLogin(OnLogin event, Emitter<AuthserviceState> emit) async {
    if (event.email.isNotEmpty && event.passWord.isNotEmpty) {
      Usuario? _usuario;
      String _error = '';
      final _email = event.email.trim();
      final _passWord = event.passWord.trim();

      emit(state.copyWith(isWorking: true, error: ''));
      final data = {'email': _email, 'password': _passWord};

      final Uri url = Uri.parse('${Environment.apiUrl}/login/');

      final resp = await http.post(url,
          body: jsonEncode(data),
          headers: {'Content-Type': 'application/json'});

      if (resp.statusCode != 200) {
        _error = 'Error de Conexion';
      } else {
        final loginResponse = loginResponseFromJson(resp.body);
        if (loginResponse.ok) {
          _usuario = loginResponse.usuario;
          await _guardarToken(loginResponse.token);
        } else {
          _error = 'Error de Autenticacion';
        }
      }
      emit(state.copyWith(
          isWorking: false,
          usuario: _usuario,
          error: _error,
          loginOk: (_error.isEmpty)));
    }
  }

  void _onRegister(OnRegister event, Emitter<AuthserviceState> emit) async {
    if (event.nombre.isNotEmpty &&
        event.email.isNotEmpty &&
        event.passWord.isNotEmpty) {
      Usuario? _usuario;

      String _error = '';
      emit(state.copyWith(isWorking: true, error: ''));
      final _email = event.email.trim();
      final _passWord = event.passWord.trim();
      final _nombre = event.nombre.trim();

      final data = {'email': _email, 'password': _passWord, 'nombre': _nombre};

      final Uri url = Uri.parse('${Environment.apiUrl}/login/new');

      final resp = await http.post(url,
          body: jsonEncode(data),
          headers: {'Content-Type': 'application/json'});

      if (resp.statusCode != 200) {
        _error = 'Error de Conexion';
      } else {
        final loginResponse = loginResponseFromJson(resp.body);
        if (loginResponse.ok) {
          _usuario = loginResponse.usuario;
          await _guardarToken(loginResponse.token);
        } else {
          _error = 'Error de Autenticacion';
        }
      }
      emit(state.copyWith(
          isWorking: false,
          usuario: _usuario,
          error: _error,
          loginOk: (_error.isEmpty)));
    }
  }

  void _onLoggedIn(OnLeggedIn event, Emitter<AuthserviceState> emit) async {
    bool loggedIn = false;
    Usuario? _usuario;

    emit(state.copyWith(isWorking: true, error: ''));

    final token = await obtenerToken();

    final Uri url = Uri.parse('${Environment.apiUrl}/login/renew');

    final resp = await http.get(url,
        headers: {'Content-Type': 'application/json', 'x-token': token});

    if (resp.statusCode == 200) {
      final loginResponse = loginResponseFromJson(resp.body);
      if (loginResponse.ok) {
        loggedIn = true;
        _usuario = loginResponse.usuario;
      } else {
        eliminarToken();
      }
    }
    emit(
        state.copyWith(isWorking: false, loginOk: loggedIn, usuario: _usuario));
  }

  Future<void> _guardarToken(String token) async {
    await storage.write(key: 'token', value: token);
  }

  static Future<String> obtenerToken() async {
    const storage = FlutterSecureStorage();
    final String? token = await storage.read(key: 'token');
    return token ?? '';
  }

  static void eliminarToken() {
    const storage = FlutterSecureStorage();
    storage.delete(key: 'token');
  }
}
