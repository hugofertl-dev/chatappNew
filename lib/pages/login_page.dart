import 'package:chat_app/bloc/autservice/authservice_bloc.dart';
import 'package:chat_app/bloc/socketservice/socketservice_bloc.dart';
import 'package:chat_app/widgets/rs_custom_button.dart';
import 'package:chat_app/widgets/rs_custom_input.dart';
import 'package:chat_app/widgets/rs_custom_labellogin.dart';
import 'package:chat_app/widgets/rs_custom_logo.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF2F2F2),
      body: SafeArea(
        child: SingleChildScrollView(
          child: SizedBox(
            height: MediaQuery.of(context).size.height * 0.9,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: const [
                RsCustomLogo(
                    imageLogo: 'assets/tag-logo.png', tituloLogo: 'Chat App'),
                _Form(),
                RsCustomLabelLogin(
                  titulo: 'No tiene una Cuenta?',
                  textoAccion: 'Crea una Cuenta ahora!',
                  ruta: 'register',
                ),
                Text(
                  'Tèrminos y condiciones de uso',
                  style: TextStyle(
                      fontWeight: FontWeight.w300, color: Colors.grey),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _Form extends StatefulWidget {
  const _Form({Key? key}) : super(key: key);

  @override
  __FormState createState() => __FormState();
}

class __FormState extends State<_Form> {
  final TextEditingController edtmail = TextEditingController();
  final TextEditingController edtpassWord = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 30),
      child: Column(
        children: [
          RsCustomInput(
            textEditingController: edtmail,
            prefixIcon: Icons.email,
            textInputType: TextInputType.emailAddress,
            isPassWord: false,
            hintText: 'Email',
          ),
          RsCustomInput(
            textEditingController: edtpassWord,
            prefixIcon: Icons.lock,
            isPassWord: true,
            hintText: 'Contraseña',
          ),
          const SizedBox(height: 20),
          BlocConsumer<AuthserviceBloc, AuthserviceState>(
            listener: (_, state) {
              if (!state.isWorking) {
                if (state.loginOk) {
                  context
                      .read<SocketserviceBloc>()
                      .add(OnConnectSocketService());
                  Navigator.popAndPushNamed(context, 'usuarios');
                } else {
                  if (state.error.isNotEmpty) {
                    final snackBar = SnackBar(content: Text(state.error));
                    ScaffoldMessenger.of(context).showSnackBar(snackBar);
                  }
                }
              }
            },
            builder: (context, state) {
              return RsCustomButton(
                  texto: 'Ingrese',
                  color: (state.isWorking) ? Colors.grey : Colors.blue,
                  onPressed: () {
                    if (!state.isWorking) {
                      FocusScope.of(context).unfocus();
                      context.read<AuthserviceBloc>().add(OnLogin(
                          email: edtmail.text, passWord: edtpassWord.text));
                    }
                  });
            },
          )
        ],
      ),
    );
  }
}
