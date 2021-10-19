import 'package:chat_app/bloc/autservice/authservice_bloc.dart';
import 'package:chat_app/bloc/socketservice/socketservice_bloc.dart';
import 'package:chat_app/pages/login_page.dart';
import 'package:chat_app/pages/usuarios_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LoadingPage extends StatelessWidget {
  const LoadingPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    context.read<AuthserviceBloc>().add(OnLeggedIn());
    return Scaffold(
        body: BlocConsumer<AuthserviceBloc, AuthserviceState>(
      listener: (_, state) {
        checkLoginState(state, context);
      },
      builder: (context, state) {
        return const Center(
          child: Text('Espere....'),
        );
      },
    ));
  }

  void checkLoginState(AuthserviceState state, BuildContext context) {
    if (!state.isWorking) {
      if (state.loginOk) {
        context.read<SocketserviceBloc>().add(OnConnectSocketService());
        Navigator.pushReplacement(
            context,
            PageRouteBuilder(
                pageBuilder: (_, __, ___) => const UsuariosPage()));
      } else {
        Navigator.pushReplacement(context,
            PageRouteBuilder(pageBuilder: (_, __, ___) => const LoginPage()));
      }
    }
  }
}
